package com.seminote.content;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class ContentServiceApplicationTest {

    @Test
    void contextLoads() {
    }

    @Test
    @Tag("piano")
    void pianoContentManagementLoads() {
    }

    @Test
    @Tag("webrtc")
    void audioContentProcessingLoads() {
    }
}
