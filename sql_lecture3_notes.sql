-- count

--count the number of products
SELECT
count(product_id) AS num_of_prod

FROM product;

--how many products per product_qty_type
SELECT
product_qty_type,
COUNT(product_id)
FROM product
WHERE product_qty_type IS NOT NULL -- remove null ROWS
GROUP BY product_qty_type;

--how many UNIQUE products were bought
--SELECT count(product_id) -- how many products total? 4221
SELECT count(DISTINCT product_id) -- how many distinct products? 8
FROM customer_purchases;

-- how many products per product_qty_type AND per their product_size
SELECT
product_size,
product_qty_type,
COUNT(product_id)

FROM product
GROUP BY product_size, product_qty_type;


--- SUM & AVERAGE
--how much do customers spend on each day?

SELECT
market_date,
customer_id,
SUM(quantity*cost_to_customer_per_qty) as total_cost

FROM customer_purchases
GROUP BY market_date, customer_id;

--how much does each customer spend on average?
SELECT
customer_first_name,
customer_last_name,
ROUND(AVG(quantity*cost_to_customer_per_qty),2) as avg_spend

FROM customer_purchases as cp
INNER JOIN customer c
	ON cp.customer_id = c.customer_id
GROUP BY c.customer_id;


--MIN & max

--what's the most expensive product
SELECT
--product_id,
product_name,
MAX(original_price) -- note doesn't handle ties very well (will not indicate tie, just choose any possible value to output)

FROM vendor_inventory vi
INNER JOIN product p
	on p.product_id = vi.product_id

	
--what is the least expensive per each typeof
SELECT
product_name,
product_qty_type,
MIN(original_price)

FROM vendor_inventory vi
INNER JOIN product p
	on p.product_id = vi.product_id
	
GROUP BY product_qty_type;

--PROVE IT!
SELECT DISTINCT
product_name,
product_qty_type,
original_price

FROM vendor_inventory vi
INNER JOIN product p
	ON p.product_id = vi.product_id
	
ORDER BY product_qty_type, original_price;

--arithmitic

SELECT 10.0/3.0 as division
,CAST (10,0 as INT) / CAST(3.0 AS INT) as integer_division
,sin(10)
,pi();

SELECT DISTINCT
cost_to_customer_per_qty,
cost_to_customer_per_qty / 2 as half,
CAST(cost_to_customer_per_qty as INT) / 2 

FROM customer_purchases


--HAVING
-- WHERE clauses filter rows before an aggregation, HAVING clauses allow us to filter rows after an aggregation is calculated

--how many products were bought
SELECT
count(product_id) as number_products,
product_id

FROM customer_purchases
--WHERE product_id <= 8 -- WHERE filter will be done first, then HAVING will happen after data is aggregated with group by command
GROUP BY product_id
HAVING count(product_id) BETWEEN 300 and 500 -- compare results from running all vs running all except this line to see how having filter works



--SUBQUERIES: JOIN

--'what is the single item that has been bought in the greatest quantity?'
--outer QUERY
SELECT
product_name,
max(quantity)

FROM product p
INNER JOIN (

--inner query
	SELECT 
	product_id,
	count(quantity) as quantity

	FROM customer_purchases
	GROUP BY product_id
) x ON p.product_id = x.product_id;


--SUBQUERIES: WHERE

--'what is the name of the vendor who sells pie'

SELECT DISTINCT vendor_name--, product_id
FROM vendor_inventory vi
INNER JOIN vendor v
	ON v.vendor_id = vi.vendor_id
WHERE product_id IN 
(
	SELECT product_id
	
	FROM product
	WHERE product_name LIKE '%pie%'
)



--TEMPORARY TABLES

--if a table named 'new_vendor_inventory' exists, delete it, otherwise DO NOTHING

DROP TABLE IF EXISTS new_vendor_inventory; --semi-colon is necessary in this use case! 

--make the TABLE
CREATE TEMP TABLE new_vendor_inventory AS

--definition of the TABLE
SELECT *
,original_price * 5 as inflation
FROM vendor_inventory

SELECT *
FROM new_vendor_inventory;

--put a temp table into another temp TABLE
DROP TABLE IF EXISTS new_new_vendor_inventory;

CREATE TEMP TABLE new_new_vendor_inventory AS
SELECT *
, inflation * 2 as super_inflation
FROM new_vendor_inventory;

SELECT * FROM new_new_vendor_inventory;


--CTEs or Common Table Expressions! (created before temp tables were developed, similar idea)
--less 'solid' than temp tables, more ephemeral if you will


--calculate sales per vendor per day
WITH vendor_daily_sales AS (
SELECT
md.market_date,
market_day,
market_week,
market_year,
vendor_name,
sum(quantity*cost_to_customer_per_qty) as sales

FROM customer_purchases cp
INNER JOIN vendor v
	ON cp.vendor_id = v.vendor_id
INNER JOIN market_date_info md
	ON cp.market_date = md.market_date

GROUP BY md.market_date, v.vendor_id
)

--re-aggregate daily sales within each market week for each vendor
SELECT 
market_year, 
market_week,
vendor_name,
sum(sales)

FROM vendor_daily_sales
GROUP BY market_year, market_week, vendor_name
;


--DATETIME FUNCTIONS!! woooo we love
--dates

SELECT 
DATE('now')
,DATETIME('now')

--strftime
,strftime('%Y-%m','now')
,strftime('%Y-%m-%d','now','+30 days') as the_future
,market_date
,strftime('%Y-%m-%d',market_date,'-1 year','+30 days') -- 11 months before the market_date
,strftime('%Y-%m-%d','now','-1 year')

--dateadd
--last day of the month
,strftime('%Y-%m-%d',market_date,'start of month','-1 day')

from market_date_info;



select distinct market_date

--datediff
,julianday('now')
,julianday(market_date)
,julianday('now') - julianday(market_date) -- number of days between now and eaach market_date
,(julianday('now') - julianday(market_date)) / 365.25 -- number of years between now and each market_date
,(julianday('now') - julianday(market_date)) * 24 -- number of hours between now and each market_date

from market_date_info




