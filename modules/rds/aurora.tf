resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier              = "${var.name}-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  engine_mode                     = local.aurora_engine_mode
  database_name                   = var.database_name
  master_username                 = var.username
  master_password                 = var.password
  port                            = var.port
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = true
  copy_tags_to_snapshot           = true

  tags = {
    Name = "${var.name}-cluster"
    Type = "aurora"
  }
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier                 = "${var.name}-writer"
  cluster_identifier         = aws_rds_cluster.this[0].id
  instance_class             = var.instance_class
  engine                     = var.engine
  engine_version             = var.engine_version
  db_subnet_group_name       = aws_db_subnet_group.this.name
  publicly_accessible        = var.publicly_accessible
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.name}-writer"
    Role = "writer"
  }
}
