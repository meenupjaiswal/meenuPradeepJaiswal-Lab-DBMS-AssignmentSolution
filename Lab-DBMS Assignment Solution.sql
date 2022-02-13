/*1 1)	You are required to create tables for supplier,customer,
category,product,productDetails,order,rating to store the data 
for the E-commerce with the schema definition given below.*/
create database if not exists ecommerce;
use ecommerce;

drop table if exists Orders;
drop table if exists Rating;
drop table if exists Product_Details;
drop table if exists Supplier;
drop table if exists Customer;
drop table if exists Product;
drop table if exists Category;

create table Supplier(
SUPP_ID int primary Key NOT NULL auto_increment,
SUPP_NAME varchar(50),
SUPP_CITY varchar(20),
SUPP_PHONE varchar(10));

create table Customer(
CUS_ID int primary key NOT NULL auto_increment,
CUS_NAME varchar(50),
CUS_PHONE varchar(10),
CUS_CITY varchar(20),
CUS_GENDER char);

create table Category(
CAT_ID int primary key NOT NULL auto_increment,
CAT_NAME varchar(50));

create table Product(
PRO_ID int primary key NOT NULL auto_increment,
PRO_NAME varchar(50),
PRO_DESC varchar(250),
CAT_ID int,
FOREIGN KEY (CAT_ID) REFERENCES Category(CAT_ID));

create table Product_Details(
PROD_ID  int primary key NOT NULL auto_increment,
PRO_ID int,
SUPP_ID int,
PRICE float,
FOREIGN KEY (PRO_ID) REFERENCES Product(PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES Supplier(SUPP_ID));

create table Orders(
ORD_ID int primary key NOT NULL auto_increment,
ORD_AMOUNT int,
ORD_DATE date,
CUS_ID int,
PROD_ID int,
FOREIGN KEY (PROD_ID) REFERENCES Product_Details(PROD_ID),
FOREIGN KEY (CUS_ID) REFERENCES Customer(CUS_ID));

create table Rating(
RAT_ID  int primary key NOT NULL auto_increment,
CUS_ID int,
SUPP_ID int,
RAT_RATSTARS int,
FOREIGN KEY (SUPP_ID) REFERENCES Supplier(SUPP_ID),
FOREIGN KEY (CUS_ID) REFERENCES Customer(CUS_ID));

/*2. Insert Data*/
insert into supplier values (1,'Rajesh Retails','Delhi','1234567890');
insert into supplier values (2,'Appario Ltd.','Mumbai','2589631470');
insert into supplier values (3,'Knome products','Banglore','9785462315');
insert into supplier values (4,'Bansal Retails','Kochi','8975463285');
insert into supplier values (5,'Mittal Ltd.','Lucknow','7898456532');

insert into customer values (1,'AAKASH','9999999999','DELHI','M');
insert into customer values (2,'AMAN','9785463215','NOIDA','M');
insert into customer values (3,'NEHA','9999999999','MUMBAI','F');
insert into customer values (4,'MEGHA','9994562399','KOLKATA','F');
insert into customer values (5,'PULKIT','7895999999','LUCKNOW','M');

insert into category values (1,'BOOKS');
insert into category values (2,'GAMES');
insert into category values (3,'GROCERIES');
insert into category values (4,'ELECTRONICS');
insert into category values (5,'CLOTHES');

insert into product values (1,'GTA V','DFJDJFDJFDJFDJFJF',2);
insert into product values (2,'TSHIRT','DFDFJDFJDKFD',5);
insert into product values (3,'ROG LAPTOP','DFNTTNTNTERND',4);
insert into product values (4,'OATS','REURENTBTOTH',3);
insert into product values (5,'HARRY POTTER','NBEMCTHTJTH',1);

insert into product_details values (1,1,2,1500);
insert into product_details values (2,3,5,30000);
insert into product_details values (3,5,1,3000);
insert into product_details values (4,2,3,2500);
insert into product_details values (5,4,1,1000);

insert into orders values (20,1500,'2021-10-12',3,5);
insert into orders values (25,30500,'2021-09-16',5,2);
insert into orders values (26,2000,'2021-10-05',1,1);
insert into orders values (30,3500,'2021-08-16',4,3);
insert into orders values (50,2000,'2021-10-06',2,1);

insert into rating values (1,2,2,4);
insert into rating values (2,3,4,3);
insert into rating values (3,5,1,5);
insert into rating values (4,1,3,2);
insert into rating values (5,4,5,4);

/*3)Display the number of the customer group by their genders 
who have placed any order of amount greater than or equal to Rs.3000.*/
select c.cus_gender, count(c.cus_id)
from customer c 
inner join orders o on o.cus_id = c.cus_id where o.ord_amount >= 3000
group by c.cus_gender;


/*4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.*/
select o.ord_id as 'Order Id', o.cus_id as 'Customer Id', pd.prod_id as 'Product Id', pr.pro_name as 'Product Name', o.ord_amount as 'Amount', o.ord_date as 'Order date'
from orders o
inner join product_details pd on pd.prod_id = o.prod_id
inner join product pr on pr.pro_id = pd.pro_id
where o.cus_id = 2;

/*5)	Display the Supplier details who can supply more than one product.*/
select s.supp_id as 'Supplier Id', s.supp_name as 'Supplier Name', s.supp_city as 'City', s.supp_phone as 'Phone', count(pd.prod_id) as 'No of products'
from supplier s
inner join product_details pd on pd.supp_id = s.supp_id
group by pd.supp_id  having count(pd.prod_id) >1 order by count(pd.prod_id);

/*6)	Find the category of the product whose order amount is minimum.*/
select o.ord_id as 'Order Id' , c.cat_id as 'Category Id' , c.cat_name as 'Category name',o.ord_amount as 'Amount'
from orders o
inner join product_details pd on pd.prod_id = o.prod_id
inner join product pr on pr.pro_id = pd.pro_id
inner join category c on c.cat_id = pr.cat_id
having min(o.ord_amount);
 
/*7)	Display the Id and Name of the Product ordered after “2021-10-05”.*/
select o.ord_id as 'Order Id', pr.pro_id as 'Product Id', pr.pro_name as 'Product name' 
from orders o 
inner join product_details pd on pd.prod_id = o.prod_id
inner join product pr on pr.pro_id = pd.pro_id
where o.ord_date > '2021-10-05';

/*8)	Display customer name and gender whose names start or end with character 'A'.*/
select cus_name as 'Customer name', cus_gender as 'Gender' 
from customer 
where cus_name like 'A%' or cus_name like '%A';

/*9)	Create a stored procedure to display the Rating for a Supplier if any 
along with the Verdict on that rating if any 
like if rating >4 then “Genuine Supplier” 
if rating >2 “Average Supplier” 
else “Supplier should not be considered”.
*/
DROP PROCEDURE IF EXISTS sp_supplier_rating;

DELIMITER //
CREATE PROCEDURE sp_supplier_rating()
BEGIN
    select s.supp_name as 'Supplier Name', r.rat_ratstars as 'Rating', 
	case  
		when r.rat_ratstars > 4 then 'Genuine Supplier'
		when r.rat_ratstars > 2 then 'Average Supplier'
		else 'Supplier should not be considered'
	end Verdict
	from supplier s
	inner join rating r on r.supp_id = s.supp_id
	order by r.rat_ratstars desc;
END //
    
DELIMITER ;

call sp_supplier_rating();





