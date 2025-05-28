package com.seminote.analytics;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public final class AnalyticsServiceApplication {

    private AnalyticsServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the Analytics Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(AnalyticsServiceApplication.class, args);
    }

    /**
     * Health check endpoint for the Analytics Service.
     * @return health status message
     */
    @GetMapping("/health")
    public static String health() {
        return "📊 Seminote Analytics Service is running! Tracking piano learning progress.";
    }
}
