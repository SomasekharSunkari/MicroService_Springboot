# ================================================================
# ECR MODULE OUTPUTS
# These outputs are used by other modules
# ================================================================

output "repository_urls" {
  description = "Map of ECR repository URLs"
  value = {
    for k, repo in aws_ecr_repository.services : k => repo.repository_url
  }
}

output "repository_arns" {
  description = "Map of ECR repository ARNs"
  value = {
    for k, repo in aws_ecr_repository.services : k => repo.arn
  }
}

output "repository_names" {
  description = "Map of ECR repository names"
  value = {
    for k, repo in aws_ecr_repository.services : k => repo.name
  }
}

output "repositories" {
  description = "Complete ECR repository details"
  value = {
    for k, repo in aws_ecr_repository.services : k => {
      name = repo.name
      url  = repo.repository_url
      arn  = repo.arn
    }
  }
}