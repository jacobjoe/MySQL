/*Create a Database*/
CREATE DATABASE store;

/*To see all Databases*/
SHOW DATABASES;

/*Use a Partiucular Database*/
USE store;

/*To create a Table*/
CREATE TABLE customer_details(
customer_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(10) NOT NULL,
birth_date DATE NOT NULL,
city VARCHAR(10) NOT NULL, 
PRIMARY KEY(customer_id)
);

/*To rename Tablename*/
ALTER TABLE customer_details 
RENAME customers;

/*To see all columns*/
DESCRIBE customers;

/*To modify column in Table*/
ALTER TABLE customers 
MODIFY city VARCHAR(20) NOT NULL;

/*To add a Column*/
ALTER TABLE customers 
ADD gender VARCHAR(10) NOT NULL 
AFTER name;

/*Insert values into Tables*/
INSERT INTO customers
	(name, gender, birth_date, city)
VALUES 
	('Raj', 'Male', '1996-06--04', 'Chennai'),
	('William', 'Male', '1993-11-01', 'Tirunelveli'),
	('Catherine', 'Female', '1997-08-17', 'Madurai'),
	('Mahendran', 'Male', '1999-06--04', 'Chennai'),
	('Peter', 'Male', '1993-11-08', 'Trichy'),
	('Mary', 'Female', '1993-05-17', 'Madurai');
  
/*To see entire Table*/
SELECT * 
FROM customers;

/*To Filter the Table*/
SELECT * 
FROM customers
WHERE gender = 'Male';

/*To filter multiple condition use AND*/
SELECT * 
FROM customers
WHERE gender = 'Male' AND city = 'Chennai';

/*Use IN for select particular word in entire Column*/
SELECT *
FROM customers
WHERE gender = 'Male' AND city in ('Chennai', 'Trichy');

/*NOT use for inverse Selection*/
SELECT *
FROM customers
WHERE city NOT IN ('Chennai', 'Trichy');

/*To select a particular Column on Table*/
SELECT city 
FROM customers;

/*BETWEEN use for select a particular range*/
/*ORDER BY use for Sort the value*/
SELECT
	name,
	birth_date
FROM customers
WHERE birth_date BETWEEN 
	'1993-01-01' AND '1997-01-01'
ORDER BY birth_date;

/*OR use to select both Condition*/
SELECT * 
FROM customers
WHERE gender = 'Female'
	OR birth_date < '1995-01-01'
ORDER BY birth_date;

/*for Unique selection use DISTINCT*/
SELECT DISTINCT city
FROM customers;

/*GROUP BY use to see count of each City*/
SELECT 	
	city,
	COUNT(city) AS 'No of cities'
FROM customers
GROUP BY city;

/*LIMIT use to set limit of Table*/
SELECT *
FROM customers
ORDER BY points DESC, birth_date 
LIMIT 3;

/*LIKE use to search String*/
SELECT *
FROM customers
WHERE name LIKE 'M%';

/*REGEXP use to powerful search on String*/
SELECT *
FROM customers
WHERE name REGEXP '^M';

SELECT *
FROM customers
WHERE name REGEXP 'will|ary';

SELECT *
FROM customers
WHERE name REGEXP 'm[a-h]';

/*IS NULL use to search NULL values*/
/*IS NOT NULL use to search NOT NULL values*/
SELECT *
FROM customers
WHERE points IS NOT NULL;

ALTER TABLE customers
ADD Points INT NOT NULL;

/*UPDATE the table value*/
UPDATE customers
SET points = 1200
WHERE customer_id IN (1, 4);

UPDATE customers
SET points = 1000
WHERE customer_id IN (2, 3, 5, 6);

/*To CREATE a VIEW*/
CREATE VIEW customer_discount AS
SELECT
	customer_id,
	name,
	points,
	CASE
		WHEN points > 1000 THEN points * 0.1  
		ELSE 'No Discount'
	END AS Discount
