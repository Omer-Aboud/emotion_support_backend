-- Create the Users table
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Interactions table
CREATE TABLE Interactions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    interaction_type VARCHAR(50) NOT NULL,
    emotion_detected VARCHAR(50),
    response_generated TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Emotion_Timeline table
CREATE TABLE Emotion_Timeline (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    emotion VARCHAR(50),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Resources table
CREATE TABLE Resources (
    id SERIAL PRIMARY KEY,
    resource_type VARCHAR(50) NOT NULL,
    emotion_tag VARCHAR(50),
    content TEXT
);

-- Create the User_Preferences table
CREATE TABLE User_Preferences (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    preference_type VARCHAR(50),
    preference_value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Shared_Emotional_Spaces table
CREATE TABLE Shared_Emotional_Spaces (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    group_id INT,
    emotion_tag VARCHAR(50),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for email in Users table
CREATE INDEX idx_users_email ON Users(email);

-- Index for user_id in Interactions table
CREATE INDEX idx_interactions_user_id ON Interactions(user_id);

-- Index for emotion in Emotion_Timeline table
CREATE INDEX idx_emotion_timeline_emotion ON Emotion_Timeline(emotion);
