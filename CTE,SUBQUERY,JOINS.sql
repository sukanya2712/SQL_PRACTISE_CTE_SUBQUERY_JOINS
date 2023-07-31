CREATE SCHEMA hr;
GO

CREATE TABLE hr.candidates(
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees(
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

INSERT INTO 
    hr.candidates(fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');


INSERT INTO 
    hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

SELECT  c.id candidate_id,c.fullname candidate_name,e.id employee_id,e.fullname employee_name
FROM  hr.candidates c INNER JOIN hr.employees e ON e.fullname = c.fullname;

select * from employees;
select * from candidates;

SELECT  c.id candidate_id,c.fullname candidate_name,e.id employee_id,e.fullname employee_name
FROM  hr.candidates c LEFT JOIN hr.employees e ON e.fullname = c.fullname;

SELECT  c.id candidate_id,c.fullname candidate_name,e.id employee_id,e.fullname employee_name
FROM  hr.candidates c RIGHT JOIN hr.employees e ON e.fullname = c.fullname;




---------------------------------------------SUBQUERY---------------------------------

SELECT * FROM sales.orders;

select order_id,order_date,customer_id from sales.orders where customer_id IN(
select customer_id from sales.customers where city ='NEW YORK') order by order_date desc;

---------------------------------nesting subquery-----------------

SELECT product_name,list_price FROM production.products WHERE list_price > (
SELECT AVG (list_price) FROM production.products WHERE brand_id IN (
SELECT brand_id FROM production.brands WHERE brand_name = 'Strider' OR brand_name = 'Trek'
)
)
ORDER BY list_price;
-------------------------------------------------------------cte--------------------------------------------------------------

WITH cte_sales AS (
SELECT staff_id,COUNT(*) order_count FROM sales.orders 
WHERE YEAR(order_date) = 2018
GROUP BY staff_id
)
SELECT AVG(order_count) average_orders_by_staff FROM cte_sales;


WITH cte_customers AS (
    SELECT customer_id, COUNT(order_id) AS total_orders
    FROM sales.orders
    GROUP BY customer_id
    ORDER BY total_orders DESC
)
SELECT customer_id, total_orders
FROM cte_customers;


WITH cte_sales_amounts (staff, sales, year) AS (
SELECT first_name + ' ' + last_name,SUM(quantity * list_price * (1 - discount)),YEAR(order_date) FROM sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
 GROUP BY first_name + ' ' + last_name,year(order_date)
)

SELECT staff,sales FROM cte_sales_amount
WHERE year = 2018;
