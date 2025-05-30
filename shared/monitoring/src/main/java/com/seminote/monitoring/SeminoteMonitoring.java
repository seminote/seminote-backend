package com.seminote.monitoring;

import java.util.logging.Logger;

/**
 * Seminote Monitoring Utilities.
 *
 * Shared monitoring and metrics for piano learning platform
 */
public final class SeminoteMonitoring {

    private static final Logger LOGGER = Logger.getLogger(SeminoteMonitoring.class.getName());

    private SeminoteMonitoring() {
        // Private constructor to prevent instantiation
    }

    /**
     * Record WebRTC latency metric.
     * @param latencyMs Latency in milliseconds
     */
    public static void recordWebRTCLatency(final int latencyMs) {
        // Placeholder for metrics recording
        LOGGER.info("📊 WebRTC Latency: " + latencyMs + "ms");
    }

    /**
     * Record piano note detection time.
     * @param detectionTimeMs Detection time in milliseconds
     */
    public static void recordNoteDetectionTime(final int detectionTimeMs) {
        // Placeholder for metrics recording
        LOGGER.info("🎹 Note Detection: " + detectionTimeMs + "ms");
    }
}
