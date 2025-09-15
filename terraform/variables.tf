
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

# MSK Configuration
variable "msk_config" {
  description = "MSK cluster configuration"
  type = object({
    kafka_version            = optional(string, "3.5.1")
    instance_type           = optional(string, "kafka.m7g.large")
    broker_count            = optional(number, 3)
    storage_volume_size     = optional(number, 1000)
    enable_cloudwatch_logs  = optional(bool, false)
    log_retention_days      = optional(number, 7)
    enable_jmx_exporter     = optional(bool, false)
    enable_node_exporter    = optional(bool, false)
    client_broker_encryption = optional(string, "TLS_PLAINTEXT")
  })
  default = {
    kafka_version            = "3.5.1"
    instance_type           = "kafka.m7g.large"
    broker_count            = 3
    storage_volume_size     = 1000
    enable_cloudwatch_logs  = false
    log_retention_days      = 7
    enable_jmx_exporter     = false
    enable_node_exporter    = false
    client_broker_encryption = "TLS_PLAINTEXT"
  }
}

# ECS Auto Scaling Configuration
variable "ecs_autoscaling_config" {
  description = "ECS services auto scaling configuration"
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