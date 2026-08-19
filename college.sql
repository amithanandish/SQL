CREATE DATABASE college;
USE college;
CREATE TABLE students
(
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age INT,
  city VARCHAR(30),
  marks INT
);
INSERT INTO students(student_id,name,age,city,marks)
VALUES
(001,'Alice',20,'Hyderabad',90),
(002,'Bob',22,'Chennai',75),
(003,'Charlie',21,'Delhi',85);
SELECT *FROM students;
SELECT name, marks FROM students;
SELECT *FROM students WHERE age = 20;
SELECT *FROM students WHERE marks > 80;
UPDATE students SET marks = 95 WHERE student_id = 1;

DELETE FROM students WHERE student_id = 2;

SELECT * FROM students ORDER BY marks;

SELECT * FROM students ORDER BY marks DESC;

SELECT * FROM students LIMIT 3;

SELECT * FROM students ORDER BY marks DESC LIMIT 5;

SELECT * FROM students WHERE city='Delhi' AND marks>70;

SELECT * FROM students WHERE city='Delhi' OR city='Mumbai';

SELECT * FROM students WHERE city IN ('Delhi','Mumbai','Chennai');

SELECT * FROM students WHERE marks BETWEEN 70 AND 90;