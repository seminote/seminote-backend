package com.seminote.notification;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public final class NotificationServiceApplication {

    private NotificationServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the Notification Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(NotificationServiceApplication.class, args);
    }

    /**
     * REST controller for health endpoints.
     */
    @RestController
    public static class HealthController {

        /**
         * Health check endpoint for the Notification Service.
         * @return health status message
         */
        @GetMapping("/health")
        public String health() {
            return "🔔 Seminote Notification Service is running! Keeping piano learners engaged.";
        }
    }
}
