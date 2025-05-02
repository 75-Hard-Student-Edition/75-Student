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
    username TEXT NOT NULL,                 
    email TEXT UNIQUE,            
    phone_number TEXT UNIQUE,
    password TEXT NOT NULL,              
    streak INT DEFAULT 0,
    difficulty INTEGER NOT NULL,
    category_order TEXT NOT NULL,
    sleep_duration_minutes INT NOT NULL,
    bedtime TEXT NOT NULL,
    notify_time_minutes INT NOT NULL,
    mindfulness_minutes INT NOT NULL            
) STRICT;

-- Create Task table
CREATE TABLE "task" (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE CASCADE,
    title TEXT NOT NULL, 
    description TEXT NOT NULL, 
    is_moveable INTEGER DEFAULT 0, -- SQLite doesn't have a boolean type
    is_complete INTEGER DEFAULT 0, 
    category INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    start_time TEXT NOT NULL,
    duration_minutes INT NOT NULL, 
    repeat_period TEXT, 
    links TEXT
) STRICT;
