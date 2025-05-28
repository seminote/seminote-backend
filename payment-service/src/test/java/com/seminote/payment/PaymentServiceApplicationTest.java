package com.seminote.payment;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class PaymentServiceApplicationTest {
    @Test
    void contextLoads() {}
    
    @Test
    @Tag("piano")
    void pianoPaymentLoads() {}
}
