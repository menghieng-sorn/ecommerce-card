#!/bin/bash

set -e

# ==========================================
# Configuration
# ==========================================

PROJECT_DIR="/home/ubuntu/ecommerce-card"

REPOSITORY="https://github.com/menghieng-sorn/ecommerce-card.git"

BRANCH="dev"

IMAGE_NAME="$1"

APP_VERSION="${2:-latest}"

# ==========================================
# Check image name
# ==========================================

if [ -z "$IMAGE_NAME" ]; then

    echo "ERROR: Docker image name is required."

    echo ""
    echo "Usage:"
    echo "./server-script.sh menghieng002/ecommerce-card:1 [app-version]"

    exit 1

fi


echo "=========================================="
echo "Laravel Deployment"
echo "=========================================="

echo "Project:    $PROJECT_DIR"
echo "Repository: $REPOSITORY"
echo "Branch:     $BRANCH"
echo "Image:      $IMAGE_NAME"
echo "Version:    $APP_VERSION"

echo "=========================================="


# ==========================================
# Update Ubuntu
# ==========================================

echo "Updating Ubuntu packages..."

sudo apt-get update


# ==========================================
# Install Git
# ==========================================

if ! command -v git >/dev/null 2>&1; then

    echo "Installing Git..."

    sudo apt-get install -y git

else

    echo "Git already installed."

fi


# ==========================================
# Install Docker
# ==========================================

if ! command -v docker >/dev/null 2>&1; then

    echo "Installing Docker..."

    sudo apt-get install -y docker.io

    sudo systemctl enable docker

else

    echo "Docker already installed."

fi


# ==========================================
# Start Docker
# ==========================================

echo "Starting Docker..."

sudo systemctl start docker


# ==========================================
# Clone / Update Laravel repository
# ==========================================

if [ -d "$PROJECT_DIR/.git" ]; then

    echo "Repository already exists."

    cd "$PROJECT_DIR"

    echo "Fetching latest code..."

    git fetch origin

    git checkout "$BRANCH"

    git reset --hard "origin/$BRANCH"

else

    echo "Cloning Laravel repository..."

    cd /home/ubuntu

    git clone \
        -b "$BRANCH" \
        "$REPOSITORY" \
        ecommerce-card

fi


# ==========================================
# Go to project
# ==========================================

cd "$PROJECT_DIR"


# ==========================================
# .env handling
#
# Priority:
#   1. If $ENV_FILE is set (passed from Jenkins), use it.
#   2. Else if /home/ubuntu/.env.ecommerce-card exists, use it.
#   3. Else fall back to .env.example (NOT for production — secrets missing).
# ==========================================

if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then

    echo "Using env file from \$ENV_FILE=$ENV_FILE"

    cp "$ENV_FILE" .env

elif [ -f "/home/ubuntu/.env.ecommerce-card" ]; then

    echo "Using env file /home/ubuntu/.env.ecommerce-card"

    cp /home/ubuntu/.env.ecommerce-card .env

elif [ ! -f ".env" ]; then

    echo "WARNING: No .env found, falling back to .env.example."
    echo "         This will NOT have real secrets — app will fail to boot."

    cp .env.example .env

else

    echo "Using existing .env in repo"

fi

chmod 600 .env


# Ensure required production-safe defaults are set
if ! grep -q "^APP_KEY=" .env || grep -q "^APP_KEY=$" .env; then

    echo "Generating APP_KEY..."

    APP_KEY="base64:$(openssl rand -base64 32)"
    sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" .env

fi

sed -i "s|^APP_ENV=.*|APP_ENV=production|" .env
sed -i "s|^APP_DEBUG=.*|APP_DEBUG=false|" .env


# ==========================================
# Permissions
# ==========================================

echo "Setting storage permissions..."

sudo chown -R www-data:www-data \
    storage bootstrap/cache || true

sudo find storage bootstrap/cache -type d -exec chmod 775 {} \; || true
sudo find storage bootstrap/cache -type f -exec chmod 664 {} \; || true


# ==========================================
# Build Docker image
# ==========================================

echo "=========================================="
echo "Building Docker image"
echo "=========================================="

# Build-time secrets (passed as ARGs, NOT baked into final image layers beyond build)
sudo docker build \
    --pull \
    --build-arg APP_ENV=production \
    --build-arg APP_VERSION="$APP_VERSION" \
    --secret id=env_file,src=.env \
    --no-cache \
    -t "$IMAGE_NAME" \
    -f Dockerfile \
    .

# IMPORTANT: delete .env copy so secrets don't sit on disk
shred -u .env 2>/dev/null || rm -f .env

# Re-create a placeholder .env for the next run (will be overwritten)
echo "APP_KEY=" > .env
chmod 600 .env


# ==========================================
# Show image
# ==========================================

echo "=========================================="
echo "Docker image created"
echo "=========================================="

sudo docker images "$IMAGE_NAME"


echo "=========================================="
echo "Build completed successfully"
echo "=========================================="
