# Final DevOps Project — AWS + Terraform + EKS + Jenkins + Argo CD + Monitoring

## Опис
Цей проєкт реалізує повний DevOps/GitOps цикл для Django-застосунку в AWS з використанням:
- **Terraform** — інфраструктура як код
- **AWS** — VPC, EKS, RDS, ECR, S3, DynamoDB
- **Jenkins** — CI pipeline
- **Helm** — встановлення Jenkins, Argo CD, Prometheus, Grafana та деплой застосунку
- **Argo CD** — GitOps синхронізація Helm chart з Git
- **Prometheus + Grafana** — моніторинг кластера та застосунку

## Компоненти інфраструктури
- **VPC** з public/private subnets, routing та security groups
- **EKS** кластер з managed node group та IAM ролями
- **RDS** модуль зі звичайною RDS або Aurora
- **ECR** для зберігання Docker-образів
- **Jenkins** в Kubernetes через Helm
- **Argo CD** в Kubernetes через Helm
- **Monitoring** через `kube-prometheus-stack` (Prometheus + Grafana + Alertmanager)
- **Django app** + Helm chart для Kubernetes деплою

## Структура проєкту
```text
Project/
├── main.tf
├── backend.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── README.md
├── modules/
│  ├── s3-backend/
│  ├── vpc/
│  ├── ecr/
│  ├── eks/
│  ├── rds/
│  ├── jenkins/
│  ├── argo_cd/
│  └── monitoring/
├── charts/
│  └── django-app/
└── Django/
   ├── app/
   ├── Dockerfile
   ├── Jenkinsfile
   ├── docker-compose.yaml
   ├── manage.py
   └── requirements.txt
```


## Передумови
Перед запуском переконайтесь, що встановлено:
- Terraform >= 1.5
- AWS CLI
- kubectl
- Helm
- доступ до AWS акаунта з правами на EKS, ECR, IAM, RDS, VPC, S3, DynamoDB

## Важливі змінні
У `terraform.tfvars` або через environment variables задайте:
- `aws_region`
- `jenkins_admin_password`
- `grafana_admin_password`
- `gitops_repo_url`
- `gitops_repo_branch`
- `gitops_chart_path`
- `db_name`
- `db_username`
- `db_password`
- `db_port`

## Ініціалізація Terraform
Оскільки `backend.tf` використовує S3 + DynamoDB для state, а ці ресурси також створюються Terraform, перший запуск потрібно робити у два етапи.

### Перший запуск (bootstrap backend)
```bash
terraform init -backend=false
terraform fmt -recursive
terraform validate
terraform apply -target=module.s3_backend
```

### Після створення S3/DynamoDB
```bash
terraform init -reconfigure
```

## Розгортання інфраструктури
```bash
terraform apply
```

Після завершення перевірте ресурси:
```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

## Перевірка доступності сервісів
### Jenkins
```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```
Після цього Jenkins буде доступний на `http://localhost:8080`

### Argo CD
```bash
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```
Argo CD буде доступний на `https://localhost:8081`

### Grafana
```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
Grafana буде доступна на `http://localhost:3000`

## CI/CD flow
1. Розробник пушить зміни в репозиторій Django-застосунку.
2. Jenkins запускає pipeline з `Jenkinsfile`.
3. Pipeline:
   - виконує checkout коду;
   - збирає Docker image через **Kaniko**;
   - пушить образ у **Amazon ECR**;
   - клонує GitOps repo;
   - оновлює `charts/django-app/values.yaml` новим image tag;
   - комітить і пушить зміни в `main`.
4. **Argo CD** відстежує GitOps repository.
5. Після push у Git Argo CD автоматично синхронізує Helm chart з EKS.
6. **Prometheus** збирає метрики, **Grafana** показує дашборди.

## Як перевірити Jenkins pipeline
1. Відкрити Jenkins.
2. Створити pipeline job, який використовує `Django/Jenkinsfile` як Pipeline Script from SCM.
3. Переконатись, що build:
   - успішно виконав Kaniko build;
   - запушив образ в ECR;
   - оновив GitOps repo.

## Як перевірити результат в Argo CD
1. Відкрити Argo CD UI.
2. Перевірити application `django-app`.
3. Статус має бути `Healthy` та `Synced`.
4. Після нового Jenkins build tag в Helm values має оновитися автоматично.

## Як перевірити моніторинг
1. Відкрити Grafana.
2. Перевірити стандартні dashboards:
   - Kubernetes / Compute Resources / Cluster
   - Kubernetes / Compute Resources / Namespace (Pods)
   - Node Exporter Full
3. Переконатись, що метрики з namespace `jenkins`, `argocd`, `monitoring` та застосунку доступні.

## Порядок запуску після `terraform destroy`
Після повного видалення інфраструктури видаляються також **S3 bucket** та **DynamoDB table** для Terraform state.
Тому повторний запуск робиться у такому порядку:
1. Знову створити backend ресурси (`s3-backend`), якщо вони видалені.
2. Оновити або перевірити `backend.tf`.
3. Запустити `terraform init`.
4. Лише після цього виконати `terraform apply`.

## Видалення ресурсів
Після перевірки **обов'язково** видаліть ресурси, щоб уникнути зайвих витрат:
```bash
terraform destroy
```

## Примітки
- У Jenkins потрібно створити credentials для AWS та GitHub/GitLab token.
- Для реального продакшен-використання паролі не слід зберігати в plaintext у `tfvars`; краще використовувати AWS Secrets Manager або SSM Parameter Store.
- `charts/django-app` містить HPA, ConfigMap, Service та Deployment.


## Відповідність структурі
- У корені є: `main.tf`, `backend.tf`, `outputs.tf`.
- У `modules/` присутні: `s3-backend`, `vpc`, `ecr`, `eks`, `rds`, `jenkins`, `argo_cd`, `monitoring`.
- У `modules/argo_cd/charts/` файли розміщено у вигляді `Chart.yaml`, `values.yaml`, `templates/application.yaml`, `templates/repository.yaml`.
- У `charts/django-app/` присутні `deployment.yaml`, `service.yaml`, `configmap.yaml`, `hpa.yaml`, `Chart.yaml`, `values.yaml`.
- У `Django/` присутні `app/`, `Dockerfile`, `Jenkinsfile`, `docker-compose.yaml`.


## Фінальна перевірка
Перед здачею рекомендовано виконати:
```bash
terraform fmt -recursive
terraform validate
helm lint charts/django-app
```
