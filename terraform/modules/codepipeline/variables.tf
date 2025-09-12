variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "services" {
  description = "Map of services to create CodePipeline for"
  type = map(object({
    name               = string
    file_path_triggers = list(string)
  }))
}

variable "github_repository_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_repository_full_id" {
  description = "GitHub repository full ID"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}

variable "codepipeline_service_role_arn" {
  description = "ARN of the CodePipeline service role"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection"
  type        = string
}

variable "s3_artifacts_bucket_name" {
  description = "S3 bucket name for pipeline artifacts"
  type        = string
}

variable "codebuild_project_names" {
  description = "Map of CodeBuild project names from CodeBuild module"
  type        = map(string)
}

variable "ecs_cluster_name" {
  description = "ECS cluster name from ECS module"
  type        = string
}

variable "ecs_service_names" {
  description = "Map of ECS service names from ECS module"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}