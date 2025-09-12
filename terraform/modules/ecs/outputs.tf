# ================================================================
# ECS MODULE OUTPUTS
# These outputs are used by other modules
# ================================================================

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "service_names" {
  description = "Map of ECS service names"
  value = {
    for k, service in aws_ecs_service.services : k => service.name
  }
}

output "service_arns" {
  description = "Map of ECS service ARNs"
  value = {
    for k, service in aws_ecs_service.services : k => service.arn
  }
}

output "task_definition_arns" {
  description = "Map of ECS task definition ARNs"
  value = {
    for k, task_def in aws_ecs_task_definition.services : k => task_def.arn
  }
}

output "services" {
  description = "Complete ECS service details"
  value = {
    for k, service in aws_ecs_service.services : k => {
      name            = service.name
      arn             = service.arn
      cluster         = service.cluster
      desired_count   = service.desired_count
      task_definition = service.task_definition
    }
  }
}

output "log_group_names" {
  description = "Map of CloudWatch log group names"
  value = {
    for k, log_group in aws_cloudwatch_log_group.services : k => log_group.name
  }
}

output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_discovery_services" {
  description = "Map of service discovery service ARNs"
  value = {
    for k, service in aws_service_discovery_service.services : k => service.arn
  }
}