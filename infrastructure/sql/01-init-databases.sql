-- Seminote Backend Development Database Initialization
-- This script sets up the initial database structure for development

-- Create additional databases for microservices
CREATE DATABASE seminote_user;
CREATE DATABASE seminote_content;
CREATE DATABASE seminote_analytics;
CREATE DATABASE seminote_progress;
CREATE DATABASE seminote_notification;
CREATE DATABASE seminote_payment;

-- Grant permissions to seminote_user for all databases
GRANT ALL PRIVILEGES ON DATABASE seminote_dev TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_user TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_content TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_analytics TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_progress TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_notification TO seminote_user;
GRANT ALL PRIVILEGES ON DATABASE seminote_payment TO seminote_user;

-- Connect to seminote_dev database and create initial schema
\c seminote_dev;

-- Create basic health check table
CREATE TABLE IF NOT EXISTS health_check (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'UP',
    last_check TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial health check record
INSERT INTO health_check (service_name, status) VALUES ('database', 'UP');

-- Create audit log table for tracking changes
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    old_values JSONB,
    new_values JSONB,
    user_id VARCHAR(100),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_health_check_service ON health_check(service_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_table ON audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_timestamp ON audit_log(timestamp);

-- Display completion message
SELECT 'Seminote development databases initialized successfully!' as message;
