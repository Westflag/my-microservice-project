

# Dev Tools Installation Script

This repository contains a Bash script `install_dev_tools.sh` that installs:

- Docker
- Docker Compose
- Python (3.9+)
- Django (via pip)

The script checks if tools are already installed to avoid duplication.

---

## 🚀 How to Run the Script

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
```
### 2. Make the script executable

```bash
chmod u+x install_dev_tools.sh
```

### 3. Run the script 

```bash
./install_dev_tools.sh
```

### 4. Verify Installation

```bash
docker --version
docker-compose --version
python3 --version
pip3 --version
python3 -m django --version
```
