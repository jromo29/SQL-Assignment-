use sakila;

select * from actor limit 10;

-- 1a. Display the first and last names from the table actor.

select first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters.
--   Name the column Actor Name 

-- Final answer

select concat(first_name," ",last_name) as Actor_Name from actor
-- ---------------------
-- Show Column data types
show fields from actor;

select first_name + last_name as Actor_Name from actor;

-- add new column named Actor Name

-- add column
alter table actor
add column Actor_Name varchar(45);

-- drop column
alter table actor
drop column Actor_Name;

select * from actor;

select *,concat(first_name," ",last_name) as Actor_Name 
-- into tempActor
from actor;


alter table actor
add column (select concat(first_name," ",last_name) as Actor_Name from actor );
-- -----------------------------
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

select actor_id,first_name,last_name from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN

select * from actor 
where last_name like "%gen%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select * from actor 
where last_name like "%LI%";

select * from actor 
where last_name like "%LI%"
order by last_name asc, first_name asc;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select * from country limit 10;

select * from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

describe actor;

alter table actor
add column description BLOB;

select * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

alter table actor
drop description;

select * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

-- display unique values in column
select distinct(last_name)from actor;

-- display count of values in column
select count(last_name) from actor;

-- display count of unique values in column
select count(distinct(last_name)) from actor;

-- display count of each unique value in column

-- final answer
select last_name, count(last_name) from actor
group by last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(last_name) as NameCount from actor
group by last_name
having NameCount >= 2;


-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

select * from actor
where first_name LIKE "GR%";

select * from actor
where first_name = "GROUCHO"
and last_name = "WILLIAMS";

update actor
set first_name = "HARPO"
WHERE first_name = "GROUCHO" 
and (last_name = "WILLIAMS");


select * from actor
where last_name = "WILLIAMS";


-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

-- Create duplicate table as backup

use sakila;

CREATE TABLE actor_2
select * from actor;

SELECT *
FROM
    actor_2
WHERE
    first_name = 'Groucho';

UPDATE actor_2
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- Final answer

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO"

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

describe actor_2;

explain actor;

SHOW TABLES FROM sakila;

-- Gives you the syntax to create an copy of the table
SHOW CREATE TABLE actor_2


