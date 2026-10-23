/* =====================================================================
   COMPLETE E-COMMERCE DATABASE PROGRAM  (MySQL 8 / MariaDB 10.5+)
   PART 1  DDL  - CREATE, ALTER, INDEX, RENAME, TRUNCATE, DROP
   PART 2  DML  - INSERT, UPDATE, DELETE, TRANSACTIONS
   PART 3  FILTERING
   PART 4  AGGREGATE FUNCTIONS
   PART 5  GROUPING (GROUP BY / HAVING)
   PART 6  JOINS
   PART 7  BUSINESS REPORT (view + final summary)
   ===================================================================== */

/* #####################################################################
   PART 1 : DDL (Data Definition Language)
   ##################################################################### */

-- 1.1 CREATE DATABASE
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- 1.2 CREATE TABLES with PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, DEFAULT
CREATE TABLE customers (
    customer_id  INT           PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100)  NOT NULL,
    email        VARCHAR(120)  NOT NULL UNIQUE,
    city         VARCHAR(60),
    state        VARCHAR(60),
    signup_date  DATE          NOT NULL
);

CREATE TABLE categories (
    category_id   INT          PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(60)  NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id    INT           PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(120)  NOT NULL,
    category_id   INT           NOT NULL,
    price         DECIMAL(10,2) NOT NULL CHECK (price > 0),
    cost          DECIMAL(10,2) NOT NULL CHECK (cost > 0),
    stock_qty     INT           NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    CONSTRAINT fk_prod_cat FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id     INT         PRIMARY KEY AUTO_INCREMENT,
    customer_id  INT         NOT NULL,
    order_date   DATE        NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'Placed',
    CONSTRAINT fk_ord_cust FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT           PRIMARY KEY AUTO_INCREMENT,
    order_id      INT           NOT NULL,
    product_id    INT           NOT NULL,
    quantity      INT           NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL,
    discount_pct  DECIMAL(5,2)  NOT NULL DEFAULT 0,
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT           PRIMARY KEY AUTO_INCREMENT,
    order_id   INT           NOT NULL,
    method     VARCHAR(20)   NOT NULL,
    amount     DECIMAL(12,2) NOT NULL,
    paid_on    DATE,
    CONSTRAINT fk_pay_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 1.3 ALTER TABLE: add, modify and drop columns / constraints
ALTER TABLE customers ADD COLUMN phone VARCHAR(15);
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) DEFAULT 'NA';
ALTER TABLE payments  ADD COLUMN pay_status VARCHAR(15) NOT NULL DEFAULT 'Paid';
ALTER TABLE products  ADD COLUMN is_active TINYINT NOT NULL DEFAULT 1;
ALTER TABLE products  DROP COLUMN is_active;

-- 1.4 CREATE INDEX to speed up common lookups
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date     ON orders(order_date);
CREATE INDEX idx_items_product   ON order_items(product_id);

-- 1.5 Temporary practice table: CREATE, RENAME, TRUNCATE, DROP
CREATE TABLE temp_coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    code      VARCHAR(20) NOT NULL,
    discount  DECIMAL(5,2)
);
INSERT INTO temp_coupons (code, discount) VALUES ('WELCOME10', 10), ('FEST20', 20);
RENAME TABLE temp_coupons TO coupons;
TRUNCATE TABLE coupons;          -- removes all rows, keeps structure
DROP TABLE coupons;              -- removes the table completely

-- 1.6 Verify structure
SHOW TABLES;
DESCRIBE customers;
DESCRIBE products;
DESCRIBE payments;

/* #####################################################################
   PART 2 : DML (Data Manipulation Language)
   ##################################################################### */

-- 2.1 INSERT (multi-row)
INSERT INTO customers (full_name, email, city, state, signup_date, phone) VALUES
('Asha Rao',     'asha@mail.com',   'Bengaluru', 'Karnataka',   '2024-01-15', '9800000001'),
('Vikram Singh', 'vikram@mail.com', 'Delhi',     'Delhi',       '2024-02-20', '9800000002'),
('Meera Nair',   'meera@mail.com',  'Kochi',     'Kerala',      '2024-03-05', '9800000003'),
('Rohit Sharma', 'rohit@mail.com',  'Mumbai',    'Maharashtra', '2024-04-11', '9800000004'),
('Sana Khan',    'sana@mail.com',   'Hyderabad', 'Telangana',   '2024-05-23', '9800000005'),
('Arjun Patel',  'arjun@mail.com',  'Ahmedabad', 'Gujarat',     '2024-06-30', '9800000006'),
('Divya Menon',  'divya@mail.com',  'Bengaluru', 'Karnataka',   '2025-01-10', '9800000007'),
('Karan Mehta',  'karan@mail.com',  'Mumbai',    'Maharashtra', '2025-02-14', '9800000008'),
('Neha Verma',   'neha@mail.com',   'Delhi',     'Delhi',       '2025-03-18', '9800000009'),
('Imran Ali',    'imran@mail.com',  'Chennai',   'Tamil Nadu',  '2025-04-01', '9800000010');

