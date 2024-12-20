###########################################################################################################

-- 								          Data Cleaning
    
###########################################################################################################
select time
from sales
;

-- added new column time_of_day that shows part of day based off the time
select time, 
case
	when time>='00:00:00' and time<'12:00:00' then 'Morning'
    when time>='12:00:00' and time<'18:00:00' then 'Afternoon'
    when time>='18:00:00' and time<'24:00:00' then 'Evening'
end time_of_day
from sales
;

alter table sales drop column time_of_day;

alter table sales add time_of_day varchar(20)
after time
;

select * 
from sales
;

update sales
set time_of_day = 
case
	when time>='00:00:00' and time<'12:00:00' then 'Morning'
    when time>='12:00:00' and time<'18:00:00' then 'Afternoon'
    when time>='18:00:00' and time<='24:59:59' then 'Evening'
end 
;

select * 
from sales
;

-- add column day_name to show days transactions took place
select date, dayname(date)
from sales
;

alter table sales add day_name varchar(15)
after date
;

update sales
set day_name=dayname(date)
;

select day_name, sum(gross_income) total_revenue_per_day, count(day_name) num_days
from sales
group by day_name
order by total_revenue_per_day desc
;

-- add column month_name to show months transactions took place
select date, monthname(date)
from sales
;

alter table sales add month_name varchar(15)
after day_name
;

SELECT * 
FROM sales;

update sales
set month_name=monthname(date)
;

###########################################################################################################

-- 								        Exploratory Data Analysis
    
###########################################################################################################
-- ------------------------------------------Generic------------------------------------------------------

#How many unique cities does the data have?
select distinct city
from sales
;

#In which city is each branch?
select distinct city, branch
from sales
;

###########################################################################################################
-- ------------------------------------------Product------------------------------------------------------

#How many unique product lines does the data have?
SELECT distinct product_line 
from sales
group by product_line
;

#What is the most common payment method?
select payment_method, count(payment_method) cnt
from sales
group by payment_method
order by cnt desc
;

#What is the most selling product line?
select product_line, count(product_line) num_sold
from sales
group by product_line
order by num_sold desc
;

#What is the total revenue by month?
select 
	month_name, 
    sum(total) total_revenue
from sales
group by month_name
order by total_revenue desc
;

#What month had the largest COGS?
select month_name, sum(cogs)
from sales
group by month_name
order by sum(cogs) desc
;

#What product line had the largest revenue?
select product_line, sum(total) revenue
from sales
group by product_line
order by revenue desc
;

#What is the city with the largest revenue?
select city, sum(total) revenue
from sales
group by city
order by revenue desc
;

#What product line had the largest VAT?
select product_line, avg(vat)
from sales
group by product_line
order by avg(vat) desc
;

#Which branch sold more products than average product sold?
select branch, sum(quantity)
from sales
group by branch
having sum(quantity)>(select avg(quantity)from sales)
;

#What is the most common product line by gender?
select gender, product_line, count(gender) as total_count
from sales
group by gender, product_line
order by 3 desc
;

#What is the average rating of each product line?
select product_line, round(avg(rating),2) avg_rating
from sales
group by product_line
order by avg(rating) desc
;


###########################################################################################################
-- ------------------------------------------Sales---------------------------------------------------------

#Number of sales made in each time of the day per weekday
select time_of_day, day_name, count(*) sales_made
from sales
group by time_of_day, day_name
having day_name not in('Saturday','Sunday')
order by field(day_name,'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), 
field(time_of_day,'Morning', 'Afternoon','Evening')
;

#Which of the customer types brings the most revenue?
select customer_type, sum(total)
from sales
group by customer_type
order by 2 desc
;

#Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(vat)
from sales
group by city
order by 2 desc
;

#Which customer type pays the most in VAT?
select * from sales;
select customer_type, avg(vat)
from sales
group by customer_type
order by 2 desc
;

###########################################################################################################
-- ------------------------------------------Customer------------------------------------------------------

#How many unique customer types does the data have?
select distinct customer_type 
from sales
;

#How many unique payment methods does the data have?
select distinct payment_method 
from sales
;

#What is the most common customer type?
select customer_type, count(customer_type) num_of_customers
from sales
group by customer_type
order by 2 desc
;

#Which customer type buys the most?
select customer_type, count(*)
from sales 
group by 1
order by 2 desc
;

#What is the gender of most of the customers?
select customer_type, gender, count(gender)
from sales 
group by customer_type, gender
order by 1
;

#What is the gender distribution per branch?
select branch, gender, count(gender)
from sales
group by 1, 2
order by 1
;

#Which time of the day do customers give most ratings?
select * from sales;

select time_of_day, count(rating)
from sales
group by 1
order by 2 desc
;

#Which time of the day do customers give most ratings per branch?
select branch, time_of_day, count(rating)
from sales
group by 1,2 
order by 1
;

#Which day of the week has the best avg ratings?
select day_name, round(avg(rating),2) avg_rating
from sales
group by 1
order by 2 desc
;

#Which day of the week has the best average ratings per branch?
select * from sales;

select branch, day_name, avg(rating)
from sales
group by 1,2 
order by 1, 3 desc



