# 🚀 Seminote Backend Development Environment Setup

This guide provides comprehensive instructions for setting up the Seminote Backend development environment, following the specifications in **SEM-37: Backend Development Environment Setup**.

## 📋 Overview

The Seminote Backend development environment includes:

- **Core Runtime Environments**: Java 21+, Node.js 18+, Python 3.9+
- **Containerization**: Docker and Docker Compose with all required services
- **Databases**: PostgreSQL, Redis, MongoDB with management tools
- **Message Queue**: RabbitMQ with management interface
- **WebRTC Development**: Node.js and Python WebRTC integration
- **Development Tools**: API testing, monitoring, and validation scripts

## 🎯 Quick Start

### Prerequisites

Ensure you have the following installed:
- **Java 21+** (OpenJDK recommended)
- **Node.js 18+** with npm
- **Python 3.9+** with pip3
- **Docker** and **Docker Compose**
- **Git** for version control

### One-Command Setup

```bash
# Start the complete development environment
./scripts/start-dev-environment.sh
```

This script will:
1. ✅ Validate prerequisites
2. 🐳 Start all Docker services
3. 🗄️ Initialize databases
4. 🖥️ Launch management tools
5. 🧪 Run environment validation
6. 📊 Display service information

## 📦 Manual Setup Steps

### 1. Core Infrastructure Services

Start the essential database and messaging services:

```bash
# Start core services
docker-compose up -d postgres redis mongodb rabbitmq

# Verify services are running
docker-compose ps
```

### 2. Management Tools

Launch database and API management interfaces:

```bash
# Start management tools
docker-compose up -d pgadmin redis-commander swagger-editor

# Access management interfaces
open http://localhost:8081  # pgAdmin
open http://localhost:8082  # Redis Commander
open http://localhost:8083  # Swagger Editor
```

### 3. WebRTC Development Environment

Set up WebRTC development for real-time audio processing:

```bash
# Set up WebRTC development environment
./scripts/setup-webrtc-dev.sh

# Start WebRTC services
./scripts/start-webrtc-dev.sh
```

### 4. Environment Configuration

Copy and configure environment variables:

```bash
# Copy environment template
cp .env.development.template .env.development

# Edit configuration as needed
nano .env.development
```

## 🔧 Service Details

### Database Services

| Service | Port | Credentials | Purpose |
|---------|------|-------------|---------|
| PostgreSQL | 5432 | seminote_user/seminote_pass | Primary relational database |
| Redis | 6379 | (no auth) | Caching and session storage |
| MongoDB | 27017 | seminote_admin/seminote_pass | Document storage for content |
| RabbitMQ | 5672, 15672 | seminote/seminote_pass | Message queue and management |

### Management Interfaces

| Tool | URL | Credentials | Purpose |
|------|-----|-------------|---------|
| pgAdmin | http://localhost:8081 | admin@seminote.com/admin | PostgreSQL management |
| Redis Commander | http://localhost:8082 | (no auth) | Redis data browser |
| Swagger Editor | http://localhost:8083 | (no auth) | API documentation |
| RabbitMQ Management | http://localhost:15672 | seminote/seminote_pass | Queue monitoring |

### WebRTC Development

| Service | URL | Purpose |
|---------|-----|---------|
| Node.js WebRTC Server | http://localhost:3001 | Real-time audio streaming |
| Python ML Service | http://localhost:8000 | Audio processing and ML |
| Test Client | http://localhost:3001/test-client.html | WebRTC testing interface |

## 🧪 Validation and Testing

### Environment Validation

Run comprehensive environment validation:

```bash
# Validate all components
./scripts/validate-backend-environment.sh
```

This checks:
- ✅ Runtime environments (Java, Node.js, Python)
- ✅ Docker and containerization tools
- ✅ Database connectivity and health
- ✅ WebRTC development setup
- ✅ Management tool accessibility

### Integration Testing

Run comprehensive integration tests:

```bash
# Run all integration tests
./scripts/test-backend-integration.sh
```

Test coverage includes:
- 📊 Database connectivity and performance
- 🌐 Network accessibility
- 💾 Data persistence
- 🏥 Container health checks
- 🔒 Security configuration
- 📈 Resource usage monitoring

## 🛠️ Development Workflow

### Daily Development

```bash
# Start development environment
./scripts/start-dev-environment.sh

# Build all services
./gradlew build

# Run tests
./gradlew test

# Stop environment when done
docker-compose down
```

