variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "services" {
  description = "Service configuration for creating target groups"
  type = map(object({
    name              = string
    port              = number
    health_check_path = optional(string, "/actuator/health")
    public_facing     = optional(bool, false)
  }))
}

variable "load_balancer_name" {
  description = "Name for the load balancer"
  type        = string
  default     = "public-ms-balancer"
}