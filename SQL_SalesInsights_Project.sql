CREATE TABLE retail_sales
			(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,	
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),	
			quantiy	INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
			)

SELECT * FROM retail_sales ;

SELECT COUNT(*) FROM retail_sales ;

-- DATA CLEANING

SELECT * FROM retail_sales 
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales 
WHERE sale_date IS NULL;

SELECT * FROM retail_sales 
WHERE sale_time IS NULL;

SELECT * FROM retail_sales 
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?

SELECT COUNT(*) AS TOTAL_SALE FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?

SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS FROM retail_sales;

-- HOW MANY UNIQUE CATEGORIES WE HAVE?

SELECT COUNT(DISTINCT category) AS TOTAL_CATEGORIES FROM retail_sales;


-- DATA ANALYSIS & BUSSINESS KEY PROBLEMS AND ANSWERS
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05' ;

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equals to 4 in the month of Nov-2022
SELECT 
*
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;

	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category,
SUM(total_sale) AS Net_Sales,
COUNT(*) AS Total_Orders
FROM retail_sales 
GROUP BY category ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
category,
ROUND(AVG(age)) AS Average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
transactions_id,
SUM(total_sale) AS TOTAL_SALES
FROM retail_sales
WHERE total_sale > 1000
GROUP BY transactions_id
ORDER BY transactions_id;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
category,
gender,
COUNT(transactions_id) AS Total_number_of_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY category;



	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT * FROM
(
SELECT
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
ROUND(AVG(total_sale)) AS Average_sales,
RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS Rank
FROM retail_sales
GROUP BY 1, 2) AS  t1
WHERE rank = 1 ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
customer_id,
SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
category,
COUNT(DISTINCT customer_id) AS Number_of_customers 
FROM retail_sales
GROUP BY category
ORDER BY 2 DESC;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH shiftly_sales
AS
(
SELECT 
CASE 
	WHEN sale_time <= '12:00:00' THEN 'Morning'
	WHEN sale_time BETWEEN '12:01:01' AND '17:00:00' THEN 'Afternoon'
	ELSE 'Evening'
END AS Shift
FROM retail_sales 
)

SELECT 
Shift,
COUNT(*) AS Total_Orders
FROM shiftly_sales
GROUP BY Shift
ORDER BY 2 DESC;