### WebRTC Development

```bash
# Start WebRTC development
./scripts/start-webrtc-dev.sh

# Test WebRTC functionality
open http://localhost:3001/test-client.html

# Stop WebRTC services
./scripts/stop-webrtc-dev.sh
```

### Database Operations

```bash
# Connect to PostgreSQL
docker exec -it seminote-postgres psql -U seminote_user -d seminote_dev

# Connect to Redis
docker exec -it seminote-redis redis-cli

# Connect to MongoDB
docker exec -it seminote-mongo mongosh -u seminote_admin -p seminote_pass
```

## 🎨 IDE Configuration

### VS Code Setup

The repository includes comprehensive VS Code configuration:

- **Extensions**: Recommended extensions for Java, Python, Docker, and WebRTC development
- **Settings**: Optimized settings for multi-language development
- **Tasks**: Pre-configured build, test, and deployment tasks
- **Launch**: Debug configurations for all services

Open the project in VS Code and install recommended extensions:

```bash
code .
# VS Code will prompt to install recommended extensions
```

### Available Tasks (Ctrl+Shift+P → "Tasks: Run Task")

- **Gradle: Build All** - Build all microservices
- **Docker: Start All Services** - Start development environment
- **Validate Environment** - Run environment validation
- **Run Integration Tests** - Execute comprehensive tests
- **Setup WebRTC Development** - Initialize WebRTC environment

## 🔍 Troubleshooting

### Common Issues

#### Port Conflicts
```bash
# Check what's using a port
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis

# Kill process using port
kill -9 $(lsof -t -i:5432)
```

#### Docker Issues
```bash
# Restart Docker daemon
sudo systemctl restart docker

# Clean up Docker resources
docker system prune -a

# Reset all data
docker-compose down -v
```

#### Database Connection Issues
```bash
# Check container logs
docker-compose logs postgres
docker-compose logs redis
docker-compose logs mongodb

# Restart specific service
docker-compose restart postgres
```

#### WebRTC Setup Issues
```bash
# Reinstall Node.js dependencies
cd webrtc-dev/node-server
rm -rf node_modules package-lock.json
npm install

# Reinstall Python dependencies
cd ../python-ml
pip3 install -r requirements.txt --force-reinstall
```

### Performance Issues

#### Database Performance
```bash
# Run PostgreSQL performance test
docker exec seminote-postgres psql -U seminote_user -d seminote_dev -f /docker-entrypoint-initdb.d/performance-test.sql

# Run Redis benchmark
docker exec seminote-redis redis-benchmark -n 10000 -c 50
```

#### Container Resource Usage
```bash
# Monitor container resources
docker stats

# Check container health
docker-compose ps
```

## 📚 Additional Resources

### Documentation Links

- [System Architecture](https://inovinc.atlassian.net/wiki/spaces/SEM/pages/3310569/System+Architecture)
- [Speed-Adaptive Processing](https://inovinc.atlassian.net/wiki/spaces/SEM/pages/3310713/Speed-Adaptive+Processing+Specifications)
- [WebRTC Integration Guide](./webrtc-dev/README.md)

### Development Guides

- [Spring Boot Microservices](./docs/spring-boot-guide.md)
- [WebRTC Development](./docs/webrtc-guide.md)
- [Database Schema Design](./docs/database-guide.md)
- [API Documentation](./docs/api-guide.md)

### External Tools

- [Docker Documentation](https://docs.docker.com/)
- [Spring Boot Reference](https://spring.io/projects/spring-boot)
- [WebRTC Specification](https://webrtc.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🎯 Next Steps

After completing the development environment setup:

1. **📋 Review Project Structure** - Understand the microservices architecture
2. **🔧 Implement First Service** - Start with User Service development
3. **🌐 WebRTC Integration** - Implement real-time audio processing
4. **🧪 Write Tests** - Add comprehensive unit and integration tests
5. **🚀 CI/CD Setup** - Configure automated testing and deployment

## 🤝 Contributing

This development environment supports the Seminote Piano Learning Platform development. For contribution guidelines and development standards, see:

- [Contributing Guide](./CONTRIBUTING.md)
- [Code Style Guide](./docs/code-style.md)
- [Testing Standards](./docs/testing-guide.md)

---

**🎹 Ready to revolutionize piano education with cutting-edge technology!**

For questions or issues, please refer to the troubleshooting section above or consult the project documentation in Confluence.
