package com.seminote.user;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Seminote User Service Application
 *
 * This microservice handles all user-related functionality for the Seminote
 * Piano Learning Platform, including user registration, authentication,
 * profile management, and piano learning preferences.
 *
 * Key Features:
 * - User registration and authentication
 * - Piano skill level assessment
 * - Learning preferences and goals
 * - Practice session tracking
 * - Social features for piano learners
 * - Integration with piano hardware/software
 */
@SpringBootApplication
public final class UserServiceApplication {

    private UserServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the User Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }

    /**
     * REST controller for user endpoints.
     */
    @RestController
    public static class UserController {

        /**
         * Health check endpoint for the User Service.
         * @return Health status message
         */
        @GetMapping("/health")
        public String health() {
            return "🎹 Seminote User Service is running! Managing piano learners worldwide.";
        }

        /**
         * User service status endpoint.
         * @return Service status and capabilities
         */
        @GetMapping("/users/status")
        public String userServiceStatus() {
            return "👥 User Service Status: ACTIVE | Features: Registration, Authentication, "
                    + "Profiles, Piano Skills Assessment";
        }

        /**
         * Piano learner statistics endpoint.
         * @return Current platform statistics
         */
        @GetMapping("/users/stats")
        public String userStats() {
            return "📊 Piano Learners: 0 registered | Skill Levels: Beginner to Advanced | "
                    + "Practice Sessions: 0 completed";
        }
    }
}
