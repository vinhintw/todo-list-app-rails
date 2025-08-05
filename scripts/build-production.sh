#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐳 Todo List App Rails - Production Build Script${NC}"
echo "=================================================="

# Check if running on ARM Mac
if [[ $(uname -m) == "arm64" ]]; then
    echo -e "${GREEN}✅ Detected ARM64 architecture${NC}"
    export DOCKER_DEFAULT_PLATFORM=linux/arm64
else
    echo -e "${YELLOW}⚠️  Not running on ARM64, using default platform${NC}"
fi

# Check if .env.production.local exists
if [ ! -f .env.production.local ]; then
    echo -e "${YELLOW}⚠️  Creating .env.production.local from template${NC}"
    cp .env.production .env.production.local
    
    # Generate SECRET_KEY_BASE if Rails is available
    if command -v rails &> /dev/null; then
        echo -e "${BLUE}🔑 Generating SECRET_KEY_BASE...${NC}"
        SECRET_KEY=$(bundle exec rails secret)
        sed -i.bak "s/your_secret_key_base_here/$SECRET_KEY/" .env.production.local
    fi
    
    # Try to get RAILS_MASTER_KEY
    if [ -f config/master.key ]; then
        echo -e "${BLUE}🔐 Using RAILS_MASTER_KEY from config/master.key${NC}"
        MASTER_KEY=$(cat config/master.key)
        sed -i.bak "s/your_master_key_here/$MASTER_KEY/" .env.production.local
    fi
    
    echo -e "${RED}🚨 IMPORTANT: Please edit .env.production.local and update the passwords and secrets!${NC}"
    echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
    read
fi

# Load environment variables
if [ -f .env.production.local ]; then
    export $(cat .env.production.local | grep -v '^#' | xargs)
    echo -e "${GREEN}✅ Loaded environment variables from .env.production.local${NC}"
fi

# Build the images
echo -e "${BLUE}🏗️  Building Docker images...${NC}"
docker compose --env-file .env.production.local build --no-cache

# Start the services
echo -e "${BLUE}🚀 Starting services...${NC}"
docker compose --env-file .env.production.local up -d

# Wait for services to be healthy
echo -e "${BLUE}⏳ Waiting for services to be healthy...${NC}"
docker compose --env-file .env.production.local ps

# Setup database
echo -e "${BLUE}🗄️  Setting up database...${NC}"
docker compose --env-file .env.production.local exec app bin/rails db:create db:migrate db:seed

echo -e "${GREEN}✅ Application is ready!${NC}"
echo -e "${BLUE}🌐 Access your app at: http://localhost:${APP_PORT:-3000}${NC}"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  docker compose --env-file .env.production.local logs -f app  # View app logs"
echo "  docker compose --env-file .env.production.local logs -f db   # View database logs"
echo "  docker compose --env-file .env.production.local down         # Stop services"
echo "  docker compose --env-file .env.production.local exec app bin/rails console  # Rails console"
