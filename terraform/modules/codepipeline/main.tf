# ================================================================
# CODEPIPELINE MODULE - CI/CD Pipelines for Each Service
# ================================================================

# CodePipeline for each service
resource "aws_codepipeline" "services" {
  for_each = var.services

  name           = "${var.project_name}-${each.key}-pipeline"
  role_arn       = var.codepipeline_service_role_arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = var.s3_artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      run_order        = 1
      region           = var.aws_region
      namespace        = "SourceVariables"

      configuration = {
        BranchName             = var.github_branch
        ConnectionArn          = var.codestar_connection_arn
        DetectChanges          = "false"
        FullRepositoryId       = var.github_repository_full_id
        OutputArtifactFormat   = "CODE_ZIP"
      }
    }

    on_failure {
      result = "RETRY"
      retry_configuration {
        retry_mode = "ALL_ACTIONS"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      run_order        = 1
      region           = var.aws_region
      namespace        = "BuildVariables"

      configuration = {
        ProjectName = var.codebuild_project_names[each.key]
      }
    }

    on_failure {
      result = "RETRY"
      retry_configuration {
        retry_mode = "ALL_ACTIONS"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["BuildArtifact"]
      run_order       = 1
      region          = var.aws_region
      namespace       = "DeployVariables"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_names[each.key]
      }
    }

    on_failure {
      result = "ROLLBACK"
    }
  }

  trigger {
    provider_type = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "Source"
      push {
        branches {
          includes = [var.github_branch]
        }
        file_paths {
          includes = each.value.file_path_triggers
        }
      }
    }
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}-pipeline"
    Service     = each.key
    Environment = var.environment
  })
}