INSERT INTO categories (category_name) VALUES
('Electronics'), ('Fashion'), ('Home & Kitchen'), ('Books'), ('Sports');

INSERT INTO products (product_name, category_id, price, cost, stock_qty) VALUES
('Wireless Earbuds',  1,  2999.00,  1800.00, 120),
('Smartphone X1',     1, 24999.00, 19000.00,  40),
('Laptop Pro 14',     1, 64999.00, 52000.00,  15),
('Cotton T-Shirt',    2,   599.00,   250.00, 300),
('Denim Jeans',       2,  1799.00,   900.00, 150),
('Air Fryer',         3,  5499.00,  3600.00,  60),
('Mixer Grinder',     3,  3299.00,  2100.00,  80),
('SQL Mastery Book',  4,   699.00,   320.00, 200),
('Yoga Mat',          5,   999.00,   450.00, 110),
('Cricket Bat',       5,  3499.00,  2000.00,  25),
('Unsold Gadget',     1,  1499.00,   900.00,  10);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1,'2025-01-12','Delivered'), (2,'2025-01-25','Delivered'),
(3,'2025-02-03','Delivered'), (1,'2025-02-18','Delivered'),
(4,'2025-03-07','Returned'),  (5,'2025-03-21','Delivered'),
(6,'2025-04-02','Cancelled'), (7,'2025-04-15','Delivered'),
(2,'2025-05-09','Delivered'), (8,'2025-05-27','Shipped'),
(9,'2025-06-14','Delivered'), (1,'2025-06-30','Delivered'),
(3,'2025-07-19','Delivered'), (4,'2025-08-08','Delivered'),
(5,'2025-09-12','Delivered'), (7,'2025-10-01','Shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
(1, 1, 2,  2999.00, 10), (1, 4, 3,   599.00,  0),
(2, 2, 1, 24999.00,  5),
(3, 6, 1,  5499.00,  0), (3, 8, 2,   699.00,  0),
(4, 3, 1, 64999.00,  8),
(5, 5, 2,  1799.00,  0),
(6, 7, 1,  3299.00, 10), (6, 9, 2,   999.00,  0),
(7, 10,1,  3499.00,  0),
(8, 1, 1,  2999.00,  0), (8, 5, 1,  1799.00,  5),
(9, 2, 1, 24999.00, 10),
(10,4, 5,   599.00,  0),
(11,6, 1,  5499.00,  5), (11,8, 3,   699.00,  0),
(12,1, 3,  2999.00, 15),
(13,9, 4,   999.00,  0), (13,10,1,  3499.00, 10),
(14,3, 1, 64999.00,  0),
(15,7, 2,  3299.00,  5),
(16,2, 1, 24999.00,  0);

-- 2.2 INSERT ... SELECT : generate payments from order totals (cancelled orders excluded)
INSERT INTO payments (order_id, method, amount, paid_on)
SELECT o.order_id,
       ELT(1 + MOD(o.order_id, 4), 'Card', 'UPI', 'COD', 'NetBanking'),
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2),
       CASE WHEN o.status = 'Shipped' THEN NULL ELSE o.order_date END
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY o.order_id, o.status, o.order_date;

-- 2.3 UPDATE (simple)
UPDATE products SET price = 2799.00 WHERE product_name = 'Wireless Earbuds';

-- 2.4 UPDATE (with expression): 5% price rise for the Books category
UPDATE products
SET price = ROUND(price * 1.05, 2)
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Books');

-- 2.5 UPDATE with JOIN: reduce stock by units already sold
UPDATE products p
JOIN (SELECT product_id, SUM(quantity) AS sold
      FROM order_items GROUP BY product_id) s ON s.product_id = p.product_id
SET p.stock_qty = p.stock_qty - s.sold;

-- 2.6 UPDATE with JOIN: mark payments of returned orders as Refunded, unpaid as Pending
UPDATE payments pay
JOIN orders o ON o.order_id = pay.order_id
SET pay.pay_status = 'Refunded'
WHERE o.status = 'Returned';

UPDATE payments SET pay_status = 'Pending' WHERE paid_on IS NULL;

