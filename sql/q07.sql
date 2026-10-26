-- Which completed products have revenue greater than 20000?
SELECT o.item AS item,
       COUNT(*) AS number_of_orders,
       SUM(o.amount) AS revenue
FROM orders AS o
WHERE o.status = 'completed'
GROUP BY o.item
HAVING SUM(o.amount) > 20000
ORDER BY revenue DESC;
