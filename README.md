# CI/CD for Django with Terraform + Jenkins + Helm + Argo CD

Цей проєкт реалізує повний CI/CD та GitOps-процес для Django-застосунку в AWS EKS.

## Що реалізовано

- **Terraform** створює інфраструктуру: S3 backend, DynamoDB lock table, VPC, ECR, EKS, Jenkins, Argo CD.
- **Jenkins** встановлюється через **Helm** і запускає pipeline із Kubernetes Agent.
- **Kaniko** збирає Docker-образ без Docker-in-Docker.
- Образ **публікується в Amazon ECR**.
- Jenkins **оновлює `values.yaml`** у GitOps-репозиторії з новим тегом образу.
- **Argo CD** відстежує GitOps-репозиторій і **автоматично синхронізує** зміни в кластері.

## CI/CD схема

```text
Developer push -> Jenkins pipeline -> Kaniko build -> Amazon ECR
                                      |
                                      v
                              Update values.yaml in GitOps repo
                                      |
                                      v
                               Argo CD detects Git change
                                      |
                                      v
                               Sync Helm chart to EKS
```

## Структура

```text
Project/
├── main.tf
├── backend.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── Jenkinsfile
├── README.md
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── jenkins/
│   └── argo_cd/
└── charts/
    └── django-app/
```

## Передумови

Потрібно мати:

- AWS account
- Terraform >= 1.5
- kubectl
- Helm
- AWS CLI
- GitHub репозиторій із Helm values для GitOps
- Dockerfile для Django-застосунку

## 1. Ініціалізація Terraform backend

Спочатку створюється S3 bucket і DynamoDB table для remote state. Після цього можна використовувати `backend.tf`.

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply -auto-approve
```

## 2. Що створює Terraform

- VPC з public/private subnet
- ECR repository
- EKS cluster
- Jenkins у namespace `jenkins`
- Argo CD у namespace `argocd`

## 3. Налаштування Jenkins

Після `terraform apply` перевірити ресурси:

```bash
kubectl get nodes
kubectl get pods -n jenkins
kubectl get svc -n jenkins
```

Отримати initial admin password Jenkins:

```bash
kubectl exec -n jenkins svc/jenkins -c jenkins -- cat /run/secrets/additional/chart-admin-password
```

У Jenkins потрібно створити credentials:

- `aws-access-key-id` — Secret text
- `aws-secret-access-key` — Secret text
- `gitops-pat` — Username with password або PAT для GitOps repo

Також треба створити pipeline job, який використовує `Jenkinsfile` з цього репозиторію.

## 4. Що робить Jenkins pipeline

Pipeline виконує такі кроки:

1. Checkout application source.
2. Запускає Kubernetes Agent із контейнером **Kaniko**.
3. Збирає Docker image з `Dockerfile`.
4. Пушить image в **Amazon ECR** з тегом `${BUILD_NUMBER}-${GIT_COMMIT:0:7}` і `latest`.
5. Клонує GitOps repository.
6. Оновлює `charts/django-app/values.yaml`.
7. Комітить і пушить зміни в `main`.

## 5. Як перевірити Jenkins job

У Jenkins після запуску job потрібно перевірити:

- чи завершився build зі статусом **Success**;
- чи з’явився новий image tag в ECR;
- чи з’явився commit у GitOps repo;
- чи оновився `values.yaml`.

Перевірка ECR:

```bash
aws ecr describe-images --repository-name django-app-ecr --region us-west-2
```

Перевірка GitOps repo:

```bash
git log --oneline -n 5
cat charts/django-app/values.yaml
```

## 6. Налаштування Argo CD

Після встановлення перевірити:

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
kubectl get applications -n argocd
```

Отримати пароль Argo CD admin:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

Після того як Jenkins оновить GitOps repo, Argo CD повинен:

- побачити новий commit;
- запустити automated sync;
- оновити Deployment у кластері.

## 7. Як побачити результат в Argo CD

В UI Argo CD потрібно перевірити:

- Application статус = **Synced**;
- Health статус = **Healthy**;
- revision відповідає останньому commit із GitOps repo.

CLI-перевірка:

```bash
kubectl get applications -n argocd
kubectl describe application django-app -n argocd
kubectl get deployment,svc,hpa -n django-app
```

## 8. Корисні команди

```bash
terraform output
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n django-app
helm list -A
```

## Примітки

- Для production краще використовувати **IRSA** замість статичних AWS credentials у Jenkins.
- GitHub PAT також варто зберігати у Kubernetes Secret або зовнішньому secret manager.
- За потреби `Jenkinsfile` можна розширити тестами, security scanning і promotion між середовищами.
