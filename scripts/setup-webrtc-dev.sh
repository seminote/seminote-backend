#!/bin/bash
# File: setup-webrtc-dev.sh
# WebRTC Development Environment Setup for Seminote

echo "🌐 Setting up WebRTC Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    if [ "$2" = "success" ]; then
        echo -e "${GREEN}✅ $1${NC}"
    elif [ "$2" = "error" ]; then
        echo -e "${RED}❌ $1${NC}"
    elif [ "$2" = "warning" ]; then
        echo -e "${YELLOW}⚠️ $1${NC}"
    else
        echo -e "${BLUE}📦 $1${NC}"
    fi
}

# Create WebRTC development directories
echo ""
print_status "Creating WebRTC development directories..." "info"
mkdir -p webrtc-dev/node-server
mkdir -p webrtc-dev/python-ml
mkdir -p webrtc-dev/test-clients

# Setup Node.js WebRTC Server
echo ""
print_status "Setting up Node.js WebRTC Server..." "info"
cd webrtc-dev/node-server

# Create package.json
cat > package.json << 'EOF'
{
  "name": "seminote-webrtc-server",
  "version": "1.0.0",
  "description": "WebRTC server for Seminote piano learning platform",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.21.2",
    "socket.io": "^4.8.1",
    "node-webrtc": "^0.4.7",
    "cors": "^2.8.5",
    "dotenv": "^16.4.7"
  },
  "devDependencies": {
    "nodemon": "^3.1.9",
    "jest": "^29.7.0"
  },
  "keywords": ["webrtc", "piano", "audio", "real-time"],
  "author": "Seminote Team",
  "license": "MIT"
}
EOF

# Create WebRTC server
cat > server.js << 'EOF'
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
require('dotenv').config();

// Import WebRTC only if available (for development)
let RTCPeerConnection, RTCSessionDescription;
try {
  const webrtc = require('node-webrtc');
  RTCPeerConnection = webrtc.RTCPeerConnection;
  RTCSessionDescription = webrtc.RTCSessionDescription;
} catch (error) {
  console.warn('node-webrtc not available, using mock implementation for development');
  RTCPeerConnection = class MockRTCPeerConnection {
    constructor() {
      this.ontrack = null;
      this.localDescription = null;
    }
    async setRemoteDescription(desc) { console.log('Mock setRemoteDescription'); }
    async createAnswer() {
      return { type: 'answer', sdp: 'mock-sdp' };
    }
    async setLocalDescription(desc) {
      this.localDescription = desc;
    }
  };
  RTCSessionDescription = class MockRTCSessionDescription {
    constructor(desc) {
      this.type = desc.type;
      this.sdp = desc.sdp;
    }
  };
}

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// WebRTC configuration for Seminote
const rtcConfig = {
  iceServers: [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' }
  ]
};

// Store active connections
const connections = new Map();

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'UP',
    service: 'seminote-webrtc-server',
    timestamp: new Date().toISOString(),
    connections: connections.size
  });
});

// WebRTC signaling
io.on('connection', (socket) => {
  console.log(`Client connected: ${socket.id}`);

  socket.on('offer', async (offer) => {
    try {
      console.log(`Received offer from ${socket.id}`);

      const peerConnection = new RTCPeerConnection(rtcConfig);
      connections.set(socket.id, peerConnection);

      // Handle incoming audio stream
      if (peerConnection.ontrack) {
        peerConnection.ontrack = (event) => {
          console.log('Received audio stream from iOS client');
          // Forward to ML processing service
          processAudioStream(event.streams[0], socket.id);
        };
      }

      await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
      const answer = await peerConnection.createAnswer();
      await peerConnection.setLocalDescription(answer);

      socket.emit('answer', answer);
      console.log(`Sent answer to ${socket.id}`);
    } catch (error) {
      console.error('Error handling offer:', error);
      socket.emit('error', { message: 'Failed to process offer' });
    }
  });

  socket.on('ice-candidate', async (candidate) => {
    try {
      const peerConnection = connections.get(socket.id);
      if (peerConnection && peerConnection.addIceCandidate) {
        await peerConnection.addIceCandidate(candidate);
        console.log(`Added ICE candidate for ${socket.id}`);
      }
    } catch (error) {
      console.error('Error adding ICE candidate:', error);
    }
  });

  socket.on('disconnect', () => {
    console.log(`Client disconnected: ${socket.id}`);
    const peerConnection = connections.get(socket.id);
    if (peerConnection && peerConnection.close) {
      peerConnection.close();
    }
    connections.delete(socket.id);
  });
});

