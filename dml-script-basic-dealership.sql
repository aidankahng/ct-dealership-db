-- Now for DML and the creation of entries into our tables.

-- Start with the tables without dependencies (customer, salesperson, mechanic)

-- Adding to customer
SELECT * FROM customer;

INSERT INTO customer (
	first_name,
	last_name ,
	address 
) VALUES 
	('George', 'Berkeley', '777 Not Locke Ct'),
	('Katherine', 'Johnson', '00 Infinite Loop'),
	('Ben', 'Johns', '65-6 Pickle Pl'),
	('Chuck', 'Yeager', 'Mach 1.05 Breakthrough Ave'),
	('Miyoko', 'Watai', 'Rh3 Queenpin ave');

SELECT * FROM customer;
-- Okay now we have 5 customers in our database

-- Creating a procedure to add new customers
CREATE OR REPLACE PROCEDURE new_customer (
	given_first_name VARCHAR(50),
	given_last_name VARCHAR(50),
	given_address VARCHAR(50)
) LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO customer (
	first_name,
	last_name ,
	address 
	) VALUES (
		given_first_name, 
		given_last_name,
		given_address
		);
END;
$$;

--test by adding a random person
CALL new_customer('test-cust', 'last', '111 simple test'); 
SELECT * FROM customer; -- It works!


-- Adding to salesperson
SELECT * FROM salesperson;

INSERT INTO salesperson (
	first_name ,
	last_name 
) VALUES
	('Lee', 'Sun'),
	('Alex', 'Lundbrook');
	
SELECT * FROM salesperson ;

-- Adding to mechanic
SELECT * FROM mechanic;

INSERT INTO mechanic (
	first_name ,
	last_name 
) VALUES
	('April', 'May'),
	('June', 'Legio VIII'),
	('Conserta', 'Felix');
	
SELECT * FROM mechanic ;

-- Now we can add entries to car
SELECT * FROM car;

INSERT INTO car (
	make, 
	model, 
	color, 
	customer_id
) VALUES
	('Honda', 'Accord', 'Silver', 3),
	('Koenigsegg', 'Jesko Absolut', 'Blue', 4),
	('Tesla', 'Model X', 'Black', 2),
	('Ford', 'Model -T', 'N/A', 1),
	('Toyota', 'Supra', 'White', 4),
	('Toyota','Shogi','Black/White',5);

-- Lets make a procedure to add cars!
CREATE OR REPLACE PROCEDURE add_car (
	given_make VARCHAR(20),
	given_model VARCHAR(20),
	given_color VARCHAR(20),
	given_cust_id INTEGER
) LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO car (
	make, 
	model, 
	color, 
	customer_id
	) VALUES (
		given_make,
		given_model,
		given_color,
		given_cust_id
		);
END;
$$;

--Try giving Ben (cust-3) a Chevy Colorado in green
CALL add_car('Chevrolet', 'Colorado', 'Green', 3);

SELECT * FROM car;
SELECT c.first_name, c.last_name, car.make, car.model 
FROM car car
JOIN customer c
ON car.customer_id = c.customer_id 
ORDER BY c.first_name ASC;
-- And now Ben has 2 cars!

-- Now that we have 6 cars... we can add invoices for some of them!
-- Lets say:
-- Ben bought his Accord for... $25,000
-- George bought his Model -T for ... $20 (I mean... cars didn't exist yet)
-- Katherine bought her Tesla for ... $80,450.22
-- the last three cars were not bought here
SELECT * FROM invoice;

INSERT INTO invoice (
	amount,
	time_created ,
	serial_number ,
	salesperson_id ,
	customer_id 
) VALUES 
	(25000, TIMESTAMP '2004-11-11 10:20:54', 1, 2, 3);
-- Now we have added the record that Ben bought his accord for 25000 from Alex

-- Lets add the other 2 cars which Lee (sales id = 1) sold
INSERT INTO invoice (
	amount,
	time_created ,
	serial_number ,
	salesperson_id ,
	customer_id 
) VALUES 
	(20, TIMESTAMP '1750-04-12 08:35:20', 4, 1, 1),
	(80450.22, TIMESTAMP '1969-07-16 20:17:00', 3, 1, 2);
-- Now we have 3 invoices each linked with a salesperson, customer, and car

-- Now for the rest of the cars we have not used... lets make service tickets!
SELECT * FROM service ;

-- do 2 at first with same timestamp
INSERT INTO service (
	amount, serial_number, customer_id 
) VALUES
	(470.12, 5, 4),
	(280.63, 6, 5);

-- add 2 more but for the same car
INSERT INTO service (
	amount, serial_number, customer_id 
) VALUES 
	(15234.33, 2, 4),
	(3700, 2, 4);

-- Now we can for each of these 4 service orders
-- add entries into work_history concerning which mechanic worked on what thing

SELECT * FROM work_history;
SELECT * FROM mechanic ;
SELECT * FROM service ;

INSERT INTO work_history ( 
	service_id,
	mechanic_id 
) VALUES
	(1,1),
	(2,3),
	(3,1),
	(3,2),
	(4,2),
	(3,3),
	(4,3);

SELECT * FROM work_history;
-- now we have some data in all our tables!

-- Example query. How much did each salesperson make from sales?
SELECT s.first_name , SUM(i.amount)
FROM salesperson s
JOIN invoice i
ON s.salesperson_id = i.salesperson_id 
GROUP BY s.salesperson_id, s.first_name;
-- Alex sold $25000 and Lee sold $80470.22

-- Example 2: Which car had the most people working on it?
SELECT c.serial_number , c.make, c.model, COUNT(DISTINCT w.mechanic_id) AS total_mechanics, COUNT(*) AS total_touches
FROM car c
JOIN service s
ON c.serial_number = s.serial_number 
JOIN work_history w
ON s.service_id = w.service_id
GROUP BY c.serial_number
ORDER BY COUNT(DISTINCT w.mechanic_id) DESC;
-- Koenigsegg Jesko Absolut was worked on by 3 distinct mechanics and including the overlap, was touched by 5 hands over 2 service sessions.












