package com.seminote.notification;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class NotificationServiceApplicationTest {
    @Test
    void contextLoads() {}
    
    @Test
    @Tag("piano")
    void pianoNotificationLoads() {}
}
