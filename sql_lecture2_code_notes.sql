--SELECT / FROM

--SELECT * FROM customer


/* -- comment out several lines (block) of code, note - can still select code and run with 'execute' even if commented out
SELECT product_name, 
product_category_id, 
product_qty_type
FROM product
*/ 

/* -- the code below will create a new column called first_name and add 'thomas' as the value for every row in the specified TABLE
SELECT 
'thomas' as first_name,
customer_first_name
FROM customer; -- semicolon here indicates end of command
*/



--WHERE

SELECT *
FROM customer
--WHERE customer_postal_code = 'M1L' --only M1L
WHERE customer_postal_code IN ('M1L', 'M8Y'); --M1L or M8Y (also, semicolon means only last query will display in results, but all code is actually running)

SELECT *
FROM market_date_info
WHERE market_date BETWEEN '2022-06-01' AND '2022-06-30'; -- dates farmers market was open in june

-- products with _tat_ or _ato_ in their names
SELECT *
FROM product
WHERE product_name LIKE '%tat%'
OR product_name LIKE '%ato%';

SELECT *
FROM market_date_info
WHERE market_year <> 2022; -- <> means not equal to;

--what product_qty types are missing in the product table
SELECT *
FROM product
WHERE product_qty_type IS NULL;

SELECT *
FROM product
WHERE product_size = '' --two single quotes with no space, not one double quote, to indicate missing or no value



--CASE -- conditional manipulations to data, always end with creation of new column (which must be specified with a name as the last arguemnt 'END AS' 'name'

--determine the prices
SELECT *
,quantity*cost_to_customer_per_qty as price -- quantity * cost per quantity
,CASE WHEN cost_to_customer_per_qty < 1.00 -- if less than $1.00
	THEN cost_to_customer_per_qty * 2 -- double
	ELSE cost_to_customer_per_qty --otherwise, do nothing
	END as new_cost_per_qty
,CASE WHEN cost_to_customer_per_qty <1.00 -- comma at beginning here is sylistic choice, could also be after previous line
	THEN cost_to_customer_per_qty * 2 * quantity
	ELSE cost_to_customer_per_qty * quantity
	END as new_price
,CASE WHEN cost_to_customer_per_qty < 1.00
	THEN cost_to_customer_per_qty * 5 * quantity -- make cheap things 5X more expensive
	WHEN cost_to_customer_per_qty BETWEEN 1.01 AND 5.00
	THEN cost_to_customer_per_qty * 2 * quantity -- make middle cost htings 2x more expensive
	ELSE cost_to_customer_per_qty
	END as new_new_price

FROM customer_purchases
ORDER by cost_to_customer_per_qty


-- DISTINCT  - (very similar to 'unique' function in pandas)

--make a selection of column DISTINCT -- will only return one instance of each unique combination of the following specified columns
-- ie what does each vendor have on inventory and what is the price
SELECT DISTINCT vendor_id, product_id, original_price
FROM vendor_inventory; 

-- what are all the possible prices that someone might have to pay at this farmers market?
SELECT DISTINCT vendor_id, original_price
FROM vendor_inventory; 

--what products does each vendor have on inventory and their price for every day they were at the market?
SELECT DISTINCT vendor_id, product_id, original_price, market_date
FROM vendor_inventory; 
-- notice how more items are returned when more options are specified; this is because there are more possible unique values when more information is available!



-- JOIN putting together information from multiple tables, per specified joining conditions
--general note - tables are usually aliased with the first letter (eg. product is p, cost is c, etc.)

/*
SELECT [column]
FROM [left table]
JOIN [right table]
ON [left table.matching column] = [right table.matching column]
*/

--INNER JOIN filters both tables to rows present in both tables
--does not produce NULL VALUES
--INNER JOIN is the 'default' join if no specific 'join' type is specified
--most 'conversative' join, meaning it will result in the fewest rows in the newly created joined TABLE

SELECT *
FROM product --left table
INNER JOIN product_category -- right table
	ON product.product_category_id = product_category.product_category_id

SELECT *
FROM product_category AS pc --'AS' aliasing to avoid typing out the table name every time, left table
INNER JOIN product AS p -- right table
	ON pc.product_category_id = p.product_category_id

-- notice these will return different results, despite joining the same tables (because we switched which table is assigned left and which is right)

-- LEFT (OUTER) JOIN ('outer' usually excluded from actual command, left is not optional ie. 'outer join' is not a command)
-- filters the 'right' table to rows present in the 'left' TABLE
--left join will often produce NULL VALUES

SELECT *
FROM product_category AS pc
LEFT JOIN product AS p
	ON pc.product_category_id = p.product_category_id
ORDER BY pc.product_category_id


--RIGHT JOIN
--filters the 'left' table to rows present in the 'right' TABLE
--will most often produce NULL VALUES
--right join is frowned upon, since you can just change which table is left and right in a left join, and right join is less intuitive


--FULL (OUTER) JOIN
--does not filter either 'left' or 'right'
--EXPECT NULL values because every row and column from both tables will be carried into new joined TABLE


--MULTIPLE TABLE JOIN
--missed copying this section -- get code snippet from github 'this cohort - live code - session 2'
