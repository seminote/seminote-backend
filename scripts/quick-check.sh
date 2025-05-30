#!/bin/bash

# 🚀 Quick Check Script for Seminote Backend
# Validates the most critical issues before pushing

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
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

print_header "🚀 QUICK VALIDATION CHECK"

# 1. Checkstyle
print_status "Running Checkstyle..."
if ./gradlew checkstyleMain --no-daemon; then
    print_success "Checkstyle passed"
else
    print_error "Checkstyle failed - fix violations before pushing"
    exit 1
fi

# 2. Compilation
print_status "Testing compilation..."
if ./gradlew compileJava --no-daemon; then
    print_success "Compilation successful"
else
    print_error "Compilation failed"
    exit 1
fi

# 3. Unit Tests
print_status "Running unit tests..."
if ./gradlew test --no-daemon; then
    print_success "Unit tests passed"
else
    print_error "Unit tests failed"
    exit 1
fi

print_header "✅ QUICK CHECK COMPLETE"
print_success "Basic validation passed! You can push your changes."
print_status "For full validation, run: ./scripts/local-validation.sh"
