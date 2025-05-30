package com.seminote.security;

/**
 * Seminote Security Configuration.
 *
 * Shared security utilities for the piano learning platform
 */
public final class SeminoteSecurityConfig {

    public static final String JWT_SECRET_KEY = "seminote-piano-learning-platform-secret";
    public static final int JWT_EXPIRATION_HOURS = 24;

    private SeminoteSecurityConfig() {
        // Private constructor to prevent instantiation
    }

    /**
     * Validate piano learning session security.
     * @return true if session is secure for real-time audio processing
     */
    public static boolean isSessionSecure() {
        return true; // Placeholder implementation
    }
}
