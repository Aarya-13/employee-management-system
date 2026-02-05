#!/bin/bash

# AWS EC2 Deployment Script
# This script sets up Docker and deploys the application on an EC2 instance

set -e

# Configuration
AWS_REGION=${AWS_REGION:-"us-east-1"}
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "🚀 Setting up EC2 instance for Employee Management System..."

# Update system packages
echo "📦 Updating system packages..."
sudo yum update -y

# Install Docker
echo "🐳 Installing Docker..."
sudo yum install docker -y
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

# Install Docker Compose
echo "📋 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
echo "☁️ Installing AWS CLI..."
sudo yum install awscli -y

# Create application directory
echo "📁 Creating application directory..."
sudo mkdir -p /opt/employee-management
sudo chown ec2-user:ec2-user /opt/employee-management
cd /opt/employee-management

# Login to ECR
echo "🔑 Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"

# Pull docker-compose file from repository or create it
# For this example, we'll assume it's already in the instance or available in S3
echo "📥 Downloading docker-compose configuration..."
# You can either:
# 1. Copy from S3: aws s3 cp s3://your-bucket/docker-compose.yml .
# 2. Or create it here with hardcoded values

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  backend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/employee-api:latest
    container_name: employee-api
    ports:
      - "8000:8000"
    environment:
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_USER=root
      - DB_PASSWORD=${DB_PASSWORD:-root}
      - DB_NAME=${DB_NAME:-employee_db}
      - DEBUG=${DEBUG:-False}
      - CORS_ORIGINS=http://localhost:3000,http://frontend:3000
    depends_on:
      - mysql
    networks:
      - app-network
    restart: unless-stopped

  frontend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/employee-ui:latest
    container_name: employee-ui
    ports:
      - "80:3000"
    environment:
      - VITE_API_URL=http://localhost:8000/api
    depends_on:
      - backend
    networks:
      - app-network
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    container_name: employee-db
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_PASSWORD:-root}
      - MYSQL_DATABASE=${DB_NAME:-employee_db}
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app-network
    restart: unless-stopped

volumes:
  mysql_data:
    driver: local

networks:
  app-network:
    driver: bridge
EOF

# Create environment file
echo "⚙️ Creating environment configuration..."
cat > .env << 'EOF'
DB_PASSWORD=secure_password_here
DB_NAME=employee_db
DEBUG=False
EOF

# Start application
echo "🚀 Starting application with Docker Compose..."
docker-compose pull
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📍 Access your application:"
echo "   Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):80"
echo "   Backend API: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8000"
echo ""
echo "📋 Useful commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Restart services: docker-compose restart"
