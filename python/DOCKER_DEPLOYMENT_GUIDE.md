# Docker and AWS Deployment Guide

## Complete Guide to Dockerizing and Deploying on AWS

### Table of Contents
1. [Prerequisites](#prerequisites)
2. [Building Docker Images](#building-docker-images)
3. [Local Testing with Docker Compose](#local-testing-with-docker-compose)
4. [Pushing to AWS ECR](#pushing-to-aws-ecr)
5. [Deploying to AWS EC2](#deploying-to-aws-ec2)
6. [Security Best Practices](#security-best-practices)
7. [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)

---

## Prerequisites

### Required Tools
- Docker installed locally
- Docker Compose installed
- AWS Account with appropriate permissions
- AWS CLI configured with credentials
- Git (for version control)

### AWS Permissions Required
```
ecr:CreateRepository
ecr:GetDownloadUrlForLayer
ecr:PutImage
ecr:InitiateLayerUpload
ecr:UploadLayerPart
ecr:CompleteLayerUpload
ec2:RunInstances
ec2:DescribeInstances
ec2:TerminateInstances
```

### Installation Steps (if needed)
```bash
# Install Docker (macOS/Linux)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and preferred region
```

---

## Building Docker Images

### Step 1: Prepare Docker Files
All Docker files are already created in your project:
- `Dockerfile.backend` - For Python FastAPI backend
- `Dockerfile.frontend` - For React/Vite frontend
- `docker-compose.yml` - For local orchestration

### Step 2: Build Images Locally

**Option A: Manual Build**
```bash
cd /path/to/project

# Build backend image
docker build -f Dockerfile.backend -t employee-api:latest .

# Build frontend image
docker build -f Dockerfile.frontend -t employee-ui:latest .

# Verify images
docker images | grep employee-
```

**Option B: Using Build Script**
```bash
chmod +x build-docker.sh
./build-docker.sh
```

### Step 3: Verify Images
```bash
docker images
# Output:
# REPOSITORY      TAG         IMAGE ID       CREATED      SIZE
# employee-ui     latest      abc123...      2 hours ago  180MB
# employee-api    latest      def456...      2 hours ago  250MB
```

---

## Local Testing with Docker Compose

### Step 1: Test Locally

```bash
cd /path/to/project

# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f

# Test endpoints
curl http://localhost:8000/api/employees    # Backend API
curl http://localhost:3000                   # Frontend
```

### Step 2: Verify All Services

```bash
# Check backend health
curl http://localhost:8000/health

# Check database connection
docker-compose exec mysql mysqladmin ping -h localhost

# View backend logs
docker-compose logs backend

# View frontend logs
docker-compose logs frontend
```

### Step 3: Stop Local Services

```bash
# Stop all services (data persists)
docker-compose stop

# Remove all containers
docker-compose down

# Remove all data including volumes
docker-compose down -v
```

---

## Pushing to AWS ECR

### Step 1: Create ECR Repositories

```bash
# Set your AWS region
export AWS_REGION="us-east-1"

# Create backend repository
aws ecr create-repository \
  --repository-name employee-api \
  --region $AWS_REGION \
  --image-scan-on-push

# Create frontend repository
aws ecr create-repository \
  --repository-name employee-ui \
  --region $AWS_REGION \
  --image-scan-on-push
```

### Step 2: Login to ECR

```bash
# Get your AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin \
  ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

### Step 3: Tag and Push Images

```bash
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Tag backend image
docker tag employee-api:latest ${ECR_REGISTRY}/employee-api:latest

# Push backend image
docker push ${ECR_REGISTRY}/employee-api:latest

# Tag frontend image
docker tag employee-ui:latest ${ECR_REGISTRY}/employee-ui:latest

# Push frontend image
docker push ${ECR_REGISTRY}/employee-ui:latest
```

### Step 4: Verify in ECR

```bash
# List repositories
aws ecr describe-repositories --region $AWS_REGION

# List images in repository
aws ecr describe-images \
  --repository-name employee-api \
  --region $AWS_REGION
```

**Or use the automated script:**
```bash
chmod +x push-to-ecr.sh
./push-to-ecr.sh
```

---

## Deploying to AWS EC2

### Step 1: Launch EC2 Instance

```bash
# Using AWS Console or AWS CLI:
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t2.medium \
  --key-name your-key-pair \
  --security-groups docker-app \
  --region us-east-1 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=EmployeeApp}]'
```

**Instance Requirements:**
- AMI: Amazon Linux 2 (ami-0c55b159cbfafe1f0) or Ubuntu
- Instance Type: t2.medium minimum (t2.small for testing)
- Storage: 20GB minimum
- Security Group: Allow ports 80, 443, 8000, 3306

### Step 2: Configure Security Group

```bash
# Allow HTTP traffic (port 80)
aws ec2 authorize-security-group-ingress \
  --group-name docker-app \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# Allow HTTPS traffic (port 443)
aws ec2 authorize-security-group-ingress \
  --group-name docker-app \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0

# Allow backend API (port 8000) - restrict to your IP
aws ec2 authorize-security-group-ingress \
  --group-name docker-app \
  --protocol tcp \
  --port 8000 \
  --cidr YOUR_IP/32

# Allow SSH (port 22)
aws ec2 authorize-security-group-ingress \
  --group-name docker-app \
  --protocol tcp \
  --port 22 \
  --cidr YOUR_IP/32
```

### Step 3: Connect to Instance

```bash
# SSH into the instance
ssh -i your-key-pair.pem ec2-user@your-instance-public-ip
```

### Step 4: Deploy Application

**Option A: Automated Deployment Script**
```bash
# On your local machine, copy the deployment script to EC2
scp -i your-key-pair.pem deploy-ec2.sh ec2-user@your-instance-ip:~/

# SSH into instance
ssh -i your-key-pair.pem ec2-user@your-instance-ip

# Run deployment script
chmod +x deploy-ec2.sh
./deploy-ec2.sh
```

**Option B: Manual Deployment Steps**
```bash
# Update system
sudo yum update -y

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create app directory
sudo mkdir -p /opt/employee-management
cd /opt/employee-management

# Copy docker-compose.yml from your local machine
scp -i your-key-pair.pem docker-compose.yml ec2-user@your-instance-ip:~/docker-compose.yml

# Login to ECR and pull images
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# Start services
docker-compose up -d
```

### Step 5: Verify Deployment

```bash
# Check running containers
docker-compose ps

# View logs
docker-compose logs -f

# Test endpoints
curl http://localhost:8000/health
curl http://localhost:80

# Get instance public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

---

## Security Best Practices

### 1. Environment Variables
```bash
# Create .env file with sensitive data
cat > .env << 'EOF'
DB_PASSWORD=your_secure_password_here
CORS_ORIGINS=http://yourdomain.com
EOF

# Use in docker-compose
docker-compose --env-file .env up -d

# Add to .gitignore
echo ".env" >> .gitignore
```

### 2. Use Secrets Manager
```bash
# Store database password in AWS Secrets Manager
aws secretsmanager create-secret \
  --name employee-db-password \
  --secret-string "your_secure_password"

# Reference in application
aws secretsmanager get-secret-value \
  --secret-id employee-db-password
```

### 3. Network Security
- Use VPC with private subnets for database
- Use Application Load Balancer (ALB) for frontend
- Enable security group rules
- Use HTTPS with SSL/TLS certificates

### 4. Image Security
- Scan images for vulnerabilities
- Use specific version tags (not `latest`)
- Run as non-root user in containers
- Minimize image size with multi-stage builds

### 5. Database Security
```bash
# Use strong passwords
DB_PASSWORD=SuperSecure@P@ssw0rd2024

# Enable MySQL authentication
# Only allow connections from backend service
```

---

## Monitoring and Troubleshooting

### View Logs

```bash
# Real-time logs for all services
docker-compose logs -f

# Logs for specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql

# Last 100 lines
docker-compose logs --tail=100
```

### Common Issues

**Issue: Port already in use**
```bash
# Kill process on port
sudo lsof -ti :3000 | xargs kill -9

# Or change port in docker-compose.yml
```

**Issue: Cannot connect to database**
```bash
# Check if MySQL is running
docker-compose ps

# Verify database connection
docker-compose exec mysql mysql -u root -p -e "SELECT 1"

# Check network connectivity
docker-compose exec backend ping mysql
```

**Issue: Out of disk space**
```bash
# Clean up Docker
docker system prune -a

# Remove old images
docker image prune -a

# Check disk usage
docker system df
```

### Performance Monitoring

```bash
# Check resource usage
docker stats

# Monitor container memory/CPU
watch docker stats --no-stream

# Get container details
docker inspect employee-api
```

### Database Backup/Restore

```bash
# Backup database
docker-compose exec mysql mysqldump -u root -p employee_db > backup.sql

# Restore database
docker-compose exec -T mysql mysql -u root -p employee_db < backup.sql

# Backup volumes
docker run --rm -v employee_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz -C /data .
```

---

## Production Deployment Checklist

- [ ] Use strong, unique passwords
- [ ] Store secrets in AWS Secrets Manager
- [ ] Enable CloudWatch logging
- [ ] Set up CloudFormation for infrastructure as code
- [ ] Configure Auto Scaling groups
- [ ] Set up Application Load Balancer (ALB)
- [ ] Enable WAF (Web Application Firewall)
- [ ] Configure Route 53 for domain routing
- [ ] Set up RDS for managed database (instead of Docker MySQL)
- [ ] Enable automated backups
- [ ] Set up monitoring and alerts
- [ ] Configure CloudFront CDN for frontend
- [ ] Enable VPC Flow Logs
- [ ] Use IAM roles for EC2 instance
- [ ] Set up CI/CD pipeline (CodePipeline, CodeBuild)
- [ ] Document runbooks for operations

---

## Next Steps

1. **Build images locally**: Run `./build-docker.sh`
2. **Test locally**: Run `docker-compose up -d`
3. **Push to ECR**: Run `./push-to-ecr.sh`
4. **Deploy to EC2**: Run `./deploy-ec2.sh` on EC2 or manually follow steps
5. **Monitor and maintain**: Set up CloudWatch dashboards and alerts

---

## Support and Resources

- Docker Documentation: https://docs.docker.com
- AWS ECR Guide: https://docs.aws.amazon.com/ecr
- Docker Compose Reference: https://docs.docker.com/compose/compose-file
- AWS EC2 User Guide: https://docs.aws.amazon.com/ec2

