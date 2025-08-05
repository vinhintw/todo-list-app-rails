#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Todo List App Rails - Cleanup Script${NC}"
echo "========================================"

# Stop and remove containers
echo -e "${YELLOW}🛑 Stopping and removing containers...${NC}"
docker compose --env-file .env.production.local down -v

# Remove images
echo -e "${YELLOW}🗑️  Removing Docker images...${NC}"
docker compose --env-file .env.production.local down --rmi all

echo -e "${GREEN}✅ Cleanup completed!${NC}"
