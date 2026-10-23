/* =====================================================================
   SQL PROGRAMME : QUERYING DATA - SELECT, WHERE, ORDER BY
   Domain   : Retail Store (same tables as the RetailDB programme)
   Database : RetailLab  (a fresh, separate database - your RetailDB is not touched)
   Written for MySQL 8.x; also run end-to-end without errors on MariaDB 10.11.
   Run section by section in Workbench (select the lines, press Ctrl + Enter).

   TOPICS COVERED
     1. Retrieve records using SELECT ............ PART 1
     2. Filter records using the WHERE clause .... PART 2
     3. Sort records using ORDER BY .............. PART 3
     4. Apply multiple conditions (AND/OR/NOT) ... PART 4
     5. Generate filtered result sets ............ PART 5  (business reports + views)
     Bonus : 10 practice questions with an answer key ... PART 6

   Every query has a comment showing how many rows it should return,
   so students can check their own output.
   ===================================================================== */


/* #####################################################################
   PART 0 : SETUP  (run once - creates the tables and loads practice data)
   ##################################################################### */

DROP DATABASE IF EXISTS RetailLab;
CREATE DATABASE RetailLab;
USE RetailLab;

CREATE TABLE categories (
    category_id    INT           AUTO_INCREMENT PRIMARY KEY,
    category_name  VARCHAR(50)   NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id     INT            AUTO_INCREMENT PRIMARY KEY,
    product_name   VARCHAR(100)   NOT NULL,
    brand          VARCHAR(40)    NOT NULL,
    category_id    INT            NOT NULL,
    unit_price     DECIMAL(10,2)  NOT NULL,
    stock_qty      INT            NOT NULL DEFAULT 0,
    reorder_level  INT            NOT NULL DEFAULT 20,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id     INT           AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(80)   NOT NULL,
    email           VARCHAR(100)  NULL,                 -- some customers have no email (NULL)
    city            VARCHAR(50)   NOT NULL,
    joined_date     DATE          NOT NULL,
    loyalty_points  INT           NOT NULL DEFAULT 0
);

CREATE TABLE orders (
    order_id       INT           AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT           NOT NULL,
    order_date     DATE          NOT NULL,
    status         VARCHAR(20)   NOT NULL,
    payment_mode   VARCHAR(20)   NOT NULL,
    delivery_date  DATE          NULL,                  -- NULL until the order is delivered
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id     INT  AUTO_INCREMENT PRIMARY KEY,
    order_id    INT  NOT NULL,
    product_id  INT  NOT NULL,
    quantity    INT  NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO categories (category_name) VALUES
('Groceries'), ('Personal Care'), ('Beverages'), ('Household'), ('Snacks');

INSERT INTO products (product_name, brand, category_id, unit_price, stock_qty, reorder_level) VALUES
('Basmati Rice 5kg',          'GoldenHarvest', 1, 550.00,  80, 30),
('Toor Dal 1kg',              'FarmFresh',     1, 165.00, 120, 40),
('Sunflower Oil 1L',          'SunGold',       1, 145.00,  15, 25),
('Green Tea Box',             'LeafLife',      3, 240.00,  45, 20),
('Filter Coffee 500g',        'BrewMaster',    3, 310.00,  12, 20),
('Fruit Juice 1L',            'FreshSip',      3, 110.00,  90, 30),
('Herbal Shampoo',            'PureBloom',     2, 199.00,  70, 25),
('Bath Soap Pack',            'PureBloom',     2, 120.00, 100, 40),
('Dish Wash Liquid',          'SparkleHome',   4,  99.00,   8, 20),
('Floor Cleaner 1L',          'SparkleHome',   4, 175.00,  40, 15),
('Masala Peanuts 200g',       'CrunchTime',    5,  60.00, 150, 50),
('Potato Chips Family Pack',  'CrunchTime',    5,  90.00,  22, 30),
('Instant Noodles Pack of 5', 'FarmFresh',     5,  85.00,   0, 30);

INSERT INTO customers (full_name, email, city, joined_date, loyalty_points) VALUES
('Aarav Sharma',   'aarav@example.com',  'Bengaluru', '2026-01-10', 320),
('Diya Nair',      'diya@example.com',   'Kochi',     '2026-02-14', 150),
('Rohan Gupta',    NULL,                 'Delhi',     '2026-03-03',  90),
('Meera Iyer',     'meera@example.com',  'Chennai',   '2026-03-21',   0),
('Kabir Singh',    'kabir@example.com',  'Mumbai',    '2026-04-09',  60),
('Ananya Reddy',   NULL,                 'Hyderabad', '2026-05-18', 210),
('Vikram Patil',   'vikram@example.com', 'Pune',      '2026-06-02',  40),
('Sneha Kulkarni', 'sneha@example.com',  'Bengaluru', '2026-06-25', 500),
('Aditya Menon',   'aditya@example.com', 'Kochi',     '2026-07-11',  25),
('Isha Kapoor',    'isha@example.com',   'Delhi',     '2026-08-05',   0);

INSERT INTO orders (customer_id, order_date, status, payment_mode, delivery_date) VALUES
(1, '2026-07-05', 'Delivered', 'UPI',  '2026-07-07'),
(2, '2026-07-12', 'Delivered', 'Card', '2026-07-15'),
(3, '2026-08-02', 'Delivered', 'Cash', '2026-08-05'),
(1, '2026-08-10', 'Delivered', 'UPI',  '2026-08-12'),
(4, '2026-08-15', 'Cancelled', 'Card', NULL),
(5, '2026-08-21', 'Delivered', 'Cash', '2026-08-24'),
(2, '2026-09-01', 'Delivered', 'UPI',  '2026-09-03'),
(6, '2026-09-08', 'Pending',   'Card', NULL),
(3, '2026-09-15', 'Delivered', 'UPI',  '2026-09-17'),
(7, '2026-09-22', 'Pending',   'Cash', NULL),
(8, '2026-09-24', 'Shipped',   'UPI',  NULL),
(1, '2026-09-25', 'Pending',   'Card', NULL),
(9, '2026-09-27', 'Shipped',   'Cash', NULL),
(8, '2026-09-28', 'Pending',   'UPI',  NULL);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),  (1, 3, 1),
(2, 5, 2),  (2, 4, 1),
(3, 2, 3),  (3, 9, 2),
(4, 7, 1),  (4, 8, 3),
(5, 1, 1),  (5, 6, 4),
(6, 10, 2), (6, 9, 1),
(7, 2, 2),  (7, 3, 2),
(8, 4, 2),  (8, 5, 1),
(9, 8, 2),  (9, 7, 2),
(10, 6, 6), (10, 1, 1),
(11, 11, 5), (11, 12, 2),
(12, 2, 2), (12, 11, 3),
(13, 6, 3), (13, 12, 1),
(14, 5, 1), (14, 4, 1), (14, 7, 1);

