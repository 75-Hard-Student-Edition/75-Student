
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
