# Django + PostgreSQL + Nginx with Docker Compose

Цей проєкт відповідає вимогам завдання:
- **Django** — вебзастосунок
- **PostgreSQL** — база даних
- **Nginx** — проксі для обробки запитів
- **Docker / Docker Compose** — контейнеризація всіх сервісів

## Структура проєкту

```bash
.
├── app/
│   ├── config/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── manage.py
│   └── requirements.txt
├── nginx/
│   └── nginx.conf
├── .env.example
├── .gitignore
├── docker-compose.yml
└── README.md
```

## Як запустити

### 1. Клонувати репозиторій і перейти в директорію

```bash
git clone https://github.com/Westflag/my-microservice-project.git
cd my-microservice-project
```

### 2. Перейти у гілку `lesson-4`

```bash
git checkout lesson-4
```

### 3. Створити `.env`

```bash
cp .env.example .env
```

### 4. Запустити контейнери

```bash
docker compose up -d --build
```

### 5. Перевірити роботу

Відкрити:
- `http://localhost` — відповідь від Django через Nginx
- `http://localhost/admin` — Django admin

### 6. Перевірити контейнери

```bash
docker compose ps
```

### 7. Перевірити логи

```bash
docker compose logs -f
```

## Перевірка PostgreSQL

Підключення до БД можна перевірити так:

```bash
docker exec -it postgres_db psql -U postgres -d postgres
```

## Що реалізовано

- Django-застосунок у контейнері `web`
- PostgreSQL у контейнері `db`
- Nginx у контейнері `nginx`
- Dockerfile для Python 3.11
- `docker-compose.yml` для запуску всіх сервісів
- `nginx.conf` для проксирування на Django
- `.env.example` для змінних середовища
