variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "services" {
  description = "Map of services to create ECR repositories for"
  type = map(object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push        = optional(bool, false)
    lifecycle_policy = optional(object({
      keep_last_images = number
    }), {
      keep_last_images = 10
    })
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}