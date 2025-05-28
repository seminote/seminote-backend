package com.seminote.content;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Seminote Content Service Application.
 *
 * Manages all piano learning content including sheet music, lessons,
 * exercises, and interactive piano tutorials with real-time audio feedback.
 */
@SpringBootApplication
public final class ContentServiceApplication {

    private ContentServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the Content Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(ContentServiceApplication.class, args);
    }

    /**
     * REST controller for content endpoints.
     */
    @RestController
    public static class ContentController {

        /**
         * Health check endpoint for the Content Service.
         * @return health status message
         */
        @GetMapping("/health")
        public String health() {
            return "🎼 Seminote Content Service is running! Delivering world-class piano education content.";
        }

        /**
         * Content status endpoint showing current content statistics.
         * @return content status information
         */
        @GetMapping("/content/status")
        public String contentStatus() {
            return "📚 Content Service: ACTIVE | Lessons: 0 | Sheet Music: 0 | Interactive Exercises: 0";
        }
    }
}
