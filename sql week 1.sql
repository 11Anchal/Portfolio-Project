use anchal;
#What is the total amount each customer spent at the restaurant?
select sales.customer_id,sum(price) from sales inner join menu on sales.product_id=menu.product_id group by customer_id;
#How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) from sales group by customer_id;

-- Write a query to display the most expensive product under each category (corresponding to each record)?
SELECT * FROM product;
select *, first_value(product_name) OVER(partition by Product_category order by price desc) as max from product;

#What was the first item from the menu purchased by each customer?
select distinct customer_id,product_name from (select customer_id,product_name,dense_rank() over(order by order_date) as pp from sales join menu on sales.product_id=menu.product_id order by customer_id) as ss
where pp=1;

#What is the most purchased item on the menu and how many times was it purchased by all customers? 
select count(product_name)as maxi,menu.product_name from sales join menu on sales.product_id=menu.product_id group by product_name order by maxi desc limit 1;

#Which item was the most popular for each customer?
select customer_id,product_name,pp from(select distinct customer_id,menu.product_name, dense_rank() over(partition by customer_id order by count(customer_id)) as pp from sales join menu on sales.product_id=menu.product_id GROUP BY customer_id, product_name) as tt where pp=1;

#Which item was purchased first by the customer after they became a member?
select customer_id,product_name,order_date from(select members.customer_id,product_id,order_date from sales right join members on sales.customer_id=members.customer_id where order_date>=join_date group by customer_id order by order_date) as pp join menu on pp.product_id=menu.product_id order by customer_id;

#Which item was purchased just before the customer became a member?
select customer_id,product_name,order_date from(select members.customer_id,product_id,order_date, 
dense_rank() over(partition by customer_id order by order_date) as rr from sales 
right join members on sales.customer_id=members.customer_id 
where order_date<join_date order by order_date) as pp join menu on pp.product_id=menu.product_id where rr=1 order by customer_id;

#What is the total items and amount spent for each member before they became a member?
select customer_id,count(distinct product_name) as uniques,sum(price) as total from(select members.customer_id,product_id,order_date from sales 
right join members on sales.customer_id=members.customer_id 
where order_date<join_date order by order_date) as pp join menu on pp.product_id=menu.product_id group by customer_id order by customer_id;

# Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)?
 select sales.customer_id,order_date,product_name,price, case 
 when order_date>=join_date then "Y"
 else "N"
 END AS members
 from sales 
left join members on sales.customer_id=members.customer_id left join menu on sales.product_id=menu.product_id;
