-- A1. Create Database
CREATE DATABASE BankDB;
USE BankDB;

-- A2. Create tables (data types + PRIMARY KEY, NOT NULL, DEFAULT, UNIQUE, FOREIGN KEY)
CREATE TABLE branches (
    branch_id    INT           AUTO_INCREMENT PRIMARY KEY,
    branch_name  VARCHAR(60)   NOT NULL UNIQUE,
    city         VARCHAR(50)   DEFAULT 'Bengaluru'
);

CREATE TABLE customers (
    customer_id   INT            AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(80)    NOT NULL,
    email         VARCHAR(100)   UNIQUE,
    city          VARCHAR(50)    DEFAULT 'Bengaluru',
    joined_date   DATE           DEFAULT (CURRENT_DATE)
);

CREATE TABLE accounts (
    account_id    INT             AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT             NOT NULL,
    branch_id     INT             NOT NULL,
    account_type  VARCHAR(20)     NOT NULL DEFAULT 'Savings',
    balance       DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    opened_date   DATE            NOT NULL,
    status        VARCHAR(15)     NOT NULL DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);

CREATE TABLE transactions (
    txn_id       INT             AUTO_INCREMENT PRIMARY KEY,
    account_id   INT             NOT NULL,
    txn_type     VARCHAR(12)     NOT NULL,            -- 'Deposit' or 'Withdrawal'
    amount       DECIMAL(12,2)   NOT NULL,
    txn_date     DATE            NOT NULL,
    remarks      VARCHAR(100),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id        INT             AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT             NOT NULL,
    loan_type      VARCHAR(30)     NOT NULL,
    principal      DECIMAL(12,2)   NOT NULL,
    interest_rate  DECIMAL(5,2)    NOT NULL,
    start_date     DATE            NOT NULL,
    status         VARCHAR(15)     NOT NULL DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- A3. ALTER : add, modify, rename and remove columns
ALTER TABLE customers ADD COLUMN phone VARCHAR(15);                   -- add a column
ALTER TABLE customers ADD COLUMN credit_score INT DEFAULT 700;        -- add with default
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20);                -- change size
ALTER TABLE customers RENAME COLUMN phone TO mobile_no;               -- rename
ALTER TABLE customers DROP COLUMN mobile_no;                          -- remove
ALTER TABLE loans     ADD COLUMN end_date DATE;                       -- nullable, filled later

-- A4. Index for faster searches
CREATE INDEX idx_txn_date ON transactions(txn_date);

-- A5. TRUNCATE vs DROP on a practice table
CREATE TABLE atm_log (
    log_id   INT AUTO_INCREMENT PRIMARY KEY,
    message  VARCHAR(200) NOT NULL
);
INSERT INTO atm_log (message) VALUES ('ATM 12 cash low'), ('ATM 07 card jam'), ('ATM 03 restocked');

TRUNCATE TABLE atm_log;      -- removes all rows, keeps the structure
DROP TABLE atm_log;          -- removes the table itself

DESCRIBE accounts;
SHOW TABLES;


/* #####################################################################
   PART B : DML - DATA MANIPULATION LANGUAGE   (Unit 2)
   Commands: INSERT, UPDATE, DELETE
   ##################################################################### */

-- B1. INSERT : master data
INSERT INTO branches (branch_name, city) VALUES
('Indiranagar Branch',     'Bengaluru'),
('Andheri Branch',         'Mumbai'),
('Connaught Place Branch', 'Delhi'),
('T Nagar Branch',         'Chennai');

