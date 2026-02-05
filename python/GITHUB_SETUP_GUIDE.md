# GitHub Repository Setup Guide

## Complete Step-by-Step Guide to Create, Setup, and Clone the Repository

---

## PHASE 1: Create Repository on GitHub

### Step 1.1: Create GitHub Account (if you don't have one)
- Go to https://github.com
- Click "Sign up"
- Enter your email, create password, and username
- Verify your email address

### Step 1.2: Create New Repository
1. Click the **"+"** icon in the top-right corner
2. Select **"New repository"**
3. Fill in the details:
   - **Repository name**: `employee-management-system`
   - **Description**: `A full-stack Employee Management System with React frontend, FastAPI backend, and MySQL database. Includes Docker and AWS deployment setup.`
   - **Visibility**: Choose "Public" (or "Private" if you prefer)
   - **Initialize with README**: Check this box
   - **.gitignore**: Select "Python"
   - **License**: Select "MIT License"

4. Click **"Create repository"**

### Step 1.3: Get Your Repository URL
After creating, you'll see a green "Code" button. The repository URL will be:
```
https://github.com/YOUR_USERNAME/employee-management-system.git
```

---

## PHASE 2: Prepare Your Local Project

### Step 2.1: Organize Project Structure
Your project should have this structure:
```
employee-management-system/
├── backend/
│   ├── __init__.py
│   ├── config.py
│   ├── main.py
│   ├── api/
│   │   ├── __init__.py
│   │   └── routes.py
│   ├── database/
│   │   ├── __init__.py
│   │   ├── connection.py
│   │   ├── mock_db.py
│   │   └── operations.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── employee.py
│   │   └── schemas.py
│   └── utils/
│       ├── __init__.py
│       └── validators.py
├── frontend/
│   ├── package.json
│   ├── vite.config.js
│   ├── src/
│   │   ├── App.jsx
│   │   ├── App.css
│   │   ├── index.jsx
│   │   ├── index.css
│   │   ├── components/
│   │   │   ├── EmployeeCard.jsx
│   │   │   ├── EmployeeCard.css
│   │   │   ├── EmployeeForm.jsx
│   │   │   ├── EmployeeForm.css
│   │   │   ├── EmployeeList.jsx
│   │   │   └── EmployeeList.css
│   │   └── services/
│   │       └── api.js
│   └── public/
├── database_schema.sql
├── requirements.txt
├── .env.example
├── .gitignore
├── .dockerignore
├── Dockerfile.backend
├── Dockerfile.frontend
├── docker-compose.yml
├── build-docker.sh
├── push-to-ecr.sh
├── deploy-ec2.sh
├── README.md
├── DOCKER_DEPLOYMENT_GUIDE.md
└── LICENSE (MIT)
```

### Step 2.2: Create .gitignore File
Ensure your `.gitignore` contains:
```
# Python
.venv/
__pycache__/
*.pyc
*.pyo
*.egg-info/
dist/
build/

# Environment variables
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# Frontend
node_modules/
dist/
.DS_Store

# Logs
*.log

# Docker
mysql_data/
```

### Step 2.3: Create .env.example File
```
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=employee_db

# Application Configuration
DEBUG=True
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
```

---

## PHASE 3: Initialize Git Repository Locally

### Step 3.1: Open Terminal/Command Prompt
Navigate to your project directory:
```bash
cd /path/to/employee-management-system
```

### Step 3.2: Initialize Git
```bash
# Initialize local git repository
git init

# Check git status
git status
```

You should see all your files listed as "Untracked files"

### Step 3.3: Configure Git (First Time Only)
```bash
# Set your name
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your.email@example.com"

# Verify configuration
git config --global --list
```

### Step 3.4: Create Initial Commit
```bash
# Add all files to staging area
git add .

# Verify files are staged
git status

# Create initial commit
git commit -m "Initial commit: Full-stack employee management system with Docker and AWS deployment setup"

# Check commit
git log
```

---

## PHASE 4: Connect Local Repository to GitHub

### Step 4.1: Add Remote Repository
```bash
# Add remote origin (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/employee-management-system.git

# Verify remote is added
git remote -v
```

