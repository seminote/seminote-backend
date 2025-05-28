package com.seminote.progress;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class ProgressServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProgressServiceApplication.class, args);
    }
    
    @GetMapping("/health")
    public String health() {
        return "📈 Seminote Progress Service is running! Monitoring piano learning achievements.";
    }
}