INSERT INTO customers (full_name, email, city, joined_date) VALUES
('Nikhil Bansal',    'nikhil@example.com',  'Delhi',     '2022-03-14'),
('Shreya Menon',     'shreya@example.com',  'Bengaluru', '2021-07-19'),
('Harsh Vardhan',    'harsh@example.com',   'Mumbai',    '2023-01-25'),
('Pallavi Joshi',    'pallavi@example.com', 'Pune',      '2023-06-02'),
('Arjun Krishnan',   'arjun@example.com',   'Chennai',   '2020-11-30'),
('Tanvi Deshmukh',   'tanvi@example.com',   'Mumbai',    '2022-09-08'),
('Yusuf Ansari',     'yusuf@example.com',   'Bengaluru', '2024-02-16'),
('Reena Thomas',     'reena@example.com',   'Chennai',   '2026-08-20');

INSERT INTO accounts (customer_id, branch_id, account_type, balance, opened_date) VALUES
(1, 3, 'Savings',       85000.00, '2022-03-14'),
(1, 3, 'Current',      250000.00, '2022-05-02'),
(2, 1, 'Savings',      120000.00, '2021-07-19'),
(3, 2, 'Savings',       45000.00, '2023-01-25'),
(4, 2, 'Savings',       30000.00, '2023-06-02'),
(5, 4, 'Savings',       95000.00, '2020-11-30'),
(6, 2, 'Current',      400000.00, '2022-09-08'),
(7, 1, 'Savings',       15000.00, '2024-02-16'),
(2, 1, 'Fixed Deposit', 300000.00, '2025-01-10'),
(5, 4, 'Current',      180000.00, '2021-04-12');

INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks) VALUES
(1,  'Deposit',     20000.00, '2026-07-03', 'Salary credit'),
(1,  'Withdrawal',   5000.00, '2026-07-10', 'ATM withdrawal'),
(3,  'Deposit',     35000.00, '2026-07-05', 'Salary credit'),
(3,  'Withdrawal',  12000.00, '2026-07-18', 'Rent payment'),
(4,  'Deposit',     10000.00, '2026-07-22', 'Cash deposit'),
(6,  'Withdrawal',   8000.00, '2026-08-02', 'ATM withdrawal'),
(7,  'Deposit',    150000.00, '2026-08-05', 'Client payment'),
(7,  'Withdrawal',  60000.00, '2026-08-19', 'Vendor payment'),
(2,  'Deposit',     75000.00, '2026-08-25', 'Business receipt'),
(8,  'Withdrawal',   3000.00, '2026-09-01', 'ATM withdrawal'),
(5,  'Deposit',      5000.00, '2026-09-04', 'Cash deposit'),
(10, 'Deposit',     90000.00, '2026-09-10', 'Client payment'),
(3,  'Withdrawal',  20000.00, '2026-09-15', 'Insurance premium'),
(6,  'Deposit',     25000.00, '2026-09-20', 'Salary credit'),
(1,  'Withdrawal',  15000.00, '2026-09-22', 'Online shopping');

INSERT INTO loans (customer_id, loan_type, principal, interest_rate, start_date, status) VALUES
(1, 'Home Loan',      4500000.00,  8.50, '2025-04-01', 'Active'),
(2, 'Car Loan',        800000.00,  9.25, '2025-11-15', 'Active'),
(3, 'Personal Loan',   300000.00, 12.00, '2026-02-10', 'Active'),
(5, 'Business Loan',  1500000.00, 11.00, '2025-08-20', 'Active'),
(6, 'Home Loan',      3200000.00,  8.75, '2024-12-05', 'Active'),
(7, 'Personal Loan',   150000.00, 13.50, '2026-05-18', 'Closed'),
(4, 'Car Loan',        600000.00,  9.50, '2026-03-01', 'Active');

-- B2. INSERT using DEFAULT values (city, joined_date and credit_score are skipped on purpose)
INSERT INTO customers (full_name, email) VALUES ('Test Customer', 'test@example.com');   -- will be deleted
SELECT customer_id, full_name, city, joined_date, credit_score FROM customers WHERE full_name = 'Test Customer';

-- B3. INSERT ... SELECT (copy data from one table into another)
CREATE TABLE high_value_accounts AS SELECT * FROM accounts WHERE 1 = 0;       -- empty copy of structure
INSERT INTO high_value_accounts SELECT * FROM accounts WHERE balance >= 200000;
SELECT * FROM high_value_accounts;