Output should show:
```
origin  https://github.com/YOUR_USERNAME/employee-management-system.git (fetch)
origin  https://github.com/YOUR_USERNAME/employee-management-system.git (push)
```

### Step 4.2: Set Default Branch
```bash
# Rename branch to main (if on master)
git branch -M main
```

### Step 4.3: Push Code to GitHub
```bash
# Push to GitHub (this will prompt for credentials)
git push -u origin main

# Verify push
git log --oneline
```

On first push, you may need to authenticate:
- GitHub will prompt you to enter credentials
- Or use GitHub CLI: `gh auth login`

---

## PHASE 5: Verify Repository on GitHub

### Step 5.1: Check GitHub
1. Go to https://github.com/YOUR_USERNAME/employee-management-system
2. Verify all files are there:
   - ✅ backend/ folder
   - ✅ frontend/ folder
   - ✅ Docker files
   - ✅ Deployment scripts
   - ✅ Documentation
   - ✅ README.md

### Step 5.2: Check File Structure
Click through folders to ensure proper hierarchy

---

## PHASE 6: Create a README.md

Replace the default README with this comprehensive one:

```markdown
# Employee Management System

A full-stack web application for managing employee records with real-time updates, built with React, FastAPI, and MySQL.

## Features

✨ **Full-Stack Application**
- React + Vite frontend with modern UI
- FastAPI backend with REST API
- MySQL database
- Real-time employee management

🎨 **Enhanced UI/UX**
- Beautiful gradient design
- Smooth animations and transitions
- Icons and intuitive controls
- Responsive layout

🐳 **Docker Support**
- Complete Docker Compose setup
- Backend, frontend, and database containers
- Ready for cloud deployment

☁️ **AWS Deployment Ready**
- ECR (Elastic Container Registry) integration
- EC2 deployment scripts
- Production-ready configuration

## Technology Stack

### Frontend
- React 18.2
- Vite 5.4
- React Icons
- Axios
- CSS3

### Backend
- FastAPI 0.104
- Python 3.13
- Uvicorn
- MySQL Connector
- Pydantic

### Database
- MySQL 8.0

### DevOps
- Docker
- Docker Compose
- AWS ECR
- AWS EC2

## Project Structure

```
employee-management-system/
├── backend/                 # FastAPI backend
├── frontend/               # React frontend
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile.backend      # Backend container
├── Dockerfile.frontend     # Frontend container
├── requirements.txt        # Python dependencies
├── DOCKER_DEPLOYMENT_GUIDE.md
└── README.md
```

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 16+ (for local development)
- Python 3.13+ (for local development)
- MySQL 8.0+ (or use Docker)

### Local Development

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/employee-management-system.git
cd employee-management-system
```

2. **Using Docker Compose (Recommended)**
```bash
# Start all services
docker-compose up -d

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8000
# API Docs: http://localhost:8000/docs
```

3. **Using Local Installation**

**Backend Setup:**
```bash
# Create virtual environment
python -m venv .venv

# Activate virtual environment
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run backend
python -m uvicorn backend.main:app --reload
```

**Frontend Setup:**
```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev
```

## API Endpoints

### Employees
- `GET /api/employees` - Get all employees
- `GET /api/employees/{id}` - Get employee by ID
- `POST /api/employees` - Create new employee
- `PUT /api/employees/{id}` - Update employee
- `DELETE /api/employees/{id}` - Delete employee

## Docker Deployment

### Build Images
```bash
./build-docker.sh
```

### Test Locally
```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f
docker-compose down
```

### Push to AWS ECR
```bash
./push-to-ecr.sh
```

### Deploy to AWS EC2
```bash
./deploy-ec2.sh
```

## Configuration

### Environment Variables

