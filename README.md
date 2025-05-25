# Seminote Backend Services

⚙️ **Java/Spring Boot microservices for core business logic including user management, content management, analytics, and orchestration services**

## Overview

The Seminote Backend provides enterprise-grade microservices that handle core business logic, user management, content delivery, and analytics processing. Built with Java/Spring Boot for reliability, scalability, and maintainability in the speed-adaptive hybrid architecture.

### Key Features

- 🏢 **Enterprise-Grade**: Spring Boot microservices with comprehensive security
- 🔐 **Authentication & Authorization**: Spring Security with OAuth2 and JWT
- 📊 **Analytics Processing**: Real-time and batch analytics from all processing modes
- 🎵 **Content Management**: Lesson content, sheet music, and curriculum management
- 🌐 **API Gateway**: Spring Cloud Gateway for internal service routing
- 📈 **Monitoring**: Spring Boot Actuator with comprehensive observability

## Architecture

### Microservices Structure

1. **User Service**
   - User registration and authentication
   - Profile management and preferences
   - COPPA/GDPR compliance handling

2. **Content Service**
   - Lesson and curriculum management
   - Sheet music and media storage
   - Content recommendation engine

3. **Analytics Service**
   - Practice session analytics processing
   - Progress tracking and insights
   - Performance metrics aggregation

4. **Progress Service**
   - Learning path management
   - Skill assessment and tracking
   - Achievement and milestone system

5. **Notification Service**
   - Push notifications and alerts
   - Email communication
   - Practice reminders

6. **Payment Service**
   - Subscription management
   - Payment processing integration
   - Billing and invoicing

## Technology Stack

### Core Framework
- **Java 17+** - Primary programming language
- **Spring Boot 3.x** - Main application framework
- **Spring Security** - Authentication and authorization
- **Spring Data JPA** - Data access layer
- **Spring Cloud Gateway** - API gateway and routing
- **Spring WebFlux** - Reactive programming for high-throughput

### Database & Storage
- **PostgreSQL 15+** - Primary relational database
- **Redis 7+** - Caching and session storage
- **MongoDB** - Document storage for content
- **Flyway** - Database migration management
- **HikariCP** - High-performance connection pooling

### Build & Development
- **Gradle 8+** - Primary build tool
- **Spring Boot Buildpacks** - Cloud-native containerization
- **TestContainers** - Integration testing with real databases
- **JUnit 5** - Testing framework
- **Mockito** - Mocking framework

### Monitoring & Observability
- **Spring Boot Actuator** - Production-ready monitoring
- **Micrometer** - Application metrics
- **Spring Cloud Sleuth** - Distributed tracing
- **SonarQube** - Code quality analysis

## Project Status

- **Current Phase**: Requirements Phase (Sprint 1 - Foundation)
- **Target Release**: Q4 2025
- **Architecture**: Microservices with Spring Boot
- **Deployment**: Kubernetes on AWS EKS

## Getting Started

### Prerequisites
- Java 17 or later
- Gradle 8.0 or later
- Docker and Docker Compose
- PostgreSQL 15+ (for local development)
- Redis 7+ (for local development)

### Installation
```bash
# Clone the repository
git clone https://github.com/seminote/seminote-backend.git
cd seminote-backend

# Build all services
./gradlew build

# Run with Docker Compose (recommended for development)
docker-compose up -d

# Or run individual services
./gradlew :user-service:bootRun
./gradlew :content-service:bootRun
./gradlew :analytics-service:bootRun
```

### Development Setup
1. Install Java 17+ and Gradle 8+
2. Set up local PostgreSQL and Redis instances
3. Copy `application-local.yml.template` to `application-local.yml`
4. Configure database connections and API keys
5. Run `./gradlew bootRun` for each service

## Project Structure

```
seminote-backend/
├── api-gateway/                       # Spring Cloud Gateway
├── user-service/                      # User management microservice
├── content-service/                   # Content management microservice
├── analytics-service/                 # Analytics processing microservice
├── progress-service/                  # Progress tracking microservice
├── notification-service/              # Notification microservice
├── payment-service/                   # Payment processing microservice
├── shared/                           # Shared libraries and utilities
│   ├── common/                       # Common utilities
│   ├── security/                     # Security configurations
│   └── monitoring/                   # Monitoring utilities
├── infrastructure/                   # Infrastructure configurations
│   ├── docker/                       # Docker configurations
│   ├── kubernetes/                   # K8s deployment manifests
│   └── scripts/                      # Deployment scripts
├── docs/                            # API documentation
├── gradle/                          # Gradle wrapper
├── build.gradle                     # Root build configuration
├── settings.gradle                  # Gradle settings
├── docker-compose.yml               # Local development setup
└── README.md                        # This file
```

## API Documentation

### Core APIs

- **User API**: `/api/v1/users` - User management and authentication
- **Content API**: `/api/v1/content` - Lesson and curriculum access
- **Analytics API**: `/api/v1/analytics` - Practice session analytics
- **Progress API**: `/api/v1/progress` - Learning progress tracking

### API Gateway Routes

- External APIs: `https://api.seminote.com/v1/*`
- Internal routing: Spring Cloud Gateway with load balancing
- Authentication: JWT tokens with Spring Security
- Rate limiting: Redis-based rate limiting

## Development Guidelines

### Code Style
- Follow Spring Boot best practices
- Use Checkstyle and SpotBugs for code quality
- Implement comprehensive unit and integration tests
- Document APIs with OpenAPI/Swagger

### Architecture Patterns
- **Microservices**: Domain-driven service boundaries
- **Repository Pattern**: Data access abstraction
- **Event-Driven**: Asynchronous communication between services
- **CQRS**: Command Query Responsibility Segregation for analytics

### Performance Requirements
- **API Response Time**: <200ms for 95th percentile
- **Throughput**: 1000+ requests/second per service
- **Database Connections**: Optimized connection pooling
- **Memory Usage**: <512MB per service instance

## Testing Strategy

### Unit Tests
- JUnit 5 with Mockito
- Test coverage >80%
- Fast execution (<30 seconds)

### Integration Tests
- TestContainers for database testing
- Spring Boot Test for full context testing
- API contract testing

### Performance Tests
- Load testing with JMeter
- Database performance testing
- Memory and CPU profiling

## Deployment

### Local Development
```bash
# Start all services with Docker Compose
docker-compose up -d

# Check service health
curl http://localhost:8080/actuator/health
```

### Production Deployment
- **Container Registry**: AWS ECR
- **Orchestration**: Kubernetes on AWS EKS
- **Service Mesh**: Istio for traffic management
- **Monitoring**: Prometheus + Grafana

## Contributing

This project is currently in the foundation phase. Development guidelines and contribution processes will be established as the project progresses.

## License

Copyright © 2024-2025 Seminote. All rights reserved.

---

**Part of the Seminote Piano Learning Platform**
- 🎹 [iOS App](https://github.com/seminote/seminote-ios)
- ⚙️ [Backend Services](https://github.com/seminote/seminote-backend) (this repository)
- 🌐 [Real-time Services](https://github.com/seminote/seminote-realtime)
- 🤖 [ML Services](https://github.com/seminote/seminote-ml)
- 🚀 [Edge Services](https://github.com/seminote/seminote-edge)
- 🏗️ [Infrastructure](https://github.com/seminote/seminote-infrastructure)
- 📚 [Documentation](https://github.com/seminote/seminote-docs)