-- B4. UPDATE with SAFE UPDATES ON
SET SQL_SAFE_UPDATES = 1;

UPDATE customers SET credit_score = 780 WHERE customer_id = 2;                -- allowed (primary key)
-- UPDATE accounts SET balance = 0;                                           -- BLOCKED: no WHERE (try it!)

-- B5. Real-world scenario 1 : quarterly interest credit (1% on Active Savings accounts)
--     Step 1: record the interest as transactions, Step 2: add it to the balance
INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks)
SELECT account_id, 'Deposit', ROUND(balance * 0.01, 2), '2026-09-30', 'Quarterly interest'
FROM   accounts
WHERE  account_type = 'Savings' AND status = 'Active';

SET SQL_SAFE_UPDATES = 0;                     -- bulk update on non-key columns
UPDATE accounts
SET    balance = ROUND(balance * 1.01, 2)
WHERE  account_type = 'Savings' AND status = 'Active';
SET SQL_SAFE_UPDATES = 1;

-- B6. Real-world scenario 2 : new customer opens an account with an opening deposit
INSERT INTO customers (full_name, email, city) VALUES ('Kavita Rao', 'kavita@example.com', 'Delhi');
SET @new_customer = LAST_INSERT_ID();

INSERT INTO accounts (customer_id, branch_id, account_type, balance, opened_date)
VALUES (@new_customer, 3, 'Savings', 10000.00, '2026-09-25');
SET @new_account = LAST_INSERT_ID();

INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks)
VALUES (@new_account, 'Deposit', 10000.00, '2026-09-25', 'Opening deposit');

-- B7. Real-world scenario 3 : a cash withdrawal (transaction record + balance change)
INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks)
VALUES (2, 'Withdrawal', 40000.00, '2026-09-26', 'Cheque payment');
UPDATE accounts SET balance = balance - 40000.00 WHERE account_id = 2;

-- B8. Real-world scenario 4 : account closure (soft delete keeps the history)
INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks)
SELECT account_id, 'Withdrawal', balance, '2026-09-28', 'Account closure payout'
FROM   accounts WHERE account_id = 8;

UPDATE accounts SET balance = 0, status = 'Closed' WHERE account_id = 8;

-- B9. Real-world scenario 5 : loan interest rate cut (0.25% reduction on Active Home Loans)
SET SQL_SAFE_UPDATES = 0;
UPDATE loans
SET    interest_rate = interest_rate - 0.25
WHERE  loan_type = 'Home Loan' AND status = 'Active';
SET SQL_SAFE_UPDATES = 1;

-- B10. Real-world scenario 6 : loan fully repaid
UPDATE loans SET status = 'Closed', end_date = '2026-09-27' WHERE loan_id = 3;

-- B11. DELETE : remove wrongly entered data
INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks)
VALUES (3, 'Deposit', 999999.00, '2026-09-28', 'Entered by mistake');       -- clerk typo!
SET @wrong_txn = LAST_INSERT_ID();
DELETE FROM transactions WHERE txn_id = @wrong_txn;                          -- reversed before posting

DELETE FROM customers WHERE full_name = 'Test Customer' AND customer_id = 9; -- the test entry
DROP TABLE high_value_accounts;                                              -- clean up practice table


/* #####################################################################
   PART C : DQL - DATA QUERY LANGUAGE   (Unit 1)
   Command: SELECT
   ##################################################################### */

-- C1. Basic retrieval
SELECT * FROM branches;
SELECT full_name, city FROM customers;

