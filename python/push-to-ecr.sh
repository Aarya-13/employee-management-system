#!/bin/bash

# AWS ECR Push Script
# This script pushes Docker images to AWS ECR

set -e

# Configuration
AWS_REGION=${AWS_REGION:-"us-east-1"}
AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-"YOUR_AWS_ACCOUNT_ID"}
ECR_REPOSITORY_NAME=${ECR_REPOSITORY_NAME:-"employee-management"}

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 AWS ECR Push Script${NC}"
echo ""

# Validate AWS credentials
echo "🔐 Validating AWS credentials..."
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "❌ AWS credentials not configured. Please run: aws configure"
    exit 1
fi

# Get AWS Account ID if not provided
if [ "$AWS_ACCOUNT_ID" == "YOUR_AWS_ACCOUNT_ID" ]; then
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    echo "✅ AWS Account ID: $AWS_ACCOUNT_ID"
fi

# ECR Registry URL
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "📋 Configuration:"
echo "   AWS Region: $AWS_REGION"
echo "   AWS Account: $AWS_ACCOUNT_ID"
echo "   ECR Registry: $ECR_REGISTRY"
echo ""

# Create ECR repositories if they don't exist
echo "📦 Creating ECR repositories (if needed)..."

for repo in "employee-api" "employee-ui"; do
    if aws ecr describe-repositories --repository-names "$repo" --region "$AWS_REGION" &> /dev/null; then
        echo "✅ Repository $repo already exists"
    else
        echo "📝 Creating repository $repo..."
        aws ecr create-repository --repository-name "$repo" --region "$AWS_REGION" --image-scan-on-push
    fi
done

# Login to ECR
echo ""
echo "🔑 Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"

# Tag and push backend image
echo ""
echo "📤 Pushing backend image..."
docker tag employee-api:latest "${ECR_REGISTRY}/employee-api:latest"
docker push "${ECR_REGISTRY}/employee-api:latest"
echo -e "${GREEN}✅ Backend image pushed!${NC}"

# Tag and push frontend image
echo ""
echo "📤 Pushing frontend image..."
docker tag employee-ui:latest "${ECR_REGISTRY}/employee-ui:latest"
docker push "${ECR_REGISTRY}/employee-ui:latest"
echo -e "${GREEN}✅ Frontend image pushed!${NC}"

echo ""
echo -e "${GREEN}🎉 All images pushed successfully!${NC}"
echo ""
echo "📝 Next steps:"
echo "   1. Deploy using ECS/EKS or EC2"
echo "   2. Update your deployment configuration with these image URIs:"
echo "      - Backend: ${ECR_REGISTRY}/employee-api:latest"
echo "      - Frontend: ${ECR_REGISTRY}/employee-ui:latest"
