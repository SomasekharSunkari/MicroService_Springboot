# =================================================================
# Terraform Variables File - Clean Configuration
# All values matching your existing AWS infrastructure
# =================================================================

# AWS Configuration
aws_region     = "us-east-1"
aws_account_id = "068856380156"

# Project Configuration
project_name = "microservices-ecommerce"
environment  = "production"

# Common Tags
common_tags = {
  Environment = "production"
  Project     = "microservices-ecommerce"
  ManagedBy   = "terraform"
}

# GitHub Configuration
github_repository_url     = "https://github.com/SomasekharSunkari/MicroService_Springboot.git"
github_repository_full_id = "SomasekharSunkari/MicroService_Springboot"
github_branch            = "main"

# VPC Configuration (matching your existing setup)
vpc_cidr = "172.31.0.0/16"

# Availability Zones
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
# Existing Private Subnets (to replicate)
existing_private_subnets = {
  "private-1" = {
    id   = "subnet-0cf1c104fc6fd3914"
    cidr = "172.31.48.0/20"
    az   = "eu-north-1a"
  }
  "private-2" = {
    id   = "subnet-029d7e0fddc91f361"
    cidr = "172.31.64.0/20"
    az   = "eu-north-1b"
  }
  "private-3" = {
    id   = "subnet-05085a3a58ec1da84"
    cidr = "172.31.80.0/20"
    az   = "eu-north-1c"
  }
}

# Existing Public Subnets (to replicate)
existing_public_subnets = {
  "public-1" = {
    id   = "subnet-090a5b1b9b8cd635e"
    cidr = "172.31.16.0/20"
    az   = "eu-north-1a"
  }
  "public-2" = {
    id   = "subnet-072693af9c1333eb5"
    cidr = "172.31.32.0/20"
    az   = "eu-north-1b"
  }
  "public-3" = {
    id   = "subnet-02ddc0e4802467362"
    cidr = "172.31.0.0/20"
    az   = "eu-north-1c"
  }
}

# ECS Cluster Configuration
existing_ecs_cluster_name = "sophisticated-fish-p08ixg"

# Service Configuration
services = {
  payment = {
    name            = "payment-service"
    port            = 8060
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "payment/buildspec.yml"
    dockerfile_path = "payment/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["payment/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
  auth = {
    name            = "auth-service"
    port            = 8080
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "authservice/buildspec.yml"
    dockerfile_path = "authservice/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["authservice/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
  order = {
    name            = "order-service"
    port            = 8070
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "order/buildspec.yml"
    dockerfile_path = "order/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["order/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
  notification = {
    name            = "notification-service"
    port            = 8050
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "notification/buildspec.yml"
    dockerfile_path = "notification/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["notification/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
  client = {
    name            = "client-service"
    port            = 80
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "clientCode/buildspec.yml"
    dockerfile_path = "clientCode/Dockerfile"
    health_check_path = "/"
    public_facing   = true
    file_path_triggers = ["clientCode/.*"]
    environment_variables = {
      NODE_ENV = "production"
    }
  }
  config = {
    name            = "config-server"
    port            = 8888
    cpu             = 512
    memory          = 1024
    buildspec_path  = "configserver/buildspec.yml"
    dockerfile_path = "configserver/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["configserver/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
  product = {
    name            = "product-api"
    port            = 8090
    cpu             = 1024
    memory          = 3072
    buildspec_path  = "product/buildspec.yml"
    dockerfile_path = "product/Dockerfile"
    health_check_path = "/actuator/health"
    file_path_triggers = ["product/.*"]
    environment_variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }
}

# ECR Configuration
ecr_repositories = {
  payment = {
    name = "payment-service"
  }
  auth = {
    name = "auth-service"
  }
  order = {
    name = "order-service"
  }
  notification = {
    name = "notification-service"
  }
  client = {
    name = "client-service"
  }
  config = {
    name = "config-server"
  }
  product = {
    name = "product-api"
  }
  stackular = {
    name = "stackular/images"
  }
}

# Load Balancer Configuration
load_balancer_config = {
  name                       = "public-ms-balancer"
  internal                   = false
  load_balancer_type        = "application"
  enable_deletion_protection = false
}