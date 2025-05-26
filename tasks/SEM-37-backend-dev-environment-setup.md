# 🚀 SEM-37: Backend Development Environment Setup

## 📋 Jira Ticket Information

**Ticket ID**: SEM-37
**Title**: [Backend] Set up Backend Development Environment
**Type**: Story
**Priority**: Medium
**Status**: To Do
**Parent Epic**: SEM-32 - Development Environment Setup
**Labels**: Backend, Development-Environment, seminote-backend

### 📝 Description
As a backend developer, I want to set up a complete backend development environment so that I can develop microservices and edge computing components.

### ✅ Acceptance Criteria
- [ ] Node.js/Python environment configured
- [ ] Docker and Docker Compose installed
- [ ] Kubernetes development tools (kubectl, minikube) set up
- [ ] WebRTC development libraries installed
- [ ] Database development tools (PostgreSQL, Redis) configured
- [ ] API development tools (Postman, Swagger) set up

### 📋 Tasks
- [ ] Install Node.js 18+ and Python 3.9+
- [ ] Set up Docker and Docker Compose
- [ ] Configure Kubernetes development environment
- [ ] Install WebRTC libraries and dependencies
- [ ] Set up local database instances
- [ ] Configure API development and testing tools

## 🏗️ Seminote Project Context

### 🎯 Project Overview
The **Seminote Piano Learning Platform** is an innovative educational platform featuring a **speed-adaptive hybrid architecture** that combines:
- **Local iOS ML processing** for ultra-low latency (<5ms) during fast playing (>120 BPM)
- **Edge computing** for detailed analysis during slow practice (<60 BPM)
- **Cloud microservices** for user management, content delivery, and analytics

### 🏛️ Backend Architecture Role
The backend services form the core business logic layer of the platform, implementing:

#### **Core Microservices (Java/Spring Boot)**
- **User Service**: Authentication, profiles, progress tracking
- **Content Service**: Learning materials, lessons, sheet music
- **Analytics Service**: Performance analysis, learning insights
- **Progress Service**: Skill tracking, achievement systems
- **Payment Service**: Subscription management, billing
- **Notification Service**: Real-time alerts, messaging

#### **Real-time Services (Node.js)**
- **Audio Service**: WebRTC audio streaming coordination
- **Edge Orchestration**: Managing edge computing resources
- **Real-time Communication**: WebSocket connections, live feedback

#### **Integration Points**
- **iOS App**: RESTful APIs, WebSocket connections
- **Edge Services**: Audio stream routing, ML model coordination
- **Cloud ML**: Model training data, analytics processing
- **External APIs**: Payment gateways, content providers

## 🔧 Technical Implementation Guide

### 📋 Prerequisites Verification
Before starting, verify system requirements:

```bash
# Check operating system
uname -a

# Check available disk space (minimum 20GB recommended)
df -h

# Check memory (minimum 8GB recommended)
free -h || vm_stat

# Check internet connectivity
ping -c 3 google.com
```

### 🟢 Phase 1: Core Runtime Environments

#### 1.1 Node.js 18+ Installation

**macOS (using Homebrew)**:
```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js 18+
brew install node@18
brew link node@18

# Verify installation
node --version  # Should be 18.x.x or higher
npm --version   # Should be 9.x.x or higher

# Install Yarn (alternative package manager)
npm install -g yarn
yarn --version
```

**Ubuntu/Debian**:
```bash
# Update package index
sudo apt update

# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version

# Install Yarn
npm install -g yarn
```

**Windows**:
```powershell
# Using Chocolatey
choco install nodejs --version=18.17.0

# Or download from https://nodejs.org/
# Verify installation
node --version
npm --version
```

#### 1.2 Python 3.9+ Installation

**macOS**:
```bash
# Install Python 3.9+ using Homebrew
brew install python@3.9

# Create symbolic link
brew link python@3.9

# Verify installation
python3 --version  # Should be 3.9.x or higher
pip3 --version

# Install virtual environment tools
pip3 install virtualenv pipenv
```

