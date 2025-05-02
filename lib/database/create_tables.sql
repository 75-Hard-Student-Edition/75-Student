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
    difficulty INTEGER NOT NULL,
    streak INT DEFAULT 0,
    mindfulness_minutes INT NOT NULL,                 -- formerly INTERVAL
    notify_time_minutes INT NOT NULL           -- formerly INTERVAL
) STRICT;

-- Create user_category_priority table
CREATE TABLE "user_category_priority" (
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE CASCADE,
    category INT NOT NULL,
    category_priority INT NOT NULL,
    PRIMARY KEY (user_id, category)
) STRICT;

-- Create Task table
CREATE TABLE "task" (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE CASCADE,
    category INTEGER NOT NULL,
    title TEXT NOT NULL, -- formerly VARCHAR(100)
    description TEXT, -- formerly VARCHAR(250)
    is_moveable INTEGER DEFAULT 0, -- formerly BOOLEAN
    is_complete INTEGER DEFAULT 0, -- formerly BOOLEAN
    start_time TEXT, -- formerly TIMESTAMP
    end_time TEXT, -- formerly TIMESTAMP
    repeat_period TEXT -- formerly INTERVAL
) STRICT;