-- Quick check: the tables are loaded
SELECT (SELECT COUNT(*) FROM products)    AS products,
       (SELECT COUNT(*) FROM customers)   AS customers,
       (SELECT COUNT(*) FROM orders)      AS orders,
       (SELECT COUNT(*) FROM order_items) AS order_lines;


/* #####################################################################
   PART 1 : RETRIEVE RECORDS USING SELECT
   Idea: SELECT decides WHICH COLUMNS you see. FROM decides WHICH TABLE.
   ##################################################################### */

-- 1.1 All columns, all rows  (* means "every column")
-- Expected: 13 row(s)
SELECT * FROM products;

-- 1.2 Only the columns you need
-- Expected: 13 row(s)
SELECT product_name, unit_price FROM products;

-- 1.3 Column aliases : give friendly names to the output columns (AS)
-- Expected: 13 row(s)
SELECT product_name AS Product,
       unit_price   AS Price_in_Rs,
       stock_qty    AS Units_Available
FROM   products;

-- 1.4 DISTINCT : remove duplicate values
-- Expected: 7 row(s)
SELECT DISTINCT city FROM customers;

-- Expected: 3 row(s)
SELECT DISTINCT payment_mode FROM orders;

-- 1.5 Calculated columns : SQL can do arithmetic like an Excel formula
-- Expected: 13 row(s)
SELECT product_name,
       unit_price,
       ROUND(unit_price * 1.05, 2)  AS price_with_5pct_gst,
       ROUND(unit_price * 0.90, 2)  AS price_after_10pct_discount,
       unit_price * stock_qty       AS stock_value
FROM   products;

-- 1.6 Text functions : CONCAT joins text, UPPER changes case
-- Expected: 10 row(s)
SELECT CONCAT(full_name, ' (', city, ')')  AS customer_label,
       UPPER(city)                          AS city_in_capitals
FROM   customers;

-- 1.7 LIMIT : see only the first few rows (great for a quick preview)
-- Expected: 3 row(s)
SELECT * FROM customers LIMIT 3;

