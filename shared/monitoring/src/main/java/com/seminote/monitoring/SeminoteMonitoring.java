package com.seminote.monitoring;

/**
 * Seminote Monitoring Utilities
 * 
 * Shared monitoring and metrics for piano learning platform
 */
public class SeminoteMonitoring {
    
    /**
     * Record WebRTC latency metric
     * @param latencyMs Latency in milliseconds
     */
    public static void recordWebRTCLatency(int latencyMs) {
        // Placeholder for metrics recording
        System.out.println("📊 WebRTC Latency: " + latencyMs + "ms");
    }
    
    /**
     * Record piano note detection time
     * @param detectionTimeMs Detection time in milliseconds
     */
    public static void recordNoteDetectionTime(int detectionTimeMs) {
        // Placeholder for metrics recording
        System.out.println("🎹 Note Detection: " + detectionTimeMs + "ms");
    }
}
