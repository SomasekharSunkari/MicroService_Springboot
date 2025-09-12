
# ================================================================
# TERRAFORM VARIABLES DEFINITION
# ================================================================

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "existing_private_subnets" {
  description = "Map of existing private subnets to replicate"
  type = map(object({
    id   = string
    cidr = string
    az   = string
  }))
}

variable "existing_public_subnets" {
  description = "Map of existing public subnets to replicate"
  type = map(object({
    id   = string
    cidr = string
    az   = string
  }))
}

# ECS Configuration
variable "existing_ecs_cluster_name" {
  description = "Name of existing ECS cluster"
  type        = string
}

# Service Configuration
variable "services" {
  description = "Map of services configuration"
  type = map(object({
    name                  = string
    port                  = number
    cpu                   = number
    memory                = number
    buildspec_path        = string
    dockerfile_path       = string
    health_check_path     = string
    public_facing         = optional(bool, false)
    file_path_triggers    = list(string)
    environment_variables = map(string)
  }))
}

# ECR Configuration
variable "ecr_repositories" {
  description = "Map of ECR repositories configuration"
  type = map(object({
    name = string
  }))
}

# Load Balancer Configuration
variable "load_balancer_config" {
  description = "Load balancer configuration"
  type = object({
    name                       = string
    internal                   = bool
    load_balancer_type        = string
    enable_deletion_protection = bool
  })
}

# GitHub Configuration
variable "github_repository_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_repository_full_id" {
  description = "GitHub repository full ID (owner/repo)"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}

# CodeStar Connection Configuration
variable "use_existing_codestar_connection" {
  description = "Whether to use existing CodeStar connection instead of creating new one"
  type        = bool
  default     = false
}

variable "existing_codestar_connection_arn" {
  description = "ARN of existing CodeStar connection (required if use_existing_codestar_connection is true)"
  type        = string
  default     = ""
}

variable "create_codestar_connection" {
  description = "Whether to create a new CodeStar connection"
  type        = bool
  default     = true
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}