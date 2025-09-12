# ================================================================
# CODEBUILD MODULE - Build Projects for Each Service
# ================================================================

# CodeBuild Projects for each service

resource "aws_codebuild_project" "services" {
  for_each = var.services

  name          = "${var.project_name}-${each.key}-build"
  description   = "CodeBuild project for ${each.value.name}"
  service_role  = var.codebuild_service_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                      = "aws/codebuild/ami/amazonlinux-x86_64-base:latest"
    type                       = "LINUX_EC2"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode            = false

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = each.value.name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = var.ecr_repository_urls[each.key]
    }
  }

  source {
    type                = "GITHUB"
    location            = var.github_repository_url
    git_clone_depth     = 1
    buildspec           = each.value.buildspec_path
    report_build_status = false
    insecure_ssl        = false

    git_submodules_config {
      fetch_submodules = false
    }
    auth {
      type = "CODECONNECTIONS"
      resource = var.codestar_connection_arn
    }
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}-build"
    Service     = each.key
    Environment = var.environment
  })
}

# CodeBuild Webhooks (for GitHub integration)
# Only create webhooks when using existing activated connection
# New connections need manual activation before webhooks can be created
resource "aws_codebuild_webhook" "services" {
  for_each = var.use_existing_codestar_connection ? var.services : {}

  project_name = aws_codebuild_project.services[each.key].name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    
    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/${var.github_branch}"
    }
    
    filter {
      type    = "FILE_PATH"
      pattern = join("|", each.value.file_path_triggers)
    }
  }
}