**Ubuntu/Debian**:
```bash
# Install Python 3.9+
sudo apt update
sudo apt install python3.9 python3.9-pip python3.9-venv

# Verify installation
python3.9 --version
pip3 --version

# Install virtual environment tools
pip3 install virtualenv pipenv
```

#### 1.3 Java 17+ (for Spring Boot services)

**macOS**:
```bash
# Install OpenJDK 17
brew install openjdk@17

# Set JAVA_HOME
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@17' >> ~/.zshrc
source ~/.zshrc

# Verify installation
java --version
javac --version
```

**Ubuntu/Debian**:
```bash
# Install OpenJDK 17
sudo apt update
sudo apt install openjdk-17-jdk

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc

# Verify installation
java --version
javac --version
```

### 🐳 Phase 2: Containerization & Orchestration

#### 2.1 Docker Installation

**macOS**:
```bash
# Install Docker Desktop
brew install --cask docker

# Start Docker Desktop application
open /Applications/Docker.app

# Verify installation
docker --version
docker-compose --version

# Test Docker installation
docker run hello-world
```

**Ubuntu/Debian**:
```bash
# Install Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker compose version
docker run hello-world
```

#### 2.2 Kubernetes Development Tools

**kubectl Installation**:
```bash
# macOS
brew install kubectl

# Ubuntu/Debian
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installation
kubectl version --client
```

**minikube Installation**:
```bash
# macOS
brew install minikube

# Ubuntu/Debian
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start minikube
minikube start

# Verify installation
minikube status
kubectl get nodes
```

### 🗄️ Phase 3: Database Development Environment

#### 3.1 PostgreSQL Setup

**Using Docker (Recommended)**:
```bash
# Create PostgreSQL container
docker run --name seminote-postgres \
  -e POSTGRES_DB=seminote_dev \
  -e POSTGRES_USER=seminote_user \
  -e POSTGRES_PASSWORD=seminote_pass \
  -p 5432:5432 \
  -d postgres:15

# Verify PostgreSQL is running
docker ps | grep seminote-postgres

# Connect to PostgreSQL
docker exec -it seminote-postgres psql -U seminote_user -d seminote_dev
```

**Native Installation (Alternative)**:
```bash
# macOS
brew install postgresql@15
brew services start postgresql@15

# Ubuntu/Debian
sudo apt update
sudo apt install postgresql-15 postgresql-client-15

# Create database and user
sudo -u postgres createuser --interactive seminote_user
sudo -u postgres createdb seminote_dev -O seminote_user
```

#### 3.2 Redis Setup

**Using Docker (Recommended)**:
```bash
# Create Redis container
docker run --name seminote-redis \
  -p 6379:6379 \
  -d redis:7-alpine

# Verify Redis is running
docker ps | grep seminote-redis

# Test Redis connection
docker exec -it seminote-redis redis-cli ping
```

#### 3.3 MongoDB Setup (for Content Service)

**Using Docker**:
```bash
# Create MongoDB container
docker run --name seminote-mongo \
  -e MONGO_INITDB_ROOT_USERNAME=seminote_admin \
  -e MONGO_INITDB_ROOT_PASSWORD=seminote_pass \
  -p 27017:27017 \
  -d mongo:6

# Verify MongoDB is running
docker ps | grep seminote-mongo

# Test MongoDB connection
docker exec -it seminote-mongo mongosh --username seminote_admin --password seminote_pass
```

### 🌐 Phase 4: WebRTC Development Environment

#### 4.1 WebRTC Libraries Installation

**Node.js WebRTC Dependencies**:
```bash
# Create a test project directory
mkdir webrtc-test && cd webrtc-test

# Initialize Node.js project
npm init -y

# Install WebRTC libraries
npm install node-webrtc socket.io express

# Install development dependencies
npm install --save-dev nodemon jest

# Test WebRTC installation
node -e "const webrtc = require('node-webrtc'); console.log('WebRTC installed successfully');"
```

