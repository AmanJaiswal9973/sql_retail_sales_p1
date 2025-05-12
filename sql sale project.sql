SELECT * FROM public.relail_sales
ORDER BY transactions_id ASC 

select * from relail_sales;

-- check data
select count(*)
from relail_sales;

SELECT * 
FROM relail_sales
WHERE transactions_id IS NULL;

SELECT * 
FROM relail_sales
WHERE quantiy IS NULL;
-- FIND NULL VALUE
SELECT * 
FROM relail_sales
WHERE 
transactions_id IS NULL OR
	sale_date	IS NULL OR
    sale_time	IS NULL OR
    customer_id	IS NULL OR
    gender	IS NULL OR
  --  age	IS NULL OR in age have null vale but in v he not remove
    category	IS NULL OR
    quantiy	IS NULL OR
    price_per_unit	IS NULL OR
    cogs	IS NULL OR
    total_sale IS NULL;

-- delete null row
delete from relail_sales
WHERE 
transactions_id IS NULL OR
	sale_date	IS NULL OR
    sale_time	IS NULL OR
    customer_id	IS NULL OR
    gender	IS NULL OR
  --  age	IS NULL OR in age have null vale but in v he not remove
    category	IS NULL OR
    quantiy	IS NULL OR
    price_per_unit	IS NULL OR
    cogs	IS NULL OR
    total_sale IS NULL;
	
	-- DATE exploration
	-- how many sales we have?
	select count(*) as tatal_sales
	from relail_sales;
	
	--how many uniuqa custemar we have?
	select count(distinct customer_id) as tatal_sales
	from relail_sales;
	
-- Data Analysis & Findings

-- The following SQL queries were developed to answer specific business questions:

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

select * 
from relail_sales
WHERE sale_date = '2022-11-05' ;

-- 2. **Write a SQL query to retrieve all transactions where the category 
-- is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

select *
from relail_sales
where
category ='Clothing' 
and 
quantiy >= 4 
and 
To_CHAR (sale_date, 'YYYY-MM') ='2022-11'; -- In MySQL, there is no TO_CHAR() function, the same result in MySQL using the DATE_FORMAT() 

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

select category, sum(total_sale)
from relail_sales
group by category;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:

select round(avg(age)) as avg_age
from relail_sales
where category ='Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

select * 
from relail_sales
where total_sale > 1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

select category, gender, count(transactions_id)
from relail_sales
group by  category, gender
order by 1;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
select year, month,rank
from(
 select 
 extract(year from sale_date) as year , -- in mysql this line such as year(sale_date)
 extract(month from sale_date) as month ,-- in mysql this line such as month(sale_date)
 avg(total_sale),
 rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
 from relail_sales
 group by 1,2
) as t1
where rank=1;

-- 8. **Write a SQL query to find the top 5 customer based on the highest total sales.

select sum(total_sale), customer_id
from relail_sales
group by customer_id 
order by 1 desc
limit 5

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

select category, count(distinct customer_id)
from relail_sales
group by category;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**

with hourly_sale
as
(
select *,
	case
		WHEN extract(hour from sale_time) < 12 THEN 'Moring'
		WHEN extract(hour from sale_time) between 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	end as shiftW
from  relail_sales
)
select shift, count(*)
from hourly_sale
group by shift