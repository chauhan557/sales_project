ALTER table sales 
change column ï»¿transactions_id transaction_id int primary key;

SELECT COUNT(*) FROM sales;

SELECT * FROM sales 
  WHERE transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- How many unique customer we have
SELECT COUNT(DISTINCT customer_id)as cnt FROM sales ;

-- How many unique category we have

SELECT DISTINCT category as ctg FROM sales ;

-- Data Analysis and Business problems 

-- Q1 Write a sql query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM sales where sale_date  = '2022-11-05';

-- Q2 Write a SQL Query to reterive all transactions where category is clothing and the 
      -- quantity sold more than 10 in the month of NOV-22

SELECT 
    *
FROM
    sales
WHERE
    category = 'clothing'
        AND YEAR(sale_date) = '2022'
        AND MONTH(sale_date) = '11'
        AND quantiy >= 4;

-- Q3 Write a  SQL query to calculate total sales in each category
 
SELECT category, sum(total_sale) FROM sales GROUP BY category;

--  Q4 Write a SQL query to find the average age of customers who purchased the item from
--  'Beauty' category

SELECT 
    round(AVG(age),0) AS Average_age
FROM
    sales
WHERE
    category = 'Beauty'
GROUP BY category;

-- Q5 Write a SQL to find all the transaction where the total sale is greater than 1000 

SELECT 
    transaction_id
FROM
    sales
WHERE
    total_sale > 1000
GROUP BY transaction_id;

-- Q6 Write a SQL query to find number of transaction made by each gender in each category

SELECT 
    gender, category, COUNT(*) AS total_transaction
FROM
    sales
GROUP BY category , gender
ORDER BY category;

-- Q7 Write a sql query to calculate the average sale for each month . 
--    Find out the best selling month in each year

WITH CTE AS(
SELECT 
    YEAR(sale_date)AS Yearr,
    MONTH(sale_date)AS Month_no,
    ROUND(AVG(total_sale),2) AS average_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2)DESC)AS rnk
FROM
    sales
GROUP BY MONTH(sale_date) , YEAR(sale_date))

SELECT * FROM CTE WHERE rnk = 1;

-- Q8 Write a SQL query to find the top 5 customers based on the higest total sales

SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q9 Write a sql query to find the number of unique customers who purchased 
-- items for each category

SELECT 
    category, COUNT(DISTINCT customer_id)
FROM
    sales
GROUP BY category; 

-- Q10 Write a sql query to create each shift and number of orders (Example Morning <=12 ,
--     Afternoon Between 12 & 17 , Evening >17
WITH CTE AS (
SELECT 
    *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM
    sales )
SELECT 
    shift, COUNT(transaction_id) AS Number_of_orders
FROM
    CTE
GROUP BY shift