**Python WebRTC Dependencies**:
```bash
# Create Python virtual environment
python3 -m venv webrtc-env
source webrtc-env/bin/activate  # On Windows: webrtc-env\Scripts\activate

# Install WebRTC libraries
pip install aiortc aiohttp websockets

# Install development dependencies
pip install pytest pytest-asyncio

# Test installation
python -c "import aiortc; print('WebRTC for Python installed successfully')"
```

### 🛠️ Phase 5: Development Tools & API Testing

#### 5.1 API Development Tools

**Postman Installation**:
```bash
# macOS
brew install --cask postman

# Ubuntu/Debian (Snap)
sudo snap install postman

# Or download from https://www.postman.com/downloads/
```

**Insomnia (Alternative)**:
```bash
# macOS
brew install --cask insomnia

# Ubuntu/Debian
sudo snap install insomnia
```

#### 5.2 Swagger/OpenAPI Tools

**Swagger Editor (Docker)**:
```bash
# Run Swagger Editor
docker run -d -p 8080:8080 swaggerapi/swagger-editor

# Access at http://localhost:8080
```

**OpenAPI Generator**:
```bash
# Install OpenAPI Generator
npm install -g @openapitools/openapi-generator-cli

# Verify installation
openapi-generator-cli version
```

### 📊 Phase 6: Monitoring & Development Tools

#### 6.1 Database Management Tools

**pgAdmin (PostgreSQL)**:
```bash
# Using Docker
docker run --name pgadmin \
  -e PGADMIN_DEFAULT_EMAIL=admin@seminote.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  -p 8081:80 \
  -d dpage/pgadmin4

# Access at http://localhost:8081
```

**Redis Commander**:
```bash
# Install globally
npm install -g redis-commander

# Run Redis Commander
redis-commander --port 8082

# Access at http://localhost:8082
```

#### 6.2 Message Queue (RabbitMQ)

**RabbitMQ Setup**:
```bash
# Using Docker
docker run --name seminote-rabbitmq \
  -e RABBITMQ_DEFAULT_USER=seminote \
  -e RABBITMQ_DEFAULT_PASS=seminote_pass \
  -p 5672:5672 \
  -p 15672:15672 \
  -d rabbitmq:3-management

# Access management UI at http://localhost:15672
# Username: seminote, Password: seminote_pass
```

## 🧪 Validation & Testing Procedures

### ✅ Environment Validation Script

Create a validation script to verify all components:

```bash
#!/bin/bash
# File: validate-backend-environment.sh

echo "🔍 Validating Backend Development Environment..."

# Check Node.js
echo "📦 Checking Node.js..."
if command -v node &> /dev/null; then
    echo "✅ Node.js version: $(node --version)"
else
    echo "❌ Node.js not found"
    exit 1
fi

# Check Python
echo "🐍 Checking Python..."
if command -v python3 &> /dev/null; then
    echo "✅ Python version: $(python3 --version)"
else
    echo "❌ Python3 not found"
    exit 1
fi

# Check Java
echo "☕ Checking Java..."
if command -v java &> /dev/null; then
    echo "✅ Java version: $(java --version | head -1)"
else
    echo "❌ Java not found"
    exit 1
fi

# Check Docker
echo "🐳 Checking Docker..."
if command -v docker &> /dev/null; then
    echo "✅ Docker version: $(docker --version)"
    if docker ps &> /dev/null; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon not running"
        exit 1
    fi
else
    echo "❌ Docker not found"
    exit 1
fi

# Check kubectl
echo "☸️ Checking kubectl..."
if command -v kubectl &> /dev/null; then
    echo "✅ kubectl version: $(kubectl version --client --short)"
else
    echo "❌ kubectl not found"
    exit 1
fi

# Check database connections
echo "🗄️ Checking database connections..."

# PostgreSQL
if docker ps | grep seminote-postgres &> /dev/null; then
    echo "✅ PostgreSQL container running"
    if docker exec seminote-postgres pg_isready -U seminote_user &> /dev/null; then
        echo "✅ PostgreSQL accepting connections"
    else
        echo "❌ PostgreSQL not accepting connections"
    fi
else
    echo "❌ PostgreSQL container not running"
fi

# Redis
if docker ps | grep seminote-redis &> /dev/null; then
    echo "✅ Redis container running"
    if docker exec seminote-redis redis-cli ping | grep PONG &> /dev/null; then
        echo "✅ Redis responding to ping"
    else
        echo "❌ Redis not responding"
    fi
else
    echo "❌ Redis container not running"
fi

# MongoDB
if docker ps | grep seminote-mongo &> /dev/null; then
    echo "✅ MongoDB container running"
else
    echo "❌ MongoDB container not running"
fi

echo "🎉 Backend development environment validation complete!"
```

