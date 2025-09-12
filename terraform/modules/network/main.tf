# ================================================================
# NETWORK MODULE - VPC, Subnets, Security Groups
# ================================================================

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    Type = "Private"
  })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = length(aws_subnet.public)

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = length(aws_subnet.public)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  })
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Security Groups
resource "aws_security_group" "ecs_services" {
  name        = "${var.project_name}-ecs-services"
  description = "Security group for ECS services"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic from ALB
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow all traffic within VPC
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-ecs-services-sg"
  })
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

# ================================================================
# APPLICATION LOAD BALANCER AND TARGET GROUPS
# ================================================================

# Application Load Balancer
resource "aws_lb" "main" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = var.common_tags
}

# Target Groups for each service
resource "aws_lb_target_group" "services" {
  for_each = {
    for k, v in var.services : k => v if v.public_facing || contains(["auth", "client", "order", "payment", "product"], k)
  }

  name     = "${each.key == "client" ? "frontedOne" : each.key == "auth" ? "auth-TG-P" : each.key == "order" ? "orders-TG-P" : each.key == "payment" ? "payment-TG-P" : each.key == "product" ? "product-TG-P" : "${each.key}-TG-P"}"
  port     = each.key == "auth" ? 8787 : each.value.port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = each.value.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${each.key == "client" ? "frontedOne" : each.key == "auth" ? "auth-TG-P" : each.key == "order" ? "orders-TG-P" : each.key == "payment" ? "payment-TG-P" : each.key == "product" ? "product-TG-P" : "${each.key}-TG-P"}"
  })
}

# ALB Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  # Default action for client service
  default_action {
    type             = "forward"
    target_group_arn = try(aws_lb_target_group.services["client"].arn, aws_lb_target_group.services[keys(aws_lb_target_group.services)[0]].arn)
  }

  tags = var.common_tags
}

# ALB Listener Rules for each service
resource "aws_lb_listener_rule" "services" {
  for_each = {
    for k, v in aws_lb_target_group.services : k => v if k != "client"
  }

  listener_arn = aws_lb_listener.main.arn
  priority     = 100 + index(keys({ for k, v in aws_lb_target_group.services : k => v if k != "client" }), each.key)

  action {
    type             = "forward"
    target_group_arn = each.value.arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}*"]
    }
  }

  tags = var.common_tags
}