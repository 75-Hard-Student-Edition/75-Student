/*
This code has been re-written to be compatible with SQLite

SQLite has fewer datatypes and fewer options for integrity constraints
than other database engines. 
This means that integrity will need to be ensured in the code that 
interfaces with the database, rather than the database itself.
 */

-- Create user table
CREATE TABLE "user" (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,                 -- forrmely VARCHAR(50)
    email TEXT NOT NULL UNIQUE,             -- formerly VARCHAR(100)
    password TEXT NOT NULL,                 -- formerly VARCHAR(100)
    difficulty_id INTEGER NOT NULL REFERENCES "difficulty"(difficulty_id) ON DELETE CASCADE,
    streak INT DEFAULT 0,
    sleep_duration TEXT,                    -- formerly INTERVAL
    winddown_interval TEXT                  -- formerly INTERVAL
) STRICT;

-- Create user_category_priority table
CREATE TABLE "user_category_priority" (
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE CASCADE,
    category_id INT NOT NULL REFERENCES "category"(category_id) ON DELETE CASCADE,
    category_priority INT NOT NULL,
    PRIMARY KEY (user_id, category_id)
) STRICT;

-- Create location table
CREATE TABLE "location" (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    location_name TEXT NOT NULL,    -- formerly VARCHAR(50)
    latitude REAL NOT NULL,         -- formerly DECIMAL(10, 8)
    longitude REAL NOT NULL,        -- formerly DECIMAL(11, 8) -- idk why they were different
    radius_meters INT NOT NULL
) STRICT;

-- Create Task table
CREATE TABLE "task" (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE CASCADE,
    location_id INTEGER REFERENCES "location"(location_id) ON DELETE SET NULL,
    category_id INTEGER NOT NULL REFERENCES "category"(category_id) ON DELETE CASCADE,
    title TEXT NOT NULL, -- formerly VARCHAR(100)
    description TEXT, -- formerly VARCHAR(250)
    is_moveable INTEGER DEFAULT 0, -- formerly BOOLEAN
    is_complete INTEGER DEFAULT 0, -- formerly BOOLEAN
    start_time TEXT, -- formerly TIMESTAMP
    end_time TEXT, -- formerly TIMESTAMP
    repeat_period TEXT, -- formerly INTERVAL
    notify_interval TEXT NOT NULL -- formerly INTERVAL
) STRICT;

-- Create Alarm table
CREATE TABLE "alarm" (
    user_id INT REFERENCES "user"(user_id) ON DELETE CASCADE,
    day_id INTEGER NOT NULL REFERENCES "day"(day_id) ON DELETE CASCADE,
    time TEXT NOT NULL, -- formerly TIME
    PRIMARY KEY (user_id, day_id)
) STRICT;