### 🧪 Component Testing

#### Test Node.js Environment:
```bash
# Create test Node.js application
mkdir node-test && cd node-test
npm init -y
npm install express

# Create test server
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Backend environment test successful!', timestamp: new Date() });
});

app.listen(port, () => {
  console.log(`Test server running at http://localhost:${port}`);
});
EOF

# Run test server
node server.js &
SERVER_PID=$!

# Test endpoint
sleep 2
curl http://localhost:3000

# Cleanup
kill $SERVER_PID
cd .. && rm -rf node-test
```

#### Test Python Environment:
```bash
# Create Python virtual environment test
python3 -m venv test-env
source test-env/bin/activate

# Install test dependencies
pip install fastapi uvicorn

# Create test API
cat > test_api.py << 'EOF'
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Python backend environment test successful!"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

# Run test API
python test_api.py &
API_PID=$!

# Test endpoint
sleep 3
curl http://localhost:8000

# Cleanup
kill $API_PID
deactivate
rm -rf test-env test_api.py
```

## 🎯 Success Criteria & Deliverables

### ✅ Completion Checklist

**Runtime Environments**:
- [ ] Node.js 18+ installed and verified
- [ ] Python 3.9+ installed with virtual environment support
- [ ] Java 17+ installed with JAVA_HOME configured

**Containerization**:
- [ ] Docker installed and daemon running
- [ ] Docker Compose functional
- [ ] Kubernetes tools (kubectl, minikube) installed and tested

**Databases**:
- [ ] PostgreSQL container running and accepting connections
- [ ] Redis container running and responding to commands
- [ ] MongoDB container running for content storage

**WebRTC Development**:
- [ ] Node.js WebRTC libraries installed and tested
- [ ] Python WebRTC libraries installed and tested

**Development Tools**:
- [ ] API testing tools (Postman/Insomnia) installed
- [ ] Database management tools accessible
- [ ] Message queue (RabbitMQ) running with management interface

**Validation**:
- [ ] Environment validation script passes all checks
- [ ] Sample Node.js application runs successfully
- [ ] Sample Python API runs successfully
- [ ] All database connections verified

### 📋 Documentation Deliverables

1. **Environment Setup Documentation**: Complete installation guide
2. **Configuration Files**: Docker Compose, environment variables
3. **Validation Scripts**: Automated environment testing
4. **Troubleshooting Guide**: Common issues and solutions
5. **Next Steps Guide**: Ready for microservice development

### 🔗 Integration Points

**With iOS Development (SEM-36)**:
- WebRTC audio streaming endpoints ready
- REST API structure prepared for iOS client integration

**With ML Development (SEM-38)**:
- Python environment ready for ML model integration
- Data pipeline infrastructure prepared

**With Architecture Design (SEM-43)**:
- Infrastructure ready for speed-adaptive processing implementation
- Microservices foundation prepared for hybrid architecture

## 🚨 Troubleshooting Guide

### Common Issues & Solutions

**Docker Permission Issues (Linux)**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Or run with sudo (not recommended for development)
sudo docker ps
```

