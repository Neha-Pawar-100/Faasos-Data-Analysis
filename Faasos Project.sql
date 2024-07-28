create database faasos;
use faasos;


CREATE TABLE driver(driver_id integer,reg_date date); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');


CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');


CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');


CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');


CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time datetime,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-03 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40','NaN'),
(5,3,'2021-01-08 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2020-01-08 21:30:45','25km','25mins',null),
(8,2,'2020-01-10 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2020-01-11 18:50:20','10km','10minutes',null);

set sql_safe_updates = 0;
update driver_order set pickup_time = '2021-01-08 21:30:45' where order_id = 7;
update driver_order set pickup_time = '2021-01-10 00:15:02' where order_id = 8;
update driver_order set pickup_time = '2021-01-11 18:50:20' where order_id = 10;


CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date datetime);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','2021-01-01  18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1,5','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2,6','1,4','2021-01-11 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;


-- 1) How many rolls have been ordered?
select count(roll_id) as total_orders
from customer_orders;


-- 2) How many unique customer orders were made?
select count(distinct customer_id) as unique_customer_count
from customer_orders;


-- 3) How many successful orders were delivererd by each driver?
select driver_id, count(order_id) as ordres_count
from driver_order
where cancellation is null or 
cancellation not in ('cancellation','customer cancellation')
group by driver_id;


-- 4) How many of each type of rolls were delivered?
select c.roll_id, r.roll_name, count(c.order_id) as total_delivered
from rolls r
join customer_orders c on r.roll_id = c.roll_id
join driver_order d on c.order_id = d.order_id
where d.cancellation is null or
d.cancellation not in ('cancellation','customer cancellation')
group by c.roll_id, r.roll_name;


-- 5) How many veg and non-veg rolls were ordered by each customers?
select customer_id,
sum(case 
		when roll_name = 'Veg Roll' then total_ordered else '' end) as Veg_Roll,
sum(case     
        when roll_name = 'Non Veg Roll' then total_ordered else '' end) as Non_Veg_Roll
from (
	   select c.customer_id, r.roll_name, count(c.order_id) as total_ordered
       from rolls r
       join customer_orders c on r.roll_id = c.roll_id
       group by c.customer_id, r.roll_name
	  ) a
group by customer_id
order by customer_id;


-- 6) What was maximum no. of rolls delivered in a single order?
select c.order_id, count(c.order_id) as order_count
from rolls r
join customer_orders c on r.roll_id = c.roll_id
join driver_order d on c.order_id = d.order_id
where d.cancellation is null or 
d.cancellation not in ('cancellation','customer cancellation')
group by c.order_id
order by order_count desc
limit 1;

-- 7) For each customers, how many delivered rolls had atleast 1 change and how many had no changes?
-- handling null values and blank spaces
with temp_customer_orders (order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date) as
(
  select order_id, customer_id, roll_id, 
         case 
	         when not_include_items is null or not_include_items = '' then 0 
			 else not_include_items 
		 end,
		 case 
			 when extra_items_included is null or extra_items_included = '' or extra_items_included = 'NaN' then 0 
             else extra_items_included 
		 end,
  order_date
  from customer_orders
  ),

temp_driver_order (order_id, driver_id, pickup_time, distance, duration, cancellation) as 
(
  select order_id, driver_id, pickup_time, distance, duration,
         case
             when cancellation in ('cancellation','customer cancellation') then 'Cancelled'
             else 'Not Cancelled'
         end
  from driver_order
  )

select customer_id, sum(changes_made) as count_of_rolls_with_at_least_1_change, sum(no_changes_made) as count_of_rolls_with_no_changes
from (
		select customer_id, not_include_items, extra_items_included,
			   case 
				   when not_include_items = 0 and extra_items_included = 0 then 1
				   else ''
			   end as no_changes_made,
			   case
				   when not_include_items > 0 or extra_items_included > 0 then 1
                   else ''
			   end as changes_made
		from temp_customer_orders 
		where order_id in (
						   select order_id from temp_driver_order where cancellation = 'Not Cancelled'
						   )
		)subquery
