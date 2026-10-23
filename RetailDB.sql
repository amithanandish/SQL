-- A1. Create Database

CREATE DATABASE RetailDB;
USE RetailDB;

-- A2. Create tables (data types + PRIMARY KEY, NOT NULL, DEFAULT, UNIQUE, FOREIGN KEY)

CREATE TABLE categories (
    category_id    INT           AUTO_INCREMENT PRIMARY KEY,
    category_name  VARCHAR(50)   NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id     INT            AUTO_INCREMENT PRIMARY KEY,
    product_name   VARCHAR(100)   NOT NULL,
    category_id    INT            NOT NULL,
    unit_price     DECIMAL(10,2)  NOT NULL,
    stock_qty      INT            NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id    INT            AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(80)    NOT NULL,
    email          VARCHAR(100)   UNIQUE,
    city           VARCHAR(50)    DEFAULT 'Bengaluru',
    joined_date    DATE           DEFAULT (CURRENT_DATE)
);

CREATE TABLE orders (
    order_id       INT            AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT            NOT NULL,
    order_date     DATE           NOT NULL,
    status         VARCHAR(20)    NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id        INT            AUTO_INCREMENT PRIMARY KEY,
    order_id       INT            NOT NULL,
    product_id     INT            NOT NULL,
    quantity       INT            NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- A3. ALTER : add, modify, rename and remove columns
ALTER TABLE customers ADD COLUMN phone VARCHAR(15);                 -- add a column
ALTER TABLE customers ADD COLUMN loyalty_points INT DEFAULT 0;      -- add with default
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20);              -- change data type/size
ALTER TABLE customers RENAME COLUMN phone TO mobile_no;             -- rename column
ALTER TABLE customers DROP COLUMN mobile_no;                        -- remove a column

-- A4. Index (speeds up searches)
CREATE INDEX idx_products_name ON products(product_name);

-- A5. TRUNCATE vs DROP (practice on a throw-away table)
CREATE TABLE feedback_temp (
    fb_id     INT AUTO_INCREMENT PRIMARY KEY,
    comments  VARCHAR(200) NOT NULL
);
INSERT INTO feedback_temp (comments) VALUES ('Good service'), ('Fresh vegetables'), ('Long queue');

TRUNCATE TABLE feedback_temp;     -- removes ALL rows, keeps the table structure
DROP TABLE feedback_temp;         -- removes the table itself

DESCRIBE customers;               -- view the final structure
SHOW TABLES;


/* #####################################################################
   PART B : DML - DATA MANIPULATION LANGUAGE   (Unit 2)
   Commands: INSERT, UPDATE, DELETE
   ##################################################################### */

-- B1. INSERT : load the master data
INSERT INTO categories (category_name) VALUES
('Groceries'), ('Personal Care'), ('Beverages'), ('Household');

INSERT INTO products (product_name, category_id, unit_price, stock_qty) VALUES
('Basmati Rice 5kg',      1, 520.00,  80),
('Toor Dal 1kg',          1, 165.00, 120),
('Sunflower Oil 1L',      1, 145.00,  60),
('Green Tea Box',         3, 240.00,  45),
('Filter Coffee 500g',    3, 310.00,  50),
('Fruit Juice 1L',        3, 110.00,  90),
('Herbal Shampoo',        2, 199.00,  70),
('Bath Soap Pack',        2, 120.00, 100),
('Dish Wash Liquid',      4,  99.00,  85),
('Floor Cleaner 1L',      4, 175.00,  40);

