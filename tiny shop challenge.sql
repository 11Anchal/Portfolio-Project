/*Which product has the highest price? Only return a single row.
Which customer has made the most orders?
What’s the total revenue per product?  
Find the day with the highest revenue.
Find the first order (by date) for each customer.
Find the top 3 customers who have ordered the most distinct products
Which product has been bought the least in terms of quantity?
What is the median order total?
For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
Find customers who have ordered the product with the highest price.
*/


select * from customerrs;
select * from orderrs;
select * from order_items;
select * from productts;


--1)Which product has the highest price? Only return a single row.


select product_id,product_name,price from productts where price=(select max(price) from productts);

--2)Which customer has made the most orders?
with cte as (select first_name,orderrs.customer_id,COUNT(orderrs.customer_id)as no_of_count from customerrs join orderrs
on customerrs.customer_id=orderrs.customer_id 
group by orderrs.customer_id,first_name)

select * from cte where no_of_count>1;

--3)What’s the total revenue per product?

select order_items.product_id,product_name, SUM(quantity*price) as totl_revenue from 
order_items join productts on order_items.product_id=productts.product_id group by product_name,order_items.product_id
order by SUM(quantity*price)



--Find the day with the highest revenue.

with quan as (select order_items.order_id,SUM(quantity*price) as max_price from order_items join productts 
on order_items.product_id=productts.product_id group by order_items.order_id)

select orderrs.order_id, order_date, max_price from quan join orderrs
on quan.order_id=orderrs.order_id where max_price=(select MAX(max_price) from quan);



--Find the first order (by date) for each customer.


with cte as (select orderrs.customer_id,CONCAT(first_name,' ',last_name) as cust_name,order_date,
dense_rank() over(partition by orderrs.customer_id order by order_date) as od
from orderrs join customerrs on orderrs.customer_id=customerrs.customer_id)
select cte.customer_id, cust_name,order_date from cte where od=1

--Find the top 3 customers who have ordered the most distinct products
select top 3 orderrs.customer_id,CONCAT(first_name,' ',last_name) as cust_name,COUNT(distinct product_id) as disc_count
from orderrs join order_items on order_items.order_id=orderrs.order_id 
join customerrs on customerrs.customer_id=orderrs.customer_id
group by orderrs.customer_id,first_name,last_name
order by COUNT(distinct product_id) desc;



--Which product has been bought the least in terms of quantity?
with cte as (select order_items.product_id, product_name, sum(quantity) as tcount from order_items 
join productts on order_items.product_id=productts.product_id 
group by order_items.product_id,product_name)

select cte.product_id, product_name, tcount from cte where tcount=(select MIN(tcount) from cte);


--What is the median order total?


with cte as (select orderrs.order_id,SUM(quantity*price) as revenue from order_items join productts 
on order_items.product_id=productts.product_id join orderrs on order_items.order_id=orderrs.order_id group by orderrs.order_id)
select distinct PERCENTILE_CONT(0.5) within group (order by revenue) over() as median from cte;

--For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

with cte as (select orderrs.order_id,SUM(quantity*price) as revenue from order_items join productts 
on order_items.product_id=productts.product_id join orderrs on order_items.order_id=orderrs.order_id group by orderrs.order_id)
select order_id, revenue,
case when revenue>300 then 'expensive'
when revenue<300 and revenue>100 then 'affordable'
else 'cheap'
end as 'Type'
from cte;


--Find customers who have ordered the product with the highest price.

select first_name,product_name,price from customerrs c
join orderrs o on c.customer_id=o.customer_id
join order_items ot on ot.order_id=o.order_id
join productts p on ot.product_id=p.product_id
where price = (select MAX(price) from productts)

