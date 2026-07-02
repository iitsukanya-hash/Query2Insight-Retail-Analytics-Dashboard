create database retail_analytics_db;
use retail_analytics_db;
show tables;
DESC customer_profiles;
alter table customer_profiles
rename  column ï»¿CustomerID to CustomerID;
alter table customer_profiles
modify JoinDate Date;
# check missing value for CustomerID 
select * from customer_profiles
where CustomerID is null
or trim(CustomerID)='';
# check missing value for Age
select * from customer_profiles
where Age is null
or trim(Age)=''; 
# check missing value for Gender
select * from customer_profiles
where Gender is null
or trim(Gender)=''; 
# check missing value for Location 
select count(*) as total_misisng
 from customer_profiles
where Location is null
or trim(Location)=''; 
# select all age column
select * from customer_profiles
where Age>100 
or Age<0;
# check missing value for JoinDate column
select count(*) as total_misisng
 from customer_profiles
where JoinDate is null
or trim(JoinDate)=''; 


# check duplicate only for CustomerID primarykey
select CustomerID,count(*) as total_duplicate
from customer_profiles
group by CustomerID
having count(*)>1;


# check category consistency
select DISTINCT Gender
from customer_profiles;
select DISTINCT Location
from customer_profiles;

## remove that null or '' from location column
SET SQL_SAFE_UPDATES = 0;
update customer_profiles
set Location ='unknown'
where Location is null
or trim(Location)='';

# check
select count(Location)
from customer_profiles
where Location ='unknown';

# update age one row
update customer_profiles
set Age=null
where Age>100 or
Age<0;
select Age from customer_profiles 
where Age>100 or Age <0;

desc customer_profiles;
alter table customer_profiles
modify CustomerID int not null;
alter table customer_profiles
add primary key(CustomerID);


#### sales transaction
desc sales_transaction;
## check missing value 
select CustomerID from  sales_transaction
where CustomerID is null
or CustomerID='';
alter table sales_transaction
RENAME column ï»¿TransactionID	to TransactionID;		
## check missing value TransactionID
select TransactionID from  sales_transaction
where TransactionID is null
or TransactionID='';


## check missing value ProductID
select ProductID from  sales_transaction
where ProductID  is null
or ProductID ='';

## check missing value QuantityPurchased
select QuantityPurchased from  sales_transaction
where QuantityPurchased  is null
or QuantityPurchased ='';

## check missing value TransactionDate
select TransactionDate from  sales_transaction
where TransactionDate  is null
or TransactionDate ='';

## check missing value Price
select Price from  sales_transaction
where Price  is null
or Price ='';
select * from sales_transaction;

## check duplicate value
select TransactionID ,count(*) from sales_transaction
group by TransactionID
having count(*)>1;
select * from sales_transaction
where TransactionID in (4999,5000);

select count(*)
from sales_transaction;

## create a new table without any duplicate TransactionID
create table sale_transaction_clean as
select distinct *
from sales_transaction;

select count(*) from sale_transaction_clean;

desc sale_transaction_clean;
select * from sale_transaction_clean;
## change datatype for TransactionDate
alter table sale_transaction_clean
modify TransactionDate DATE;
## add primary key for TransactionID
alter table sale_transaction_clean
add primary key(TransactionID);
select * from sale_transaction_clean;
select QuantityPurchased from sale_transaction_clean
where QuantityPurchased <=0;
select Price from sale_transaction_clean
where Price <=0;
alter table sale_transaction_clean
modify column Price decimal(10,2);



######  product-subcategorie
select * from `product-subcategories`;
# checking missing value  ProductSubcategoryKey
select ProductSubcategoryKey from  `product-subcategories`
where  ProductSubcategoryKey is null 
or  ProductSubcategoryKey='';

## # checking missing value  SubcategoryName
select SubcategoryName from  `product-subcategories`
where  SubcategoryName is null 
or  SubcategoryName='';


##### checking missing value  SubcategoryName
select ProductCategoryKey from  `product-subcategories`
where  ProductCategoryKey is null 
or  ProductCategoryKey='';

### need to check duplicate value 
select ProductSubcategoryKey,count(*) from `product-subcategories`
group by  ProductSubcategoryKey
having count(*)>1;
alter table `product-subcategories`
add primary key(ProductSubcategoryKey);
desc `product-subcategories`;

## desc product_inventory
desc product_inventory;
alter table product_inventory
rename  column ï»¿ProductID to ProductID;
select ProductID from product_inventory
where ProductID is null
or ProductID='';

select ProductName from product_inventory
where ProductName is null
or ProductName='';

select Category  from product_inventory
where Category  is null
or Category  ='';

select StockLevel from product_inventory
where StockLevel is null
or StockLevel ='';

select Price from product_inventory
where Price is null
or Price ='';
desc product_inventory;
select ProductID ,count(*) from product_inventory
group by ProductID
having count(*)>1;
alter table product_inventory
add Primary key(ProductID);
desc product_inventory;
select * from product_inventory;




