# Lesson 7 - Terraform AWS Infrastructure + EKS + Helm

## Опис
Проєкт створює AWS-інфраструктуру та Kubernetes середовище для Django-застосунку:

- S3 bucket для Terraform state
- DynamoDB table для state locking
- VPC з 3 public та 3 private subnets
- Internet Gateway та NAT Gateway
- ECR repository для Docker-образу
- EKS cluster у тій самій VPC
- Helm chart для Django-застосунку

## Структура проєкту

```text
lesson-7/
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
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
```

## Команди

```bash
terraform init
terraform plan
terraform apply
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks
helm upgrade --install django-app ./charts/django-app
```