-- C2. Filtering : WHERE, AND/OR, BETWEEN, IN, LIKE, IS NULL
SELECT account_id, account_type, balance FROM accounts WHERE balance > 100000;
SELECT account_id, balance FROM accounts WHERE balance BETWEEN 50000 AND 150000;
SELECT full_name, city FROM customers WHERE city IN ('Mumbai', 'Chennai');
SELECT full_name FROM customers WHERE full_name LIKE 'S%' OR full_name LIKE '%Rao';
SELECT loan_id, loan_type FROM loans WHERE end_date IS NULL;                 -- loans still running

-- C3. DISTINCT, ORDER BY, LIMIT
SELECT DISTINCT account_type FROM accounts;
SELECT account_id, balance FROM accounts ORDER BY balance DESC LIMIT 5;      -- top 5 balances

-- C4. Calculated columns and date functions
SELECT loan_id, loan_type, principal, interest_rate,
       ROUND(principal * interest_rate / 100, 2)      AS yearly_interest,
       TIMESTAMPDIFF(MONTH, start_date, CURDATE())    AS months_running
FROM   loans;

-- C5. CASE : classify customers by balance
SELECT account_id, balance,
       CASE
           WHEN balance >= 250000 THEN 'Premium'
           WHEN balance >= 50000  THEN 'Regular'
           ELSE                        'Basic'
       END AS customer_tier
FROM   accounts
WHERE  status = 'Active'
ORDER  BY balance DESC;

-- C6. INNER JOIN : account with customer and branch
SELECT a.account_id, c.full_name, a.account_type, a.balance, b.branch_name
FROM   accounts a
JOIN   customers c ON c.customer_id = a.customer_id
JOIN   branches  b ON b.branch_id   = a.branch_id
ORDER  BY c.full_name;

-- C7. Multi-table JOIN : full statement (who did what, where, when)
SELECT t.txn_id, t.txn_date, c.full_name, a.account_type,
       t.txn_type, t.amount, t.remarks
FROM   transactions t
JOIN   accounts  a ON a.account_id  = t.account_id
JOIN   customers c ON c.customer_id = a.customer_id
ORDER  BY t.txn_date, t.txn_id;

-- C8. LEFT JOIN : customers who have no account yet
SELECT c.customer_id, c.full_name
FROM   customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
WHERE  a.account_id IS NULL;

-- C9. Customers who have BOTH an account and a loan
SELECT DISTINCT c.full_name
FROM   customers c
JOIN   accounts a ON a.customer_id = c.customer_id
JOIN   loans    l ON l.customer_id = c.customer_id;

-- C10. Subquery : accounts with balance above the bank average
SELECT account_id, account_type, balance
FROM   accounts
WHERE  balance > (SELECT AVG(balance) FROM accounts WHERE status = 'Active')
ORDER  BY balance DESC;

-- C11. Correlated subquery : accounts above the average of their own type
SELECT a.account_id, a.account_type, a.balance
FROM   accounts a
WHERE  a.balance > (SELECT AVG(balance) FROM accounts WHERE account_type = a.account_type);


/* #####################################################################
   PART D : AGGREGATION & GROUPING   (Unit 4)
   COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, GROUP BY + JOIN
   ##################################################################### */

-- D1. Aggregate functions on the whole table (Active accounts only)
SELECT COUNT(*)                AS total_accounts,
       SUM(balance)            AS total_deposits,
       ROUND(AVG(balance), 2)  AS average_balance,
       MIN(balance)            AS smallest_balance,
       MAX(balance)            AS largest_balance
FROM   accounts
WHERE  status = 'Active';

-- D2. GROUP BY : accounts and deposits by account type
SELECT account_type,
       COUNT(*)                AS accounts,
       SUM(balance)            AS total_balance,
       ROUND(AVG(balance), 2)  AS avg_balance
FROM   accounts
WHERE  status = 'Active'
GROUP  BY account_type
ORDER  BY total_balance DESC;

-- D3. GROUP BY with JOIN : branch-wise performance
SELECT b.branch_name, b.city,
       COUNT(a.account_id)     AS accounts,
       SUM(a.balance)          AS deposits_held,
       MAX(a.balance)          AS largest_account
