-- USE PROPER DATABASE
USE retailproj;

-- SHOW ALL TABLES
show tables;

-- VIEW THE DETAILS
select * from retail;

/* BASIC ANALYSIS */

-- Q1. Find the total revenue (sum of Quantity * UnitPrice) generated from
-- all invoices
select 
round(sum(quantity*unitprice),2) AS total_revenue
from retail;

-- Q2.  Count the number of unique products (StockCode) sold
select 
count(distinct stockcode) AS unique_product
from retail;


-- Q3. Identify the total number of invoices in the dataset.
select 
count(distinct InvoiceNO) AS total_invoice
from retail;


-- Q4. ind the total quantity of products sold for each StockCode and sort
-- them in descending order.
select 
stockcode,
sum(quantity) AS total_qty
from retail
group by stockcode
order by total_qty desc;


-- Q5 Count the number of transactions (distinct InvoiceNo) per customer
-- (CustomerID)
select 
CustomerID,
count(distinct InvoiceNO) AS transaction
from retail
group by customerID
order by transaction desc;


/* CUSTOMER ANALYSIS */
-- Q1. Identify the top 5 customers who have generated the highest revenue
select 
CustomerID,
round(sum(quantity*unitprice),2) AS total_revenue
from retail
group by CustomerID
order by total_revenue desc
limit 5; 


-- Q2. Find the average number of products purchased per customer.
select
CustomerID,
 round(avg(quantity),2) AS avg_qty
 from retail
 group by CustomerID
 order by avg_qty desc; 
 
 
 -- Q3. Retrieve all transactions made by the customer who has purchased the
-- most products in total.
select 
CustomerID,
sum(quantity) AS total_qty
from retail
group by CustomerID
order by total_qty desc
limit 1;

select * 
from retail
where CustomerID = (
select CustomerID 
from retail
group by CustomerID
order by sum(quantity) desc
limit 1
);

-- Q4. Identify the country with the highest number of unique customers.
select 
country,
count(distinct CustomerId) AS total_Customer
from retail
group by country
order by total_customer desc
limit 1;


-- Q5. Find the customer who made the maximum number of transactions.
select 
CustomerID,
count(distinct InvoiceNo) AS transaction
from retail
group by CustomerId
order by transaction desc
limit 1;


/* PRODUCT-BASED ANALYSIS */

-- Q1. List the top 5 most frequently purchased products (based on total
-- quantity sold).
select 
stockcode,
sum(quantity) AS total_qty
from retail
group by stockcode
order by total_qty desc 
limit 5;   


-- Q2. Find the product that generated the highest revenue.
select 
stockcode,
 round(sum(quantity*unitprice),2) AS revenue
 from retail
 group by stockcode
 order by revenue desc
 limit 1;
 
 
 -- Q3. Identify products that have been sold in exactly 10 or more different
-- invoices.
select 
stockcode,
count(distinct InvoiceNo) AS transaction
from retail
group by stockcode
having transaction >=10
order by transaction;


-- Q4. Count how many times each product has been sold and list those that
-- have been purchased more than 5 times.
select 
stockcode,
count(distinct InvoiceNO) AS transaction
from retail
group by stockcode
having transaction > 5
order by transaction;


-- Q5. Retrieve all distinct product descriptions purchased by a specific
-- customer (CustomerID = 17850).
select distinct description 
from retail
where CustomerId = 17850;


/* TIME-BASED ANALYSIS */

-- Q1. Find the total revenue generated per month.
select 
	year(InvoiceDate) AS invoice_year,
    month(InvoiceDate) AS invoice_month,
    round(sum(quantity* unitprice),2) AS total_revenue
    from retail
    group by invoice_year, invoice_month
    order by invoice_year, invoice_month;
    
    
    -- Q2. Identify the hour of the day when the highest number of transactions
-- occurred
select 
hour(InvoiceDate) AS invoice_hour,
count(distinct InvoiceNo) AS transaction
from retail
group by invoice_hour
order by transaction desc
limit 1;


-- Q3. Count the number of invoices generated per day
select 
	date(InvoiceDate) AS Inv_date,
    count(distinct InvoiceNo) AS transaction
    from retail
    group by inv_date
    order by transaction desc;
    
    
    -- Q4. Identify the date when the highest number of products were sold.
    select 
		date(InvoiceDate) AS inv_date,
        sum(quantity) AS total_qty
        from retail
        group by inv_date
        order by total_qty desc
        limit 1;
        
        
        -- Q5. Find the number of transactions that happened before 12 PM vs. after
-- 12 PM
select 
	'Before 12 pm' AS time_period,
    count(InvoiceNO) AS transaction
    from retail
    where hour (InvoiceDate) < 12
    union 
    select 
		'After 12 pm' AS time_period,
        count(distinct InvoiceNO) AS transaction
        from retail
        where hour (invoiceDate) < 12;
        
        
	/*  EXTRA - show top 3 customer by total revenue for each month */
    with Date_customer_revenue AS (
    select 
    Date(InvoiceDate) As inv_date,
    CustomerID,
    round(sum(quantity*unitprice),2) AS total_revenue,
    dense_rank() over(partition by Date (invoiceDate) order by sum(quantity*unitprice) desc) AS Qty_rank
    from retail
    group by inv_date, CustomerID
    )
    select * from Date_customer_revenue
    where Qty_rank <=3;
        
        
    