function processAudioStream(stream, clientId) {
  // Integration point for ML processing
  // This will connect to Python ML services
  console.log(`Processing audio stream for client ${clientId}`);

  // Mock processing for development
  setTimeout(() => {
    const mockFeedback = {
      notes: ['C4', 'D4', 'E4'],
      accuracy: 0.95,
      tempo: 120,
      timestamp: Date.now()
    };

    const socket = io.sockets.sockets.get(clientId);
    if (socket) {
      socket.emit('feedback', mockFeedback);
    }
  }, 100);
}

const PORT = process.env.WEBRTC_SERVER_PORT || 3001;
server.listen(PORT, () => {
  console.log(`🌐 WebRTC server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
});

module.exports = { app, server };
EOF

# Create test client
cat > test-client.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Seminote WebRTC Test Client</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        button { padding: 10px 20px; margin: 5px; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .info { background-color: #d1ecf1; color: #0c5460; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎹 Seminote WebRTC Test Client</h1>

        <div id="status" class="status info">Ready to connect</div>

        <div>
            <button onclick="startConnection()">Start Connection</button>
            <button onclick="stopConnection()">Stop Connection</button>
            <button onclick="testAudio()">Test Audio</button>
        </div>

        <div>
            <h3>Connection Info</h3>
            <p>Server: <span id="serverUrl">ws://localhost:3001</span></p>
            <p>Status: <span id="connectionStatus">Disconnected</span></p>
        </div>

        <div>
            <h3>Feedback</h3>
            <div id="feedback"></div>
        </div>
    </div>

    <script src="/socket.io/socket.io.js"></script>
    <script>
        let socket;
        let peerConnection;

        function updateStatus(message, type = 'info') {
            const statusDiv = document.getElementById('status');
            statusDiv.textContent = message;
            statusDiv.className = `status ${type}`;
        }

        function startConnection() {
            socket = io('http://localhost:3001');

            socket.on('connect', () => {
                updateStatus('Connected to WebRTC server', 'success');
                document.getElementById('connectionStatus').textContent = 'Connected';
            });

            socket.on('disconnect', () => {
                updateStatus('Disconnected from server', 'error');
                document.getElementById('connectionStatus').textContent = 'Disconnected';
            });

            socket.on('answer', (answer) => {
                updateStatus('Received answer from server', 'success');
                console.log('Answer:', answer);
            });

            socket.on('feedback', (feedback) => {
                const feedbackDiv = document.getElementById('feedback');
                feedbackDiv.innerHTML = `
                    <p><strong>Notes:</strong> ${feedback.notes.join(', ')}</p>
                    <p><strong>Accuracy:</strong> ${(feedback.accuracy * 100).toFixed(1)}%</p>
                    <p><strong>Tempo:</strong> ${feedback.tempo} BPM</p>
                    <p><strong>Time:</strong> ${new Date(feedback.timestamp).toLocaleTimeString()}</p>
                `;
            });

            socket.on('error', (error) => {
                updateStatus(`Error: ${error.message}`, 'error');
            });
        }

        function stopConnection() {
            if (socket) {
                socket.disconnect();
                updateStatus('Connection stopped', 'info');
            }
        }

        function testAudio() {
            if (!socket) {
                updateStatus('Please connect first', 'error');
                return;
            }

            // Send mock offer
            const mockOffer = {
                type: 'offer',
                sdp: 'mock-sdp-offer-for-testing'
            };

            socket.emit('offer', mockOffer);
            updateStatus('Sent test offer to server', 'info');
        }
    </script>
</body>
</html>
EOF

# Create public directory and move test client
mkdir -p public
mv test-client.html public/

print_status "Node.js WebRTC server setup complete" "success"

# Setup Python WebRTC ML Service
cd ../python-ml
print_status "Setting up Python WebRTC ML Service..." "info"

# Create requirements.txt
cat > requirements.txt << 'EOF'
# WebRTC and Audio Processing
aiortc==1.9.0
aiohttp==3.11.11
websockets==14.1

# Audio Processing
librosa==0.10.2
numpy==2.2.1
scipy==1.15.0

# ML Libraries (for future use)
torch==2.5.1
torchaudio==2.5.1
scikit-learn==1.6.0

# Web Framework
fastapi==0.115.6
uvicorn==0.34.0

# Development
pytest==8.3.4
pytest-asyncio==0.25.0
python-dotenv==1.0.1
EOF

# Create Python WebRTC service
cat > audio_processor.py << 'EOF'
import asyncio
import aiohttp
import json
import logging
from typing import Optional
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
import numpy as np

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Try to import WebRTC, fallback to mock for development
try:
    from aiortc import RTCPeerConnection, RTCSessionDescription
    from aiortc.contrib.media import MediaPlayer, MediaRecorder
    WEBRTC_AVAILABLE = True
except ImportError:
    logger.warning("aiortc not available, using mock implementation")
    WEBRTC_AVAILABLE = False

    class MockRTCPeerConnection:
        def __init__(self):
            self.ontrack = None
            self.localDescription = None

        async def setRemoteDescription(self, desc):
            logger.info("Mock setRemoteDescription")

        async def createAnswer(self):
            return type('Answer', (), {'type': 'answer', 'sdp': 'mock-sdp'})()

        async def setLocalDescription(self, desc):
            self.localDescription = desc

    RTCPeerConnection = MockRTCPeerConnection
    RTCSessionDescription = lambda desc: desc

class SeminoteAudioProcessor:
    def __init__(self):
        self.peer_connections = set()
        self.active_sessions = {}

    async def handle_webrtc_connection(self, pc, session_id):
        """Handle WebRTC connection for audio processing"""

        if WEBRTC_AVAILABLE:
            @pc.on("track")
            async def on_track(track):
                if track.kind == "audio":
                    logger.info(f"Received audio track from session {session_id}")

                    # Process audio frames for ML analysis
                    try:
                        while True:
                            frame = await track.recv()
                            audio_data = self.frame_to_numpy(frame)

                            # Perform ML processing
                            notes = await self.detect_notes(audio_data)

                            # Send feedback back to client
                            await self.send_feedback(notes, session_id)

                    except Exception as e:
                        logger.error(f"Error processing audio: {e}")
                        break

        self.peer_connections.add(pc)

    def frame_to_numpy(self, frame):
        """Convert WebRTC audio frame to numpy array"""
        # Mock implementation for development
        # In production, this would convert actual audio frames
        return np.random.random(1024)  # Mock audio data

    async def detect_notes(self, audio_data):
        """ML-based note detection"""
        # Mock implementation for development
        # This will be replaced with actual ML models in SEM-38
        await asyncio.sleep(0.01)  # Simulate processing time

        mock_notes = {
            'detected_notes': ['C4', 'E4', 'G4'],
            'confidence': 0.92,
            'tempo': 120,
            'accuracy': 0.88,
            'timestamp': asyncio.get_event_loop().time()
        }

        return mock_notes

    async def send_feedback(self, notes, session_id):
        """Send processed feedback back to client"""
        # This would send feedback through WebSocket or HTTP
        logger.info(f"Sending feedback to session {session_id}: {notes}")

# FastAPI application
app = FastAPI(title="Seminote WebRTC ML Service", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

processor = SeminoteAudioProcessor()

@app.get("/health")
async def health_check():
    return {
        "status": "UP",
        "service": "seminote-webrtc-ml",
        "webrtc_available": WEBRTC_AVAILABLE,
        "active_connections": len(processor.peer_connections),
        "timestamp": asyncio.get_event_loop().time()
    }

@app.websocket("/webrtc")
async def webrtc_endpoint(websocket: WebSocket):
    await websocket.accept()
    session_id = id(websocket)

    logger.info(f"WebSocket connection established: {session_id}")

    pc = RTCPeerConnection()
    await processor.handle_webrtc_connection(pc, session_id)

    try:
        while True:
            message = await websocket.receive_json()

            if message["type"] == "offer":
                await pc.setRemoteDescription(RTCSessionDescription(
                    sdp=message["sdp"], type=message["type"]
                ))

                answer = await pc.createAnswer()
                await pc.setLocalDescription(answer)

                await websocket.send_json({
                    "type": "answer",
                    "sdp": pc.localDescription.sdp if hasattr(pc.localDescription, 'sdp') else 'mock-sdp'
                })

            elif message["type"] == "test":
                # Handle test messages
                mock_feedback = await processor.detect_notes(np.random.random(1024))
                await websocket.send_json({
                    "type": "feedback",
                    "data": mock_feedback
                })

    except WebSocketDisconnect:
        logger.info(f"WebSocket disconnected: {session_id}")
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
    finally:
        if hasattr(pc, 'close'):
            await pc.close()
        processor.peer_connections.discard(pc)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

# Create test script
cat > test_webrtc.py << 'EOF'
import asyncio
import websockets
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def test_webrtc_service():
    """Test the WebRTC ML service"""
    uri = "ws://localhost:8000/webrtc"

    try:
        async with websockets.connect(uri) as websocket:
            logger.info("Connected to WebRTC ML service")

            # Send test message
            test_message = {
                "type": "test",
                "data": "test audio processing"
            }

            await websocket.send(json.dumps(test_message))
            logger.info("Sent test message")

            # Receive response
            response = await websocket.recv()
            data = json.loads(response)
            logger.info(f"Received response: {data}")

            return data

    except Exception as e:
        logger.error(f"Test failed: {e}")
        return None

if __name__ == "__main__":
    result = asyncio.run(test_webrtc_service())
    if result:
        print("✅ WebRTC ML service test passed")
    else:
        print("❌ WebRTC ML service test failed")
EOF

print_status "Python WebRTC ML service setup complete" "success"

# Create startup scripts
cd ../../
cat > scripts/start-webrtc-dev.sh << 'EOF'
#!/bin/bash
# Start WebRTC development environment

echo "🚀 Starting WebRTC Development Environment..."

# Start Node.js server
echo "Starting Node.js WebRTC server..."
cd webrtc-dev/node-server
npm install
npm start &
NODE_PID=$!

# Start Python ML service
echo "Starting Python WebRTC ML service..."
cd ../python-ml
pip3 install -r requirements.txt
python3 audio_processor.py &
PYTHON_PID=$!

cd ../../

echo "✅ WebRTC development environment started!"
echo "📊 Node.js server: http://localhost:3001"
echo "📊 Python ML service: http://localhost:8000"
echo "🧪 Test client: http://localhost:3001/test-client.html"
echo ""
echo "To stop services:"
echo "  kill $NODE_PID $PYTHON_PID"

# Save PIDs for cleanup
echo $NODE_PID > .webrtc-node.pid
echo $PYTHON_PID > .webrtc-python.pid
EOF

chmod +x scripts/start-webrtc-dev.sh

cat > scripts/stop-webrtc-dev.sh << 'EOF'
#!/bin/bash
# Stop WebRTC development environment

echo "🛑 Stopping WebRTC Development Environment..."

# Kill Node.js server
if [ -f .webrtc-node.pid ]; then
    NODE_PID=$(cat .webrtc-node.pid)
    kill $NODE_PID 2>/dev/null
    rm .webrtc-node.pid
    echo "✅ Node.js server stopped"
fi

# Kill Python ML service
if [ -f .webrtc-python.pid ]; then
    PYTHON_PID=$(cat .webrtc-python.pid)
    kill $PYTHON_PID 2>/dev/null
    rm .webrtc-python.pid
    echo "✅ Python ML service stopped"
fi

echo "🛑 WebRTC development environment stopped"
EOF

chmod +x scripts/stop-webrtc-dev.sh

print_status "WebRTC development environment setup complete!" "success"
echo ""
print_status "Next steps:" "info"
echo "  1. Install Node.js dependencies: cd webrtc-dev/node-server && npm install"
echo "  2. Install Python dependencies: cd webrtc-dev/python-ml && pip3 install -r requirements.txt"
echo "  3. Start services: ./scripts/start-webrtc-dev.sh"
echo "  4. Test: Open http://localhost:3001/test-client.html"