-- 1.8 SELECT without a table : SQL as a calculator
-- Expected: 1 row(s)
SELECT 2500 * 12 AS yearly_amount, CURDATE() AS today;

-- 1.9 Count the rows in a table
-- Expected: 1 row(s)
SELECT COUNT(*) AS total_products FROM products;


/* #####################################################################
   PART 2 : FILTER RECORDS USING THE WHERE CLAUSE
   Idea: SELECT picks COLUMNS. WHERE picks ROWS.
   ##################################################################### */

-- 2.1 Equal to (=)   Text values go inside single quotes
-- Expected: 2 row(s)
SELECT full_name, city FROM customers WHERE city = 'Bengaluru';

-- 2.2 Not equal to (<> or !=)
-- Expected: 7 row(s)
SELECT order_id, status FROM orders WHERE status <> 'Delivered';

-- 2.3 Comparison operators : >  <  >=  <=
-- Expected: 3 row(s)
SELECT product_name, unit_price FROM products WHERE unit_price > 200;

-- Expected: 4 row(s)
SELECT product_name, stock_qty FROM products WHERE stock_qty <= 15;

-- 2.4 BETWEEN : an inclusive range (both ends included)
-- Expected: 6 row(s)
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 100 AND 200;

-- BETWEEN also works with dates
-- Expected: 4 row(s)
SELECT order_id, order_date, status
FROM   orders
WHERE  order_date BETWEEN '2026-08-01' AND '2026-08-31';

-- 2.5 IN : match any value from a list (shorter than many ORs)
-- Expected: 6 row(s)
SELECT full_name, city FROM customers WHERE city IN ('Bengaluru', 'Delhi', 'Kochi');

-- Expected: 4 row(s)
SELECT product_name, brand FROM products WHERE brand IN ('CrunchTime', 'PureBloom');

-- 2.6 LIKE : search for a pattern.  % = any number of characters,  _ = exactly one character
-- Expected: 3 row(s)
SELECT full_name FROM customers WHERE full_name LIKE 'A%';           -- starts with A

-- Expected: 3 row(s)
SELECT product_name FROM products WHERE product_name LIKE '%Pack%';  -- contains "Pack"

-- Expected: 3 row(s)
SELECT product_name FROM products WHERE product_name LIKE '%1L';     -- ends with 1L

-- Expected: 1 row(s)
SELECT full_name FROM customers WHERE full_name LIKE '_iya%';        -- 1 letter, then "iya"

-- 2.7 NULL handling : NULL means "no value". Use IS NULL / IS NOT NULL (never = NULL)
-- Expected: 2 row(s)
SELECT full_name, city FROM customers WHERE email IS NULL;

-- Expected: 8 row(s)
SELECT full_name, email FROM customers WHERE email IS NOT NULL;

-- Orders that are not delivered yet have no delivery date
-- Expected: 7 row(s)
SELECT order_id, status, delivery_date FROM orders WHERE delivery_date IS NULL;

-- 2.8 Filtering by date parts
-- Expected: 8 row(s)
SELECT order_id, order_date FROM orders WHERE MONTH(order_date) = 9;

-- Expected: 6 row(s)
SELECT order_id, order_date FROM orders WHERE order_date >= '2026-09-15';

-- 2.9 Filtering on a calculated value (use the expression itself in WHERE)
-- Expected: 1 row(s)
SELECT product_name, unit_price * stock_qty AS stock_value
FROM   products
WHERE  unit_price * stock_qty > 20000;

-- NOTE : an alias created in SELECT cannot be used in WHERE. This gives an error:
-- SELECT product_name, unit_price * stock_qty AS stock_value FROM products WHERE stock_value > 20000;


/* #####################################################################
   PART 3 : SORT RECORDS USING ORDER BY
   Idea: ORDER BY decides the ORDER of the rows. ASC = low to high (default),
         DESC = high to low. It always comes near the END of the query.
   ##################################################################### */

-- 3.1 Ascending order (default)
-- Expected: 13 row(s)
SELECT product_name, unit_price FROM products ORDER BY unit_price;

-- 3.2 Descending order
-- Expected: 13 row(s)
SELECT product_name, unit_price FROM products ORDER BY unit_price DESC;

-- 3.3 Sort text alphabetically
-- Expected: 10 row(s)
SELECT full_name, city FROM customers ORDER BY full_name;

-- 3.4 Sort by more than one column : first by city (A-Z), then by points (highest first)
-- Expected: 10 row(s)
SELECT full_name, city, loyalty_points
FROM   customers
ORDER  BY city ASC, loyalty_points DESC;

