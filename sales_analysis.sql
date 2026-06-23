-- Find the total revenue
select 
	sum(total_revenue) 
from sales;

--Find the revenue by each category
select
	product_category,
	sum(total_revenue) revenue
from sales
group by product_category
order by revenue desc;

-- Find the Revenue by each Region
select
	customer_region,
	sum(total_revenue) revenue
from sales
group by customer_region
order by revenue desc;

-- Find the Top 10 Products
select 
	product_id,
	sum(total_revenue) revenue
from sales
group by product_id
order by revenue desc 
limit 10;

-- Find the Best Payment Method
select 
	payment_method,
	count(*) no_of_orders
from sales
group by payment_method
order by no_of_orders desc;

-- Find Average Rating by Category
select
	product_category,
	avg(rating) average
from sales
group by product_category
order by average desc;

-- Find the Product Categories Generate the Highest Revenue Contribution
with cte as (
select
	product_category,
	sum(total_revenue) revenue
from sales
group by product_category
)
select 
	product_category,
	revenue,
	revenue*100/sum(revenue)over() as revenue_contribution
from cte
order by revenue desc;

-- Top 5 Products within Each Category
WITH cte AS (
SELECT
    product_category,
    product_id,
    SUM(total_revenue) revenue,
    ROW_NUMBER() OVER(
        PARTITION BY product_category
        ORDER BY SUM(total_revenue) DESC
    ) rn
FROM sales
GROUP BY 1,2
)

SELECT *
FROM cte
WHERE rn <= 5;

--Total Revenue Month by Month
WITH cte AS (
SELECT
    month,
    SUM(total_revenue) revenue
FROM sales
GROUP BY 1
)

SELECT
    month,
    revenue,
    SUM(revenue)
    OVER(
        ORDER BY month
    ) cumulative_revenue
FROM cte;
select * from sales

-- Month over Month Growth %
WITH cte AS (
SELECT
    month,
    SUM(total_revenue) revenue
FROM sales
GROUP BY 1
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER(
        ORDER BY month
    ) previous_month,

    
        (
            revenue -
            LAG(revenue) OVER(
                ORDER BY month
            )
        )
        /
        LAG(revenue) OVER(
            ORDER BY month
        ) * 100  growth_pct
FROM cte;

-- Which Region has the Highest Average Order Value
SELECT
    customer_region,
    (
        SUM(total_revenue)
        /
        COUNT(DISTINCT order_id)) avg_order_value
FROM sales
GROUP BY customer_region
ORDER BY avg_order_value DESC;

-- Does Higher Discount Increase Sales
SELECT
    discount_percent,
    COUNT(*) orders,
    SUM(total_revenue) revenue,
    AVG(quantity_sold) avg_quantity
FROM sales
GROUP BY discount_percent
ORDER BY discount_percent;

--Which Categories have High Revenue but Low Ratings
SELECT
    product_category,
    SUM(total_revenue) revenue,
    AVG(rating) avg_rating
FROM sales
GROUP BY product_category
ORDER BY revenue DESC;

--Find Best Performing Quarter
SELECT
    EXTRACT(QUARTER FROM order_date) quarter,
    SUM(total_revenue) revenue
FROM sales
GROUP BY quarter
ORDER BY revenue DESC;

-- Best Category-Year Combination
SELECT
    year,
    product_category,
    SUM(total_revenue) revenue
FROM sales
GROUP BY 1,2
ORDER BY revenue DESC;