FROM customers;

/*FULL TABLES to see all types of Tables in the Database*/
SHOW FULL TABLES;

CREATE TABLE Point_logs(
id INT NOT NULL AUTO_INCREMENT,
customer_id INT NOT NULL,
points INT NOT NULL,
new_points INT NOT NULL,
PRIMARY KEY(id)
);

/*To Create a TRIGGER*/
/*Change delimiter as $$ On Mysqlcmd */
/*Below queries are perform in mysqlcmd*/
/*
CREATE TRIGGER before_point_update	
	BEFORE UPDATE ON customers
	FOR EACH ROW
BEGIN
	INSERT INTO point_logs(customer_id, points, new_points)
	VALUES(OLD.customer_id, OLD.points, NEW.points);
END $$ */

UPDATE customers SET points = 1300
WHERE customer_id = 5;

SELECT *
FROM point_logs;

/*To create a copy of a Table*/
CREATE TABLE customer_copy AS
SELECT *
FROM customers;

/*To see all Tables*/
SHOW TABLES;

/*To delete a ROW in the Table*/
DELETE 
FROM customers
WHERE customer_id = 3;

/To Empty the Table/
TRUNCATE TABLE customers;

SELECT *
FROM customers;

/*To Drop a Table*/
DROP TABLE customers;

/*To Drop a Database*/
DROP DATABASE store;

/*JOINS*/
/*INNER JOIN*/
SELECT 
	orders.order_Id,
	customers.customer_id,
	customers.first_name,
	customers.last_name
FROM orders 
JOIN customers  
	ON customers.customer_id = orders.customer_id;
    
/*To Create ALIAS*/
SELECT 
	o.order_Id,
	c.customer_id,
	c.first_name,
	c.last_name
FROM orders o
JOIN customers c
	ON c.customer_id = o.customer_id;
    
/*While JOIN two tables using same column name use USING*/
SELECT 
	o.order_Id,
	c.customer_id,
	c.first_name,
	c.last_name
FROM orders o
JOIN customers c
	USING(customer_id);
    
/*JOIN ACROSS DATABASES*/
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
	USING (product_id);
    
/*SELF JOIN*/
SELECT 
	e.employee_id,
	e.first_name AS Employee,
	m.first_name AS Manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;
    
/*JOIN MULTIPLE TABLES*/
SELECT 
	o.order_id,
	o.order_date,
	c.first_name,
	c.last_name,
	os.name AS Status
FROM orders o
JOIN customers c
	USING(customer_id)
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY status, order_id;

/*COPOUND JOIN*/
/*Join using multiple columns in Two tables*/
SELECT *
FROM order_items oi
JOIN order_item_notes oin 
	ON oi.order_Id = oin.order_Id
	AND oi.product_id = oin.product_id;
    
/*IMPLICIT JOIN*/
SELECT *
FROM orders o, 
customers c
WHERE o.customer_id = c.customer_id;

/*OUTER JOIN*/
SELECT 
	c.customer_id,
	c.first_name,
	o.order_Id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

/*SELF OUTER JOIN*/
SELECT 
	e.employee_id,
	e.first_name,
	m.first_name AS Manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
/*NATURAL JOIN*/
SELECT 
	o.order_id,
	c.first_name
FROM orders o
NATURAL JOIN customers c;

/*CROSS JOIN*/
SELECT 
	c.first_name AS Customer,
	p.name AS Product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

/*UNIONS*/
/*To join more than one Select statement*/
SELECT 
	order_Id, 
	order_date,
	'Avtive' AS Status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
	order_Id, 
	order_date,
	'Archived' AS Status
FROM orders
WHERE order_date < '2019-01-01';

/*SUBQUERIES IN UPDATE STATEMENT*/
UPDATE invoices 
SET 
	payment_total = invoice_total * .1,
	payment_date = due_date
WHERE client_id = 
		(SELECT client_id
		FROM clients
		WHERE name = 'Myworks');
