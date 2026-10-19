College Database Management System (MySQL)
A beginner-friendly MySQL project demonstrating database design and common SQL operations using a college database with students, courses, and enrollments.
Project Overview
This project creates a college_db database and uses three related tables:
- students — student details such as name, email, age, and department.
- courses — course name, credits, and instructor.
- enrollments — connects students to courses and stores enrollment dates and grades.
The SQL script includes sample data and examples of querying, updating, and managing the database.
Features
- Database and table creation
- Constraints: primary keys, foreign keys, NOT NULL, UNIQUE, and CHECK
- Sample records for students, courses, and enrollments
- CRUD operations: SELECT, UPDATE, and DELETE
- Safe update mode demonstration with SQL_SAFE_UPDATES
- INNER JOIN, LEFT JOIN, and RIGHT JOIN
- Aggregate functions: COUNT, AVG, MAX, MIN, and SUM
- GROUP BY and HAVING
- Subqueries and EXISTS
- Views for enrollment details and department statistics
- Index creation and query-plan inspection with EXPLAIN
- Transactions using COMMIT, ROLLBACK, and SAVEPOINT
- ON DELETE CASCADE relationship demonstration
Database Schema
students
Column	Description
student_id	Auto-incrementing primary key
name	Student name; required
email	Required and unique email
age	Student age; check constraint requires age to be at least 16
department	Student department; required


courses
Column	Description
course_id	Auto-incrementing primary key
course_name	Required and unique course name
credits	Required; check constraint allows values from 1 to 6
instructor	Instructor name; required


enrollments
Column	Description
enrollment_id	Auto-incrementing primary key
student_id	Foreign key referencing students.student_id
course_id	Foreign key referencing courses.course_id
enrollment_date	Required enrollment date
grade	Grade constrained to A, B, C, D, F, or A+


The enrollments table also has a unique constraint on (student_id, course_id), preventing the same student from enrolling in the same course more than once. Its foreign keys use ON DELETE CASCADE.
Requirements
- MySQL 8.0 or another MySQL version that supports the SQL features used in the script
- A MySQL client, such as MySQL Workbench or the MySQL command-line client
Note: CHECK constraint enforcement depends on the MySQL version. Use a version that enforces the checks for the intended behavior.
