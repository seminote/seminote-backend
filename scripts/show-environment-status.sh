#!/bin/bash
# File: show-environment-status.sh
# Display comprehensive status of Seminote Backend Development Environment

echo "📊 Seminote Backend Development Environment Status"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check Docker services
echo ""
print_status "🐳 Docker Services Status:" "info"
if docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep seminote; then
    echo ""
else
    print_status "No Seminote services running. Run: ./scripts/start-dev-environment.sh" "warning"
fi

# Check service health
echo ""
print_status "🏥 Service Health Checks:" "info"

# PostgreSQL
if docker ps | grep seminote-postgres > /dev/null; then
    if docker exec seminote-postgres pg_isready -U seminote_user > /dev/null 2>&1; then
        print_status "PostgreSQL: Healthy" "success"
    else
        print_status "PostgreSQL: Unhealthy" "error"
    fi
else
    print_status "PostgreSQL: Not running" "warning"
fi

# Redis
if docker ps | grep seminote-redis > /dev/null; then
    if docker exec seminote-redis redis-cli ping | grep -q PONG; then
        print_status "Redis: Healthy" "success"
    else
        print_status "Redis: Unhealthy" "error"
    fi
else
    print_status "Redis: Not running" "warning"
fi

# MongoDB
if docker ps | grep seminote-mongo > /dev/null; then
    if docker exec seminote-mongo mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        print_status "MongoDB: Healthy" "success"
    else
        print_status "MongoDB: Unhealthy" "error"
    fi
else
    print_status "MongoDB: Not running" "warning"
fi

# RabbitMQ
if docker ps | grep seminote-rabbitmq > /dev/null; then
    if docker exec seminote-rabbitmq rabbitmq-diagnostics ping > /dev/null 2>&1; then
        print_status "RabbitMQ: Healthy" "success"
    else
        print_status "RabbitMQ: Unhealthy" "error"
    fi
else
    print_status "RabbitMQ: Not running" "warning"
fi

# Check management tools
echo ""
print_status "🖥️ Management Tools Status:" "info"

check_url() {
    local name=$1
    local url=$2
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; then
        print_status "$name: Available at $url" "success"
    else
        print_status "$name: Not accessible at $url" "warning"
    fi
}

check_url "pgAdmin" "http://localhost:8081"
check_url "Redis Commander" "http://localhost:8082"
check_url "Swagger Editor" "http://localhost:8083"
check_url "RabbitMQ Management" "http://localhost:15672"

# Check WebRTC development environment
echo ""
print_status "🌐 WebRTC Development Environment:" "info"

if [ -d "webrtc-dev" ]; then
    print_status "WebRTC directory exists" "success"
    
    if [ -f "webrtc-dev/node-server/package.json" ]; then
        print_status "Node.js WebRTC server configured" "success"
    else
        print_status "Node.js WebRTC server not configured" "warning"
    fi
    
    if [ -f "webrtc-dev/python-ml/requirements.txt" ]; then
        print_status "Python ML service configured" "success"
    else
        print_status "Python ML service not configured" "warning"
    fi
    
    # Check if WebRTC services are running
    if pgrep -f "webrtc-dev/node-server/server.js" > /dev/null; then
        print_status "Node.js WebRTC server: Running" "success"
    else
        print_status "Node.js WebRTC server: Not running" "warning"
    fi
    
    if pgrep -f "webrtc-dev/python-ml/audio_processor.py" > /dev/null; then
        print_status "Python ML service: Running" "success"
    else
        print_status "Python ML service: Not running" "warning"
    fi
else
    print_status "WebRTC environment not set up. Run: ./scripts/setup-webrtc-dev.sh" "warning"
fi

# Check environment configuration
echo ""
print_status "⚙️ Environment Configuration:" "info"

if [ -f ".env.development.template" ]; then
    print_status "Environment template available" "success"
else
    print_status "Environment template missing" "error"
fi

if [ -f ".env.development" ]; then
    print_status "Development environment configured" "success"
else
    print_status "Development environment not configured. Copy .env.development.template to .env.development" "warning"
fi

# Check VS Code configuration
if [ -d ".vscode" ]; then
    print_status "VS Code configuration available" "success"
else
    print_status "VS Code configuration missing" "warning"
fi

# Check scripts
echo ""
print_status "🛠️ Available Scripts:" "info"

scripts=(
    "validate-backend-environment.sh"
    "test-backend-integration.sh"
    "setup-webrtc-dev.sh"
    "start-dev-environment.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "scripts/$script" ]; then
        print_status "$script: Available" "success"
    else
        print_status "$script: Missing or not executable" "error"
    fi
done

# Check infrastructure files
echo ""
print_status "🏗️ Infrastructure Files:" "info"

if [ -f "docker-compose.yml" ]; then
    print_status "Docker Compose configuration: Available" "success"
else
    print_status "Docker Compose configuration: Missing" "error"
fi

if [ -f "infrastructure/sql/01-init-databases.sql" ]; then
    print_status "Database initialization scripts: Available" "success"
else
    print_status "Database initialization scripts: Missing" "error"
fi

if [ -f "infrastructure/docker/prometheus/prometheus.yml" ]; then
    print_status "Prometheus configuration: Available" "success"
else
    print_status "Prometheus configuration: Missing" "warning"
fi

# Resource usage
echo ""
print_status "📊 Resource Usage:" "info"

if command -v docker &> /dev/null; then
    echo ""
    print_status "Docker Container Resources:" "info"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" | grep seminote || echo "No Seminote containers running"
fi

# Summary and recommendations
echo ""
echo "=================================================="
print_status "📋 Environment Summary:" "info"

RUNNING_SERVICES=$(docker ps | grep seminote | wc -l)
TOTAL_EXPECTED=7  # postgres, redis, mongodb, rabbitmq, pgadmin, redis-commander, swagger-editor

if [ "$RUNNING_SERVICES" -eq "$TOTAL_EXPECTED" ]; then
    print_status "All core services are running ($RUNNING_SERVICES/$TOTAL_EXPECTED)" "success"
elif [ "$RUNNING_SERVICES" -gt 0 ]; then
    print_status "Some services are running ($RUNNING_SERVICES/$TOTAL_EXPECTED)" "warning"
    print_status "Run: ./scripts/start-dev-environment.sh to start all services" "info"
else
    print_status "No services are running (0/$TOTAL_EXPECTED)" "error"
    print_status "Run: ./scripts/start-dev-environment.sh to start the environment" "info"
fi

echo ""
print_status "🚀 Quick Actions:" "info"
echo "  Start environment:     ./scripts/start-dev-environment.sh"
echo "  Validate environment:  ./scripts/validate-backend-environment.sh"
echo "  Run integration tests: ./scripts/test-backend-integration.sh"
echo "  Setup WebRTC:          ./scripts/setup-webrtc-dev.sh"
echo "  Stop all services:     docker-compose down"

echo ""
print_status "📚 Documentation:" "info"
echo "  Development Setup:     ./DEVELOPMENT_SETUP.md"
echo "  Project README:        ./README.md"
echo "  Task Instructions:     ./tasks/SEM-37-backend-dev-environment-setup.md"

echo ""
print_status "🎹 Ready for Seminote development!" "success"
echo "=================================================="
