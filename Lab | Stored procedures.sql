# Lab | Stored procedures
# 1. Convert the query into a simple stored procedure.
DELIMITER $$
CREATE PROCEDURE `action_films_customers`()
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = "Action"
  GROUP BY first_name, last_name, email;
END $$
DELIMITER ;

call action_films_customers(); 

# 2. Now keep working on the previous stored procedure to make it more dynamic
DELIMITER $$
CREATE PROCEDURE `get_customers_by_category`(IN category_name VARCHAR(50))
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = category_name
  GROUP BY first_name, last_name, email;
END $$
DELIMITER ;

CALL get_customers_by_category("Animation");

# 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

# Number of movies released in each movie category

SELECT category.name, COUNT(film.film_id) AS num_films
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name;

DELIMITER $$
CREATE PROCEDURE `get_categories_with_num_films`(IN min_films INT)
BEGIN
  SELECT category.name, COUNT(film.film_id) AS num_films
  FROM category
  JOIN film_category ON category.category_id = film_category.category_id
  JOIN film ON film_category.film_id = film.film_id
  GROUP BY category.name
  HAVING num_films >= min_films;
END $$
DELIMITER ;

CALL get_categories_with_num_films(10);


