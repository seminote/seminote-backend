# Multi-stage build for Seminote API Gateway
FROM eclipse-temurin:21-jdk-alpine AS builder

# Set working directory
WORKDIR /app

# Copy Gradle wrapper and build files
COPY gradlew gradlew.bat ./
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./

# Copy shared libraries first (for better caching)
COPY shared/ shared/

# Copy API Gateway source code
COPY api-gateway/ api-gateway/

# Make gradlew executable
RUN chmod +x gradlew

# Build the application
RUN ./gradlew api-gateway:bootJar --no-daemon

# Runtime stage
FROM eclipse-temurin:21-jre-alpine

# Add non-root user for security
RUN addgroup -g 1001 seminote && \
    adduser -D -s /bin/sh -u 1001 -G seminote seminote

# Set working directory
WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/api-gateway/build/libs/api-gateway-*.jar app.jar

# Change ownership to non-root user
RUN chown seminote:seminote app.jar

# Switch to non-root user
USER seminote

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
