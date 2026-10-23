CREATE DATABASE SalesBook;
USE SalesBook;

CREATE TABLE sales (
    sale_id    INT           PRIMARY KEY,
    sale_date  DATE          NOT NULL,
    region     VARCHAR(10)   NOT NULL,
    product    VARCHAR(30)   NOT NULL,
    quantity   INT           NOT NULL,
    price      INT           NOT NULL       
);


INSERT INTO sales (sale_id, sale_date, region, product, quantity, price) VALUES
(1,  '2026-09-01', 'North', 'Laptop',     2, 55000),
(2,  '2026-09-03', 'South', 'Mobile',     5, 18000),
(3,  '2026-09-05', 'East',  'Headphones', 10, 2500),
(4,  '2026-09-08', 'West',  'Mobile',     3, 18000),
(5,  '2026-09-10', 'North', 'Mobile',     4, 18000),
(6,  '2026-09-12', 'South', 'Laptop',     1, 55000),
(7,  '2026-09-15', 'East',  'Laptop',     2, 55000),
(8,  '2026-09-18', 'West',  'Headphones', 8, 2500),
(9,  '2026-09-20', 'North', 'Headphones', 6, 2500),
(10, '2026-09-25', 'South', 'Headphones', 12, 2500);

SELECT * FROM sales;

SELECT count(*) AS total_sales FROM sales;
SELECT COUNT(*)AS north_sales FROM sales WHERE region='North';
SELECT region, count(*) AS number_of_sales FROM sales group by region;

SELECT SUM(quantity) AS total_items_sold FROM sales;
SELECT sum(quantity*price) AS TOTAL_REVENUE FROM sales;
SELECT product,sum(quantity*price) AS REVENUE FROM sales group by product;

SELECT avg(quantity) as average_quantity FROM sales;
SELECT avg(quantity*price)AS AVG_SALE_VALUE FROM sales;
SELECT region,avg(quantity*price)AS AVG_SALE_VALUE FROM sales group by region;

SELECT min(price)AS LOWEST_PRICE,MIN(quantity * price) AS smallest_sale FROM   sales;

SELECT MIN(sale_date) AS first_sale_date FROM sales;
SELECT region, MIN(quantity * price) AS smallest_sale FROM   sales GROUP  BY region;

SELECT MAX(price) AS highest_price, MAX(quantity * price) AS biggest_sale FROM   sales;
SELECT MAX(sale_date) AS latest_sale_date FROM sales;

SELECT region, MAX(quantity * price) AS biggest_sale FROM   sales GROUP  BY region;


SELECT COUNT(*) AS total_sales,
SUM(quantity * price)AS total_revenue,
AVG(quantity * price)AS average_sale,
MIN(quantity * price)AS smallest_sale,
MAX(quantity * price)AS biggest_sale FROM   sales;


SELECT region,COUNT(*) AS sales, 
SUM(quantity * price) AS revenue, 
AVG(quantity * price) AS average_sale, 
MIN(quantity * price) AS smallest_sale,
MAX(quantity * price) AS biggest_sale FROM   sales GROUP  BY region ORDER  BY revenue DESC;
SELECT sale_id, sale_date, region, product, quantity * price AS sale_value FROM   sales WHERE  quantity * price = (SELECT MAX(quantity * price) FROM sales);
