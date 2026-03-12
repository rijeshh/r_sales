-- total sales done
select count(*) as total_sales_count from r_sales;

--total customers
select  count(distinct customer_id) from r_sales;



-- sales made on specific date say(2022-11-05)
SELECT * from r_sales
where sale_date = '2022-11-05';

-- total sale for each category

SELECT 
    category,
    sum(total_Sale) as group_sale_total
FROM 
    r_sales
GROUP BY 
    category;


-- average sell in each month and best selling month in each year
-- here we use CTE first to group the data accorfing to year and month
--then with its help we find the best selling month using subquery(correlated)

WITH yr_mon as (
            SELECT 
                TO_CHAR(sale_date,'YYYY') as year,
                TO_CHAR(sale_date,'mon') as month,
                ROUND(AVG(total_sale),2) as total_sale_month
            FROM r_sales
            GROUP BY year,month
            ORDER BY
                year,
                MIN(EXTRACT(MONTH FROM sale_date))
)
SELECT 
    year,
    month,
    total_sale_month
FROM yr_mon yr1
WHERE total_sale_month =
        (
            SELECT
                MAX(total_sale_month)
            FROM 
                yr_mon yr2
            WHERE
                yr2.year=yr1.year
        )


        
-- avg age of customer from beauty purchase category

SELECT 
    category,
    round(avg(age),0) as year_average
FROM r_sales
GROUP BY category
HAVING category='Beauty';


--total transaction made by each gender in each category

SELECT 
    gender,
    category,
    count(transactions_id) as total_trans
FROM r_sales
GROUP BY gender,category;





-- top 5 customer with their highest total sales

SELECT 
    customer_id,
    gender,
    SUM(total_Sale)
FROM 
    r_sales
GROUP BY 
    customer_id,
    gender
ORDER BY 
    SUM(total_sale) DESC
LIMIT 5;

-- select no. of unique customer who purchased the item from each category 

r