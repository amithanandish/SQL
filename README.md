CREATE DATABASE KJU;
USE KJU;
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
(001,'ARPITHA',20,'Hyderabad',90),
(002,'AMITHA',22,'Chennai',75),
(003,'ANVITHA',22,'Bengaluru',75),
(004,'KAVITHA',22,'Chennai',85),
(005,'KUSUMA',22,'Bengaluru',75),
(006,'HITHA',16,'Chennai',85),
(007,'POORNA',22,'Chennai',75),
(008,'NANDISH',22,'Bengaluru',95),
(009,'MAMITHA',18,'Chennai',65),
(0010,'PAVAN',21,'Delhi',85);
SELECT *FROM students;
SELECT name, marks FROM students;
SELECT *FROM students WHERE age = 20;
SELECT *FROM students WHERE marks > 80;
