variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "services" {
  description = "Map of services to create CodeBuild projects for"
  type = map(object({
    name               = string
    buildspec_path     = string
    dockerfile_path    = string
    file_path_triggers = list(string)
  }))
}

variable "github_repository_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}

variable "ecr_repository_urls" {
  description = "Map of ECR repository URLs from ECR module"
  type        = map(string)
}
variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection"
  type        = string
}
variable "codebuild_service_role_arn" {
  description = "ARN of the CodeBuild service role"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "use_existing_codestar_connection" {
  description = "Whether to use existing CodeStar connection (webhooks only work with activated connections)"
  type        = bool
  default     = false
}