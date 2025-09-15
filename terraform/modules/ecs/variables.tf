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

# Auto Scaling Configuration
variable "autoscaling_config" {
  description = "Auto scaling configuration for ECS services"
  type = object({
    min_capacity                     = optional(number, 1)
    max_capacity                     = optional(number, 10)
    scale_up_adjustment              = optional(number, 1)
    scale_down_adjustment            = optional(number, -1)
    scale_up_cooldown               = optional(number, 300)
    scale_down_cooldown             = optional(number, 300)
    cpu_high_threshold              = optional(number, 70)
    cpu_low_threshold               = optional(number, 30)
    memory_high_threshold           = optional(number, 70)
    memory_low_threshold            = optional(number, 30)
    cpu_high_evaluation_periods     = optional(number, 2)
    cpu_low_evaluation_periods      = optional(number, 2)
    memory_high_evaluation_periods  = optional(number, 2)
    memory_low_evaluation_periods   = optional(number, 2)
    cpu_high_period                 = optional(number, 300)
    cpu_low_period                  = optional(number, 300)
    memory_high_period              = optional(number, 300)
    memory_low_period               = optional(number, 300)
  })
  default = {
    min_capacity                     = 1
    max_capacity                     = 10
    scale_up_adjustment              = 1
    scale_down_adjustment            = -1
    scale_up_cooldown               = 300
    scale_down_cooldown             = 300
    cpu_high_threshold              = 70
    cpu_low_threshold               = 30
    memory_high_threshold           = 70
    memory_low_threshold            = 30
    cpu_high_evaluation_periods     = 2
    cpu_low_evaluation_periods      = 2
    memory_high_evaluation_periods  = 2
    memory_low_evaluation_periods   = 2
    cpu_high_period                 = 300
    cpu_low_period                  = 300
    memory_high_period              = 300
    memory_low_period               = 300
  }
}