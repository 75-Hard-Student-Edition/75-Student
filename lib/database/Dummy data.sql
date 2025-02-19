
-----------------------------------------------------------------------------------------------------------------------

-------------------------------------       INSERTS       -----------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------

-- Insert into User table
INSERT INTO "User" (username, email, password, difficulty, streak, sleep_duration, winddown_interval)
VALUES
('tom_yo', 'tommy@example.com', 'hashed_password_123', 'easy', 5, '8 hours', '30 minutes'),
('charlie_wiz', 'charlie@example.com', 'hashed_password_456', 'medium', 10, '7 hours', '45 minutes');

-- Insert into Category table
INSERT INTO "Category" (category_name)
VALUES
('academic'),
('social'),
('health'),
('employment'),
('chores');

-- Insert into User_Category_Priority table
INSERT INTO "User_Category_Priority" (user_id, category_id, category_priority)
VALUES
(1, 1, 2), -- tom prefers Academic tasks with priority 2
(1, 3, 1), -- tom prioritizes Health tasks the most
(2, 2, 3), -- charlie prefers Social tasks with priority 3
(2, 4, 2); -- charlie prefers Employment tasks with priority 2

-- Insert into Location table
INSERT INTO "Location" (location_name, latitude, longitude, radius_meters)
VALUES
('Home', 40.712776, -74.005974, 50),
('Office', 37.774929, -122.419418, 100),
('Gym', 51.507351, -0.127758, 30);

-- Insert into Task table
INSERT INTO "Task" (user_id, category_id, location_id, title, description, is_moveable, is_complete, start_time, end_time, repeat_period, notify_interval)
VALUES
(1, 1, 1, 'Study for exam', 'Review math notes', FALSE, FALSE, '2025-02-18 10:00:00', '2025-02-18 12:00:00', '1 day', '15 minutes'),
(1, 3, 3, 'Morning workout', 'Cardio and weights session', TRUE, FALSE, '2025-02-18 06:00:00', '2025-02-18 07:00:00', '1 day', '10 minutes'),
(2, 4, 2, 'Job interview', 'Online interview with XYZ Corp', FALSE, FALSE, '2025-02-20 14:00:00', '2025-02-20 15:00:00', NULL, '30 minutes');

-- Insert into Alarm table
INSERT INTO "Alarm" (day, time)
VALUES
('Monday', '07:00:00'),
('Tuesday', '06:30:00'),
('Wednesday', '07:15:00');

-- Insert into User_Alarm table
INSERT INTO "User_Alarm" (alarm_id, user_id)
VALUES
(1, 1), -- tom has a Monday 7:00 AM alarm
(2, 2), -- charlie has a Tuesday 6:30 AM alarm
(3, 1); -- tom has a Wednesday 7:15 AM alarm
