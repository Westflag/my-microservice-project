locals {
  is_postgres       = can(regex("postgres", var.engine))
  aurora_engine_mode = var.use_aurora ? "provisioned" : null
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "DB access"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_db_parameter_group" "rds" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.name}-rds-pg"
  family = var.parameter_group_family

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  dynamic "parameter" {
    for_each = local.is_postgres ? [1] : []
    content {
      name  = "work_mem"
      value = var.work_mem
    }
  }

  tags = {
    Name = "${var.name}-rds-pg"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.name}-aurora-pg"
  family = var.parameter_group_family

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  dynamic "parameter" {
    for_each = local.is_postgres ? [1] : []
    content {
      name  = "work_mem"
      value = var.work_mem
    }
  }

  tags = {
    Name = "${var.name}-aurora-pg"
  }
}
