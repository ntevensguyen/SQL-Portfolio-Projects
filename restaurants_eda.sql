#####################FIRST ANALYZING MENU_ITEMS TABLE
use restaurant_db;

-- 1. View the menu_items table.
select * 
from menu_items;

-- 2. Find the number of items on the menu.
select count(item_name) from menu_items;

-- 3. What are the least and most expensive items on the menu?
select item_name, min(price)
from menu_items
group by item_name
order by min(price) asc
limit 1;

select item_name, max(price)
from menu_items
group by item_name
order by max(price) desc
limit 1;

-- 4. How many Italian dishes are on the menu?
select count(category) Italian_Dishes
from menu_items
where category='Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?
select item_name, category, min(price) price
from menu_items
group by item_name, category
having category='Italian'
order by price
limit 2;

select item_name, category, max(price) price
from menu_items
group by item_name, category
having category='Italian'
order by price desc
limit 2;

-- 6. How many dishes are in each category?
select category, count(item_name) number_of_dishes
from menu_items
group by category
order by count(item_name) desc;

-- 7. What is the average dish price within each category?
select category, round(avg(price),2) average_price
from menu_items
group by category
order by average_price desc; 



#################################ANALYZING ORDER_DETAILS TABLE
-- 1.View the order_details table.
select * from order_details;

-- 2. What is the date range of the table?
select min(order_date), max(order_date)
from order_details;

-- 3. How many orders were made within this date range?
select count(distinct order_id)
from order_details;

-- 4. How many items were ordered within this date range?
select count(*)
from order_details;

-- 5. Which orders had the most number of items?
select order_id,count(order_id) num_items
from order_details
group by order_id
order by count(order_id) desc;

-- 6. How many orders had more than 12 items?
select count(*) orders_with_13_or_more_items from 
(select order_id,count(item_id)
from order_details
group by order_id
having count(item_id)>12
order by count(item_id) desc) count_table_greater_than_12;



####################################################ANALYZE CUSTOMER BEHAVIOR
-- 1. Combine the menu_items and order_details tables into a single table.
drop temporary table combined_order_details;
create temporary table combined_order_details
(
select *
from menu_items mi
right join order_details od
	on mi.menu_item_id=od.item_id
order by order_id
);

select * from combined_order_details;

-- 2. What were the least and most ordered items? What categories were they in?
select item_name, count(item_name) order_count
from combined_order_details
group by item_name
order by count(item_name) desc;

select category, count(category)
from combined_order_details
group by category
order by count(category) desc;

-- 3. What were the top 5 orders that spent the most money?
select order_id, sum(price) total_spent
from combined_order_details
group by order_id
order by total_spent desc
limit 5;

-- 4. View the details of the highest spend order. What insights can you gather from the results?
select *
from combined_order_details
where order_id=440;

select category, count(category) num_category
from combined_order_details
where order_id=440
group by category
order by num_category desc;

-- 5. View the details of the top 5 highest spend orders. What insights can you gather from the results?
select category, count(category) num_category
from combined_order_details
where order_id in (440,2075,1957,330,2675)
group by category
order by num_category desc;
