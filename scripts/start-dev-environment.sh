#!/bin/bash
# File: start-dev-environment.sh
# Comprehensive Development Environment Startup Script for Seminote Backend

echo "🚀 Starting Seminote Backend Development Environment..."

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

# Function to check if a port is in use
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to wait for service to be ready
wait_for_service() {
    local service_name=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    print_status "Waiting for $service_name to be ready..." "info"
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" > /dev/null 2>&1; then
            print_status "$service_name is ready!" "success"
            return 0
        fi
        
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    print_status "$service_name failed to start within timeout" "error"
    return 1
}

# Check prerequisites
echo ""
print_status "Checking prerequisites..." "info"

# Check Docker
if ! command -v docker &> /dev/null; then
    print_status "Docker not found. Please install Docker first." "error"
    exit 1
fi

if ! docker ps &> /dev/null; then
    print_status "Docker daemon not running. Please start Docker." "error"
    exit 1
fi

print_status "Docker is available and running" "success"

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    print_status "Docker Compose not found. Please install Docker Compose." "error"
    exit 1
fi

print_status "Docker Compose is available" "success"

# Check for port conflicts
echo ""
print_status "Checking for port conflicts..." "info"

PORTS_TO_CHECK=(5432 6379 27017 5672 15672 8081 8082 8083 9090 3000)
CONFLICTS_FOUND=false

for port in "${PORTS_TO_CHECK[@]}"; do
    if check_port $port; then
        print_status "Port $port is already in use" "warning"
        CONFLICTS_FOUND=true
    fi
done

if [ "$CONFLICTS_FOUND" = true ]; then
    echo ""
    print_status "Port conflicts detected. Do you want to continue? (y/N)" "warning"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_status "Startup cancelled due to port conflicts" "error"
        exit 1
    fi
fi

# Start core infrastructure services
echo ""
print_status "Starting core infrastructure services..." "info"

$COMPOSE_CMD up -d postgres redis mongodb rabbitmq

# Wait for databases to be ready
echo ""
print_status "Waiting for databases to initialize..." "info"

# Wait for PostgreSQL
print_status "Waiting for PostgreSQL..." "info"
for i in {1..30}; do
    if docker exec seminote-postgres pg_isready -U seminote_user > /dev/null 2>&1; then
        print_status "PostgreSQL is ready!" "success"
        break
    fi
    echo -n "."
    sleep 2
done

# Wait for Redis
print_status "Waiting for Redis..." "info"
for i in {1..30}; do
    if docker exec seminote-redis redis-cli ping | grep -q PONG; then
        print_status "Redis is ready!" "success"
        break
    fi
    echo -n "."
    sleep 2
done

# Wait for MongoDB
print_status "Waiting for MongoDB..." "info"
for i in {1..30}; do
    if docker exec seminote-mongo mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        print_status "MongoDB is ready!" "success"
        break
    fi
    echo -n "."
    sleep 2
done

# Wait for RabbitMQ
print_status "Waiting for RabbitMQ..." "info"
for i in {1..30}; do
    if docker exec seminote-rabbitmq rabbitmq-diagnostics ping > /dev/null 2>&1; then
        print_status "RabbitMQ is ready!" "success"
        break
    fi
    echo -n "."
    sleep 2
done

# Start management tools
echo ""
print_status "Starting management tools..." "info"

$COMPOSE_CMD up -d pgadmin redis-commander swagger-editor

# Wait for management tools
wait_for_service "pgAdmin" "http://localhost:8081"
wait_for_service "Redis Commander" "http://localhost:8082"
wait_for_service "Swagger Editor" "http://localhost:8083"

# Optional: Start monitoring services
echo ""
print_status "Do you want to start monitoring services (Prometheus, Grafana)? (y/N)" "info"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    print_status "Starting monitoring services..." "info"
    $COMPOSE_CMD --profile monitoring up -d
    
    wait_for_service "Prometheus" "http://localhost:9090"
    wait_for_service "Grafana" "http://localhost:3000"
fi

# Setup WebRTC development environment
echo ""
print_status "Do you want to set up WebRTC development environment? (y/N)" "info"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    if [ ! -d "webrtc-dev" ]; then
        print_status "Setting up WebRTC development environment..." "info"
        ./scripts/setup-webrtc-dev.sh
    else
        print_status "WebRTC development environment already exists" "success"
    fi
fi

# Run validation
echo ""
print_status "Running environment validation..." "info"
./scripts/validate-backend-environment.sh

# Display service information
echo ""
echo "=================================================="
print_status "🎉 Seminote Backend Development Environment Started!" "success"
echo "=================================================="
echo ""
print_status "📊 Database Services:" "info"
echo "  PostgreSQL:  localhost:5432 (seminote_user/seminote_pass)"
echo "  Redis:       localhost:6379"
echo "  MongoDB:     localhost:27017 (seminote_admin/seminote_pass)"
echo "  RabbitMQ:    localhost:5672 (seminote/seminote_pass)"
echo ""
print_status "🖥️ Management Interfaces:" "info"
echo "  pgAdmin:           http://localhost:8081 (admin@seminote.com/admin)"
echo "  Redis Commander:   http://localhost:8082"
echo "  Swagger Editor:    http://localhost:8083"
echo "  RabbitMQ Mgmt:     http://localhost:15672 (seminote/seminote_pass)"

if docker ps | grep seminote-prometheus > /dev/null; then
    echo ""
    print_status "📈 Monitoring Services:" "info"
    echo "  Prometheus:        http://localhost:9090"
    echo "  Grafana:           http://localhost:3000 (admin/admin)"
fi

echo ""
print_status "🛠️ Development Commands:" "info"
echo "  Stop all services:     docker-compose down"
echo "  View logs:             docker-compose logs -f [service-name]"
echo "  Restart service:       docker-compose restart [service-name]"
echo "  Run integration tests: ./scripts/test-backend-integration.sh"
echo "  Validate environment:  ./scripts/validate-backend-environment.sh"

if [ -d "webrtc-dev" ]; then
    echo ""
    print_status "🌐 WebRTC Development:" "info"
    echo "  Start WebRTC services: ./scripts/start-webrtc-dev.sh"
    echo "  Stop WebRTC services:  ./scripts/stop-webrtc-dev.sh"
fi

echo ""
print_status "📚 Next Steps:" "info"
echo "  1. Copy .env.development.template to .env.development and configure"
echo "  2. Begin microservice development with Spring Boot"
echo "  3. Implement WebRTC integration for real-time audio processing"
echo "  4. Set up CI/CD pipeline for automated testing and deployment"

echo ""
print_status "🎹 Ready to build the future of piano education!" "success"
echo "=================================================="
