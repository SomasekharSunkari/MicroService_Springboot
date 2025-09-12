# ================================================================
# ECS MODULE - Cluster, Task Definitions, and Services
# ================================================================

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = merge(var.common_tags, {
    Name        = var.cluster_name
    Environment = var.environment
  })
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Service Discovery
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${var.project_name}.local"
  description = "Private DNS namespace for service discovery"
  vpc         = var.vpc_id

  tags = var.common_tags
}

# Service Discovery Services
resource "aws_service_discovery_service" "services" {
  for_each = var.services

  name = each.value.name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.value.name}-discovery"
    Environment = var.environment
  })
}

# CloudWatch Log Groups for ECS services
resource "aws_cloudwatch_log_group" "services" {
  for_each = var.services

  name              = "/ecs/${each.value.name}"
  retention_in_days = 7
  
  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}-logs"
    Service     = each.key
    Environment = var.environment
  })
}

# ECS Task Definitions
resource "aws_ecs_task_definition" "services" {
  for_each = var.services

  family                   = each.value.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.value.name
      image     = "${var.ecr_repository_urls[each.key]}:latest"
      cpu       = each.value.cpu
      memory    = each.value.memory
      essential = true
      
      portMappings = [
        {
          containerPort = each.value.port
          hostPort      = each.value.port
          protocol      = "tcp"
          name          = "${each.key}-port"
          appProtocol   = "http"
        }
      ]
      
      environment = [
        for env_key, env_value in each.value.environment_variables : {
          name  = env_key
          value = env_value
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.services[each.key].name
          "awslogs-create-group"  = "true"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  ephemeral_storage {
    size_in_gib = 21
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}-task"
    Service     = each.key
    Environment = var.environment
  })
}

# ECS Services
resource "aws_ecs_service" "services" {
  for_each = var.services

  name            = "${each.value.name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_configuration {
      strategy = "ROLLING"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = each.value.public_facing ? var.public_subnet_ids : var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = each.value.public_facing
  }

  # Load balancer configuration for services that have target groups
  dynamic "load_balancer" {
    for_each = contains(keys(var.target_group_arns), each.key) ? [1] : []
    content {
      target_group_arn = var.target_group_arns[each.key]
      container_name   = each.value.name
      container_port   = each.value.port
    }
  }

  # Service Discovery registration
  service_registries {
    registry_arn = aws_service_discovery_service.services[each.key].arn
  }

  enable_execute_command = true
  
  # Health check grace period for services with load balancers
  health_check_grace_period_seconds = contains(keys(var.target_group_arns), each.key) ? 60 : null

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${each.key}-service"
    Service     = each.key
    Environment = var.environment
  })

  depends_on = [
    aws_ecs_task_definition.services
  ]
  lifecycle {
    ignore_changes = [desired_count]
  }
}