INSERT INTO customers (full_name, email, city, joined_date) VALUES
('Aarav Sharma',   'aarav@example.com',  'Bengaluru', '2026-01-10'),
('Diya Nair',      'diya@example.com',   'Kochi',     '2026-02-14'),
('Rohan Gupta',    'rohan@example.com',  'Delhi',     '2026-03-03'),
('Meera Iyer',     'meera@example.com',  'Chennai',   '2026-03-21'),
('Kabir Singh',    'kabir@example.com',  'Mumbai',    '2026-04-09'),
('Ananya Reddy',   'ananya@example.com', 'Hyderabad', '2026-05-18'),
('Vikram Patil',   'vikram@example.com', 'Pune',      '2026-06-02'),
('Sneha Kulkarni', 'sneha@example.com',  'Bengaluru', '2026-06-25');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-07-05', 'Delivered'),
(2, '2026-07-12', 'Delivered'),
(3, '2026-08-02', 'Delivered'),
(1, '2026-08-10', 'Delivered'),
(4, '2026-08-15', 'Cancelled'),
(5, '2026-08-21', 'Delivered'),
(2, '2026-09-01', 'Delivered'),
(6, '2026-09-08', 'Pending'),
(3, '2026-09-15', 'Delivered'),
(7, '2026-09-22', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2), (1, 3, 1),
(2, 5, 2), (2, 4, 1),
(3, 2, 3), (3, 9, 2),
(4, 7, 1), (4, 8, 3),
(5, 1, 1), (5, 6, 4),
(6, 10, 2), (6, 9, 1),
(7, 2, 2), (7, 3, 2),
(8, 4, 2), (8, 5, 1),
(9, 8, 2), (9, 7, 2),
(10, 6, 6), (10, 1, 1);

-- B2. INSERT using DEFAULT values (city and joined_date are skipped on purpose)
INSERT INTO customers (full_name, email) VALUES ('Imran Khan', 'imran@example.com');
SELECT * FROM customers WHERE full_name = 'Imran Khan';   -- city = Bengaluru, date = today

-- B3. INSERT ... SELECT (copy data from one table into another)
CREATE TABLE bengaluru_customers AS SELECT * FROM customers WHERE 1 = 0;   -- empty copy of structure
INSERT INTO bengaluru_customers SELECT * FROM customers WHERE city = 'Bengaluru';

-- B4. UPDATE with SAFE UPDATES ON
--     In MySQL Workbench, safe mode blocks UPDATE/DELETE that do not use a KEY column in WHERE.
SET SQL_SAFE_UPDATES = 1;

UPDATE products SET unit_price = 550.00 WHERE product_id = 1;             -- allowed (primary key)
-- UPDATE products SET unit_price = unit_price * 1.05;                    -- BLOCKED: no WHERE (try it!)

-- B5. Real-world scenario 1 : festive price revision (+5% on Groceries)
--     Temporarily switch safe mode off, run the bulk update, switch it back on.
SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET    unit_price = ROUND(unit_price * 1.05, 2)
WHERE  category_id = 1;
SET SQL_SAFE_UPDATES = 1;

-- B6. Real-world scenario 2 : customer places a new order and stock is reduced
INSERT INTO products (product_name, category_id, unit_price, stock_qty)
VALUES ('Peanut Butter 500g', 1, 260.00, 30);                             -- new product = id 11

INSERT INTO orders (customer_id, order_date, status) VALUES (1, '2026-09-25', 'Pending');
SET @new_order = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(@new_order, 2, 2),
(@new_order, 11, 1);

UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 2;
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 11;

-- B7. Real-world scenario 3 : order delivered, reward loyalty points
UPDATE orders    SET status = 'Delivered' WHERE order_id = @new_order;
UPDATE customers SET loyalty_points = loyalty_points + 50 WHERE customer_id = 1;

-- B8. DELETE : remove wrongly entered / cancelled data
--     Child rows must be deleted first because of the FOREIGN KEY.
DELETE FROM customers WHERE full_name = 'Imran Khan' AND customer_id = 9;  -- entry mistake

DELETE FROM order_items WHERE order_id = 5;    -- items of the cancelled order
DELETE FROM orders      WHERE order_id = 5;    -- now the order itself

DROP TABLE bengaluru_customers;                -- clean up practice table


/* #####################################################################
   PART C : DQL - DATA QUERY LANGUAGE   (Unit 1)
   Command: SELECT
   ##################################################################### */

-- C1. Basic retrieval
SELECT * FROM products;
SELECT product_name, unit_price FROM products;

-- C2. Filtering with WHERE, BETWEEN, IN, LIKE
SELECT product_name, unit_price FROM products WHERE unit_price > 200;
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 100 AND 200;
SELECT full_name, city FROM customers WHERE city IN ('Bengaluru', 'Delhi');
SELECT full_name FROM customers WHERE full_name LIKE 'A%';

-- C3. Sorting and limiting
SELECT product_name, unit_price FROM products ORDER BY unit_price DESC LIMIT 5;

