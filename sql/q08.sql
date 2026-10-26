-- What is the customer age profile by region?
SELECT c.region AS region,
       COUNT(*) AS number_of_customers,
       AVG(c.age) AS average_age,
       MIN(c.age) AS min_age,
       MAX(c.age) AS max_age
FROM customers AS c
GROUP BY c.region
ORDER BY c.region ASC;