-- 2.7 INSERT / DELETE a test customer
INSERT INTO customers (full_name, email, city, state, signup_date)
VALUES ('Test User', 'test@mail.com', 'Pune', 'Maharashtra', '2025-10-10');
DELETE FROM customers WHERE email = 'test@mail.com';

-- 2.8 TRANSACTION: ROLLBACK discards, COMMIT saves
START TRANSACTION;
UPDATE products SET stock_qty = 0;               -- accidental mass update
SELECT COUNT(*) AS products_with_zero_stock FROM products WHERE stock_qty = 0;
ROLLBACK;                                        -- undo it
SELECT COUNT(*) AS products_with_zero_stock_after_rollback FROM products WHERE stock_qty = 0;

START TRANSACTION;
UPDATE products SET stock_qty = stock_qty + 50 WHERE product_name = 'Laptop Pro 14';
COMMIT;                                          -- restock saved permanently

-- 2.9 Verify DML results
SELECT product_id, product_name, price, stock_qty FROM products;
SELECT * FROM payments;

/* #####################################################################
   PART 3 : FILTERING
   ##################################################################### */

-- 3.1 IN : customers in Bengaluru or Mumbai
SELECT customer_id, full_name, city FROM customers WHERE city IN ('Bengaluru', 'Mumbai');

-- 3.2 BETWEEN + ORDER BY : mid-priced products
SELECT product_name, price FROM products WHERE price BETWEEN 1000 AND 10000 ORDER BY price;

-- 3.3 LIKE : product names containing 'Pro' or starting with 'Air'
SELECT product_name, price FROM products WHERE product_name LIKE '%Pro%' OR product_name LIKE 'Air%';

-- 3.4 AND / comparison : delivered orders in Q1 2025
SELECT order_id, customer_id, order_date
FROM orders
WHERE status = 'Delivered' AND order_date BETWEEN '2025-01-01' AND '2025-03-31';

-- 3.5 NOT EQUAL : orders that were not delivered
SELECT order_id, order_date, status FROM orders WHERE status <> 'Delivered';

-- 3.6 IS NULL : pending payments
SELECT payment_id, order_id, method, amount, pay_status FROM payments WHERE paid_on IS NULL;

-- 3.7 ORDER BY + LIMIT : top 3 most expensive products
SELECT product_name, price FROM products ORDER BY price DESC LIMIT 3;

-- 3.8 DISTINCT : cities we serve
SELECT DISTINCT city FROM customers ORDER BY city;

/* #####################################################################
   PART 4 : AGGREGATE FUNCTIONS
   ##################################################################### */

-- 4.1 COUNT, SUM, AVG, MIN, MAX on products
SELECT COUNT(*)                AS total_products,
       SUM(stock_qty)          AS total_units_in_stock,
       ROUND(AVG(price), 2)    AS avg_price,
       MIN(price)              AS cheapest,
       MAX(price)              AS costliest
FROM products;

-- 4.2 Total orders and customers
SELECT COUNT(*) AS total_orders, COUNT(DISTINCT customer_id) AS customers_who_ordered FROM orders;

-- 4.3 Inventory value (at cost and at selling price)
SELECT SUM(stock_qty * cost) AS inventory_cost_value,
       SUM(stock_qty * price) AS inventory_retail_value
FROM products;

-- 4.4 Total revenue from valid sales (Delivered + Shipped)
SELECT ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('Delivered', 'Shipped');

-- 4.5 Collected vs pending payments
SELECT SUM(CASE WHEN paid_on IS NOT NULL THEN amount ELSE 0 END) AS collected,
       SUM(CASE WHEN paid_on IS NULL     THEN amount ELSE 0 END) AS pending
FROM payments;

/* #####################################################################
   PART 5 : GROUPING
   ##################################################################### */

-- 5.1 Customers per city
SELECT city, COUNT(*) AS total_customers FROM customers GROUP BY city ORDER BY total_customers DESC, city;

-- 5.2 Orders by status
SELECT status, COUNT(*) AS order_count FROM orders GROUP BY status ORDER BY order_count DESC;

-- 5.3 Products per category with price statistics
SELECT c.category_name,
       COUNT(p.product_id)    AS products,
       ROUND(AVG(p.price), 2) AS avg_price,
       MIN(p.price)           AS min_price,
       MAX(p.price)           AS max_price
FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_name;

-- 5.4 Payment method summary
SELECT method, COUNT(*) AS payments, SUM(amount) AS total_amount
FROM payments GROUP BY method ORDER BY total_amount DESC;

-- 5.5 HAVING : customers with 2 or more orders
SELECT customer_id, COUNT(*) AS orders_placed
FROM orders GROUP BY customer_id HAVING COUNT(*) >= 2 ORDER BY orders_placed DESC, customer_id;

