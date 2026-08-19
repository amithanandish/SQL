CREATE DATABASE shop;
USE shop;
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
SELECT*FROM Customer;
SELECT*FROM Product;
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
TRUNCATE TABLE Customer;
TRUNCATE TABLE Product;
DESC Customer;
DROP TABLE Product;
DROP TABLE Customer;
DROP DATABASE shop;