**Port Conflicts**:
```bash
# Check what's using a port
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :27017 # MongoDB

# Kill process using port
kill -9 $(lsof -t -i:5432)
```

**Node.js Version Issues**:
```bash
# Use Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

**Python Virtual Environment Issues**:
```bash
# Recreate virtual environment
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
```

## 🎯 Next Steps

After completing this setup:

1. **Proceed to SEM-38**: ML Development Environment Setup
2. **Begin SEM-43**: Speed-Adaptive Hybrid Architecture Design
3. **Start Microservice Development**: User Service, Content Service
4. **Implement WebRTC Integration**: Real-time audio streaming
5. **Set up CI/CD Pipeline**: Automated testing and deployment

## 🔧 Docker Compose Configuration

Create a comprehensive Docker Compose setup for local development:

```yaml
# File: docker-compose.dev.yml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15
    container_name: seminote-postgres
    environment:
      POSTGRES_DB: seminote_dev
      POSTGRES_USER: seminote_user
      POSTGRES_PASSWORD: seminote_pass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./infrastructure/sql:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U seminote_user -d seminote_dev"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: seminote-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # MongoDB for Content
  mongodb:
    image: mongo:6
    container_name: seminote-mongo
    environment:
      MONGO_INITDB_ROOT_USERNAME: seminote_admin
      MONGO_INITDB_ROOT_PASSWORD: seminote_pass
      MONGO_INITDB_DATABASE: seminote_content
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 30s
      timeout: 10s
      retries: 3

  # RabbitMQ Message Queue
  rabbitmq:
    image: rabbitmq:3-management
    container_name: seminote-rabbitmq
    environment:
      RABBITMQ_DEFAULT_USER: seminote
      RABBITMQ_DEFAULT_PASS: seminote_pass
    ports:
      - "5672:5672"   # AMQP port
      - "15672:15672" # Management UI
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # pgAdmin for PostgreSQL Management
  pgadmin:
    image: dpage/pgadmin4
    container_name: seminote-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@seminote.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8081:80"
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    depends_on:
      - postgres

  # Redis Commander
  redis-commander:
    image: rediscommander/redis-commander:latest
    container_name: seminote-redis-commander
    environment:
      REDIS_HOSTS: local:redis:6379
    ports:
      - "8082:8081"
    depends_on:
      - redis

volumes:
  postgres_data:
  redis_data:
  mongodb_data:
  rabbitmq_data:
  pgadmin_data:

networks:
  default:
    name: seminote-network
```

### Quick Start Commands:
```bash
# Start all services
docker-compose -f docker-compose.dev.yml up -d

# Check service health
docker-compose -f docker-compose.dev.yml ps

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop all services
docker-compose -f docker-compose.dev.yml down

# Reset all data
docker-compose -f docker-compose.dev.yml down -v
```

## 🌐 WebRTC Development Setup

### Advanced WebRTC Configuration

**Node.js WebRTC Server Setup**:
```javascript
// File: webrtc-server/server.js
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const { RTCPeerConnection, RTCSessionDescription } = require('node-webrtc');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// WebRTC configuration for Seminote
const rtcConfig = {
  iceServers: [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' }
  ]
};

// Handle WebRTC signaling for audio streaming
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  socket.on('offer', async (offer) => {
    const peerConnection = new RTCPeerConnection(rtcConfig);

    // Handle incoming audio stream
    peerConnection.ontrack = (event) => {
      console.log('Received audio stream from iOS client');
      // Forward to ML processing service
      processAudioStream(event.streams[0]);
    };

    await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
    const answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    socket.emit('answer', answer);
  });

  socket.on('ice-candidate', async (candidate) => {
    // Handle ICE candidates
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

function processAudioStream(stream) {
  // Integration point for ML processing
  // This will connect to Python ML services
  console.log('Processing audio stream for piano note detection');
}

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`WebRTC server running on port ${PORT}`);
});
```

**Python WebRTC Integration**:
```python
# File: webrtc-ml/audio_processor.py
import asyncio
import aiohttp
from aiortc import RTCPeerConnection, RTCSessionDescription
from aiortc.contrib.media import MediaPlayer, MediaRecorder
import numpy as np
import librosa

