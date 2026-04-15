output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "parameter_group_name" {
  description = "Parameter group name"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.aurora[0].name : aws_db_parameter_group.rds[0].name
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_port" {
  description = "Database port"
  value       = var.port
}

output "db_identifier" {
  description = "DB identifier"
  value       = var.use_aurora ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
}

output "db_engine" {
  description = "Database engine"
  value       = var.engine
}

output "use_aurora" {
  description = "Aurora mode enabled or not"
  value       = var.use_aurora
}
