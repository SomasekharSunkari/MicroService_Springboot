# ================================================================
# MSK MODULE VARIABLES
# ================================================================

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where MSK cluster will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for MSK cluster"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least 2 private subnets are required for MSK cluster."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# MSK Cluster Configuration
variable "kafka_version" {
  description = "Version of Apache Kafka for MSK cluster"
  type        = string
  default     = "3.5.1"
}

variable "instance_type" {
  description = "Instance type for MSK brokers"
  type        = string
  default     = "kafka.m7g.large"
  validation {
    condition = can(regex("^kafka\\.", var.instance_type))
    error_message = "Instance type must be a valid MSK instance type starting with 'kafka.'."
  }
}

variable "broker_count" {
  description = "Number of broker nodes in MSK cluster"
  type        = number
  default     = 3
  validation {
    condition     = var.broker_count >= 2 && var.broker_count <= 15
    error_message = "Broker count must be between 2 and 15."
  }
}

variable "storage_volume_size" {
  description = "Size of EBS volume for each broker (GB)"
  type        = number
  default     = 1000
  validation {
    condition     = var.storage_volume_size >= 1 && var.storage_volume_size <= 16384
    error_message = "Storage volume size must be between 1 and 16384 GB."
  }
}

# Security and Encryption
variable "kms_key_id" {
  description = "KMS key ID for encryption at rest (optional)"
  type        = string
  default     = null
}

variable "client_broker_encryption" {
  description = "Encryption setting for client-broker communication"
  type        = string
  default     = "TLS_PLAINTEXT"
  validation {
    condition     = contains(["TLS", "TLS_PLAINTEXT", "PLAINTEXT"], var.client_broker_encryption)
    error_message = "Client-broker encryption must be TLS, TLS_PLAINTEXT, or PLAINTEXT."
  }
}

# Monitoring and Logging
variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs for MSK broker logs"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch log retention period."
  }
}

variable "enable_jmx_exporter" {
  description = "Enable JMX exporter for Prometheus monitoring"
  type        = bool
  default     = false
}

variable "enable_node_exporter" {
  description = "Enable Node exporter for Prometheus monitoring"
  type        = bool
  default     = false
}

# Network Access
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access MSK cluster"
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to MSK cluster"
  type        = list(string)
  default     = []
}