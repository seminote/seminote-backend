package com.seminote.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Seminote API Gateway Application
 * 
 * This service acts as the main entry point for the Seminote Piano Learning Platform,
 * routing requests to appropriate microservices and handling cross-cutting concerns
 * like authentication, rate limiting, and request/response transformation.
 * 
 * Key Features:
 * - Request routing to microservices
 * - Authentication and authorization
 * - Rate limiting and throttling
 * - Request/response logging
 * - Circuit breaker patterns
 * - WebRTC signaling coordination
 */
@SpringBootApplication
@RestController
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }

    /**
     * Health check endpoint for the API Gateway
     * @return Health status message
     */
    @GetMapping("/health")
    public String health() {
        return "🎹 Seminote API Gateway is running! Ready to orchestrate your piano learning journey.";
    }

    /**
     * API Gateway status endpoint
     * @return Gateway status and routing information
     */
    @GetMapping("/gateway/status")
    public String gatewayStatus() {
        return "🚀 API Gateway Status: ACTIVE | Services: User, Content, Analytics, Progress, Notification, Payment | WebRTC: READY";
    }

    /**
     * Piano learning platform information
     * @return Platform information
     */
    @GetMapping("/")
    public String welcome() {
        return "🎹 Welcome to Seminote - The Future of Piano Learning! 🎵\n" +
               "API Gateway v0.1.0 | Microservices Architecture | Real-time WebRTC Audio Processing";
    }
}