Create a `.env` file (copy from `.env.example`):

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=employee_db
DEBUG=False
CORS_ORIGINS=http://localhost:3000
```

## Documentation

- [Docker Deployment Guide](./DOCKER_DEPLOYMENT_GUIDE.md) - Complete guide for Docker and AWS deployment

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions, please open an GitHub issue or contact the development team.

## Roadmap

- [ ] Add user authentication
- [ ] Add employee performance tracking
- [ ] Add reporting and analytics
- [ ] Mobile app (React Native)
- [ ] Advanced search and filtering
- [ ] Bulk operations

## Changelog

### v1.0.0 (Current)
- Initial release
- Full CRUD operations for employees
- Docker support
- AWS deployment ready
- Enhanced UI with animations
```

---

## PHASE 7: Clone the Repository (For Testing/New Machine)

### Step 7.1: Clone on New Location
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/employee-management-system.git

# Navigate to project
cd employee-management-system

# Verify files
ls -la
```

### Step 7.2: Set Up After Cloning
```bash
# Create virtual environment
python -m venv .venv

# Activate it
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install frontend dependencies
cd frontend
npm install
cd ..

# Create .env file (copy from .env.example)
cp .env.example .env

# Edit .env with your settings
```

### Step 7.3: Run the Application
```bash
# Option 1: Using Docker Compose (Recommended)
docker-compose up -d

# Option 2: Local setup
# Terminal 1 - Backend
python -m uvicorn backend.main:app --reload

# Terminal 2 - Frontend
cd frontend
npm run dev
```

---

## PHASE 8: Common Git Commands

### Regular Workflow
```bash
# Check status
git status

# Add changes
git add .
git add filename  # specific file

# Commit changes
git commit -m "Your message"

# Push to GitHub
git push origin main

# Pull latest changes
git pull origin main
```

### Branching (For Features)
```bash
# Create new branch
git checkout -b feature/new-feature

# Work on feature
# ... make changes ...

# Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Create Pull Request on GitHub
# After approval, merge to main
git checkout main
git pull origin main
git merge feature/new-feature
```

### Undo Changes
```bash
# Undo uncommitted changes
git checkout -- filename

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo specific commit
git revert <commit-hash>
```

---

## PHASE 9: GitHub Pages (Optional - For Documentation)

If you want to host documentation:

1. Go to repository Settings
2. Scroll to "GitHub Pages"
3. Select "Deploy from a branch"
4. Choose "main" branch and "/root" folder
5. Save

Documentation will be available at: `https://YOUR_USERNAME.github.io/employee-management-system/`

---

## PHASE 10: Add Collaborators (Optional)

1. Go to repository Settings
2. Click "Collaborators"
3. Click "Add people"
4. Enter collaborator's GitHub username
5. Select permission level
6. Send invitation

---

## Troubleshooting

### Issue: "Permission denied (publickey)"
**Solution:**
```bash
# Generate SSH key (if not exists)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add SSH key to GitHub
# Copy key: cat ~/.ssh/id_ed25519.pub
# GitHub Settings → SSH and GPG keys → New SSH key

# Use SSH URL for cloning
git clone git@github.com:YOUR_USERNAME/employee-management-system.git
```

### Issue: "fatal: could not read Username"
**Solution:**
```bash
# Use GitHub Personal Access Token instead of password
# Create token: GitHub → Settings → Developer settings → Personal access tokens
# Use token as password when prompted
```

### Issue: "Everything up-to-date" but changes not visible
```bash
# Make sure files are properly staged
git add .
git commit -m "Your message"
git push origin main

# Verify on GitHub
```

### Issue: Large files rejected by Git
```bash
# Use Git LFS for large files
git lfs install
git lfs track "*.{psd,zip,rar}"
git add .gitattributes
git add .
git commit -m "Add large files with LFS"
git push origin main
```

---

## Next Steps

1. ✅ Create GitHub repository
2. ✅ Initialize local Git
3. ✅ Push code to GitHub
4. ✅ Add collaborators (if needed)
5. ✅ Set up CI/CD (optional - GitHub Actions)
6. ✅ Enable branch protection rules (optional)
7. ✅ Configure automated deployments (optional)

---

## Resources

- GitHub Docs: https://docs.github.com
- Git Documentation: https://git-scm.com/doc
- GitHub CLI: https://cli.github.com
- GitHub Actions: https://github.com/features/actions

