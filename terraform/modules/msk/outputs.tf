# ================================================================
# MSK MODULE OUTPUTS
# These outputs provide important MSK cluster information
# ================================================================

output "cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_cluster.kafka.arn
}

output "cluster_name" {
  description = "Name of the MSK cluster"
  value       = aws_msk_cluster.kafka.cluster_name
}

output "zookeeper_connect_string" {
  description = "ZooKeeper connection string"
  value       = aws_msk_cluster.kafka.zookeeper_connect_string
}

output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = aws_msk_cluster.kafka.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.kafka.bootstrap_brokers_tls
}

output "kafka_version" {
  description = "Apache Kafka version"
  value       = aws_msk_cluster.kafka.kafka_version
}

output "number_of_broker_nodes" {
  description = "Number of broker nodes in the cluster"
  value       = aws_msk_cluster.kafka.number_of_broker_nodes
}

output "security_group_id" {
  description = "ID of the MSK security group"
  value       = aws_security_group.msk.id
}

output "security_group_arn" {
  description = "ARN of the MSK security group"
  value       = aws_security_group.msk.arn
}

output "configuration_arn" {
  description = "ARN of the MSK configuration"
  value       = aws_msk_configuration.kafka_config.arn
}

output "configuration_revision" {
  description = "Latest revision of the MSK configuration"
  value       = aws_msk_configuration.kafka_config.latest_revision
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group (if enabled)"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.msk_broker_logs[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group (if enabled)"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.msk_broker_logs[0].arn : null
}

# Connection information for applications
output "connection_info" {
  description = "Connection information for applications"
  value = {
    cluster_name               = aws_msk_cluster.kafka.cluster_name
    bootstrap_brokers         = aws_msk_cluster.kafka.bootstrap_brokers
    bootstrap_brokers_tls     = aws_msk_cluster.kafka.bootstrap_brokers_tls
    zookeeper_connect_string  = aws_msk_cluster.kafka.zookeeper_connect_string
    kafka_version            = aws_msk_cluster.kafka.kafka_version
    security_group_id        = aws_security_group.msk.id
  }
}

# Cost and resource information
output "cluster_details" {
  description = "Detailed cluster information"
  value = {
    arn                    = aws_msk_cluster.kafka.arn
    cluster_name          = aws_msk_cluster.kafka.cluster_name
    instance_type         = var.instance_type
    broker_count          = var.broker_count
    storage_volume_size   = var.storage_volume_size
    kafka_version         = var.kafka_version
    private_subnet_ids    = var.private_subnet_ids
    vpc_id               = var.vpc_id
  }
}