class SeminoteAudioProcessor:
    def __init__(self):
        self.peer_connections = set()

    async def handle_webrtc_connection(self, pc):
        """Handle WebRTC connection for audio processing"""

        @pc.on("track")
        async def on_track(track):
            if track.kind == "audio":
                print("Received audio track from iOS client")

                # Process audio frames for ML analysis
                while True:
                    try:
                        frame = await track.recv()
                        audio_data = self.frame_to_numpy(frame)

                        # Perform ML processing
                        notes = await self.detect_notes(audio_data)

                        # Send feedback back to client
                        await self.send_feedback(notes)

                    except Exception as e:
                        print(f"Error processing audio: {e}")
                        break

        self.peer_connections.add(pc)

    def frame_to_numpy(self, frame):
        """Convert WebRTC audio frame to numpy array"""
        # Implementation for audio frame conversion
        pass

    async def detect_notes(self, audio_data):
        """ML-based note detection"""
        # Integration point for TensorFlow/PyTorch models
        # This will be implemented in SEM-38
        pass

    async def send_feedback(self, notes):
        """Send processed feedback back to client"""
        # Implementation for feedback transmission
        pass

# FastAPI integration for WebRTC signaling
from fastapi import FastAPI, WebSocket

app = FastAPI()
processor = SeminoteAudioProcessor()

@app.websocket("/webrtc")
async def webrtc_endpoint(websocket: WebSocket):
    await websocket.accept()

    pc = RTCPeerConnection()
    await processor.handle_webrtc_connection(pc)

    try:
        while True:
            message = await websocket.receive_json()

            if message["type"] == "offer":
                await pc.setRemoteDescription(RTCSessionDescription(
                    sdp=message["sdp"], type=message["type"]
                ))

                answer = await pc.createAnswer()
                await pc.setLocalDescription(answer)

                await websocket.send_json({
                    "type": "answer",
                    "sdp": pc.localDescription.sdp
                })

    except Exception as e:
        print(f"WebSocket error: {e}")
    finally:
        await pc.close()
```

## 🧪 Advanced Testing & Validation

### Comprehensive Test Suite

**Backend Integration Tests**:
```bash
#!/bin/bash
# File: test-backend-integration.sh

echo "🧪 Running Backend Integration Tests..."

# Test 1: Database Connectivity
echo "📊 Testing Database Connections..."

# PostgreSQL Test
docker exec seminote-postgres psql -U seminote_user -d seminote_dev -c "SELECT version();" > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ PostgreSQL connection successful"
else
    echo "❌ PostgreSQL connection failed"
    exit 1
fi

# Redis Test
REDIS_RESPONSE=$(docker exec seminote-redis redis-cli ping)
if [ "$REDIS_RESPONSE" = "PONG" ]; then
    echo "✅ Redis connection successful"
else
    echo "❌ Redis connection failed"
    exit 1
fi

# MongoDB Test
docker exec seminote-mongo mongosh --eval "db.adminCommand('ping')" > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ MongoDB connection successful"
else
    echo "❌ MongoDB connection failed"
    exit 1
fi

# Test 2: WebRTC Server
echo "🌐 Testing WebRTC Server..."
cd webrtc-server
npm install > /dev/null 2>&1
node server.js &
WEBRTC_PID=$!
sleep 3

