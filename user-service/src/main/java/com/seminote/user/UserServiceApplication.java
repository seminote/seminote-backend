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
@RestController
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }

    /**
     * Health check endpoint for the User Service
     * @return Health status message
     */
    @GetMapping("/health")
    public String health() {
        return "🎹 Seminote User Service is running! Managing piano learners worldwide.";
    }

    /**
     * User service status endpoint
     * @return Service status and capabilities
     */
    @GetMapping("/users/status")
    public String userServiceStatus() {
        return "👥 User Service Status: ACTIVE | Features: Registration, Authentication, Profiles, Piano Skills Assessment";
    }

    /**
     * Piano learner statistics endpoint
     * @return Current platform statistics
     */
    @GetMapping("/users/stats")
    public String userStats() {
        return "📊 Piano Learners: 0 registered | Skill Levels: Beginner to Advanced | Practice Sessions: 0 completed";
    }
}