-- C4. Aliases and calculated columns (stock value)
SELECT product_name,
       unit_price * stock_qty AS stock_value
FROM   products
ORDER  BY stock_value DESC;

-- C5. INNER JOIN : product with its category
SELECT p.product_name, c.category_name, p.unit_price
FROM   products p
JOIN   categories c ON c.category_id = p.category_id;

-- C6. Multi-table JOIN : full order details with line amount
SELECT o.order_id, o.order_date, cu.full_name, p.product_name,
       oi.quantity, p.unit_price,
       oi.quantity * p.unit_price AS line_amount
FROM   orders o
JOIN   customers   cu ON cu.customer_id = o.customer_id
JOIN   order_items oi ON oi.order_id    = o.order_id
JOIN   products    p  ON p.product_id   = oi.product_id
ORDER  BY o.order_id;

-- C7. LEFT JOIN : customers who have never placed an order
SELECT cu.customer_id, cu.full_name
FROM   customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id
WHERE  o.order_id IS NULL;

-- C8. Subquery : products priced above the average price
SELECT product_name, unit_price
FROM   products
WHERE  unit_price > (SELECT AVG(unit_price) FROM products);


/* #####################################################################
   PART D : AGGREGATION & GROUPING   (Unit 4)
   COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, GROUP BY + JOIN
   ##################################################################### */

-- D1. Aggregate functions on the whole table
SELECT COUNT(*)                    AS total_products,
       SUM(stock_qty)              AS total_units_in_stock,
       ROUND(AVG(unit_price), 2)   AS average_price,
       MIN(unit_price)             AS cheapest,
       MAX(unit_price)             AS costliest
FROM   products;

-- D2. GROUP BY : number of customers per city
SELECT city, COUNT(*) AS customer_count
FROM   customers
GROUP  BY city
ORDER  BY customer_count DESC;

-- D3. GROUP BY : orders by status
SELECT status, COUNT(*) AS order_count
FROM   orders
GROUP  BY status;

-- D4. GROUP BY with JOIN : product count and average price per category
SELECT c.category_name,
       COUNT(p.product_id)         AS products,
       ROUND(AVG(p.unit_price), 2) AS avg_price,
       MIN(p.unit_price)           AS min_price,
       MAX(p.unit_price)           AS max_price
FROM   categories c
JOIN   products   p ON p.category_id = c.category_id
GROUP  BY c.category_name;

-- D5. REPORT 1 : Revenue by category (delivered orders only)
SELECT c.category_name,
       SUM(oi.quantity)                    AS units_sold,
       SUM(oi.quantity * p.unit_price)     AS revenue
FROM   order_items oi
JOIN   orders     o ON o.order_id     = oi.order_id
JOIN   products   p ON p.product_id   = oi.product_id
JOIN   categories c ON c.category_id  = p.category_id
WHERE  o.status = 'Delivered'
GROUP  BY c.category_name
ORDER  BY revenue DESC;

-- D6. REPORT 2 : Customer-wise orders and spending
SELECT cu.full_name,
       COUNT(DISTINCT o.order_id)          AS orders_placed,
       SUM(oi.quantity * p.unit_price)     AS total_spent
FROM   customers cu
JOIN   orders      o  ON o.customer_id = cu.customer_id
JOIN   order_items oi ON oi.order_id   = o.order_id
JOIN   products    p  ON p.product_id  = oi.product_id
GROUP  BY cu.full_name
ORDER  BY total_spent DESC;

-- D7. HAVING : filter groups (customers who spent more than Rs. 1000)
SELECT cu.full_name,
       SUM(oi.quantity * p.unit_price) AS total_spent
FROM   customers cu
JOIN   orders      o  ON o.customer_id = cu.customer_id
JOIN   order_items oi ON oi.order_id   = o.order_id
JOIN   products    p  ON p.product_id  = oi.product_id
GROUP  BY cu.full_name
HAVING SUM(oi.quantity * p.unit_price) > 1000
ORDER  BY total_spent DESC;

-- D8. WHERE vs HAVING together : delivered orders only, cities with 2+ orders
SELECT cu.city, COUNT(o.order_id) AS delivered_orders
FROM   customers cu
JOIN   orders o ON o.customer_id = cu.customer_id
WHERE  o.status = 'Delivered'             -- filters rows BEFORE grouping
GROUP  BY cu.city
HAVING COUNT(o.order_id) >= 2;            -- filters groups AFTER grouping

