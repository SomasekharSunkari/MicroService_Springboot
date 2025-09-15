# ================================================================
# MSK MODULE - Amazon Managed Streaming for Apache Kafka
# ================================================================

# Security Group for MSK Cluster
resource "aws_security_group" "msk" {
  name        = "${var.project_name}-msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  # Allow Kafka broker communication (plaintext)
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Kafka broker communication (plaintext)"
  }

  # Allow Kafka broker communication (TLS)
  ingress {
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Kafka broker communication (TLS)"
  }

  # Allow ZooKeeper communication
  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "ZooKeeper communication"
  }

  # Allow JMX monitoring
  ingress {
    from_port   = 11001
    to_port     = 11001
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "JMX monitoring"
  }

  # Allow Node Exporter (Prometheus monitoring)
  ingress {
    from_port   = 11002
    to_port     = 11002
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Node Exporter for Prometheus monitoring"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-msk-sg"
  })
}

# MSK Cluster Configuration
resource "aws_msk_configuration" "kafka_config" {
  kafka_versions = ["3.5.1"]
  name           = "${var.project_name}-msk-config"

  server_properties = <<PROPERTIES
# Basic Kafka settings for cost optimization
auto.create.topics.enable=true
default.replication.factor=${var.broker_count}
min.insync.replicas=${var.broker_count > 1 ? 2 : 1}
num.partitions=1
offsets.topic.replication.factor=${var.broker_count > 1 ? 2 : 1}
transaction.state.log.replication.factor=${var.broker_count > 1 ? 2 : 1}
transaction.state.log.min.isr=${var.broker_count > 1 ? 2 : 1}

# Log retention settings (cost optimization)
log.retention.hours=168
log.retention.bytes=1073741824
log.segment.bytes=1073741824

# Compression settings
compression.type=snappy
PROPERTIES

  description = "MSK configuration for ${var.project_name}"
}

# MSK Cluster
resource "aws_msk_cluster" "kafka" {
  cluster_name           = "${var.project_name}-msk-cluster"
  kafka_version         = var.kafka_version
  number_of_broker_nodes = var.broker_count
  configuration_info {
    arn      = aws_msk_configuration.kafka_config.arn
    revision = aws_msk_configuration.kafka_config.latest_revision
  }

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets = var.private_subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.storage_volume_size
      }
    }
    security_groups = [aws_security_group.msk.id]
  }

  # Use ZooKeeper mode (as requested)
  client_authentication {
    unauthenticated = true
  }

  # Basic logging for cost optimization
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.enable_cloudwatch_logs
        log_group = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.msk_broker_logs[0].name : null
      }
      s3 {
        enabled = false
      }
      firehose {
        enabled = false
      }
    }
  }

  # Disable enhanced monitoring for cost optimization
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.enable_jmx_exporter
      }
      node_exporter {
        enabled_in_broker = var.enable_node_exporter
      }
    }
  }

  # Encryption settings
  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker_encryption
      in_cluster    = true
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-msk-cluster"
  })
}

# CloudWatch Log Group for MSK (optional)
resource "aws_cloudwatch_log_group" "msk_broker_logs" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/msk/${var.project_name}-broker"
  retention_in_days = var.log_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-msk-broker-logs"
  })
}