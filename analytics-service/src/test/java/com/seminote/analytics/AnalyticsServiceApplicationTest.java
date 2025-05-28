package com.seminote.analytics;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AnalyticsServiceApplicationTest {
    @Test
    void contextLoads() {}
    
    @Test
    @Tag("piano")
    void pianoAnalyticsLoads() {}
}
