package com.seminote.progress;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ProgressServiceApplicationTest {
    @Test
    void contextLoads() {}
    
    @Test
    @Tag("piano")
    void pianoProgressLoads() {}
}
