#Retrieve the total number of orders placed.

SELECT 
    COUNT(*) AS total_orders
FROM
    orders;

#Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;

#Identify the highest-priced pizza.

SELECT 
    pt.name, p.size, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1; 

#Identify the most common pizza size ordered.

SELECT 
    size, COUNT(size) AS size_count
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY size_count DESC
LIMIT 1;

#List the top 5 most ordered pizza types along with their quantities.

SELECT 
    p.pizza_type_id,
    COUNT(p.pizza_type_id) AS count_pizza_types_ordered,
    SUM(od.quantity) AS sum_quantity
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_type_id
ORDER BY count_pizza_types_ordered DESC
LIMIT 5;

#Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    p.pizza_type_id, SUM(od.quantity) AS sum_quantity
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_type_id;

#Determine the distribution of orders by hour of the day.

SELECT 
    COUNT(order_id) AS count_orders,
    HOUR(order_time) AS hour_of_day
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY hour_of_day;

#Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pt.category, COUNT(od.order_details_id) AS order_count
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category; 

#Group the orders by date and calculate the average number of pizzas ordered per day.

WITH CTE AS(
SELECT o.order_date, SUM(od.quantity) s_quantity
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.order_date
)
SELECT ROUND(AVG(s_quantity),2) AS average_number_of_pizzas_ordered_per_day
FROM CTE;

#Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name,
    COUNT(od.order_details_id) C_order,
    SUM(od.quantity * p.price) AS REVENUE
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY REVENUE DESC
LIMIT 3;

#Calculate the percentage contribution of each pizza type to total revenue.

WITH CTE AS(
SELECT pt.name, COUNT(od.order_details_id) C_order, SUM(od.quantity * p.price) AS REVENUE
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY REVENUE DESC
)
SELECT name, (REVENUE/(SELECT SUM(REVENUE) FROM CTE)) *100 AS percentage_contribution
FROM CTE;

#Analyze the cumulative revenue generated over time.

WITH CTE AS(
SELECT o.order_date, o.order_time , SUM(od.quantity * p.price) AS REVENUE
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY o.order_date, o.order_time
)
SELECT *, SUM(REVENUE) OVER(ORDER BY order_date, order_time) AS CUMULATIVE_REVENUE
FROM CTE;

#Determine the top 3 most ordered pizza types based on revenue for each pizza category.

WITH CTE AS(
SELECT 
pt.category,
pt.name, 
SUM(od.quantity * p.price) AS REVENUE,
DENSE_RANK() OVER(PARTITION BY CATEGORY ORDER BY SUM(od.quantity * p.price) DESC) AS MOST_ORDERED_RANK
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
)
SELECT *
FROM CTE
WHERE MOST_ORDERED_RANK <= 3
;
