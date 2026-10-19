-- 1. Create Database
CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- 2. Drop old tables if exists to avoid errors
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

-- 3. Create students table with Constraints
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INT CHECK (age >= 16),
    department VARCHAR(50) NOT NULL
);

-- 4. Create courses table with Constraints
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) UNIQUE NOT NULL,
    credits INT NOT NULL CHECK (credits > 0 AND credits <= 6),
    instructor VARCHAR(100) NOT NULL
);

-- 5. Create enrollments table with Relationships
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2) CHECK (grade IN ('A', 'B', 'C', 'D', 'F', 'A+')),
    -- Relationship 1: student_id refers to students table
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    -- Relationship 2: course_id refers to courses table
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    -- Constraint: A student cannot enroll in same course twice
    UNIQUE (student_id, course_id)
);

-- 1. Insert Students (5 Students)
INSERT INTO students (name, email, age, department) VALUES
('Ravi Kumar', 'ravi.cse@gmail.com', 20, 'CSE'),
('Anjali Reddy', 'anjali.ece@gmail.com', 19, 'ECE'),
('Vikram Singh', 'vikram.cse@gmail.com', 21, 'CSE'),
('Sneha Patel', 'sneha.mech@gmail.com', 20, 'MECH'),
('Arjun Das', 'arjun.ece@gmail.com', 22, 'ECE');

-- 2. Insert Courses (4 Courses)
INSERT INTO courses (course_name, credits, instructor) VALUES
('Database Management System', 4, 'Dr. Sharma'),
('Operating Systems', 3, 'Dr. Verma'),
('Computer Networks', 4, 'Dr. Rao'),
('Digital Electronics', 3, 'Dr. Gupta');

-- 3. Insert Enrollments (Linking Students and Courses)
-- Ravi (1) enrolls in DBMS (1) and OS (2)
-- Anjali (2) enrolls in Networks (3) and Digital (4)
-- Vikram (3) enrolls in DBMS (1), OS (2), Networks (3)

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-01-10', 'A'),
(1, 2, '2024-01-11', 'B'),
(2, 3, '2024-01-12', 'A+'),
(2, 4, '2024-01-10', 'A'),
(3, 1, '2024-01-15', 'B'),
(3, 2, '2024-01-15', 'C'),
(3, 3, '2024-01-16', 'A'),
(4, 1, '2024-01-20', 'A'),
(5, 4, '2024-01-18', 'B');

-- Verify data inserted
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;

-- ================== READ / SELECT OPERATIONS ==================

-- 1. Get all CSE students
SELECT * FROM students WHERE department = 'CSE';

-- 2. Get students ordered by age (Youngest first)
SELECT * FROM students ORDER BY age ASC;

-- 3. Search student by name pattern (names starting with 'R')
SELECT * FROM students WHERE name LIKE 'R%';

-- 4. Get all courses with more than 3 credits
SELECT * FROM courses WHERE credits > 3;

-- ================== UPDATE OPERATIONS ==================

-- 5. Update: Ravi's department changed from CSE to ECE (for example)
UPDATE students SET department = 'ECE' WHERE student_id = 1;

-- Verify update
SELECT * FROM students WHERE student_id = 1;

-- 6. Update: Change grade of a student in enrollment
-- Vikram (student 3) improved his grade in OS (course 2) from C to B
UPDATE enrollments SET grade = 'B' WHERE student_id = 3 AND course_id = 2;

-- Verify
SELECT * FROM enrollments WHERE student_id = 3;

set SQL_SAFE_UPDATES=0;
-- 7. Update: Increase credits for all courses by Dr. Sharma
UPDATE courses SET credits = 5 WHERE instructor = 'Dr. Sharma';
set SQL_SAFE_UPDATES=1;
SELECT * FROM courses;

-- ================== DELETE OPERATIONS ==================

-- 8. Delete a specific enrollment (Sneha - student 4 - unenrolls from DBMS)
DELETE FROM enrollments WHERE student_id = 4 AND course_id = 1;

-- Check enrollments now has 8 rows (one less)
SELECT * FROM enrollments;

-- 9. DEMO of ON DELETE CASCADE (Do not execute if you want to keep all data)
-- If we delete student 5, his enrollment will be auto-deleted
-- DELETE FROM students WHERE student_id = 5;
-- After this, check: SELECT * FROM enrollments WHERE student_id = 5; -- will be empty

