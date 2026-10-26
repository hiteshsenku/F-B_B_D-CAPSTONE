-- What is the completed-order performance by customer region and month?
-- INNER JOIN is appropriate because only completed orders with matching customers are reported; COUNT(DISTINCT ...) avoids counting a customer more than once when they place multiple orders in the same region-month.
SELECT c.region AS region,
       o.order_month AS order_month,
       COUNT(*) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region ASC, o.order_month ASC;
