package com.seminote.common;

/**
 * Seminote Common Utilities
 * 
 * Shared utilities and constants for the Seminote Piano Learning Platform
 */
public class SeminoteCommon {

    public static final String PLATFORM_NAME = "Seminote";
    public static final String VERSION = "0.1.0-SNAPSHOT";
    
    // Piano Learning Constants
    public static final int MAX_WEBRTC_LATENCY_MS = 5;
    public static final int MAX_NOTE_DETECTION_LATENCY_MS = 10;
    public static final int MAX_FEEDBACK_LATENCY_MS = 20;
    
    /**
     * Get platform information
     * @return Platform info string
     */
    public static String getPlatformInfo() {
        return String.format("🎹 %s v%s - Piano Learning Platform", PLATFORM_NAME, VERSION);
    }
    
    /**
     * Validate WebRTC latency requirements
     * @param latencyMs Measured latency in milliseconds
     * @return true if latency meets piano learning requirements
     */
    public static boolean isWebRTCLatencyAcceptable(int latencyMs) {
        return latencyMs <= MAX_WEBRTC_LATENCY_MS;
    }
}
