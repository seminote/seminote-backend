package com.seminote.common;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Tag;
import static org.junit.jupiter.api.Assertions.*;

class SeminoteCommonTest {

    @Test
    void getPlatformInfo() {
        String info = SeminoteCommon.getPlatformInfo();
        assertTrue(info.contains("Seminote"));
        assertTrue(info.contains("Piano Learning Platform"));
    }

    @Test
    @Tag("webrtc")
    @Tag("performance")
    void webrtcLatencyValidation() {
        assertTrue(SeminoteCommon.isWebRTCLatencyAcceptable(3));
        assertTrue(SeminoteCommon.isWebRTCLatencyAcceptable(5));
        assertFalse(SeminoteCommon.isWebRTCLatencyAcceptable(6));
        assertFalse(SeminoteCommon.isWebRTCLatencyAcceptable(10));
    }
}
