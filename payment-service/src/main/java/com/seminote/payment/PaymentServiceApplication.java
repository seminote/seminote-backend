package com.seminote.payment;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public final class PaymentServiceApplication {

    private PaymentServiceApplication() {
        // Private constructor to prevent instantiation
    }

    /**
     * Main method to start the Payment Service application.
     * @param args command line arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }

    /**
     * REST controller for payment endpoints.
     */
    @RestController
    public static class PaymentController {

        /**
         * Health check endpoint for the Payment Service.
         * @return health status message
         */
        @GetMapping("/health")
        public String health() {
            return "💳 Seminote Payment Service is running! Processing piano lesson subscriptions.";
        }
    }
}
