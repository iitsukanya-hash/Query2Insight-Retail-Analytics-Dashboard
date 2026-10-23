
### product_revenue total revenue based on product .
create view product_revenue as
 select i.ProductName,sum(s.QuantityPurchased*s.Price) as revenue
  from product_inventory i
  join sale_transaction_clean s 
  on i.ProductID=s.ProductID
  group by ProductName;
 
 ### View category_revenue ,revenue based on the diff category.
 CREATE VIEW category_revenue AS
SELECT
    i.Category,
    SUM(s.QuantityPurchased * s.Price) AS revenue
FROM product_inventory i
JOIN sale_transaction_clean s
ON i.ProductID = s.ProductID
GROUP BY Category;

### view customer_spending ,total spending by each customer.
CREATE VIEW customer_spending AS
SELECT
    CustomerID,
    SUM(QuantityPurchased * Price) AS total_spending
FROM sale_transaction_clean
GROUP BY CustomerID;

##gender_category_revenue
create view gender_category_revenue as
 with cte as (select s.CustomerID,s.QuantityPurchased,s.Price,p.Category 
  from product_inventory p
  join sale_transaction_clean s
  on s.ProductID=p.ProductID)
    select  c.Gender,cte.Category,sum(cte.QuantityPurchased*cte.Price) as total_revenue
  from cte 
  join customer_profiles c
  on cte.CustomerID=c.CustomerID
  group by c.Gender,cte.Category;
  
  
## customer_segments
   drop view customer_segments;
  CREATE VIEW customer_segments AS
   with cte as(select CustomerID,count(*) as total_order
  from sale_transaction_clean
  group by CustomerID
  )
  select total_order,CustomerID,
  case
  when total_order=0 then 'no order'
  when total_order <=3 then 'low'
  when total_order between 4 and 10 then 'mid'
  when total_order >10 then 'high value'
  end as customer_segment
  from cte;


# loyal_customer
drop view customer_loyalty;
CREATE VIEW customer_loyalty AS
WITH cte AS (
    SELECT CustomerID,
           COUNT(*) AS total_order,
           CASE
               WHEN COUNT(*) = 1 THEN 'one time'
               ELSE 'repeat'
           END AS customer_type
    FROM sale_transaction_clean
    GROUP BY CustomerID
)
SELECT customer_type,
       COUNT(*) AS total_customers
FROM cte
GROUP BY customer_type;


# view category_location_revenue
create view category_location_revenue as
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
 
 
 # view monthly_trend 
 create view monthly_trend as
 select  month(TransactionDate) as month_no, monthname(TransactionDate) as month_name,sum(QuantityPurchased*Price) as total_revenue
from sale_transaction_clean
group by month(TransactionDate),monthname(TransactionDate)
order by month(TransactionDate) ;