-- D9. REPORT 3 : Monthly sales trend
SELECT DATE_FORMAT(o.order_date, '%Y-%m')  AS sales_month,
       COUNT(DISTINCT o.order_id)          AS orders,
       SUM(oi.quantity * p.unit_price)     AS sales_amount
FROM   orders o
JOIN   order_items oi ON oi.order_id  = o.order_id
JOIN   products    p  ON p.product_id = oi.product_id
WHERE  o.status <> 'Cancelled'
GROUP  BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER  BY sales_month;

-- D10. REPORT 4 : Best-selling products (top 5 by units)
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM   order_items oi
JOIN   products p ON p.product_id = oi.product_id
GROUP  BY p.product_name
ORDER  BY units_sold DESC
LIMIT  5;


/* #####################################################################
   PART E : DCL - DATA CONTROL LANGUAGE   (Unit 1)
   Commands: GRANT, REVOKE      (run as root / admin user)
   ##################################################################### */

-- E1. Create users
CREATE USER 'sales_clerk'@'localhost' IDENTIFIED BY 'Clerk@123';
CREATE USER 'store_manager'@'localhost' IDENTIFIED BY 'Manager@123';

-- E2. GRANT permissions
GRANT SELECT, INSERT ON RetailDB.orders      TO 'sales_clerk'@'localhost';
GRANT SELECT, INSERT ON RetailDB.order_items TO 'sales_clerk'@'localhost';
GRANT SELECT         ON RetailDB.products    TO 'sales_clerk'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON RetailDB.* TO 'store_manager'@'localhost';

SHOW GRANTS FOR 'sales_clerk'@'localhost';

-- E3. REVOKE permissions
REVOKE INSERT ON RetailDB.order_items FROM 'sales_clerk'@'localhost';
REVOKE DELETE ON RetailDB.*           FROM 'store_manager'@'localhost';

SHOW GRANTS FOR 'sales_clerk'@'localhost';
SHOW GRANTS FOR 'store_manager'@'localhost';

-- E4. Clean up users
DROP USER 'sales_clerk'@'localhost';
DROP USER 'store_manager'@'localhost';


/* #####################################################################
   PART F : TCL - TRANSACTION CONTROL LANGUAGE   (Unit 1)
   Commands: COMMIT, ROLLBACK, SAVEPOINT
   Note: DDL statements (CREATE, ALTER, DROP, TRUNCATE) auto-commit in MySQL.
   ##################################################################### */

-- F1. COMMIT : save changes permanently
SET autocommit = 0;                           -- take manual control (or use START TRANSACTION)

START TRANSACTION;
UPDATE products SET stock_qty = stock_qty + 50 WHERE product_id = 4;   -- new stock arrives
COMMIT;                                       -- change is now permanent

-- F2. ROLLBACK : discard changes
START TRANSACTION;
UPDATE products SET unit_price = 1.00 WHERE product_id = 1;            -- wrong price by mistake!
SELECT product_id, product_name, unit_price FROM products WHERE product_id = 1;
ROLLBACK;                                     -- undo everything since START TRANSACTION
SELECT product_id, product_name, unit_price FROM products WHERE product_id = 1;   -- restored

-- F3. SAVEPOINT : partial rollback inside one transaction
START TRANSACTION;

UPDATE customers SET loyalty_points = loyalty_points + 20 WHERE customer_id = 2;
SAVEPOINT after_points;

UPDATE customers SET city = 'Unknown' WHERE customer_id = 2;           -- mistake
SAVEPOINT after_city;

ROLLBACK TO SAVEPOINT after_points;           -- undo only the city change
COMMIT;                                       -- loyalty points stay, city is unchanged

SELECT customer_id, full_name, city, loyalty_points FROM customers WHERE customer_id = 2;

-- F4. Real-world scenario : all-or-nothing order placement
START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status) VALUES (3, '2026-09-29', 'Pending');
SET @o = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity) VALUES (@o, 5, 2);
UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 5;

-- If every step worked -> COMMIT;   If anything failed -> ROLLBACK;
COMMIT;

SET autocommit = 1;                           -- restore default behaviour
