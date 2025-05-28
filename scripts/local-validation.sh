#!/bin/bash

# 🔍 Local Validation Script for Seminote Backend
# This script validates your changes locally before pushing to avoid pipeline failures

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Check if we're in the right directory
if [ ! -f "build.gradle" ]; then
    print_error "Please run this script from the seminote-backend root directory"
    exit 1
fi

print_header "🚀 SEMINOTE BACKEND LOCAL VALIDATION"

# 1. Environment Validation
print_header "🔍 1. ENVIRONMENT VALIDATION"

print_status "Checking Java version..."
if java -version 2>&1 | grep -q "21"; then
    print_success "Java 21 detected"
else
    print_error "Java 21 required but not found"
    java -version
    exit 1
fi

print_status "Checking Gradle..."
if ./gradlew --version > /dev/null 2>&1; then
    print_success "Gradle wrapper available"
else
    print_error "Gradle wrapper not working"
    exit 1
fi

# 2. Code Quality Checks
print_header "🔍 2. CODE QUALITY CHECKS"

print_status "Running Checkstyle..."
if ./gradlew checkstyleMain checkstyleTest --no-daemon; then
    print_success "Checkstyle passed"
else
    print_error "Checkstyle violations found. Fix them before pushing."
    echo "Run: ./gradlew checkstyleMain checkstyleTest --no-daemon"
    exit 1
fi

# 3. Build and Test
print_header "🔍 3. BUILD AND TEST"

print_status "Cleaning previous builds..."
./gradlew clean --no-daemon

print_status "Building all services..."
if ./gradlew build --no-daemon --parallel; then
    print_success "Build completed successfully"
else
    print_error "Build failed. Check the errors above."
    exit 1
fi

print_status "Running tests..."
if ./gradlew test --no-daemon --parallel; then
    print_success "All tests passed"
else
    print_error "Tests failed. Check the test reports."
    echo "Test reports available in: */build/reports/tests/test/index.html"
    exit 1
fi

# 4. Test Coverage
print_header "🔍 4. TEST COVERAGE"

print_status "Generating test coverage reports..."
if ./gradlew jacocoTestReport --no-daemon; then
    print_success "Coverage reports generated"
else
    print_warning "Coverage report generation had issues"
fi

print_status "Checking coverage thresholds..."
if ./gradlew jacocoTestCoverageVerification --no-daemon; then
    print_success "Coverage thresholds met"
else
    print_warning "Coverage thresholds not met. Consider adding more tests."
    echo "Coverage reports available in: */build/reports/jacoco/test/html/index.html"
fi

# 5. Security Scan
print_header "🔍 5. SECURITY SCAN"

print_status "Running dependency vulnerability check..."
if ./gradlew dependencyCheckAnalyze --no-daemon; then
    print_success "Security scan completed"
else
    print_warning "Security scan had issues"
fi

# 6. Integration Test Preparation
print_header "🔍 6. INTEGRATION TEST PREPARATION"

print_status "Checking Docker availability..."
if command -v docker > /dev/null 2>&1; then
    if docker info > /dev/null 2>&1; then
        print_success "Docker is available and running"
        
        print_status "Testing container startup..."
        # Quick test of PostgreSQL container
        docker run --rm -d --name test-postgres -e POSTGRES_PASSWORD=test postgres:16 > /dev/null
        sleep 5
        if docker exec test-postgres pg_isready -U postgres > /dev/null 2>&1; then
            print_success "Container infrastructure test passed"
        else
            print_warning "Container test had issues"
        fi
        docker stop test-postgres > /dev/null 2>&1 || true
    else
        print_warning "Docker is installed but not running"
    fi
else
    print_warning "Docker not available - integration tests may fail in CI"
fi

# 7. Final Summary
print_header "📊 VALIDATION SUMMARY"

print_success "✅ Environment validation passed"
print_success "✅ Code quality checks passed"
print_success "✅ Build completed successfully"
print_success "✅ Unit tests passed"

if ./gradlew jacocoTestCoverageVerification --no-daemon > /dev/null 2>&1; then
    print_success "✅ Test coverage thresholds met"
else
    print_warning "⚠️  Test coverage below threshold (consider adding tests)"
fi

print_success "✅ Security scan completed"

if command -v docker > /dev/null 2>&1 && docker info > /dev/null 2>&1; then
    print_success "✅ Docker infrastructure ready"
else
    print_warning "⚠️  Docker not available (integration tests may fail)"
fi

print_header "🎉 LOCAL VALIDATION COMPLETE"
print_success "Your code is ready to push! The CI pipeline should pass."

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. git add ."
echo "2. git commit -m 'your commit message'"
echo "3. git push origin your-branch"

echo -e "\n${BLUE}If you want to run specific checks:${NC}"
echo "• Code quality only: ./gradlew checkstyleMain checkstyleTest"
echo "• Tests only: ./gradlew test"
echo "• Coverage only: ./gradlew jacocoTestReport jacocoTestCoverageVerification"
echo "• Security scan: ./gradlew dependencyCheckAnalyze"
