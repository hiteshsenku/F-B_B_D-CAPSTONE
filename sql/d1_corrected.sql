-- D1: Completed-order revenue by customer region; retain only INR 80,000+? No: strictly greater than INR 80,000.
-- SQLite dialect. Revenue is the sum of orders.amount for completed orders only.
SELECT
    c.region AS region,
    SUM(o.amount) AS revenue
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