FROM   branches b
JOIN   accounts a ON a.branch_id = b.branch_id
WHERE  a.status = 'Active'
GROUP  BY b.branch_name, b.city
ORDER  BY deposits_held DESC;

-- D4. HAVING : branches holding more than Rs. 5,00,000 in deposits
SELECT b.branch_name, SUM(a.balance) AS deposits_held
FROM   branches b
JOIN   accounts a ON a.branch_id = b.branch_id
WHERE  a.status = 'Active'
GROUP  BY b.branch_name
HAVING SUM(a.balance) > 500000;

-- D5. REPORT 1 : Cash flow by type (money in vs money out)
SELECT txn_type,
       COUNT(*)      AS transactions,
       SUM(amount)   AS total_amount,
       AVG(amount)   AS average_amount,
       MAX(amount)   AS largest
FROM   transactions
GROUP  BY txn_type;

-- D6. REPORT 2 : Monthly transaction trend
SELECT DATE_FORMAT(txn_date, '%Y-%m')                              AS month,
       SUM(CASE WHEN txn_type = 'Deposit'    THEN amount ELSE 0 END) AS money_in,
       SUM(CASE WHEN txn_type = 'Withdrawal' THEN amount ELSE 0 END) AS money_out
FROM   transactions
GROUP  BY DATE_FORMAT(txn_date, '%Y-%m')
ORDER  BY month;

-- D7. REPORT 3 : Customer relationship view - total balance per customer
SELECT c.full_name,
       COUNT(a.account_id)  AS accounts_held,
       SUM(a.balance)       AS total_balance
FROM   customers c
JOIN   accounts a ON a.customer_id = c.customer_id
WHERE  a.status = 'Active'
GROUP  BY c.full_name
HAVING SUM(a.balance) >= 200000
ORDER  BY total_balance DESC;

-- D8. REPORT 4 : Loan portfolio by type
SELECT loan_type,
       COUNT(*)                      AS loans,
       SUM(principal)                AS total_lent,
       ROUND(AVG(interest_rate), 2)  AS avg_interest_rate,
       MIN(interest_rate)            AS lowest_rate,
       MAX(interest_rate)            AS highest_rate
FROM   loans
WHERE  status = 'Active'
GROUP  BY loan_type
ORDER  BY total_lent DESC;

-- D9. WHERE vs HAVING together : Active loans only, borrowers with more than Rs. 10 lakh outstanding
SELECT c.full_name, COUNT(l.loan_id) AS active_loans, SUM(l.principal) AS total_borrowed
FROM   customers c
JOIN   loans l ON l.customer_id = c.customer_id
WHERE  l.status = 'Active'                                     -- before grouping
GROUP  BY c.full_name
HAVING SUM(l.principal) > 1000000;                             -- after grouping

-- D10. REPORT 5 : Which customers are net savers? (deposits minus withdrawals per customer)
SELECT c.full_name,
       SUM(CASE WHEN t.txn_type = 'Deposit' THEN t.amount ELSE -t.amount END) AS net_flow
FROM   transactions t
JOIN   accounts  a ON a.account_id  = t.account_id
JOIN   customers c ON c.customer_id = a.customer_id
GROUP  BY c.full_name
ORDER  BY net_flow DESC;


/* #####################################################################
   PART E : DCL - DATA CONTROL LANGUAGE   (Unit 1)
   Commands: GRANT, REVOKE      (run as root / admin user)
   ##################################################################### */

-- E1. Create users
CREATE USER 'bank_teller'@'localhost'     IDENTIFIED BY 'Teller@123';
CREATE USER 'loan_officer'@'localhost'    IDENTIFIED BY 'Loan@123';
CREATE USER 'internal_auditor'@'localhost' IDENTIFIED BY 'Audit@123';

