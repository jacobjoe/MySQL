SELECT 
  c.customer_id,
  c.first_name AS Name,
  c.points,
  o.order_Id,
  oi.product_id,
  p.name AS Product,
  o.shipper_id,
  sh.name AS Shipper,
  os.name AS Status
FROM customers c
JOIN orders o
  USING(customer_id)
JOIN order_statuses os
	ON o.status = os.order_status_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_items oi
	ON oi.order_Id = o.order_Id
JOIN products p
	ON p.product_id = oi.product_id
ORDER BY customer_id;

SELECT 
  c.customer_id,
  c.first_name,
  os.name AS Status
FROM customers c
JOIN orders o
	USING(customer_id)
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY customer_id;

CREATE TABLE Total_cost AS
SELECT 
	c.customer_id,
  c.first_name,
  o.order_Id,
  oi.quantity,
  oi.unit_price,
  oi.quantity * oi.unit_price AS Cost 
FROM customers c
JOIN orders o
	USING(customer_id)
JOIN order_items oi
	ON o.order_Id = oi.order_id
ORDER BY Cost DESC;

SELECT 
	customer_id,
	first_name,
  SUM(Cost) AS Total_cost
FROM total_cost
GROUP BY customer_id
ORDER BY total_cost DESC;

SELECT 
	sh.shipper_id,
  sh.name AS Shipper,
  c.first_name AS Customer,
  os.name AS Status
FROM shippers sh
LEFT JOIN orders o
	USING (Shipper_id)
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY sh.shipper_id;

SELECT 
	sh.shipper_id,
  sh.name AS Shipper,
  p.name AS Product,
  p.quantity_in_stock,
  oi.quantity AS Order_quantity,
  oi.unit_price,
  oi.quantity * oi.unit_price AS Cost
FROM shippers sh
JOIN orders o
	ON sh.shipper_id = o.shipper_id
JOIN order_items oi
	ON o.order_id = oi.order_id
JOIN products p
	ON oi.product_id = p.product_id;
    
SELECT 
	p.name AS Products,
  p.quantity_in_stock,
  p.quantity_in_stock * oi.unit_price AS Total_quantity_price,
  SUM(oi.quantity) AS Order_quantity,
  SUM(oi.quantity) * oi.unit_price AS Ordered_items_price,
  p.quantity_in_stock - SUM(oi.quantity) AS Remaining_stock,
  (p.quantity_in_stock - SUM(oi.quantity))* oi.unit_price AS Remaining_product_price
FROM products p
JOIN order_items oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id;

SELECT 
	os.name AS Status,
  SUM(oi.quantity * oi.unit_price) AS Cost
FROM order_statuses os
LEFT JOIN orders o
	ON os.order_status_id = o.status
LEFT JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY os.name;