CREATE TABLE `actor_2` (
   `actor_id` smallint(5) unsigned NOT NULL DEFAULT '0',
   `first_name` varchar(45) CHARACTER SET utf8 NOT NULL,
   `last_name` varchar(45) CHARACTER SET utf8 NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1



-- Final Answer
Show create table address;

CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `location` geometry NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT players.first_name, players.last_name, players.hand, matches.loser_rank

FROM matches

INNER JOIN players ON

players.player_id=matches.loser_id;

select * from staff;

SELECT * FROM address;

-- Final Answer
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
staff.address_id = address.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT * FROM payment; -- staff_id, amount, payment_date

SELECT * FROM staff; -- first_name, last_name

select payment.staff_id, payment.amount, month(payment.payment_date) from payment;

select staff_id, sum(amount) as TotalPayment, payment_date from payment
GROUP BY staff_id, payment_date;


select payment.staff_id, sum(payment.amount) from payment;


select staff_id, sum(amount) as TotalPayment, payment_date from payment
GROUP BY staff_id, payment_date
having month(payment_date) = 8;



select staff_id, amount, payment_date from payment 
having month(payment_date) = 8;

select staff_id, sum(amount), month(payment_date) as monthnum from payment
group by staff_id
where monthnum = 8;

-- key notes - HAVING is done after aggregation, WHERE is used to filter row by row so it must be done
-- if you want to use data from a sub query you give the sub query a name
select staff_id, amount, month(payment_date) from payment
where month(payment_date) = 8;

-- final answer

select pay_aug.staff_id, sum(pay_aug.amount) as AugPayments from
(select staff_id, amount, month(payment_date) from payment
where month(payment_date) = 8) as pay_aug
GROUP BY pay_aug.staff_id;


select staff.first_name, staff.last_name, pay_aug.staff_id, sum(pay_aug.amount) as AugPayments from
(select staff_id, amount, month(payment_date) from payment
where month(payment_date) = 8) as pay_aug
GROUP BY pay_aug.staff_id
inner join staff on staff.staff_id = pay_aug.staff_id;



-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select film.film_id, film.title, film_actor.actor_id from film_actor
inner join film on
film.film_id = film_actor.film_id;


-- final answer
select all_data.film_id, all_data.title, count(all_data.actor_id) as ActorCount from
(select film.film_id, film.title, film_actor.actor_id from film_actor
inner join film on
film.film_id = film_actor.film_id) all_data
GROUP BY all_data.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * from inventory;

select film.title, film.film_id, inventory.inventory_id, inventory.film_id from inventory
inner join film on
inventory.film_id = film.film_id;

select film.title, film.film_id, inventory.inventory_id, inventory.film_id from inventory
inner join film on
inventory.film_id = film.film_id
having film.title = "Hunchback Impossible";


-- Final Answer
select FilmInven.film_id, FilmInven.title, count(FilmInven.inventory_id) as TotalInventory from
(select film.title, film.film_id as F_ID, inventory.inventory_id, inventory.film_id from inventory
inner join film on
inventory.film_id = film.film_id
having film.title = "Hunchback Impossible" ) FilmInven;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:


select payment.payment_id, payment.amount, payment.customer_id, customer.first_name, customer.last_name from customer
inner join payment on
payment.customer_id = customer.customer_id;

-- best final Answer
select customer.first_name, customer.last_name, sum(payment.amount) from customer
inner join payment on
payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name asc;


-- Final Answer - do not use 
select pay_data.first_name, pay_data.last_name, sum(pay_data.amount) from
(
select payment.payment_id, payment.amount, payment.customer_id, customer.first_name, customer.last_name from customer
inner join payment on
payment.customer_id = customer.customer_id) as pay_data
group by pay_data.customer_id
ORDER BY pay_data.last_name ASC;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select title, film_id from film;

select title, film_id from film
where title like "K%"
or title like "Q%";


select film.title, film.film_id, film.language_id, language.name from  language
inner join film on
film.language_id = language.language_id;


-- Final Answer
select film2.film_id, film2.title, film2.name from
(select film.title, film.film_id, film.language_id, language.name from  language
inner join film on
film.language_id = language.language_id) as film2
where film2.title like "K%"
or film2.title like "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select film.film_id, film.title, film_actor.actor_id from film_actor
inner join film on
film.film_id = film_actor.film_id;


select actor.actor_id, actor.first_name, actor.last_name, film1.title from 
(
select film.film_id, film.title, film_actor.actor_id from film_actor
inner join film on
film.film_id = film_actor.film_id) as film1
inner join actor on
actor.actor_id = film1.actor_id;

-- Final Answer
select actor.actor_id, actor.first_name, actor.last_name, film1.title from 
(
select film.film_id, film.title, film_actor.actor_id from film_actor
inner join film on
film.film_id = film_actor.film_id) as film1
inner join actor on
actor.actor_id = film1.actor_id
where film1.title = "Alone Trip";

-- 7c. You want to run an email marketing campaign in Canada, for which you will need 
-- the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select city.city_id, city.city, city.country_id, country.country from country
inner join city on
city.country_id = country.country_id;


select address.address_id, address.city_id, C.country from
(select city.city_id, city.city, city.country_id, country.country from country
inner join city on
city.country_id = country.country_id) as C
inner join address on 
address.city_id = C.city_id;

-- Final Answer
select customer.first_name, customer.last_name, customer.email, A.country from
(select address.address_id, address.city_id, C.country from
	(select city.city_id, city.city, city.country_id, country.country from country
	inner join city on
	city.country_id = country.country_id) as C
inner join address on 
address.city_id = C.city_id) as A
inner join customer on
customer.address_id = A.address_id
having A.country = "Canada";


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

use sakila;

select * from category;

select * from film_category;


select film_category.film_id, film_category.category_id, category.category_id, category.name from category
inner join film_category on
category.category_id = film_category.category_id;

-- Final Answer
select FilmType.film_id, FilmType.name, film.title from
(
select film_category.film_id, film_category.category_id, category.name from category
inner join film_category on
category.category_id = film_category.category_id) as FilmType
inner join film on 
film.film_id = FilmType.film_id
having name = "FAMILY";

-- 7e. Display the most frequently rented movies in descending order.

select film.film_id, film.title, inventory.inventory_id from inventory
inner join film on
film.film_id = inventory.film_id;



select rental.rental_date, FilmInfo.film_id, FilmInfo.title from
(
select film.film_id, film.title, inventory.inventory_id from inventory
inner join film on
film.film_id = inventory.film_id) as FilmInfo
inner join rental on
rental.inventory_id = FilmInfo.inventory_id;


-- Final Answer
select FilmInfo.film_id, FilmInfo.title, count(rental.rental_date) as RentalCount from
(
select film.film_id, film.title, inventory.inventory_id from inventory
inner join film on
film.film_id = inventory.film_id) as FilmInfo
inner join rental on
rental.inventory_id = FilmInfo.inventory_id
group by FilmInfo.film_id
order by RentalCount desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in.

select * from payment;

select payment.amount, payment.rental_id, rental.inventory_id from rental
inner join payment on
payment.rental_id = rental.rental_id;


select inventory.store_id, RentalInfo.amount, RentalInfo.inventory_id from
(
select payment.amount, payment.rental_id, rental.inventory_id from rental
inner join payment on
payment.rental_id = rental.rental_id) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id;


select inventory.store_id, RentalInfo.amount, RentalInfo.inventory_id from
(
select payment.amount, payment.rental_id, rental.inventory_id from rental
inner join payment on
payment.rental_id = rental.rental_id) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id;


select StoreInfo.store_id, store.address_id, StoreInfo.amount from
(
	select inventory.store_id, RentalInfo.amount, RentalInfo.inventory_id from

		(
		select payment.amount, payment.rental_id, rental.inventory_id from rental
		inner join payment on
		payment.rental_id = rental.rental_id) as RentalInfo

	inner join inventory on
	inventory.inventory_id = RentalInfo.inventory_id) as StoreInfo

inner join store on
store.store_id = StoreInfo.store_id;


-- Final Answer
select StoreAmount.store_id, address.address, sum(StoreAmount.amount) as Gross_Sales from
(
	select StoreInfo.store_id, store.address_id, StoreInfo.amount from
	(
		select inventory.store_id, RentalInfo.amount, RentalInfo.inventory_id from

			(
			select payment.amount, payment.rental_id, rental.inventory_id from rental
			inner join payment on
			payment.rental_id = rental.rental_id) as RentalInfo

		inner join inventory on
		inventory.inventory_id = RentalInfo.inventory_id) as StoreInfo

	inner join store on
	store.store_id = StoreInfo.store_id) as StoreAmount

inner join address on 
address.address_id = StoreAmount.address_id
group by StoreAmount.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.

select store.store_id, address.city_id from address
inner join store on
store.address_id = address.address_id;


select AddressInfo.store_id, AddressInfo.city_id, city.city, city.country_id from
(
	select store.store_id, address.city_id from address
	inner join store on
	store.address_id = address.address_id
) as AddressInfo
 
 inner join city on 
 city.city_id = AddressInfo.city_id;
 
-- Final Answer

select CityInfo.store_id, CityInfo.city, country.country from
(
	select AddressInfo.store_id, AddressInfo.city_id, city.city, city.country_id from
	(
		select store.store_id, address.city_id from address
		inner join store on
		store.address_id = address.address_id
	) as AddressInfo
 
	inner join city on 
	city.city_id = AddressInfo.city_id

) as CityInfo
inner join country on
country.country_id = CityInfo.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)