-- E2. GRANT permissions
GRANT SELECT                 ON BankDB.customers    TO 'bank_teller'@'localhost';
GRANT SELECT, UPDATE         ON BankDB.accounts     TO 'bank_teller'@'localhost';
GRANT SELECT, INSERT         ON BankDB.transactions TO 'bank_teller'@'localhost';

GRANT SELECT, INSERT, UPDATE ON BankDB.loans        TO 'loan_officer'@'localhost';
GRANT SELECT                 ON BankDB.customers    TO 'loan_officer'@'localhost';

-- Read-only access for the auditor across the whole database
GRANT SELECT ON BankDB.* TO 'internal_auditor'@'localhost';

SHOW GRANTS FOR 'bank_teller'@'localhost';
SHOW GRANTS FOR 'loan_officer'@'localhost';

-- E3. REVOKE permissions
REVOKE UPDATE ON BankDB.accounts FROM 'bank_teller'@'localhost';       -- teller can no longer change balances directly
REVOKE UPDATE ON BankDB.loans    FROM 'loan_officer'@'localhost';

SHOW GRANTS FOR 'bank_teller'@'localhost';

-- E4. Clean up users
DROP USER 'bank_teller'@'localhost';
DROP USER 'loan_officer'@'localhost';
DROP USER 'internal_auditor'@'localhost';


/* #####################################################################
   PART F : TCL - TRANSACTION CONTROL LANGUAGE   (Unit 1)
   Commands: COMMIT, ROLLBACK, SAVEPOINT
   Note: DDL statements (CREATE, ALTER, DROP, TRUNCATE) auto-commit in MySQL.
   ##################################################################### */

-- F1. COMMIT : save changes permanently
SET autocommit = 0;

START TRANSACTION;
UPDATE customers SET credit_score = credit_score + 10 WHERE customer_id = 4;   -- timely repayments
COMMIT;

-- F2. ROLLBACK : discard changes
START TRANSACTION;
UPDATE accounts SET balance = 0 WHERE account_id = 7;                          -- wrong account by mistake!
SELECT account_id, balance FROM accounts WHERE account_id = 7;
ROLLBACK;                                                                      -- undo it
SELECT account_id, balance FROM accounts WHERE account_id = 7;                 -- restored

-- F3. SAVEPOINT : partial rollback in one transaction
START TRANSACTION;

UPDATE customers SET credit_score = credit_score + 20 WHERE customer_id = 5;
SAVEPOINT after_score;

UPDATE customers SET city = 'Unknown' WHERE customer_id = 5;                   -- mistake
SAVEPOINT after_city;

ROLLBACK TO SAVEPOINT after_score;                                             -- undo only the city change
COMMIT;

SELECT customer_id, full_name, city, credit_score FROM customers WHERE customer_id = 5;

-- F4. THE CLASSIC : fund transfer of Rs. 10,000 from account 3 to account 1
--     Both the debit and the credit must succeed together, or neither should happen.
START TRANSACTION;

UPDATE accounts SET balance = balance - 10000.00 WHERE account_id = 3;         -- step 1: debit
UPDATE accounts SET balance = balance + 10000.00 WHERE account_id = 1;         -- step 2: credit

INSERT INTO transactions (account_id, txn_type, amount, txn_date, remarks) VALUES
(3, 'Withdrawal', 10000.00, '2026-09-29', 'Transfer to account 1'),
(1, 'Deposit',    10000.00, '2026-09-29', 'Transfer from account 3');

-- Check both balances before deciding:
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 3);

-- If everything looks right -> COMMIT;     If anything failed -> ROLLBACK;
COMMIT;

-- F5. A failed transfer : the power fails after the debit, so we ROLLBACK
START TRANSACTION;
UPDATE accounts SET balance = balance - 5000.00 WHERE account_id = 3;          -- debit done...
-- ...system error before the credit step! Cancel everything:
ROLLBACK;
SELECT account_id, balance FROM accounts WHERE account_id = 3;                 -- unchanged

SET autocommit = 1;

/* ============================== END OF PROGRAMME ============================== */
