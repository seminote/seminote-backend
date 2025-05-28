package com.seminote.monitoring;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;

class SeminoteMonitoringTest {
    
    @Test
    @Tag("webrtc")
    @Tag("performance")
    void webrtcLatencyRecording() {
        // Test that WebRTC latency recording works
        SeminoteMonitoring.recordWebRTCLatency(3);
    }
    
    @Test
    @Tag("piano")
    @Tag("performance")
    void noteDetectionTimeRecording() {
        // Test that note detection time recording works
        SeminoteMonitoring.recordNoteDetectionTime(8);
    }
}
