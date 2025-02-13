-- Create ENUM types
CREATE TYPE difficulty_enum AS ENUM ('easy', 'medium', 'hard');
CREATE TYPE day_enum AS ENUM ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
CREATE TYPE category_enum AS ENUM ('academic', 'social', 'health', 'employment', 'chores');

-- Create User table
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    difficulty difficulty_enum NOT NULL,
    streak INT DEFAULT 0,
    sleep_duration INTERVAL,
    winddown_interval INTERVAL
);

-- Create User_Category_Priority table
CREATE TABLE "User_Category_Priority" (
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    category category_enum NOT NULL,
    category_priority INT NOT NULL,
    PRIMARY KEY (user_id, category)
);

-- Create Location table
CREATE TABLE "Location" (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(50) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    radius_meters INT NOT NULL
);

-- Create Task table
CREATE TABLE "Task" (
    task_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    location_id INT REFERENCES "Location"(location_id) ON DELETE SET NULL,
    category category_enum NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(250),
    is_moveable BOOLEAN DEFAULT FALSE,
    is_complete BOOLEAN DEFAULT FALSE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    repeat_period INTERVAL,
    notify_interval INTERVAL
);

-- Create Alarm table
CREATE TABLE "Alarm" (
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    day day_enum NOT NULL,
    time TIME NOT NULL,
    PRIMARY KEY (user_id, day)
);