group by customer_id
order by customer_id;


-- 8) How many rolls were delivered that had both exclusions and extras?
with temp_customer_orders (order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date) as
( 
select order_id, customer_id, roll_id,
		case 
			when not_include_items is null or not_include_items = '' then 0 else not_include_items end,
		case 
			when extra_items_included is null or extra_items_included = '' or extra_items_included = 'NaN' then 0 else extra_items_included end
,order_date
from customer_orders
),

temp_driver_order (order_id, driver_id, pickup_time, distance, duration, cancellation) as
(
select order_id,driver_id,pickup_time,distance,duration,
		case when
				 cancellation = 'cancellation'or cancellation ='customer cancellation' then 1 else 0
			 end
from driver_order
)

select customer_id, count(exclusions_extras_both) as count_of_rolls
from (    
		select customer_id,
							case 
								when not_include_items > 0 and extra_items_included > 0 then 1 else ''
							end as exclusions_extras_both
		from temp_customer_orders
		where order_id in (    
							select order_id from temp_driver_order where cancellation = 0
						   )
	   ) subquery
where exclusions_extras_both > 0
group by customer_id
order by customer_id;


-- 9) What was the total no. of rolls ordered for each hour of the day?
select bucket as timeframe, count(bucket) as number_of_orders
from (
	    select *, concat(hour(order_date),'-', hour(order_date)+1) as bucket
	    from customer_orders
      ) subquery
group by bucket
order by bucket;


-- 10) What was the no. of orders for each day of the week?
select day, count(day) as number_of_orders
from (
        select *, dayname(order_date) as day from customer_orders
	  ) subquery
group by day
order by day;


-- 11) What was the avg time in mins. for each driver to arrive at the faasos location to pickup the order?
select driver_id, round(avg(diff),0) as avg_time_in_mins, rnk
from (
		select d.driver_id, c.order_id, timestampdiff(minute,order_date,pickup_time) as diff,
		row_number() over (partition by order_id) as rnk
		from customer_orders c
		join driver_order d on c.order_id = d.order_id
		where d.pickup_time is not null
	  ) subquery
where rnk = 1
group by driver_id;


-- 12) What was the average distance travelled for each customer?
select customer_id, cast(sum(new_distance)/count(order_id) as decimal(4,2)) as avg_distance_in_km
from(
		select c.customer_id, c.order_id,
		cast(trim(replace(distance,'km',''))as decimal (4,2)) as new_distance,
		row_number() over (partition by order_id) as rnk
		from customer_orders c
		join driver_order d on c.order_id = d.order_id
		where d.pickup_time is not null
	  ) subquery
where rnk = 1
group by customer_id;


-- 13) What was the difference between longest and shortest delivery time among all orders?
select longest - shortest as difference_in_minutes
from (
		select max(duration) as longest, min(duration) as shortest
		from driver_order
		where duration is not null
	  ) subquery;
      
      
-- 14) What was the avg speed of each driver for each delivery?
select * from(
				select d.driver_id, c.order_id, round(avg(d.distance/d.duration),2) as avg_speed
				from driver_order d
				join customer_orders c on c.order_id = d.order_id
				group by driver_id,c.order_id
			  ) subquery
where avg_speed is not null
order by driver_id;


-- 15) What is the successful delivery percentage for each driver?
select a.driver_id, round(a.cnt/b.cnt,2)*100 as successful_delivery_percentage
from (
		select driver_id, count(driver_id) as cnt
		from driver_order
		where pickup_time is not null
		group by driver_id
	  ) a
join (     
		select driver_id, count(driver_id) cnt
		from driver_order
		group by driver_id
	  ) b
on a.driver_id = b.driver_id;


-- 16) What is the repeat customer rate?
select round((number_of_repeat_customers/total_orders)*100,2) as repeat_customer_rate
from (
		select count(order_date) - count(distinct (order_date)) as number_of_repeat_customers, count(order_date) as total_orders
		from customer_orders
	   ) subquery;