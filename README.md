# Project - Terraform Infrastructure with Universal RDS Module

## Опис
Цей проєкт містить AWS/Kubernetes інфраструктурні модулі та універсальний модуль `rds`, який може створювати:

- звичайну RDS instance (`use_aurora = false`)
- або Aurora cluster + writer (`use_aurora = true`)

## Структура
```text
Project/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   │   ├── rds.tf
│   │   ├── aurora.tf
│   │   ├── shared.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── jenkins/
│   └── argo_cd/
├── charts/
│   └── django-app/
└── README.md
```

## Приклад використання модуля

### Стандартна RDS
```hcl
module "rds" {
  source                 = "./modules/rds"
  name                   = "app-postgres"
  use_aurora             = false
  engine                 = "postgres"
  engine_version         = "16.3"
  parameter_group_family = "postgres16"
  instance_class         = "db.t3.medium"
  allocated_storage      = 20
  storage_type           = "gp3"
  multi_az               = false

  database_name          = "appdb"
  username               = "dbadmin"
  password               = "ChangeMe123!"
  port                   = 5432

  subnet_ids             = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  allowed_cidr_blocks    = ["10.0.0.0/16"]
}
```

### Aurora
```hcl
module "rds" {
  source                 = "./modules/rds"
  name                   = "app-aurora"
  use_aurora             = true
  engine                 = "aurora-postgresql"
  engine_version         = "16.1"
  parameter_group_family = "aurora-postgresql16"
  instance_class         = "db.r6g.large"

  database_name          = "appdb"
  username               = "dbadmin"
  password               = "ChangeMe123!"
  port                   = 5432

  subnet_ids             = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  allowed_cidr_blocks    = ["10.0.0.0/16"]
}
```

## Як змінити тип БД
- `use_aurora = false` → створюється `aws_db_instance`
- `use_aurora = true` → створюється `aws_rds_cluster` + `aws_rds_cluster_instance`

## Основні змінні
- `name` — базова назва ресурсів
- `use_aurora` — перемикач між RDS і Aurora
- `engine` — тип рушія: `postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql`
- `engine_version` — версія рушія
- `parameter_group_family` — family для parameter group
- `instance_class` — клас інстансу
- `multi_az` — Multi-AZ для стандартної RDS
- `allocated_storage` — розмір сховища для стандартної RDS
- `storage_type` — тип storage для стандартної RDS
- `database_name` — назва бази
- `username`, `password` — master credentials
- `port` — порт бази
- `subnet_ids` — приватні підмережі
- `vpc_id` — ID VPC
- `allowed_cidr_blocks` — доступ до БД
- `max_connections`, `log_statement`, `work_mem` — параметри parameter group
- `backup_retention_period` — retention для backup
- `skip_final_snapshot` — чи пропускати фінальний snapshot
- `deletion_protection` — захист від видалення
- `apply_immediately` — застосувати зміни одразу

## Що створює модуль
В обох режимах:
- `aws_db_subnet_group`
- `aws_security_group`
- parameter group

Для стандартної RDS:
- `aws_db_instance`

Для Aurora:
- `aws_rds_cluster`
- `aws_rds_cluster_instance` (writer)
