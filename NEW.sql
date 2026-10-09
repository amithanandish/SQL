CREATE DATABASE student;
USE student;
CREATE TABLE details
(
  student_id INT,
  name VARCHAR(50),
  age INT,
  city VARCHAR(30),
  marks INT
);
INSERT INTO details(student_id,name,age,city,marks)
VALUES
(001,'Alice',20,'Hyderabad',90),
(002,'Bob',22,'Chennai',75),
(003,'Charlie',21,'Delhi',85);
SELECT *FROM details;