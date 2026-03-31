# Lesson 5 - Terraform AWS Infrastructure

## Опис
Цей проєкт створює AWS-інфраструктуру за допомогою Terraform:
- S3 bucket для Terraform state
- DynamoDB для locking
- VPC з публічними та приватними підмережами
- ECR repository

## Команди
terraform init
terraform plan
terraform apply
terraform destroy

## Backend нюанс
Спочатку закоментуйте backend.tf, виконайте apply, потім:
terraform init -reconfigure
