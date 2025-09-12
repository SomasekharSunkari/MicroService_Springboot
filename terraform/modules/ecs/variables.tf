variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
  default     = "sophisticated-fish-p08ixg"
}

variable "services" {
  description = "Map of services to create ECS resources for"
  type = map(object({
    name                  = string
    port                  = number
    cpu                   = number
    memory                = number
    health_check_path     = optional(string, "/health")
    public_facing         = optional(bool, false)
    environment_variables = optional(map(string), {})
  }))
}

variable "vpc_id" {
  description = "VPC ID from network module"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from network module"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs from network module"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group ID from network module"
  type        = string
}

variable "target_group_arns" {
  description = "Target group ARNs from network module"
  type        = map(string)
}

variable "ecr_repository_urls" {
  description = "ECR repository URLs from ECR module"
  type        = map(string)
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECS task role ARN"
  type        = string
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