-- How many orders and how much amount are there for each status?
SELECT o.status AS status,
       COUNT(*) AS number_of_orders,
       SUM(o.amount) AS total_amount
FROM orders AS o
GROUP BY o.status
ORDER BY number_of_orders DESC;
