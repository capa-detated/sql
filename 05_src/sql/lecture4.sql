-- IFNULL and coalesce

SELECT *,
IFNULL(product_size,'Unknown') as new_product_size,
IFNULL(product_size, product_qty_type), -- both null, results will be null
coalesce(product_size,product_qty_type,'missing'), -- if first value is null, then second value, if thats null then third value
IFNULL(IFNULL(product_size, product_qty_type),'missing') -- same as coalesce but you have to wrap within itself


FROM product;


SELECT *
,IFNULL(product_size,'Unknown') as new_product_size,
NULLIF(product_size,'') as blank_finder, --finding the values that product_size is 'blank' and returning NULL
coalesce(NULLIF(product_size,''), 'Unknown') as good_product_size

FROM product
--WHERE product_size is null
WHERE NULLIF(product_size,'') IS NULL -- both blanks and nulls


--WINDOW functions
--certain windowed functions are not available using typical groupby, so remember to search windowed functions if groupby not working well

--row number
--what was the highest price seen per product for each vendor?

SELECT *

FROM (
	SELECT DISTINCT
	vendor_id,
	market_date
	,product_id
	,original_price
	,ROW_NUMBER() OVER(PARTITION BY vendor_id,product_id ORDER BY original_price DESC) as price_rank

	FROM vendor_inventory
) x
WHERE x.price_rank = 1;


--most expensive priced item per product
SELECT *

FROM (
	SELECT DISTINCT
	vendor_id,
	product_id, --notice how price rank value resets when product_id changes, if this argument left out price rank would not reset for each product_id
	original_price,
	ROW_number() OVER(Partition BY vendor_id ORDER BY original_price DESC) as price_rank
	
	FROM vendor_inventory
) x 
WHERE x.price_rank = 1;



--dense_rank vs rank vs row_number !! common interview question lol
-- row number will always be unique and increasing by one per row, rank will allow ties but will skip ranks after ties (ie if two first place, rank will skip second place so third item will be 3rd place)
--dense_rank allows ties and does not skip ranks, so even if two first place items, the third item will get rank 2


DROP TABLE IF EXISTS temp.row_rank_dense;

CREATE TEMP TABLE IF NOT EXISTS temp.row_rank_dense
(
emp_id INT,
salary INT
);

INSERT INTO temp.row_rank_dense
VALUES(1,200000),
(2,200000),
(3, 160000),
(4, 120000),
(5, 125000),
(6, 165000),
(7, 230000),
(8, 100000),
(9, 165000),
(10, 100000);

SELECT *
,row_number() OVER(ORDER BY salary DESC) as [row]
,RANK() OVER(ORDER BY salary DESC) as [rank]
,DENSE_RANK() OVER(ORDER BY salary DESC) as [dense_rank]

FROM row_rank_dense;

--NTILE(4,5,100) quartiles, quintiles, percentiles, etc


--day sales


SELECT *
,NTILE(4) OVER(PARTITION BY vendor_name ORDER BY sales ASC) as quartile
,NTILE(5) OVER(PARTITION BY vendor_name ORDER BY sales ASC) as quintile
,NTILE(100) OVER(PARTITION BY vendor_name ORDER BY sales ASC) as percentile


FROM(
	SELECT
	md.market_date,
	market_week,
	market_year,
	vendor_name,
	sum(quantity*cost_to_customer_per_qty) as sales

	FROM market_date_info as md
	JOIN customer_purchases cp
		on md.market_date = cp.market_date
	JOIN vendor v
		on cp.vendor_id = v.vendor_id
		
	GROUP BY md.market_date, v.vendor_id
) ;


---STRING MANIPULATIONS (may be easier to perform these manipulations in python/other language, but still exists in sql)

SELECT DISTINCT
LTRIM('              CAMERON      ') as [ltrim], --left trim 
RTRIM('              CAMERON      ') as [rtrim], --right trim -- both of these are helpful for removing blank spaces that can be common when dealing with user-entered data
TRIM('              CAMERON      ') as [both],
LTRIM(RTRIM('              CAMERON      ')) as [also_both];

--REPLACE (string manipulation)
SELECT DISTINCT
product_name
,REPLACE(product_name, 'a', 'e') -- replacing a's with e's
,REPLACE(product_name,'h','l') -- case sensitive
,REPLACE(product_name,' ', '_') -- converting blank spaces to underscores (ie. pothole case)
FROM product