-- 3.5 Sort by a column alias (allowed here, unlike in WHERE)
-- Expected: 13 row(s)
SELECT product_name, unit_price * stock_qty AS stock_value
FROM   products
ORDER  BY stock_value DESC;

-- 3.6 Sort by column position (1 = first column in SELECT)
-- Expected: 13 row(s)
SELECT product_name, category_id, unit_price
FROM   products
ORDER  BY 2, 3 DESC;

-- 3.7 Sort dates : newest first
-- Expected: 14 row(s)
SELECT order_id, order_date, status FROM orders ORDER BY order_date DESC;

-- 3.8 Custom sort order with CASE (Pending first, then Shipped, Delivered, others)
-- Expected: 14 row(s)
SELECT order_id, order_date, status
FROM   orders
ORDER  BY CASE status
              WHEN 'Pending'   THEN 1
              WHEN 'Shipped'   THEN 2
              WHEN 'Delivered' THEN 3
              ELSE 4
          END,
          order_date;

-- 3.9 NULL values in sorting : NULLs come first in ASC order. Push them last like this:
-- Expected: 14 row(s)
SELECT order_id, status, delivery_date
FROM   orders
ORDER  BY delivery_date IS NULL, delivery_date;

-- 3.10 WHERE and ORDER BY together : filter first, then sort
-- Expected: 3 row(s)
SELECT product_name, brand, unit_price
FROM   products
WHERE  category_id = 3
ORDER  BY unit_price DESC;

-- 3.11 Top-N with LIMIT : the 5 most expensive products
-- Expected: 5 row(s)
SELECT product_name, unit_price
FROM   products
ORDER  BY unit_price DESC
LIMIT  5;

-- 3.12 Pagination with OFFSET : page 2 of the product list (5 rows per page)
-- Expected: 5 row(s)
SELECT product_id, product_name
FROM   products
ORDER  BY product_name
LIMIT  5 OFFSET 5;


/* #####################################################################
   PART 4 : APPLY MULTIPLE CONDITIONS  (AND, OR, NOT, parentheses)
   Idea: AND = both conditions true.  OR = at least one true.  NOT = reverse.
         Priority: NOT first, then AND, then OR.  Use ( ) to be safe.
   ##################################################################### */

-- 4.1 AND : both conditions must be true
-- Expected: 1 row(s)
SELECT full_name, city, loyalty_points
FROM   customers
WHERE  city = 'Bengaluru' AND loyalty_points > 400;

-- 4.2 OR : any one condition is enough
-- Expected: 2 row(s)
SELECT full_name, city
FROM   customers
WHERE  city = 'Mumbai' OR city = 'Pune';

-- 4.3 NOT : reverse a condition
-- Expected: 7 row(s)
SELECT order_id, status FROM orders WHERE NOT status = 'Delivered';

-- 4.4 The AND / OR priority trap.  Same conditions, different brackets, different answers.
-- Without brackets: AND runs first, so this means  cat 3  OR  (cat 5 AND price > 200)
-- Expected: 3 row(s)
SELECT product_name, category_id, unit_price
FROM   products
WHERE  category_id = 3 OR category_id = 5 AND unit_price > 200;

-- With brackets: (cat 3 OR cat 5) AND price > 200
-- Expected: 2 row(s)
SELECT product_name, category_id, unit_price
FROM   products
WHERE  (category_id = 3 OR category_id = 5) AND unit_price > 200;

-- 4.5 IN combined with AND
-- Expected: 2 row(s)
SELECT order_id, order_date, status, payment_mode
FROM   orders
WHERE  status IN ('Pending', 'Shipped') AND payment_mode = 'UPI';

-- 4.6 BETWEEN combined with another condition
-- Expected: 4 row(s)
SELECT product_name, unit_price, stock_qty
FROM   products
WHERE  unit_price BETWEEN 100 AND 250 AND stock_qty > 50;

-- 4.7 LIKE combined with OR
-- Expected: 4 row(s)
SELECT full_name, city
FROM   customers
WHERE  full_name LIKE 'A%' OR full_name LIKE 'S%';

-- 4.8 NOT IN and NOT LIKE
-- Expected: 4 row(s)
SELECT full_name, city FROM customers WHERE city NOT IN ('Bengaluru', 'Delhi', 'Kochi');

-- Expected: 10 row(s)
SELECT product_name FROM products WHERE product_name NOT LIKE '%Pack%';

