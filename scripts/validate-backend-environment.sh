#!/bin/bash
# File: validate-backend-environment.sh
# Seminote Backend Development Environment Validation Script

echo "🔍 Validating Backend Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ "$2" = "success" ]; then
        echo -e "${GREEN}✅ $1${NC}"
    elif [ "$2" = "error" ]; then
        echo -e "${RED}❌ $1${NC}"
    elif [ "$2" = "warning" ]; then
        echo -e "${YELLOW}⚠️ $1${NC}"
    else
        echo -e "${BLUE}📦 $1${NC}"
    fi
}

# Track validation status
VALIDATION_FAILED=0

# Check Node.js
echo ""
print_status "Checking Node.js..." "info"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_status "Node.js version: $NODE_VERSION" "success"

    # Check if version is 18 or higher
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 18 ]; then
        print_status "Node.js version meets requirements (18+)" "success"
    else
        print_status "Node.js version is below 18. Please upgrade." "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "Node.js not found. Please install Node.js 18+" "error"
    VALIDATION_FAILED=1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_status "npm version: $NPM_VERSION" "success"
else
    print_status "npm not found" "error"
    VALIDATION_FAILED=1
fi

# Check Python
echo ""
print_status "Checking Python..." "info"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_status "Python version: $PYTHON_VERSION" "success"

    # Check if version is 3.9 or higher
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d' ' -f2 | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d' ' -f2 | cut -d'.' -f2)
    if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 9 ]; then
        print_status "Python version meets requirements (3.9+)" "success"
    else
        print_status "Python version is below 3.9. Please upgrade." "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "Python3 not found. Please install Python 3.9+" "error"
    VALIDATION_FAILED=1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version)
    print_status "pip3 version: $PIP_VERSION" "success"
else
    print_status "pip3 not found" "error"
    VALIDATION_FAILED=1
fi

# Check Java
echo ""
print_status "Checking Java..." "info"
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java --version 2>/dev/null | head -1 || java -version 2>&1 | head -1)
    print_status "Java version: $JAVA_VERSION" "success"

    # Check if version is 21 or higher
    if echo "$JAVA_VERSION" | grep -q "21\|22\|23"; then
        print_status "Java version meets requirements (21+)" "success"
    elif echo "$JAVA_VERSION" | grep -q "17\|18\|19\|20"; then
        print_status "Java version is compatible but 21+ recommended" "warning"
    else
        print_status "Java version may be below 17. Please upgrade." "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "Java not found. Please install Java 21+" "error"
    VALIDATION_FAILED=1
fi

# Check Gradle
echo ""
print_status "Checking Gradle..." "info"
if command -v gradle &> /dev/null; then
    GRADLE_VERSION=$(gradle --version | grep "Gradle" | head -1)
    print_status "Gradle version: $GRADLE_VERSION" "success"
elif [ -f "./gradlew" ]; then
    GRADLE_VERSION=$(./gradlew --version | grep "Gradle" | head -1)
    print_status "Gradle wrapper version: $GRADLE_VERSION" "success"
else
    print_status "Gradle not found. Using Gradle wrapper is recommended." "warning"
fi

# Check Docker
echo ""
print_status "Checking Docker..." "info"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    print_status "Docker version: $DOCKER_VERSION" "success"

    if docker ps &> /dev/null; then
        print_status "Docker daemon is running" "success"
    else
        print_status "Docker daemon not running. Please start Docker." "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "Docker not found. Please install Docker." "error"
    VALIDATION_FAILED=1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    print_status "Docker Compose version: $COMPOSE_VERSION" "success"
elif docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version)
    print_status "Docker Compose (plugin) version: $COMPOSE_VERSION" "success"
else
    print_status "Docker Compose not found" "error"
    VALIDATION_FAILED=1
fi

# Check kubectl
echo ""
print_status "Checking kubectl..." "info"
if command -v kubectl &> /dev/null; then
    KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -1)
    print_status "kubectl version: $KUBECTL_VERSION" "success"
else
    print_status "kubectl not found. Install for Kubernetes development." "warning"
