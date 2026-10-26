-- What is the enriched order-level fact table for every order?
SELECT o.order_id AS order_id,
       o.order_month AS order_month,
       c.first_name AS first_name,
       c.last_name AS last_name,
       c.region AS region,
       r.rep_name AS rep_name,
       o.item AS item,
       o.quantity AS quantity,
       o.amount AS amount,
       o.status AS status
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN reps AS r ON c.rep_id = r.rep_id
ORDER BY o.order_id ASC;
