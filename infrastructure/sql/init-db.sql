-- Seminote Backend Database Initialization Script
-- This script creates the necessary tables and initial data for the development environment

-- Create health_check table for monitoring
CREATE TABLE IF NOT EXISTS health_check (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    last_check TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table for user service
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    instrument_preference VARCHAR(50) DEFAULT 'piano',
    skill_level VARCHAR(50) DEFAULT 'beginner',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create content table for content service
CREATE TABLE IF NOT EXISTS content (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    instrument VARCHAR(50) NOT NULL,
    difficulty_level VARCHAR(50) NOT NULL,
    file_path VARCHAR(500),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create progress table for progress service
CREATE TABLE IF NOT EXISTS progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    content_id INTEGER REFERENCES content(id),
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    practice_time_minutes INTEGER DEFAULT 0,
    last_practiced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create analytics table for analytics service
CREATE TABLE IF NOT EXISTS analytics (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    event_type VARCHAR(100) NOT NULL,
    event_data JSONB,
    session_id VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create payments table for payment service
CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'pending',
    transaction_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create notifications table for notification service
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial health check data
INSERT INTO health_check (service_name, status) VALUES 
    ('database', 'healthy'),
    ('redis', 'healthy'),
    ('mongodb', 'healthy'),
    ('rabbitmq', 'healthy')
ON CONFLICT DO NOTHING;

-- Insert sample data for development
INSERT INTO users (username, email, password_hash, instrument_preference, skill_level) VALUES 
    ('demo_user', 'demo@seminote.com', '$2a$10$dummy.hash.for.development', 'piano', 'beginner'),
    ('test_user', 'test@seminote.com', '$2a$10$dummy.hash.for.development', 'violin', 'intermediate')
ON CONFLICT DO NOTHING;

INSERT INTO content (title, content_type, instrument, difficulty_level, file_path) VALUES 
    ('Basic Piano Scales', 'lesson', 'piano', 'beginner', '/content/piano/basic-scales.json'),
    ('Violin Bow Technique', 'lesson', 'violin', 'beginner', '/content/violin/bow-technique.json'),
    ('Piano Chord Progressions', 'exercise', 'piano', 'intermediate', '/content/piano/chord-progressions.json')
ON CONFLICT DO NOTHING;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_progress_user_id ON progress(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_user_id ON analytics(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_timestamp ON analytics(timestamp);
CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_health_check_service ON health_check(service_name);