fi

# Check minikube
if command -v minikube &> /dev/null; then
    MINIKUBE_VERSION=$(minikube version --short 2>/dev/null || minikube version | head -1)
    print_status "minikube version: $MINIKUBE_VERSION" "success"
else
    print_status "minikube not found. Install for local Kubernetes development." "warning"
fi

# Check database connections
echo ""
print_status "Checking database connections..." "info"

# PostgreSQL
if docker ps | grep seminote-postgres &> /dev/null; then
    print_status "PostgreSQL container running" "success"
    if docker exec seminote-postgres pg_isready -U seminote_user &> /dev/null; then
        print_status "PostgreSQL accepting connections" "success"
    else
        print_status "PostgreSQL not accepting connections" "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "PostgreSQL container not running. Run 'docker-compose up -d postgres'" "warning"
fi

# Redis
if docker ps | grep seminote-redis &> /dev/null; then
    print_status "Redis container running" "success"
    if docker exec seminote-redis redis-cli ping | grep PONG &> /dev/null; then
        print_status "Redis responding to ping" "success"
    else
        print_status "Redis not responding" "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "Redis container not running. Run 'docker-compose up -d redis'" "warning"
fi

# MongoDB
if docker ps | grep seminote-mongo &> /dev/null; then
    print_status "MongoDB container running" "success"
    if docker exec seminote-mongo mongosh --eval "db.adminCommand('ping')" &> /dev/null; then
        print_status "MongoDB responding to ping" "success"
    else
        print_status "MongoDB not responding" "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "MongoDB container not running. Run 'docker-compose up -d mongodb'" "warning"
fi

# RabbitMQ
if docker ps | grep seminote-rabbitmq &> /dev/null; then
    print_status "RabbitMQ container running" "success"
    if docker exec seminote-rabbitmq rabbitmq-diagnostics ping &> /dev/null; then
        print_status "RabbitMQ responding to ping" "success"
    else
        print_status "RabbitMQ not responding" "error"
        VALIDATION_FAILED=1
    fi
else
    print_status "RabbitMQ container not running. Run 'docker-compose up -d rabbitmq'" "warning"
fi

# Check development tools
echo ""
print_status "Checking development tools..." "info"

# Check if management interfaces are accessible
if docker ps | grep seminote-pgadmin &> /dev/null; then
    print_status "pgAdmin container running (http://localhost:8081)" "success"
else
    print_status "pgAdmin not running. Run 'docker-compose up -d pgadmin'" "warning"
fi

if docker ps | grep seminote-redis-commander &> /dev/null; then
    print_status "Redis Commander running (http://localhost:8082)" "success"
else
    print_status "Redis Commander not running. Run 'docker-compose up -d redis-commander'" "warning"
fi

if docker ps | grep seminote-swagger-editor &> /dev/null; then
    print_status "Swagger Editor running (http://localhost:8083)" "success"
else
    print_status "Swagger Editor not running. Run 'docker-compose up -d swagger-editor'" "warning"
fi

# Summary
echo ""
echo "=================================================="
if [ $VALIDATION_FAILED -eq 0 ]; then
    print_status "🎉 Backend development environment validation complete!" "success"
    print_status "All critical components are properly configured." "success"
    echo ""
    print_status "Next steps:" "info"
    echo "  1. Start all services: docker-compose up -d"
    echo "  2. Access management interfaces:"
    echo "     - pgAdmin: http://localhost:8081"
    echo "     - Redis Commander: http://localhost:8082"
    echo "     - Swagger Editor: http://localhost:8083"
    echo "     - RabbitMQ Management: http://localhost:15672"
    echo "  3. Begin microservice development"
else
    print_status "❌ Validation failed. Please fix the issues above." "error"
    echo ""
    print_status "Common solutions:" "info"
    echo "  - Install missing tools using package managers (brew, apt, choco)"
    echo "  - Start Docker daemon"
    echo "  - Run 'docker-compose up -d' to start database services"
    exit 1
fi

echo "=================================================="