-- ================== INNER JOIN ==================
-- Use: To get only matched data. Get list of students who ARE enrolled.

-- 1. Get Student Name with their Enrolled Course Name and Grade
SELECT s.name, s.department, c.course_name, e.grade, e.enrollment_date
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- 2. Get students enrolled in 'Database Management System'
SELECT s.name, s.email, c.course_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Management System';

-- ================== LEFT JOIN ==================
-- Use: To get ALL students, even if they are NOT enrolled in any course.

-- 3. Show all students and their courses (including students with no course)
SELECT s.name, c.course_name, e.grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;
-- Sneha will show NULL if you deleted her enrollment in Step 3, that's LEFT JOIN power

-- ================== RIGHT JOIN ==================
-- Use: To get ALL courses, even if no student enrolled in them.

-- 4. Show all courses and enrolled students (including courses with no students)
SELECT c.course_name, s.name, e.grade
FROM students s
RIGHT JOIN enrollments e ON s.student_id = e.student_id
RIGHT JOIN courses c ON e.course_id = c.course_id;

-- ================== Advanced JOIN with Aggregation ==================
-- 5. How many students are enrolled in each course?
SELECT c.course_name, COUNT(e.student_id) AS total_enrolled
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- ================== AGGREGATE FUNCTIONS ==================

-- 1. COUNT - How many total students?
SELECT COUNT(*) AS total_students FROM students;

-- 2. COUNT with GROUP BY - How many students in each department?
SELECT department, COUNT(*) AS students_count
FROM students
GROUP BY department;

-- 3. COUNT - How many students enrolled in each course?
SELECT c.course_name, COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 4. AVG - Average age of students
SELECT AVG(age) AS average_age FROM students;

-- 5. MAX / MIN - Youngest and Oldest student age
SELECT MAX(age) AS max_age, MIN(age) AS min_age FROM students;

-- 6. SUM - Total credits offered (sum of all course credits)
SELECT SUM(credits) AS total_credits FROM courses;

-- 7. GROUP BY with HAVING - Departments having more than 1 student
-- (HAVING is used after GROUP BY, WHERE cannot be used with aggregate)
SELECT department, COUNT(*) AS count
FROM students
GROUP BY department
HAVING COUNT(*) > 1;

-- 8. Complex Report: For each student, how many courses they enrolled in?
SELECT s.name, s.department, COUNT(e.course_id) AS courses_enrolled
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name, s.department;

-- ================== SUBQUERIES ==================

-- 1. Find students who are older than average age
-- Step: First find average age, then compare
SELECT name, age FROM students
WHERE age > (SELECT AVG(age) FROM students);

-- 2. Find courses where no student is enrolled
-- (Using NOT IN subquery)
SELECT course_name FROM courses
WHERE course_id NOT IN (SELECT course_id FROM enrollments);

-- 3. Find students who are enrolled in 'Database Management System'
-- (Without JOIN, using subquery)
SELECT name FROM students
WHERE student_id IN (
    SELECT student_id FROM enrollments
    WHERE course_id = (SELECT course_id FROM courses WHERE course_name = 'Database Management System'));

-- 4. Find student(s) with maximum age (using subquery with MAX)
SELECT name, age FROM students
WHERE age = (SELECT MAX(age) FROM students);

-- 5. Get courses with enrollment count greater than average enrollment count
-- Advanced: Subquery in FROM clause
SELECT course_name FROM courses
WHERE course_id IN (
    SELECT course_id FROM enrollments
    GROUP BY course_id
    HAVING COUNT(*) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM enrollments GROUP BY course_id) AS avg_table));

-- Find students enrolled in any course taught by 'Dr. Sharma'
SELECT name FROM students WHERE student_id IN (
    SELECT student_id FROM enrollments WHERE course_id IN (
        SELECT course_id FROM courses WHERE instructor = 'Dr. Sharma'));

-- 6. EXISTS - Find students who have at least one enrollment
SELECT name FROM students s
WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id);

-- ================== VIEWS ==================

-- 1. Simple View: Show only CSE/ECE students basic info (For security purpose)
CREATE OR REPLACE VIEW vw_cse_students AS
SELECT student_id, name, department FROM students
WHERE department = 'CSE';

