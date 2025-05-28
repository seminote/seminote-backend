package com.seminote.content;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Seminote Content Service Application
 * 
 * Manages all piano learning content including sheet music, lessons,
 * exercises, and interactive piano tutorials with real-time audio feedback.
 */
@SpringBootApplication
@RestController
public class ContentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ContentServiceApplication.class, args);
    }

    @GetMapping("/health")
    public String health() {
        return "🎼 Seminote Content Service is running! Delivering world-class piano education content.";
    }

    @GetMapping("/content/status")
    public String contentStatus() {
        return "📚 Content Service: ACTIVE | Lessons: 0 | Sheet Music: 0 | Interactive Exercises: 0";
    }
}
