CREATE DATABASE BUSINESS;
USE BUSINESS;
CREATE TABLE Customer
(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(30)
);
CREATE TABLE Product
(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(30),
    price DECIMAL(10,2),
    quantity INT
);

SHOW DATABASES;
SHOW TABLES;
DESC Customer;
DESC Product;

ALTER TABLE Customer
ADD address VARCHAR(100);

DESC Customer;

ALTER TABLE Customer
MODIFY phone VARCHAR(20);
DESC Customer;

ALTER TABLE Customer
RENAME COLUMN city TO customer_city;

DESC Customer;

ALTER TABLE Customer
DROP COLUMN address;

DESC Customer;

INSERT INTO Customer
(customer_name, email, phone, customer_city)
VALUES
('Alice', 'alice@gmail.com', '9876543210', 'Bangalore'),
('Bob', 'bob@gmail.com', '9876543211', 'Chennai'),
('Charlie', 'charlie@gmail.com', '9876543212', 'Hyderabad'),
('David', 'david@gmail.com', '9876543213', 'Delhi'),
('Emma', 'emma@gmail.com', '9876543214', 'Mumbai');

SELECT * FROM Customer;

INSERT INTO Product
(product_name, category, price, quantity)
VALUES
('Laptop', 'Electronics', 55000.00, 10),
('Mouse', 'Electronics', 800.00, 25),
('Keyboard', 'Electronics', 1500.00, 20),
('Office Chair', 'Furniture', 7500.00, 15),
('Desk', 'Furniture', 12000.00, 8);

SELECT * FROM Product;

UPDATE Customer
SET phone = '9999999999'
WHERE customer_id = 1;

SELECT * FROM Customer;

UPDATE Product
SET price = 57000.00
WHERE product_id = 1;

SELECT * FROM Product;

UPDATE Product
SET price = 900.00,
    quantity = 30
WHERE product_id = 2;

SELECT * FROM Product;

DELETE FROM Customer
WHERE customer_id = 5;

SELECT * FROM Customer;

DELETE FROM Product
WHERE product_id = 5;

SELECT * FROM Product;

SELECT * FROM Customer;
SELECT * FROM Product;

TRUNCATE TABLE Customer;
TRUNCATE TABLE Product;

DROP TABLE Product;
DROP TABLE Customer;

DROP DATABASE BUSINESS;
