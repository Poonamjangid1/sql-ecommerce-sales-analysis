-- CREATE TABLES

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE
);

-- INSERT DATA

INSERT INTO Customers VALUES
(1, 'Asha', 'Delhi'),
(2, 'Ravi', 'Mumbai'),
(3, 'Neha', 'Bangalore'),
(4, 'Karan', 'Pune'),
(5, 'Tina', 'Chennai');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 60000),
(102, 'Phone', 'Electronics', 30000),
(103, 'Shoes', 'Fashion', 4000),
(104, 'Watch', 'Accessories', 5000),
(105, 'Bag', 'Fashion', 2000);

INSERT INTO Orders VALUES
(1, 1, 101, 1, '2025-01-10'),
(2, 2, 102, 2, '2025-01-12'),
(3, 3, 103, 3, '2025-01-15'),
(4, 1, 104, 1, '2025-01-20'),
(5, 4, 105, 2, '2025-02-01'),
(6, 5, 101, 1, '2025-02-05'),
(7, 2, 103, 2, '2025-02-08'),
(8, 3, 102, 1, '2025-02-15');


-- PROJECT QUERIES


SELECT c.customer_name,
       p.product_name,
       o.quantity
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id;

SELECT o.order_id,
       c.customer_name,
       p.product_name,
       o.quantity,
       p.price,
       (o.quantity * p.price) AS total_amount
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id;


SELECT p.product_name,
       SUM(o.quantity * p.price) AS total_revenue
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY p.product_name;

SELECT c.customer_name,
       SUM(o.quantity * p.price) AS total_spent
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

SELECT p.product_name,
       SUM(o.quantity) AS total_quantity_sold
FROM Orders AS o
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

SELECT MONTH(o.order_date) AS month,
       SUM(o.quantity * p.price) AS revenue
FROM Orders AS o
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY MONTH(o.order_date);

SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING  COUNT(o.order_id) > 1;

SELECT p.product_name
FROM Products AS p
LEFT JOIN Orders AS o
ON o.product_id = p.product_id
WHERE o.order_id IS NULL;

SELECT c.customer_name,
       SUM(o.quantity * p.price) AS total_spent
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1 OFFSET 1;

SELECT p.category,
       SUM(o.quantity * p.price) AS revenue
FROM Products AS p
JOIN Orders AS o
ON p.product_id = o.product_id
GROUP BY p.category;

SELECT c.customer_name
FROM Customers AS c
LEFT JOIN Orders AS o
ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

SELECT p.product_name,
       SUM(o.quantity * p.price) AS revenue
FROM Products AS p
JOIN Orders AS o
ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY SUM(o.quantity * p.price) DESC
LIMIT 3;

SELECT c.customer_name,
       AVG(o.quantity * p.price) AS avg_order_value
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY c.customer_name;

SELECT p.product_name,
       (o.quantity * p.price) AS order_amount
FROM Products AS p
JOIN Orders AS o
ON p.product_id = o.product_id
ORDER BY order_amount DESC
LIMIT 1;

SELECT c.customer_name,
       SUM(o.quantity * p.price) AS total_spending
FROM Customers AS c
JOIN Orders AS o
ON o.customer_id = c.customer_id
JOIN Products AS p
ON p.product_id = o.product_id
GROUP BY c.customer_name
HAVING SUM(o.quantity * p.price) >
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT SUM(o.quantity * p.price) AS customer_total
        FROM Orders AS o
        JOIN Products AS p
        ON p.product_id = o.product_id
        GROUP BY o.customer_id
    ) AS avg_table
);