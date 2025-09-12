# ================================================================
# ECR MODULE - Docker Image Repositories
# ================================================================

# ECR Repositories for each service
resource "aws_ecr_repository" "services" {
  for_each = var.services

  name                 = each.value.name
  image_tag_mutability = each.value.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  force_delete = true

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}"
    Service     = each.key
    Environment = var.environment
  })
}

# ECR Lifecycle Policies
resource "aws_ecr_lifecycle_policy" "services" {
  for_each = var.services

  repository = aws_ecr_repository.services[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${each.value.lifecycle_policy.keep_last_images} images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["build-", "latest"]
          countType     = "imageCountMoreThan"
          countNumber   = each.value.lifecycle_policy.keep_last_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}