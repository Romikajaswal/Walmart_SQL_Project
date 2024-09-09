create database if not exists salesDataWalmart;
create table if not exists sales(invoice_id varchar(30) not null primary key,
banch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT Float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time TIME not null,
payment varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1));


-- --------------------------------------------Feature Engineering-----------------------------------------------------------------
-- --------adding new column named time_of_day

select 
time,
(CASE
 WHEN `time` between "00:00:00" and "12:00:00" then "Morning"
 WHEN `time` between "12:01:00" and "16:00:00" then "Afternoon"
 else "Evening" end) as time_of_day from sales;
 
 
 alter table sales add column time_of_day varchar(20);
  update sales
 set time_of_day=(CASE
 WHEN `time` between "00:00:00" and "12:00:00" then "Morning"
 WHEN `time` between "12:01:00" and "16:00:00" then "Afternoon"
 else "Evening" end);
 
 -- ----------------adding new column named day_Name
 
 select date,dayname(date) as day_name from sales;
 alter table sales add column day_name varchar(20);
 update sales set day_name=dayname(date);
 
 -- ----------------adding new column named month_Name
 
 alter table sales add column month_name varchar(10);
 select date,
 monthname(date) from sales;
 update sales 
 set month_name= monthname(date);
 
-- -------------------------------------------------Generic------------------------------------------------------------ 
 -- How many unique cities does te data have?
  
 select distinct city from sales;
 
 -- In which city is each branch?
 select distinct city,banch from sales;
 
 -- --------------------------------------------------Product-----------------------------------------------------------
 
 -- -------How many unique product lines does the data have?
select count(distinct product_line) from sales;
 
 -- -------What is the most common payment method?
 
select payment,
count(payment)as payment_method from sales
group by payment
order by payment_method desc;

-- --------What is the most selling product line? 

select* from product_line;
select product_line,
count(product_line) as cnt from sales
group by product_line
order by cnt desc;

-- --------What is the total revenue by month?

select month_name as month,
sum(total) AS total_revenue from sales
group by month_name
order by total_revenue desc;

-- --------Which month had the largest COGS?

select month_name as month,
SUM(cogs) as total_cogs from sales
group by month_name
order by total_cogs DESC;

-- -------------Which product line had the largest revenue?

SELECT product_line,
sum(total) as total_revenue from sales
group by product_line
order by total_revenue desc;

-- ------------Which city has the largest revenue?

select city,
sum(total) as total_revenue from sales
group by city
order by total_revenue desc;

-- -------------Which product line has te largest VAT?

select product_line,
avg(VAT) As avg_vat from sales
group by product_line
order by avg_vat desc;

-- -------------Which branch sold more products than average products sold?

select banch,
sum(quantity) as qty from sales
group by banch
having sum(quantity)>(select avg(quantity) from sales);

-- -----------What is the most common product line by gender?

select product_line,gender,
count(gender) as total_cnt from sales
group by gender,product_line
order by total_cnt desc;

-- ----------------What is the average rating of each product line?

select product_line,
round(avg(rating),1) as avg_rating from sales
group by product_line
order by avg_rating;

-- ------------------------------------------------------Sales---------------------------------------------------------
-- ---------Number of sales made in each time of the day on Sunday

 select time_of_day,
 count(*) as total_sales from sales
 WHERE day_name="Sunday"
 group by time_of_day
 order by total_sales desc;
 
   -- -------Which customer type brings the most revenue?
   
 select customer_type,
 sum(total) as total_revenue
 from sales
 group by customer_type
 order by total_revenue desc;
 
 -- ------Which city has the largest tax percent/VAT?
 
 select city,
 AVG(VAT) AS VAT
 from sales
 group by city
 order by VAT desc;
 
 -- ------Which customer type pays the most in VAT?
 
 select customer_type,
 avg(VAT) AS VAT
 FROM sales
 group by customer_type
 order by VAT DESC;
 
 -- --------------------------------------------Customers----------------------------------------------------------------
 -- ---------How many unique customer types does the data have?
 
 select distinct customer_type from sales;
 
 -- --------How many unique payment methods does the data have?
 
 select distinct payment from sales;
 
 -- -------Which customer_type buys the most?
 
 select customer_type,
 count(*) as cstm_cnt from sales
 group by customer_type;
 
-- --------What is the gender of most of the customers?
 
 select 
 gender,
 count(*) as gender_cnt
 from sales
group by gender
order by gender_cnt desc;

-- -------What is the Gender distribution in C branch?

 select 
 gender,
 count(*) as gender_cnt
 from sales
 where banch="C"
group by gender
order by gender_cnt desc;

-- --------Which time of the day customers give most ratings?

select time_of_day,
avg(rating) as avg_rating
FROM sales
group by time_of_day
order by avg_rating desc;

-- -------Which time of the day customers give most ratings in A branc?

select time_of_day,
avg(rating) as avg_rating
FROM sales
where banch ="A"
group by time_of_day
order by avg_rating desc;

-- -------Which day of the week gets the best average ratings?

select day_name,
avg(rating) as avg_rating
FROM sales
group by day_name
order by  avg_rating desc;

-- -----Which day of te week has the best average ratings in B branch?

select day_name,
avg(rating) as avg_rating
FROM sales
where banch="B"
group by day_name
order by avg_rating desc;




 