select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id;
 
select RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount from
( 
select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id
) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id;



select film_category.category_id, FilmInfo.amount from
(
select RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount from
( 
select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id
) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id
)as FilmInfo
inner join film_category on
film_category.film_id = FilmInfo.film_id;



select category.category_id, category.name, GenreAmounts.amount from
(
select film_category.category_id, FilmInfo.amount from
(
select RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount from
( 
select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id
) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id
)as FilmInfo
inner join film_category on
film_category.film_id = FilmInfo.film_id
) as GenreAmounts
inner join category on
category.category_id = GenreAmounts.category_id;


-- Final Answer

select category.category_id, category.name, sum(GenreAmounts.amount) as Total_Sales from
(
select film_category.category_id, FilmInfo.amount from
(
select RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount from
( 
select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id
) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id
)as FilmInfo
inner join film_category on
film_category.film_id = FilmInfo.film_id
) as GenreAmounts 
inner join category on
category.category_id = GenreAmounts.category_id
group by category.category_id
ORDER BY Total_Sales DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view Top_Genres as
select category.category_id, category.name, sum(GenreAmounts.amount) as Total_Sales from
(
select film_category.category_id, FilmInfo.amount from
(
select RentalInfo.inventory_id, inventory.film_id, RentalInfo.amount from
( 
select rental.rental_id, rental.inventory_id, payment.amount from payment
inner join rental on
rental.rental_id = payment.rental_id
) as RentalInfo
inner join inventory on
inventory.inventory_id = RentalInfo.inventory_id
)as FilmInfo
inner join film_category on
film_category.film_id = FilmInfo.film_id
) as GenreAmounts 
inner join category on
category.category_id = GenreAmounts.category_id
group by category.category_id
ORDER BY Total_Sales DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

select *  
from Top_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view Top_Genres;