-- 4.9 IS NULL combined with AND : customers with no email who have good loyalty points
-- Expected: 1 row(s)
SELECT full_name, city, loyalty_points
FROM   customers
WHERE  email IS NULL AND loyalty_points > 100;

-- 4.10 Date range AND status
-- Expected: 2 row(s)
SELECT order_id, order_date, status
FROM   orders
WHERE  order_date >= '2026-09-01' AND order_date < '2026-10-01' AND status = 'Delivered';

-- 4.11 Three conditions with brackets : a realistic marketing filter
--      (Bengaluru or Kochi) AND joined in 2026 AND loyalty points of 100 or more
-- Expected: 3 row(s)
SELECT full_name, city, joined_date, loyalty_points
FROM   customers
WHERE  city IN ('Bengaluru', 'Kochi')
  AND  YEAR(joined_date) = 2026
  AND  loyalty_points >= 100;

-- 4.12 Mixing all operators : cheap in-stock snacks or beverages, but not from brand FarmFresh
-- Expected: 3 row(s)
SELECT product_name, brand, unit_price, stock_qty
FROM   products
WHERE  (category_id = 3 OR category_id = 5)
  AND  unit_price < 120
  AND  stock_qty > 0
  AND  NOT brand = 'FarmFresh';


/* #####################################################################
   PART 5 : GENERATE FILTERED RESULT SETS  (business reports)
   Idea: combine SELECT + JOIN + WHERE + ORDER BY to answer a real business
         question. Finally, save a result set as a VIEW so it can be reused.
   ##################################################################### */

-- 5.1 STOCK ALERT : products below their reorder level, most urgent first
-- Expected: 5 row(s)
SELECT product_name, stock_qty, reorder_level,
       reorder_level - stock_qty AS shortage
FROM   products
WHERE  stock_qty < reorder_level
ORDER  BY shortage DESC;

-- 5.2 OUT OF STOCK products
-- Expected: 1 row(s)
SELECT product_id, product_name, brand FROM products WHERE stock_qty = 0;

-- 5.3 PREMIUM RANGE : costly products that are actually available
-- Expected: 3 row(s)
SELECT product_name, unit_price, stock_qty
FROM   products
WHERE  unit_price >= 200 AND stock_qty > 0
ORDER  BY unit_price DESC;

-- 5.4 OPEN ORDERS : orders still to be delivered, with customer names (JOIN)
-- Expected: 6 row(s)
SELECT o.order_id, o.order_date, c.full_name, c.city, o.status, o.payment_mode
FROM   orders o
JOIN   customers c ON c.customer_id = o.customer_id
WHERE  o.status IN ('Pending', 'Shipped')
ORDER  BY o.order_date;

-- 5.5 SEPTEMBER UPI SALES : delivered orders paid by UPI in September
-- Expected: 2 row(s)
SELECT o.order_id, o.order_date, c.full_name, o.delivery_date
FROM   orders o
JOIN   customers c ON c.customer_id = o.customer_id
WHERE  o.status = 'Delivered'
  AND  o.payment_mode = 'UPI'
  AND  o.order_date >= '2026-09-01' AND o.order_date < '2026-10-01'
ORDER  BY o.order_date;

-- 5.6 EMAIL CAMPAIGN LIST : customers we can email, from selected cities
-- Expected: 5 row(s)
SELECT full_name, email, city
FROM   customers
WHERE  email IS NOT NULL
  AND  city IN ('Bengaluru', 'Kochi', 'Delhi')
ORDER  BY city, full_name;

-- 5.7 DATA CLEAN-UP LIST : customers whose email is missing
-- Expected: 2 row(s)
SELECT customer_id, full_name, city FROM customers WHERE email IS NULL ORDER BY full_name;

-- 5.8 RE-ENGAGEMENT LIST : 2026 joiners with zero loyalty points
-- Expected: 2 row(s)
SELECT full_name, city, joined_date
FROM   customers
WHERE  loyalty_points = 0 AND YEAR(joined_date) = 2026
ORDER  BY joined_date;

-- 5.9 BIG BILL LINES : order lines worth more than Rs. 500 (calculated value in WHERE)
-- Expected: 5 row(s)
SELECT oi.order_id, p.product_name, oi.quantity, p.unit_price,
       oi.quantity * p.unit_price AS line_amount
FROM   order_items oi
JOIN   products p ON p.product_id = oi.product_id
WHERE  oi.quantity * p.unit_price > 500
ORDER  BY line_amount DESC;

