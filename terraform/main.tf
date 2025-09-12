# ================================================================
# MAIN TERRAFORM CONFIGURATION
# Sequential deployment: Network → ECR → CodeBuild → ECS → CodePipeline
# ================================================================

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ================================================================
# STEP 1: NETWORK MODULE (VPC, Subnets, Load Balancer, Target Groups)
# ================================================================

module "network" {
  source = "./modules/network"

  project_name           = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = [for k, v in var.existing_public_subnets : v.cidr]
  private_subnet_cidrs  = [for k, v in var.existing_private_subnets : v.cidr]
  services              = var.services
  load_balancer_name    = var.load_balancer_config.name
  common_tags           = var.common_tags
}

# ================================================================
# STEP 2: ECR MODULE (After network is created)
# ================================================================

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  services     = var.ecr_repositories
  common_tags  = var.common_tags

  depends_on = [module.network]
}

# ================================================================
# STEP 3: CODEBUILD MODULE (After ECR repositories are created)
# ================================================================

module "codebuild" {
  source = "./modules/codebuild"

  project_name                    = var.project_name
  environment                    = var.environment
  services                       = var.services
  github_repository_url          = var.github_repository_url
  github_branch                  = var.github_branch
  codestar_connection_arn        = local.codestar_connection_arn
  use_existing_codestar_connection = var.use_existing_codestar_connection

  ecr_repository_urls     = module.ecr.repository_urls
  codebuild_service_role_arn = aws_iam_role.codebuild.arn
  aws_region              = var.aws_region
  aws_account_id          = var.aws_account_id
  common_tags             = var.common_tags

  depends_on = [module.ecr, aws_iam_role.codebuild]
}

# ================================================================
# STEP 4: ECS MODULE (After network and ECR are ready)
# ================================================================

module "ecs" {
  source = "./modules/ecs"

  project_name                = var.project_name
  environment                = var.environment
  cluster_name               = var.existing_ecs_cluster_name
  services                   = var.services
  vpc_id                     = module.network.vpc_id
  private_subnet_ids         = module.network.private_subnet_ids
  public_subnet_ids          = module.network.public_subnet_ids
  ecs_security_group_id      = module.network.ecs_security_group_id
  target_group_arns          = module.network.target_group_arns
  ecr_repository_urls        = module.ecr.repository_urls
  ecs_task_execution_role_arn = aws_iam_role.ecs_task_execution.arn
  ecs_task_role_arn          = aws_iam_role.ecs_task.arn
  aws_region                 = var.aws_region
  common_tags                = var.common_tags

  depends_on = [module.network, module.ecr, aws_iam_role.ecs_task_execution, aws_iam_role.ecs_task]
}

# ================================================================
# STEP 5: CODEPIPELINE MODULE (After all previous modules are ready)
# ================================================================

module "codepipeline" {
  source = "./modules/codepipeline"

  project_name                   = var.project_name
  environment                   = var.environment
  services                      = var.services
  github_repository_url         = var.github_repository_url
  github_repository_full_id     = var.github_repository_full_id
  github_branch                = var.github_branch
  codepipeline_service_role_arn = aws_iam_role.codepipeline.arn
  codestar_connection_arn       = local.codestar_connection_arn
  s3_artifacts_bucket_name      = aws_s3_bucket.codepipeline_artifacts.bucket
  codebuild_project_names       = module.codebuild.codebuild_project_names
  ecs_cluster_name             = module.ecs.cluster_name
  ecs_service_names            = module.ecs.service_names
  aws_region                   = var.aws_region
  common_tags                  = var.common_tags

  depends_on = [module.network, module.ecr, module.codebuild, module.ecs, aws_iam_role.codepipeline]
}

# ================================================================
# OUTPUT SUMMARY (Aggregated from all modules)
# ================================================================

output "deployment_summary" {
  description = "Summary of all deployed resources"
  value = {
    # Network information
    vpc_id                = module.network.vpc_id
    load_balancer_dns     = module.network.load_balancer_dns_name
    
    # ECR repositories
    ecr_repositories      = module.ecr.repositories
    
    # ECS cluster and services
    ecs_cluster_name      = module.ecs.cluster_name
    ecs_services         = module.ecs.services
    
    # CI/CD pipelines
    codepipelines        = module.codepipeline.pipelines
    
    # Application URLs
    application_urls = {
      load_balancer = "http://${module.network.load_balancer_dns_name}"
      services = {
        for k, v in var.services : k => v.public_facing ? {
          url = "http://${module.network.load_balancer_dns_name}/${k}"
          health_check = "http://${module.network.load_balancer_dns_name}/${k}${v.health_check_path}"
        } : null
      }
    }
  }
}