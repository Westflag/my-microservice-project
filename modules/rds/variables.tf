variable "name" {
  description = "Base name for RDS/Aurora resources"
  type        = string
  default     = "app-db"
}

variable "use_aurora" {
  description = "If true, create Aurora cluster + writer. If false, create a single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine: postgres, mysql, aurora-postgresql, aurora-mysql"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora writer"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for standard RDS"
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "dbadmin"
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the DB"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "parameter_group_family" {
  description = "Parameter group family: postgres16, mysql8.0, aurora-postgresql16, aurora-mysql8.0"
  type        = string
  default     = "postgres16"
}

variable "max_connections" {
  description = "Value for max_connections"
  type        = string
  default     = "100"
}

variable "log_statement" {
  description = "Value for log_statement"
  type        = string
  default     = "all"
}

variable "work_mem" {
  description = "Value for work_mem"
  type        = string
  default     = "4096"
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether DB is publicly accessible"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}