-- 5.6 HAVING : products with more than 3 units sold
SELECT product_id, SUM(quantity) AS units_sold
FROM order_items GROUP BY product_id HAVING SUM(quantity) > 3 ORDER BY units_sold DESC;

-- 5.7 Monthly order count (cancelled excluded)
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, COUNT(*) AS orders
FROM orders WHERE status <> 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY order_month;

/* #####################################################################
   PART 6 : JOINS
   ##################################################################### */

-- 6.1 INNER JOIN : orders with customer names
SELECT o.order_id, c.full_name, o.order_date, o.status
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id
LIMIT 8;

-- 6.2 Multi-table JOIN (5 tables) : full line-item detail
SELECT o.order_id, c.full_name, p.product_name, cat.category_name,
       oi.quantity, oi.discount_pct,
       ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100), 2) AS line_total
FROM order_items oi
JOIN orders     o   ON o.order_id      = oi.order_id
JOIN customers  c   ON c.customer_id   = o.customer_id
JOIN products   p   ON p.product_id    = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
ORDER BY o.order_id, p.product_name
LIMIT 10;

-- 6.3 LEFT JOIN : customers who never ordered
SELECT c.customer_id, c.full_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 6.4 LEFT JOIN : products never sold
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;

-- 6.5 LEFT JOIN : orders with no payment (cancelled)
SELECT o.order_id, o.status
FROM orders o
LEFT JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_id IS NULL;

-- 6.6 RIGHT JOIN : every category and how many products it holds
SELECT cat.category_name, COUNT(p.product_id) AS products
FROM products p
RIGHT JOIN categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_name;

-- 6.7 JOIN + GROUP BY : revenue per category
SELECT cat.category_name,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
FROM order_items oi
JOIN orders     o   ON o.order_id      = oi.order_id
JOIN products   p   ON p.product_id    = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY cat.category_name
ORDER BY revenue DESC;

-- 6.8 JOIN + GROUP BY + HAVING : customer spending above 20,000
SELECT c.full_name,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_spent
FROM customers c
JOIN orders      o  ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.full_name
HAVING total_spent > 20000
ORDER BY total_spent DESC;

-- 6.9 SELF JOIN : customer pairs from the same city
SELECT a.full_name AS customer_1, b.full_name AS customer_2, a.city
FROM customers a
JOIN customers b ON a.city = b.city AND a.customer_id < b.customer_id;

/* #####################################################################
    PART 7 : BUSINESS REPORT
   ##################################################################### */
  
CREATE VIEW v_sales_detail AS
SELECT o.order_id, o.order_date, o.status, c.customer_id, c.full_name, c.state,
       p.product_name, cat.category_name, oi.quantity,
       ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100), 2) AS revenue,
       ROUND(oi.quantity * p.cost, 2) AS total_cost
FROM order_items oi
JOIN orders     o   ON o.order_id      = oi.order_id
JOIN customers  c   ON c.customer_id   = o.customer_id
JOIN products   p   ON p.product_id    = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id;

-- 7.1 Executive summary
SELECT COUNT(DISTINCT order_id)                          AS total_orders,
       COUNT(DISTINCT customer_id)                       AS active_customers,
       SUM(quantity)                                     AS units_sold,
       ROUND(SUM(revenue), 2)                            AS total_revenue,
       ROUND(SUM(revenue - total_cost), 2)               AS gross_profit,
       ROUND(SUM(revenue - total_cost) / SUM(revenue) * 100, 1) AS profit_margin_pct,
       ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM v_sales_detail
WHERE status IN ('Delivered', 'Shipped');

-- 7.2 Monthly revenue and profit
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       COUNT(DISTINCT order_id)         AS orders,
       ROUND(SUM(revenue), 2)           AS revenue,
       ROUND(SUM(revenue - total_cost), 2) AS profit
FROM v_sales_detail
WHERE status IN ('Delivered', 'Shipped')
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- 7.3 Top 5 customers by revenue
SELECT full_name, ROUND(SUM(revenue), 2) AS revenue
FROM v_sales_detail
WHERE status IN ('Delivered', 'Shipped')
GROUP BY customer_id, full_name
ORDER BY revenue DESC
LIMIT 5;

-- 7.4 State-wise sales
SELECT state, COUNT(DISTINCT order_id) AS orders, ROUND(SUM(revenue), 2) AS revenue
FROM v_sales_detail
WHERE status IN ('Delivered', 'Shipped')
GROUP BY state
ORDER BY revenue DESC;

-- END PROGRAM -- 