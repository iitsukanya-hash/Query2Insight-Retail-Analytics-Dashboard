-- NOTE: the customer_segments view (search "#146") uses an earlier threshold (1-10 / 11-30 / >30 orders).
-- The final definition used by the dashboard is in 03_views.sql (low 1-3, mid 4-10, high value >10).

use retail_analytics_db;
show table status;
# Q1 How many customers are there?
select count(*) as total_no_ofcustomer
 from customer_profiles;
 
 # Q2 How many subcategory products are there?
 desc `product-subcategories`;
 select count(*) as total_product
 from `product-subcategories`;
 desc product_inventory;
 
  # Q3 How many products are there?
  select count(*) as total_products 
  from product_inventory;
  
  #Q4 How many sales transactions are there?
  select count(*) as total_sales_transaction
  from sale_transaction_clean;
  
  #Q5 Find total revenue generated.
  desc sale_transaction_clean;
  select sum(QuantityPurchased*Price) as total_revenue
  from sale_transaction_clean;
  
  #Q6 Find average transaction value.
   select avg(QuantityPurchased*Price) as avg_transaction
  from sale_transaction_clean;
  
  #Q7 Which 10 products generated the highest revenue?
  desc product_inventory;
  select i.ProductName,sum(s.QuantityPurchased*s.Price) as revenue
  from product_inventory i
  join sale_transaction_clean s 
  on i.ProductID=s.ProductID
  group by ProductName
  order by  revenue desc
  limit 10;
  
  #Q8 Which 10 products generated the lowest revenue?
    select i.ProductName,i.Category,sum(s.QuantityPurchased*s.Price) as revenue
  from product_inventory i
  join sale_transaction_clean s 
  on i.ProductID=s.ProductID
  group by ProductName,Category
  order by  revenue 
  limit 10;
  
  #Q9 (highest revenue category):
    select i.Category,sum(s.QuantityPurchased*s.Price) as revenue
  from product_inventory i
  join sale_transaction_clean s 
  on i.ProductID=s.ProductID
  group by Category
  order by revenue desc
  limit 1;
  select Category from product_inventory;
  
  #Q10: Top 10 Customers by Total Spending
  desc sale_transaction_clean;
  desc `product-subcategories`;
desc customer_profiles;
 select CustomerID,sum(QuantityPurchased*Price) as total_spending
 from sale_transaction_clean
 group by CustomerID
 order by total_spending desc
 limit 10;
 
 #Q11: avg spending by gender
  select c.Gender,avg(s.QuantityPurchased*s.Price) as avg_spending
  from customer_profiles c
  join sale_transaction_clean s 
  on c.CustomerID=s.CustomerID
  group by Gender
  order by avg_spending desc;
  
  
 # Q12: avg customer spending by gender
  with cte as  (select c.CustomerID,c.Gender ,sum(s.QuantityPurchased*s.Price) as total_spending from customer_profiles c
  join sale_transaction_clean s 
  on c.CustomerID=s.CustomerID
  group by CustomerID,Gender)
   select Gender,avg(total_spending) as avg_spending from cte
  group by Gender
  order by avg_spending desc;
  
  #Q13. Orders per Customer
  desc customer_profiles;
  desc sale_transaction_clean;
  desc product_inventory;
  select CustomerID,count(*) as total_order
  from sale_transaction_clean
  group by CustomerID;
  
 #Q14. Which product categories generate the highest revenue for each gender?
  desc sale_transaction_clean;
  desc product_inventory;
  desc customer_profiles;

with cte as (select s.CustomerID,s.QuantityPurchased,s.Price,p.Category 
  from product_inventory p
  join sale_transaction_clean s
  on s.ProductID=p.ProductID)
    select  c.Gender,cte.Category,sum(cte.QuantityPurchased*cte.Price) as total_revenue
  from cte 
  join customer_profiles c
  on cte.CustomerID=c.CustomerID
  group by c.Gender,cte.Category;
  
  #15Which customer has placed the highest number of orders?
  select CustomerID,count(*) as total_order
  from sale_transaction_clean
  group by CustomerID
  order by total_order desc
  limit 1;
  
  #146 Segment all customers based on the number of orders.
  CREATE VIEW customer_segments AS
   with cte as(select CustomerID,count(*) as total_order
  from sale_transaction_clean
  group by CustomerID
  )
  select total_order,CustomerID,
  case
  when total_order=0 then 'no order'
  when total_order between 1 and 10 then 'low'
  when total_order between 11 and 30 then 'mild'
  when total_order>30 then 'high value'
  end as customer_segment
  from cte;
 
  desc customer_profiles;
  
  
  #Q13. Which product categories generate the highest revenue across different regions?
 with cte as (select s.CustomerID,p.Category,s.QuantityPurchased,s.Price 
 from sale_transaction_clean s
 join product_inventory p
 on s.ProductID=p.ProductID)
 select cte.Category,c.Location,sum(cte.QuantityPurchased*cte.Price) as total_revenue
 from cte 
 join customer_profiles c
 on c.CustomerID=cte.CustomerID
 group by cte.Category,c.Location
 order by total_revenue desc;
 
 #14How has revenue changed from month to month? Are there any seasonal trends or months with higher/lower sales?
desc sale_transaction_clean;
select  month(TransactionDate) as month_no, monthname(TransactionDate) as month_name,sum(QuantityPurchased*Price) as total_revenue
from sale_transaction_clean
group by month(TransactionDate),monthname(TransactionDate)
order by month(TransactionDate) ;

#15 What is the distribution of customers based on loyalty status?
 select *from customer_profiles;
 with cte as (select CustomerID,count(*) as total_order,
  case
 when count(*)=1 then 'one time'
 when count(*)>1 then 'repeat'
 end as customer_type
 from sale_transaction_clean
 group by CustomerID)
select cte.customer_type,count(cte.CustomerID) as total_customers
from cte
group by customer_type;