--UPPER & lower -- forces all string characters to upper or lower case 
SELECT DISTINCT
product_name,
UPPER(product_name) as upper_case,
LOWER(product_name) as lower_case
FROM product;

--CONCAT -- concatenation
SELECT *
,customer_first_name || ' ' || customer_last_name as customer_name
,UPPER(customer_last_name) || ', ' || UPPER(customer_first_name) as custoner_name_upper
FROM customer;

--SUBSTR substring
SELECT *
,SUBSTR(customer_last_name,4) -- any length from the 4th character
,SUBSTR(customer_last_name,4,2) -- 2 characters long from the 4th character
,SUBSTR(customer_last_name,-5,4) -- starting from the right, 5 charcters in and going 4 characters
FROM customer;


--INSTR (ie. 'in string'), provides the starting position or location of a specified string, can help with splitting a text string on delimiters
--probably easier to accomplish this in python/other language, code can get very unruly in sql with nested substr instr functions

--LENGTH returns number of charcters in a given string (or set of strings in a column), also works on integers



SELECT *
,customer_last_name
,INSTR(customer_last_name,'a')
,LENGTH(customer_last_name)
FROM customer;


--CHAR  -- will replace any instance of a specific ascii character with the specified replacement character
SELECT 

'CAMERON

PARRO' -- added a line break, notice the elipsis in output

,replace('CAMERON

PARRO', char(10),' ') -- replaces line break (ascii code 10) with space
,UNICODE('a') -- returns ascii value for specified string value (a is 97), opposite of CHAR

FROM customer
WHERE customer_first_name REGEXP '(a)$';----REGEX regular expressions


--UNION & UNION ALL -- combine results of two or more queries vertically (ie. row-wise)
--UNION ALL will keep duplicates, union will not

--most and least expensive product by vendor using a UNION

SELECT
vendor_id,
product_id,
original_price,
rn_max as [row_number] -- renaming because later union query will want this neutral name
FROM (
	SELECT DISTINCT
	vendor_id,
	product_id,
	original_price,
	row_number() OVER(PARTITION BY vendor_id ORDER BY original_price DESC) as rn_max
	
	FROM vendor_inventory
) x
WHERE rn_max = 1

--UNION -- union returned 5 ROWS
UNION ALL -- returned 6 rows because vendor 4 is duplicate value (most and least expensive product is the same)

SELECT *
FROM(
	SELECT DISTINCT
	vendor_id,
	product_id,
	original_price,
	row_number() OVER(PARTITION BY vendor_id ORDER BY original_price ASC) as rn_min
	
	FROM vendor_inventory
) x
WHERE rn_min = 1



--union can replicate full outer JOIN

    DROP TABLE IF EXISTS temp.store1; 
    CREATE TEMP TABLE IF NOT EXISTS temp.store1

    (
    costume TEXT,
    quantity INT
    );

    INSERT INTO temp.store1
    VALUES("tiger",6),
        ("elephant",2),
        ("princess", 4);

    DROP TABLE IF EXISTS temp.store2;
    CREATE TEMP TABLE IF NOT EXISTS temp.store2
    (
    costume TEXT,
    quantity INT
    );

    INSERT INTO temp.store2
    VALUES("tiger",2),
        ("dancer",7),
        ("superhero", 5);


    SELECT 
	s1.costume, 
	s1.quantity AS store1_quant, 
	s2.quantity AS store2_quant
	
    FROM store1 s1
    LEFT JOIN store2 s2 
		ON s1.costume = s2.costume
		
    UNION ALL
	
    SELECT s2.costume, 
	s1.quantity, 
	s2.quantity
    FROM store2 s2
    LEFT JOIN store1 s1 
		ON s2.costume = s1.costume
    WHERE s1.quantity IS NULL
	
	
-- INTERSECT and EXCEPT
-- require both/all queries to have the same number of columns
-- intersect and inner join are very similar, but intersect will carry null values, inner join never carries null VALUES
--except returns opposite (ie select all items in table a that are not found in table b)

--products that have been sold (eg are in the customer purchases table and product table)

SELECT product_id
FROM customer_purchases
INTERSECT
SELECT product_id
FROM product

--products that have not been sold
SELECT x.product_id,product_name -- adding product name with subquery and join!
FROM(
	SELECT product_id
	FROM product -- what products are not in customer purchases (need to select from product first)
	EXCEPT
	SELECT product_id
	FROM customer_purchases
) x
JOIN product p on x.product_id = p.product_id
