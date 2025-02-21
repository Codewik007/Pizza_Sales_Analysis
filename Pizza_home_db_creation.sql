CREATE DATABASE pizzahome;

CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id)
);

CREATE TABLE order_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id)
);

CREATE TABLE pizza_types(
pizza_types_id TEXT NOT NULL,
name TEXT NOT NULL,
category TEXT NOT NULL,
ingredients TEXT NOT NULL,
PRIMARY KEY(pizza_types_id)
);

CREATE TABLE pizzas(
pizza_id TEXT NOT NULL,
pizza_type_id TEXT NOT NULL,
size TEXT NOT NULL,
price DOUBLE NOT NULL,
PRIMARY KEY(pizza_types_id)
);