-- Use the view
SELECT * FROM vw_cse_students;

-- 2. Complex View (MOST IMPORTANT FOR YOUR PROJECT): Enrollment Details
-- This view combines all 3 tables. You will use this view in your final viva.
CREATE OR REPLACE VIEW vw_enrollment_details AS
SELECT s.student_id,s.name AS student_name,s.department,
    c.course_id,c.course_name,c.credits,c.instructor,
    e.enrollment_date,e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- Now using view is super simple, no need to write JOIN again
SELECT * FROM vw_enrollment_details;

-- Get only A grade students from view
SELECT student_name, course_name, grade FROM vw_enrollment_details WHERE grade = 'A';

-- Get CSE students with their courses from view
SELECT student_name, course_name FROM vw_enrollment_details WHERE department = 'CSE';

-- 3. Aggregate View: Department-wise student count
CREATE OR REPLACE VIEW vw_department_stats AS
SELECT department, COUNT(*) AS total_students, AVG(age) AS avg_age
FROM students
GROUP BY department;

SELECT * FROM vw_department_stats;

-- 4. View Operations
-- Show all views in your database
SHOW FULL TABLES IN college_db WHERE TABLE_TYPE LIKE 'VIEW';

-- Delete a view (if needed)
-- DROP VIEW vw_cse_students;

-- ================== INDEXES ==================

-- 1. Check existing indexes (Primary keys are auto-indexed)
SHOW INDEX FROM students;
SHOW INDEX FROM enrollments;

-- 2. Create Index on department (because we search WHERE department = 'CSE' a lot)
CREATE INDEX idx_department ON students(department);

-- 3. Create Index on grade (filtering by grade is common)
CREATE INDEX idx_grade ON enrollments(grade);

-- 4. Create Composite Index (Multiple columns together)
-- Useful when you search by name AND department together
CREATE INDEX idx_name_dept ON students(name, department);

-- 5. Unique Index (already exists for email, but example)
 -- CREATE UNIQUE INDEX idx_unique_email ON students(email);

-- 6. Check indexes again - you will see your new indexes
SHOW INDEX FROM students;
SHOW INDEX FROM enrollments;

-- 7. Test Performance (Optional but good for viva)
-- Run EXPLAIN to see if index is used
EXPLAIN SELECT * FROM students WHERE department = 'CSE';
-- Look for 'key' column - it should show idx_department if used

-- 8. Drop Index (if not needed)
-- DROP INDEX idx_grade ON enrollments;

-- ================== TRANSACTION ==================

-- Use: When multiple queries must ALL succeed or ALL fail together

START TRANSACTION;

-- Deduct 1 credit from DBMS
UPDATE courses SET credits = credits - 1 WHERE course_id = 1;

-- Add 1 credit to OS
UPDATE courses SET credits = credits + 1 WHERE course_id = 2;

-- Check
SELECT course_id, course_name, credits FROM courses WHERE course_id IN (1,2);

-- If both are OK, save
COMMIT;

-- If something went wrong, you would do ROLLBACK instead of COMMIT
-- ROLLBACK;

-- ================= ROLLBACK ==================

START TRANSACTION;

-- Use small values that pass CHECK (3 and 4)
UPDATE courses SET credits = 3 WHERE course_id = 1;
UPDATE courses SET credits = 4 WHERE course_id = 2;

-- Check - will show 3, 4
SELECT course_id, course_name, credits FROM courses WHERE course_id IN (1,2);

-- Undo
ROLLBACK;

-- Check again - back to original
SELECT course_id, course_name, credits FROM courses WHERE course_id IN (1,2);

-- ================== SAVEPOINT ==================

START TRANSACTION;

-- Step 1: Change to 3
UPDATE courses SET credits = 3 WHERE course_id = 1;

-- Savepoint
SAVEPOINT sp1;

-- Step 2: Change to 4 (wrong change)
UPDATE courses SET credits = 4 WHERE course_id = 2;

-- Check
SELECT course_id, course_name, credits FROM courses WHERE course_id IN (1,2);

-- Rollback only second change
ROLLBACK TO SAVEPOINT sp1;

-- Check - course 1 = 3 kept, course 2 = old value
SELECT course_id, course_name, credits FROM courses WHERE course_id IN (1,2);

-- Save good change
COMMIT;

SELECT * FROM courses;