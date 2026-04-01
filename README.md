# Lesson 5 - Terraform AWS Infrastructure

## Опис
Цей проєкт створює AWS-інфраструктуру за допомогою Terraform:

- S3 bucket для збереження Terraform state
- DynamoDB table для state locking
- VPC з 3 публічними та 3 приватними підмережами
- Internet Gateway та NAT Gateway
- Route Tables для маршрутизації
- ECR repository для Docker-образів
- автоматичне сканування образів при push

## Структура проєкту

```text
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── .gitignore
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ecr/
│       ├── ecr.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## Опис модулів

### s3-backend
Створює:
- S3 bucket для Terraform state
- Versioning для bucket
- шифрування bucket
- DynamoDB table для блокування state

### vpc
Створює:
- VPC
- 3 public subnets
- 3 private subnets
- Internet Gateway
- NAT Gateway
- Route Tables та associations

### ecr
Створює:
- ECR repository
- image scanning on push
- lifecycle policy
- repository policy
- output з URL репозиторію

## Команди для запуску

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Важливий нюанс по backend

Terraform backend у S3 не можна використати до того, як S3 bucket і DynamoDB table вже створені.

Порядок такий:

1. Тимчасово закоментувати `backend.tf`
2. Виконати:
   ```bash
   terraform init
   terraform apply
   ```
3. Після створення bucket і table повернути `backend.tf`
4. Виконати:
   ```bash
   terraform init -reconfigure
   ```

## Outputs
- S3 bucket name
- DynamoDB table name
- VPC ID
- Public subnet IDs
- Private subnet IDs
- ECR repository URL
