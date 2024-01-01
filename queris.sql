use Shein_data
--1- Most rated product in each category 
select  p.product_id , c.category_name
from Review r, products p ,Category c
where r.product_id = p.product_id
and p.category_id = c.category_id
and rate = 5

--2- create index on column (product_name)
create nonclustered index on_product_name
on products (product_name)

--3- retrive number of pices that order for each product
select product_id,sum(order_quantity) as total_sales 
from order_product 
group by product_id 
order by total_sales desc

--4-total amount spent by a customer and total number of orders
CREATE OR ALTER PROCEDURE GetTotalAmountSpentByCustomer
    @customerId INT
AS
BEGIN
    SELECT cust_ID, SUM(p.price) AS TotalAmountSpent , COUNT(o.order_id) AS total_orders
    FROM orders o
    JOIN order_product op ON o.order_id = op.order_id
    JOIN products p ON p.product_ID = op.product_ID
    WHERE o.cust_ID = @customerId
    GROUP BY cust_ID
END 
GetTotalAmountSpentByCustomer 5

--5--Apply discounts
UPDATE Products
SET Price = Price * discount_value
WHERE product_id = 101

--6- Identify Products That Need Restocking (Function)
CREATE FUNCTION GetProductsInNeedOfRestocking()
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Products
    WHERE in_stock < 50
)

--7-Identify the Most Popular Products Based on Sales
SELECT p.Product_ID, p.product_name, COUNT(op.Product_ID) AS SalesCount
FROM Products p
LEFT JOIN order_product op ON p.Product_ID = op.Product_ID
GROUP BY p.Product_ID, p.product_name
ORDER BY SalesCount DESC

--8-Find Customers Who Haven't Placed Orders yet
UPDATE Orders
SET Cust_ID = 2
WHERE Order_id = 105
GO
SELECT c.Cust_ID, c.FName, c.LName, c.E_mail
FROM Customer c
LEFT JOIN Orders o ON c.Cust_ID = o.Cust_ID
WHERE o.Cust_ID IS NULL

--9-Identify Products That Have Never Been Ordered
CREATE FUNCTION GetProductsNeverOrdered()
RETURNS TABLE
AS
RETURN
(
    SELECT p.Product_ID, p.product_name
    FROM Products p
    LEFT JOIN order_product op ON p.Product_ID = op.Product_ID
    WHERE op.Product_ID IS NULL
)
--10- most ordered broduct in each country
with count_products as(
SELECT c.country, op.product_id,p.product_name, count(op.product_id) as cnt_prods
from order_product op
join Orders o
on op.order_id = o.order_id
join Customer c
on c.cust_id = o.cust_id
join products p 
on p.product_id = op.product_id
group by c.country, op.product_id, p.product_name
),
 get_rank as
(
select country,product_name,cnt_prods,
ROW_NUMBER() over (partition by country order by cnt_prods desc) as RN
from count_products cp
)
select country,product_name, cnt_prods
from get_rank
where RN = 1
order by cnt_prods desc

--11- average days the order is delivered since it has been ordered for each shipping method 
select shipping_method,avg(DATEDIFF(day,order_date, estimated_date)) as avg_days
from orders
where order_status not in ('Canceled', 'in processing')
group by shipping_method

--12- most used shipping method for each country:
with most_shipmethod_uesd as(
select country, shipping_method,
ROW_NUMBER() over (partition by country order by cnt_shipmethod desc) as RN
from(
   select country,shipping_method, count(shipping_method) as cnt_shipmethod
from orders o , Customer c
where o.cust_id = C.cust_id
and o.order_status not in ('Canceled', 'in processing')
group by country,shipping_method
)as cnt_table
)
select country, shipping_method
from most_shipmethod_uesd 
where RN = 1

--13- Toral price for each order
create view  order_prod_prices 
as(
select op.order_id,op.product_id, p.price, op.order_quantity, p.price*op.order_quantity as total
from products p ,  order_product op
where op.product_id = p.product_id 
)
create view order_prices
as(
select order_id,sum(total) as order_total
from order_prod_prices
group by order_id
)
select * from order_prices

--14- avg product prices  for each age and gender
with age_bins as
(
select cust_id,gender, 
case 
	when age >= 18 and age <25 then '18-24'
	when age>= 25 and age <= 30 then '25-30'
	when age > 30 and age <= 35 then '30-35'
	when age > 35 and age <= 40 then  '35-40'
	else 'Older than 40'
end as ages
from Customer
)
select ab.gender,ab.ages,opp.product_id,AVG(opp.total) as avg_total
from age_bins ab,order_prod_prices opp, Orders o 
where o.cust_id = ab.cust_id
and opp.order_id = o.order_id
group by ab.gender,ab.ages, opp.product_id

--15-Find the order(s) with the highest(5) total quantity of products.
SELECT top 5 o.order_id, SUM(op.order_quantity) AS total_quantity
FROM orders o
JOIN order_product op ON o.order_id = op.order_id
GROUP BY o.order_id
ORDER BY total_quantity DESC

--16-Retrieve the customer(s) who have placed orders for products from a specific class. (Assuming the class is 'women')
SELECT c.cust_id, c.fname, c.lname
FROM customer c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_product op ON o.order_id = op.order_id
JOIN products p ON op.product_id = p.product_id
JOIN category ct ON p.category_id = ct.category_id
WHERE ct.class_name = 'women';

--17-Show the most requested(ordered) products and their classification
SELECT p.product_id, p.product_name,  ct.class_name, max(op.product_id) AS Most_requested_ordered
FROM Orders o , order_product op , products p , Category ct
WHERE o.order_id =op.order_id 
AND op.product_id = p.product_id
AND p.category_id = ct.category_id
GROUP BY p.product_id, p.product_name,  ct.class_name ,op.product_id
ORDER BY Most_requested_ordered DESC;

--18-Calculate the total revenue generated from each product (taking discounts into account):
SELECT p.product_id, p.product_name, SUM((p.price - (p.discount_value*p.price)) * op.order_quantity) AS total_revenue
FROM products p
JOIN order_product op ON p.product_id = op.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue;

--19-Show products that have a discount of more than 25%, reduce them to 12%
CREATE trigger discount_update
on products after UPDATE
as 
declare @old_dis_val float, @new_dis_val float
select @new_dis_val =  discount_value
from inserted
select @old_dis_val discount_value
from deleted
select @old_dis_val, @new_dis_val
---------------------
update products
set discount_value = 0.15
where discount_value > 0.25

--20-- Create trigger to reduce the stock quantity when adding the order ------
create  trigger UpdateQuan
on order_product
after insert
as
    declare @quan int, @p_id int
    select @quan =  order_quantity , @p_id = product_id
	from  inserted

	update products
	set in_stock = in_stock - @quan
	where product_id = @p_id
