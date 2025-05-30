package com.seminote.security;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import static org.junit.jupiter.api.Assertions.*;

class SeminoteSecurityConfigTest {
    
    @Test
    void sessionSecurityValidation() {
        assertTrue(SeminoteSecurityConfig.isSessionSecure());
    }
    
    @Test
    @Tag("piano")
    void pianoSecurityConfiguration() {
        assertNotNull(SeminoteSecurityConfig.JWT_SECRET_KEY);
        assertTrue(SeminoteSecurityConfig.JWT_EXPIRATION_HOURS > 0);
    }
}
