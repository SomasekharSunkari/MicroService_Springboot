# ================================================================
# MAIN TERRAFORM OUTPUTS 
# Aggregated outputs from all modules
# ================================================================

# AWS Account Information
output "aws_account_info" {
  description = "AWS account information"
  value = {
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.id
  }
}

# Network Module Outputs
output "network" {
  description = "Network infrastructure details"
  value = {
    vpc_id               = module.network.vpc_id
    vpc_cidr            = module.network.vpc_cidr
    public_subnet_ids   = module.network.public_subnet_ids
    private_subnet_ids  = module.network.private_subnet_ids
    load_balancer_dns   = module.network.load_balancer_dns_name
    load_balancer_arn   = module.network.load_balancer_arn
    target_groups       = module.network.target_groups
  }
}

# ECR Module Outputs
output "ecr" {
  description = "ECR repository details"
  value = {
    repositories = module.ecr.repositories
  }
}

# ECS Module Outputs
output "ecs" {
  description = "ECS cluster and service details"
  value = {
    cluster_name = module.ecs.cluster_name
    cluster_arn  = module.ecs.cluster_arn
    services     = module.ecs.services
  }
}

# CodeBuild Module Outputs
output "codebuild" {
  description = "CodeBuild project details"
  value = {
    projects = module.codebuild.codebuild_projects
  }
}

# CodePipeline Module Outputs
output "codepipeline" {
  description = "CodePipeline details"
  value = {
    pipelines = module.codepipeline.pipelines
  }
}

# Application URLs
output "application_urls" {
  description = "Application access URLs"
  value = {
    load_balancer_url = "http://${module.network.load_balancer_dns_name}"
    
    service_urls = {
      for k, v in var.services : k => v.public_facing ? {
        url = "http://${module.network.load_balancer_dns_name}/${k}"
        health_check = "http://${module.network.load_balancer_dns_name}/${k}${v.health_check_path}"
      } : {
        internal_dns = "${v.name}.${var.project_name}.local:${v.port}"
      }
    }
  }
}

# IAM Roles (from existing 02-iam.tf)
output "iam_roles" {
  description = "IAM role information"
  value = {
    ecs_task_execution_role = {
      name = aws_iam_role.ecs_task_execution.name
      arn  = aws_iam_role.ecs_task_execution.arn
    }
    ecs_task_role = {
      name = aws_iam_role.ecs_task.name
      arn  = aws_iam_role.ecs_task.arn
    }
    codebuild_role = {
      name = aws_iam_role.codebuild.name
      arn  = aws_iam_role.codebuild.arn
    }
    codepipeline_role = {
      name = aws_iam_role.codepipeline.name
      arn  = aws_iam_role.codepipeline.arn
    }
  }
}

# CodeStar Connection
output "codestar_connection" {
  description = "CodeStar connection for GitHub"
  value = var.create_codestar_connection && !var.use_existing_codestar_connection ? {
    arn    = aws_codestarconnections_connection.github[0].arn
    status = aws_codestarconnections_connection.github[0].connection_status
  } : var.use_existing_codestar_connection ? {
    arn    = var.existing_codestar_connection_arn
    status = "AVAILABLE"
  } : null
  sensitive = true
}

# Next Steps Information
output "next_steps" {
  description = "Required manual steps after terraform apply"
  value = {
    step_1 = "Activate GitHub connection in AWS Console > Developer Tools > Settings > Connections"
    step_2 = "Run initial CodeBuild projects to push first images to ECR"
    step_3 = "ECS services will automatically start using the new images"
    step_4 = "CI/CD pipelines are ready for automated deployments"
  }
}