#!/bin/bash

set -e  # зупиняє скрипт при помилці

echo "🚀 Starting development tools installation..."

# -------------------------------
# Helper function
# -------------------------------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# -------------------------------
# Update system
# -------------------------------
echo "🔄 Updating package list..."
sudo apt update -y

# -------------------------------
# Install Docker
# -------------------------------
if command_exists docker; then
  echo "✅ Docker already installed"
else
  echo "📦 Installing Docker..."
  sudo apt install -y ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update -y
  sudo apt install -y docker-ce docker-ce-cli containerd.io

  sudo systemctl enable docker
  sudo systemctl start docker

  echo "✅ Docker installed"
fi

# -------------------------------
# Install Docker Compose
# -------------------------------
if command_exists docker-compose; then
  echo "✅ Docker Compose already installed"
else
  echo "📦 Installing Docker Compose..."
  sudo apt install -y docker-compose
  echo "✅ Docker Compose installed"
fi

# -------------------------------
# Install Python
# -------------------------------
if command_exists python3; then
  echo "✅ Python already installed: $(python3 --version)"
else
  echo "📦 Installing Python..."
  sudo apt install -y python3 python3-pip
  echo "✅ Python installed"
fi

# -------------------------------
# Install pip (if needed)
# -------------------------------
if command_exists pip3; then
  echo "✅ pip already installed"
else
  echo "📦 Installing pip..."
  sudo apt install -y python3-pip
fi

# -------------------------------
# Install Django
# -------------------------------
if python3 -m django --version >/dev/null 2>&1; then
  echo "✅ Django already installed"
else
  echo "📦 Installing Django..."
  pip3 install --user django
  echo "✅ Django installed"
fi

# -------------------------------
# Done
# -------------------------------
echo "🎉 All tools installed successfully!"
