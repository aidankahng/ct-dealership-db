-- This script is going to create our tables in the car-sales-service database

-- Creating customer table
CREATE TABLE customer (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(50)	
);

-- Creating salesperson table
CREATE TABLE salesperson (
	salesperson_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);

-- Creating the mechanic table
CREATE TABLE mechanic (
	mechanic_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);

-- Creating the car table (FKs: customer)
CREATE TABLE car (
	serial_number SERIAL PRIMARY KEY,
	make VARCHAR(20),
	model VARCHAR(20),
	color VARCHAR(20),
	customer_id INTEGER REFERENCES customer
);

-- Creating the invoice table (FKs: salesperson, customer, car)
CREATE TABLE invoice (
	invoice_id SERIAL PRIMARY KEY,
	amount NUMERIC(7,2) NOT NULL,
	time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	serial_number INTEGER REFERENCES car,
	salesperson_id INTEGER REFERENCES salesperson,
	customer_id INTEGER REFERENCES customer
);

-- Creating the service table (FKs: car, customer)
CREATE TABLE service (
	service_id SERIAL PRIMARY KEY,
	amount NUMERIC(7,2) NOT NULL,
	time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	serial_number INTEGER REFERENCES car,
	customer_id INTEGER REFERENCES customer
);

-- Creating the work_history table (FKs: service, mechanic)
CREATE TABLE work_history (
	service_id INTEGER REFERENCES service,
	mechanic_id INTEGER REFERENCES mechanic
);

-- Now all of our tables are set up! We can start adding data