-- 5.10 BUDGET BEVERAGES AND SNACKS : category names through a JOIN
-- Expected: 4 row(s)
SELECT p.product_name, c.category_name, p.unit_price
FROM   products p
JOIN   categories c ON c.category_id = p.category_id
WHERE  c.category_name IN ('Beverages', 'Snacks')
  AND  p.unit_price <= 120
ORDER  BY c.category_name, p.unit_price;

-- 5.11 SLOW MOVERS : products that never appear in any order (LEFT JOIN + IS NULL)
-- Expected: 1 row(s)
SELECT p.product_id, p.product_name, p.stock_qty
FROM   products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE  oi.item_id IS NULL
ORDER  BY p.product_name;

-- 5.12 SAVE A RESULT SET AS A VIEW : a "saved query" that behaves like a table
CREATE VIEW v_low_stock_products AS
SELECT product_id, product_name, stock_qty, reorder_level,
       reorder_level - stock_qty AS shortage
FROM   products
WHERE  stock_qty < reorder_level;

CREATE VIEW v_open_orders AS
SELECT o.order_id, o.order_date, c.full_name, c.city, o.status, o.payment_mode
FROM   orders o
JOIN   customers c ON c.customer_id = o.customer_id
WHERE  o.status IN ('Pending', 'Shipped');

-- Use the views like tables, and filter or sort them further
-- Expected: 5 row(s)
SELECT * FROM v_low_stock_products ORDER BY shortage DESC;

-- Expected: 3 row(s)
SELECT * FROM v_open_orders WHERE city = 'Bengaluru' ORDER BY order_date;


/* #####################################################################
   PART 6 : PRACTICE QUESTIONS  (try each one before looking at the answer key)
   ##################################################################### */

/*
   Q1.  Show the name and city of all customers from Delhi.
   Q2.  List products priced between 100 and 250, cheapest first.
   Q3.  Find customers whose name starts with 'A' and who have no email.
   Q4.  Show orders placed in August that were paid by Cash or Card.
   Q5.  Show the 3 products with the highest stock value (price x stock).
   Q6.  List products of brand 'CrunchTime' with stock above 50.
   Q7.  Customers from Bengaluru or Kochi with 150 or more loyalty points,
        highest points first.
   Q8.  Pending orders that were NOT paid by UPI.
   Q9.  Products with 'Pack' in the name that are not in the Snacks category (5).
   Q10. Second page of customers when sorted by joined_date, 4 customers per page.
*/

/* ------------------------------ ANSWER KEY ------------------------------ */

-- A1
-- Expected: 2 row(s)
SELECT full_name, city FROM customers WHERE city = 'Delhi';

-- A2
-- Expected: 7 row(s)
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 100 AND 250 ORDER BY unit_price;

-- A3
-- Expected: 1 row(s)
SELECT full_name, city FROM customers WHERE full_name LIKE 'A%' AND email IS NULL;

-- A4
-- Expected: 3 row(s)
SELECT order_id, order_date, payment_mode
FROM   orders
WHERE  MONTH(order_date) = 8 AND payment_mode IN ('Cash', 'Card');

-- A5
-- Expected: 3 row(s)
SELECT product_name, unit_price * stock_qty AS stock_value
FROM   products
ORDER  BY stock_value DESC
LIMIT  3;

-- A6
-- Expected: 1 row(s)
SELECT product_name, stock_qty FROM products WHERE brand = 'CrunchTime' AND stock_qty > 50;

-- A7
-- Expected: 3 row(s)
SELECT full_name, city, loyalty_points
FROM   customers
WHERE  city IN ('Bengaluru', 'Kochi') AND loyalty_points >= 150
ORDER  BY loyalty_points DESC;

-- A8
-- Expected: 3 row(s)
SELECT order_id, order_date, payment_mode
FROM   orders
WHERE  status = 'Pending' AND payment_mode <> 'UPI';

-- A9
-- Expected: 1 row(s)
SELECT product_name, category_id FROM products WHERE product_name LIKE '%Pack%' AND category_id <> 5;

-- A10
-- Expected: 4 row(s)
SELECT full_name, joined_date FROM customers ORDER BY joined_date LIMIT 4 OFFSET 4;


/* ---------------------------- OPTIONAL CLEAN-UP ----------------------------
DROP VIEW IF EXISTS v_low_stock_products;
DROP VIEW IF EXISTS v_open_orders;
DROP DATABASE IF EXISTS RetailLab;
---------------------------------------------------------------------------- */

/* ============================== END OF PROGRAMME ============================== */
