#!/bin/bash

# Build Docker Images Script
# This script builds Docker images for the Employee Management System

set -e

echo "🔨 Building Docker images..."

# Build backend image
echo "📦 Building backend image..."
docker build -f Dockerfile.backend -t employee-api:latest .

# Build frontend image
echo "📦 Building frontend image..."
docker build -f Dockerfile.frontend -t employee-ui:latest .

echo "✅ Docker images built successfully!"
echo ""
echo "Available images:"
docker images | grep employee-