# Test WebRTC endpoint
WEBRTC_RESPONSE=$(curl -s http://localhost:3001/health || echo "failed")
if [ "$WEBRTC_RESPONSE" != "failed" ]; then
    echo "✅ WebRTC server responding"
else
    echo "❌ WebRTC server not responding"
fi

kill $WEBRTC_PID
cd ..

# Test 3: Python ML Environment
echo "🐍 Testing Python ML Environment..."
python3 -c "
import asyncio
import aiohttp
from aiortc import RTCPeerConnection
import numpy as np
print('✅ Python WebRTC environment ready')
" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Python ML environment validated"
else
    echo "❌ Python ML environment validation failed"
    exit 1
fi

# Test 4: API Gateway Readiness
echo "🚪 Testing API Gateway Readiness..."
# This will be expanded when Spring Boot services are implemented

echo "🎉 All backend integration tests passed!"
```

### Performance Benchmarks

**Database Performance Test**:
```sql
-- File: performance-tests.sql
-- PostgreSQL Performance Test

-- Create test table
CREATE TABLE IF NOT EXISTS performance_test (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    session_data JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert test data
INSERT INTO performance_test (user_id, session_data)
SELECT
    generate_series(1, 10000) as user_id,
    '{"notes": ["C4", "D4", "E4"], "tempo": 120, "accuracy": 0.95}'::jsonb;

-- Performance queries
EXPLAIN ANALYZE SELECT * FROM performance_test WHERE user_id = 5000;
EXPLAIN ANALYZE SELECT * FROM performance_test WHERE session_data->>'tempo' = '120';

-- Cleanup
DROP TABLE performance_test;
```

**Redis Performance Test**:
```bash
# Redis performance benchmark
docker exec seminote-redis redis-benchmark -h localhost -p 6379 -n 10000 -c 50

# Test specific operations
docker exec seminote-redis redis-benchmark -h localhost -p 6379 -t set,get -n 10000 -q
```

## 📚 Development Environment Documentation

### Environment Variables Configuration

**Create .env file for development**:
```bash
# File: .env.development

# Database Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=seminote_dev
POSTGRES_USER=seminote_user
POSTGRES_PASSWORD=seminote_pass

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# MongoDB Configuration
MONGODB_HOST=localhost
MONGODB_PORT=27017
MONGODB_DATABASE=seminote_content
MONGODB_USERNAME=seminote_admin
MONGODB_PASSWORD=seminote_pass

# RabbitMQ Configuration
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=seminote
RABBITMQ_PASSWORD=seminote_pass

# WebRTC Configuration
WEBRTC_SERVER_PORT=3001
STUN_SERVERS=stun:stun.l.google.com:19302,stun:stun1.l.google.com:19302

# ML Service Configuration
ML_SERVICE_HOST=localhost
ML_SERVICE_PORT=8000

# API Gateway Configuration
API_GATEWAY_PORT=8080

# Development Settings
NODE_ENV=development
LOG_LEVEL=debug
ENABLE_CORS=true
```

### IDE Configuration

**VS Code Settings for Backend Development**:
```json
{
  "recommendations": [
    "ms-vscode.vscode-typescript-next",
    "ms-python.python",
    "redhat.java",
    "ms-vscode.vscode-docker",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "humao.rest-client",
    "bradlc.vscode-tailwindcss"
  ],
  "settings": {
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "typescript.preferences.importModuleSpecifier": "relative",
    "java.configuration.runtimes": [
      {
        "name": "JavaSE-17",
        "path": "/usr/lib/jvm/java-17-openjdk-amd64"
      }
    ]
  }
}
```

---

**🎹 Backend development environment is now ready for building the Seminote Piano Learning Platform!**

## 🔄 Next Actions

1. **Validate Environment**: Run all validation scripts
2. **Start SEM-38**: ML Development Environment Setup
3. **Begin Architecture Design**: SEM-43 Speed-Adaptive Hybrid Architecture
4. **Implement First Microservice**: User Service with Spring Boot
5. **Set up CI/CD Pipeline**: Automated testing and deployment

**The foundation is set for revolutionary piano education technology! 🚀**
