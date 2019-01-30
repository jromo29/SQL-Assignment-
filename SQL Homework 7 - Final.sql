use sakila;

-- 1a. Display the first and last names from the table actor.

SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters.
--   Name the column Actor Name 

SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor;
    
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN

SELECT *
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC , first_name ASC;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT *
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

DESCRIBE actor;

ALTER TABLE actor
ADD COLUMN description BLOB;

SELECT * FROM actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor
DROP description;

SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name AS First_Name, COUNT(last_name) AS Last_Name 
FROM actor
GROUP BY last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(last_name) AS NameCount 
FROM actor
GROUP BY last_name
HAVING NameCount >= 2;


-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" 
AND (last_name = "WILLIAMS");


SELECT * FROM actor
WHERE last_name = "WILLIAMS";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

-- Create duplicate table as backup

CREATE TABLE actor_2
select * from actor;

SELECT *
FROM actor_2
WHERE first_name = 'Groucho';

UPDATE actor_2
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- Final answer

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO"

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

DESCRIBE actor_2;

EXPLAIN actor;

SHOW TABLES FROM sakila;

-- Final Answer
SHOW CREATE TABLE address;

-- Output from Query
CREATE TABLE `address` (
   `address_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
   `address` VARCHAR(50) NOT NULL,
   `address2` VARCHAR(50) DEFAULT NULL,
   `district` VARCHAR(20) NOT NULL,
   `city_id` SMALLINT(5) UNSIGNED NOT NULL,
   `postal_code` VARCHAR(10) DEFAULT NULL,
   `phone` VARCHAR(20) NOT NULL,
   `location` GEOMETRY NOT NULL,
   `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=INNODB AUTO_INCREMENT=606 DEFAULT CHARSET=UTF8;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff 
ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.


SELECT pay_aug.staff_id, SUM(pay_aug.amount) AS AugPayments 
FROM (
	SELECT staff_id, amount, MONTH(payment_date) FROM payment
	WHERE MONTH(payment_date) = 8
    ) AS pay_aug
GROUP BY pay_aug.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT all_data.film_id, all_data.title, COUNT(all_data.actor_id) AS ActorCount 
FROM (
	SELECT film.film_id, film.title, film_actor.actor_id FROM film_actor
	INNER JOIN film 
    ON film.film_id = film_actor.film_id
    ) AS all_data
GROUP BY all_data.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT FilmInven.film_id, FilmInven.title, COUNT(FilmInven.inventory_id) AS Total_Inventory 
FROM (
	SELECT film.title, film.film_id AS F_ID, inventory.inventory_id, inventory.film_id 
    FROM inventory
	INNER JOIN film 
    ON inventory.film_id = film.film_id
	HAVING film.title = "Hunchback Impossible" ) FilmInven;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS Total_Cust_Revenue
FROM customer
INNER JOIN payment 
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.


SELECT film2.film_id, film2.title, film2.name 
FROM (
	SELECT film.title, film.film_id, film.language_id, language.name FROM  language
	INNER JOIN film 
    ON film.language_id = language.language_id
    ) AS film2
WHERE film2.title LIKE "K%"
OR film2.title LIKE "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.


SELECT actor.actor_id, actor.first_name, actor.last_name, film1.title 
FROM (
	SELECT film.film_id, film.title, film_actor.actor_id 
    FROM film_actor
	INNER JOIN film 
    ON film.film_id = film_actor.film_id
    ) AS film1
INNER JOIN actor 
ON actor.actor_id = film1.actor_id
WHERE film1.title = "Alone Trip";

-- 7c. You want to run an email marketing campaign in Canada, for which you will need 
-- the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT customer.first_name, customer.last_name, customer.email, A.country 
FROM(
	SELECT address.address_id, address.city_id, C.country 
    FROM(
		SELECT city.city_id, city.city, city.country_id, country.country 
        FROM country
		INNER JOIN city 
        ON city.country_id = country.country_id
        ) AS C
	INNER JOIN address 
    ON address.city_id = C.city_id
    ) AS A
INNER JOIN customer 
ON customer.address_id = A.address_id
HAVING A.country = "Canada";


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.


SELECT FilmType.film_id, FilmType.name, film.title 
FROM (
	SELECT film_category.film_id, film_category.category_id, category.name 
    FROM category
	INNER JOIN film_category 
    ON category.category_id = film_category.category_id
    ) AS FilmType
INNER JOIN film 
ON film.film_id = FilmType.film_id
HAVING name = "FAMILY";

-- 7e. Display the most frequently rented movies in descending order.

SELECT FilmInfo.film_id, FilmInfo.title, COUNT(rental.rental_date) AS RentalCount 
FROM (
	SELECT film.film_id, film.title, inventory.inventory_id 
    FROM inventory
	INNER JOIN film 
    ON film.film_id = inventory.film_id
    ) AS FilmInfo
INNER JOIN rental 
ON rental.inventory_id = FilmInfo.inventory_id
GROUP BY FilmInfo.film_id
ORDER BY RentalCount DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT StoreAmount.store_id, address.address as Store_Location, SUM(StoreAmount.amount) AS Gross_Sales 
FROM (
	
    SELECT StoreInfo.store_id, store.address_id, StoreInfo.amount 
    FROM (
		
        SELECT inventory.store_id, RentalInfo.amount, RentalInfo.inventory_id 
        FROM (
			
            SELECT payment.amount, payment.rental_id, rental.inventory_id 
            FROM rental
			INNER JOIN payment 
            ON payment.rental_id = rental.rental_id
            ) AS RentalInfo

		INNER JOIN inventory 
        ON inventory.inventory_id = RentalInfo.inventory_id
        ) AS StoreInfo

	INNER JOIN store 
    ON store.store_id = StoreInfo.store_id
    ) AS StoreAmount

INNER JOIN address 
ON address.address_id = StoreAmount.address_id
GROUP BY StoreAmount.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT CityInfo.store_id, CityInfo.city, country.country 
FROM(
	
    SELECT AddressInfo.store_id, AddressInfo.city_id, city.city, city.country_id 
    FROM (
		
        SELECT store.store_id, address.city_id 
        FROM address
		INNER JOIN store 
        ON store.address_id = address.address_id
		) AS AddressInfo
 
	INNER JOIN city 
    ON city.city_id = AddressInfo.city_id
	) AS CityInfo

INNER JOIN country 
ON country.country_id = CityInfo.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)


