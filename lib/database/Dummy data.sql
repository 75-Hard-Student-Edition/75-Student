
-----------------------------------------------------------------------------------------------------------------------

-------------------------------------       INSERTS       -----------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------

-- Insert into User table
INSERT INTO "user" (username, email, password, difficulty_id, streak, sleep_duration, winddown_interval)
VALUES
('tom_yo', 'tommy@example.com', 'hashed_password_123', 1, 5, '8 hours', '30 minutes'),
('charlie_wiz', 'charlie@example.com', 'hashed_password_456', 2, 10, '7 hours', '45 minutes');

-- Insert into User_Category_Priority table
INSERT INTO "user_category_priority" (user_id, category_id, category_priority)
VALUES
(1, 1, 2), -- tom prefers Academic tasks with priority 2
(1, 3, 1), -- tom prioritizes Health tasks the most
(2, 2, 3), -- charlie prefers Social tasks with priority 3
(2, 4, 2); -- charlie prefers Employment tasks with priority 2

-- Insert into Location table
INSERT INTO "location" (location_name, latitude, longitude, radius_meters)
VALUES
('Home', 40.712776, -74.005974, 50),
('Office', 37.774929, -122.419418, 100),
('Gym', 51.507351, -0.127758, 30);

-- Insert into Task table
INSERT INTO "task" (user_id, category_id, location_id, title, description, is_moveable, is_complete, start_time, end_time, repeat_period, notify_interval)
VALUES
(1, 1, 1, 'Study for exam', 'Review math notes', FALSE, FALSE, '2025-02-18 10:00:00', '2025-02-18 12:00:00', '1 day', '15 minutes'),
(1, 3, 3, 'Morning workout', 'Cardio and weights session', TRUE, FALSE, '2025-02-18 06:00:00', '2025-02-18 07:00:00', '1 day', '10 minutes'),
(2, 4, 2, 'Job interview', 'Online interview with XYZ Corp', FALSE, FALSE, '2025-02-20 14:00:00', '2025-02-20 15:00:00', NULL, '30 minutes');
