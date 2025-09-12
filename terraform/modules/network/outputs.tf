# ================================================================
# NETWORK MODULE OUTPUTS
# These outputs are used by other modules
# ================================================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "Public subnet details"
  value = {
    for idx, subnet in aws_subnet.public : idx => {
      id   = subnet.id
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  }
}

output "private_subnets" {
  description = "Private subnet details"
  value = {
    for idx, subnet in aws_subnet.private : idx => {
      id   = subnet.id
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  }
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "ecs_security_group_id" {
  description = "ID of the ECS services security group"
  value       = aws_security_group.ecs_services.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = var.availability_zones
}

# Load Balancer Outputs
output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value = {
    for k, tg in aws_lb_target_group.services : k => tg.arn
  }
}

output "target_groups" {
  description = "Target group details"
  value = {
    for k, tg in aws_lb_target_group.services : k => {
      arn  = tg.arn
      name = tg.name
      port = tg.port
    }
  }
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.main.arn
}