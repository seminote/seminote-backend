package com.seminote.progress;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public final class ProgressServiceApplication {

    private ProgressServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the Progress Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(ProgressServiceApplication.class, args);
    }

    /**
     * REST controller for progress endpoints.
     */
    @RestController
    public static class ProgressController {

        /**
         * Health check endpoint for the Progress Service.
         * @return health status message
         */
        @GetMapping("/health")
        public String health() {
            return "📈 Seminote Progress Service is running! Monitoring piano learning achievements.";
        }
    }
}