SELECT category.category_id, category.name, SUM(GenreAmounts.amount) AS Total_Sales 
FROM (
	
    SELECT film_category.category_id, FilmInfo.amount 
    FROM (
    
		SELECT RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount 
        FROM ( 
        
			SELECT rental.rental_id, rental.inventory_id, payment.amount 
            FROM payment
			INNER JOIN rental 
            ON rental.rental_id = payment.rental_id
			) AS RentalInfo

		INNER JOIN inventory 
        ON inventory.inventory_id = RentalInfo.inventory_id
		)AS FilmInfo
        
	INNER JOIN film_category 
    ON film_category.film_id = FilmInfo.film_id
	) AS GenreAmounts 
    
INNER JOIN category 
ON category.category_id = GenreAmounts.category_id
GROUP BY category.category_id
ORDER BY Total_Sales DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_Genres AS
SELECT category.category_id, category.name, SUM(GenreAmounts.amount) AS Total_Sales 
FROM (
	
    SELECT film_category.category_id, FilmInfo.amount 
    FROM (
    
		SELECT RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount 
        FROM ( 
        
			SELECT rental.rental_id, rental.inventory_id, payment.amount 
            FROM payment
			INNER JOIN rental 
            ON rental.rental_id = payment.rental_id
			) AS RentalInfo

		INNER JOIN inventory 
        ON inventory.inventory_id = RentalInfo.inventory_id
		)AS FilmInfo
        
	INNER JOIN film_category 
    ON film_category.film_id = FilmInfo.film_id
	) AS GenreAmounts 
    
INNER JOIN category 
ON category.category_id = GenreAmounts.category_id
GROUP BY category.category_id
ORDER BY Total_Sales DESC
LIMIT 5;


-- 8b. How would you display the view that you created in 8a?

SELECT *  
FROM Top_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_Genres;





