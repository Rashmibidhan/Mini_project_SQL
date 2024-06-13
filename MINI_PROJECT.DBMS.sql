-- -----------------------------------------------PART A ------------------------------------------------------------

##1.	Import the csv file to a table in the database.
create database icc_cricket; 
use icc_cricket;

-- 2. Remove the column 'Player Profile' from the table.
ALTER TABLE icctest
DROP COLUMN Player_Profile;

-- 3 Extract the country name and player names from the given data and 
   ##    store it in separate columns for further usage.

alter table icctest
add (

Player_Name varchar(200) , Country_Name varchar(200)

);


update `icctest` set Country_name = SUBSTRING_INDEX(SUBSTRING_INDEX(Player, '(', '-1'),')',1);
update `icctest` set Player_name = SUBSTRING_INDEX(Player, '(', '1');

-- 4 From the column 'Span' extract the start_year and end_year and 
###store them in separate columns for further usage.


Alter table `icctest` add column Start_year int;
Alter table `icctest` add column End_year int;
update `icctest` set Start_year = SUBSTRING_INDEX(Span, '-', '1');
update `icctest` set End_year = SUBSTRING_INDEX(Span, '-', '-1');

-- 5 The column 'HS' has the highest score scored by the player so far in any given match.
 ###The column also has details if the player had completed the match in a NOT OUT status. 
 ###Extract the data and store the highest runs and the NOT OUT status in different columns.
 
Alter table `icctest` add column Highest_runs int;
Alter table `icctest` add column Not_out_status BOOL;
UPDATE `icctest`
SET Highest_runs = SUBSTRING_INDEX(HS, '*', 1),
    Not_out_status = CASE WHEN HS LIKE '%*' THEN TRUE ELSE FALSE END;
    
    -- 6 Using the data given, considering the players who were active in the year of 2019,
   ## create a set of batting order of best 6 players using the selection criteria of 
    ##those who have a good average score across all matches for India.
    select Avg, Player_name from   `icctest` 
  where End_year = 2019 or Start_year = 2019 order by Avg desc limit 6;
  
  -- 7 Using the data given, considering the players who were active in the year of 2019, 
    ##create a set of batting order of best 6 players using the selection criteria of 
    ##those who have the highest number of 100s across all matches for India.
  select `Hundred`, Player_name from   `icctest` 
  where End_year = 2019 or Start_year = 2019 order by `Hundred` desc limit 6;
  
  -- 8 Using the data given, considering the players who were active in the year of 2019,
  ##create a set of batting order of best 6 players using 2 selection criteria of your own for India.
  
    select Runs,Inn, Player_name,country_name from   `icctest` 
  where Country_name ='India'
  and End_year = 2019 or Start_year = 2019;
  
  select Runs,Inn, Player_name,country_name from   `icctest` 
  where Country_name ='India'
  and End_year = 2019 or Start_year = 2019
  order by runs DESC, Inn desc LIMIT 6;
  
  -- 9 	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
  #considering the players who were active in the year of 2019, create a set of batting 
 # order of best 6 players using the selection criteria of those who have a good average
  #score across all matches for South Africa.
  create view Batting_Order_GoodAvgScorers_SA as
   select Avg, Player_name from   `icctest` 
  where End_year = 2019 or Start_year = 2019 order by Avg desc limit 6;
  
  select * from Batting_Order_GoodAvgScorers_SA;
  
  -- 10 Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given,
  #considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria 
  #of those who have highest number of 100s across all matches for South Africa.
  
  create view Batting_Order_HighestCenturyScorers_SA as
   select `Hundred`, Player_name from   `icc_test` 
  where End_year = 2019 or Start_year = 2019 order by `Hundred` desc limit 6;
  
  select * from Batting_Order_HighestCenturyScorers_SA;
  
  -- 11 Using the data given, Give the number of player_played for each country.
  select count(player_name) as NoofPlayer, country_name from `icctest` 
 group by country_name;
 
 -- 12 Using the data given, Give the number of player_played for Asian and Non-Asian continent

 SELECT COUNT(DISTINCT(PLAYER_NAME)) AS ASIAN_COUNT FROM icctest  
 WHERE COUNTRY_NAME IN('INDIA','SL','ICC/INDIA','PAK','ICC/PAK','BDESH','ICC/SL','INDIA/PAK','AFG');
 
SELECT COUNT(DISTINCT(PLAYER_NAME)) AS NON_ASIAN_COUNT FROM icctest  
 WHERE COUNTRY_NAME IN('AUS','ICC/SA','ENG','ICC/WI','WI','SA','NZ','ZIM','ICC/NZ','ENG/ICC','AUS/SA',
'AUS/ENG','ENG/SA','ENG/IRE','SA/ZIM','NZ/WI','IRE');


  
  
--  ------------------------------------PART B-----------------------------------------------------------------------------------
Create database Supply_chain;
use Supply_chain;

-- 1.	Company sells the product at different discounted rates. Refer actual product price in product table and selling price in the order item table. 
-- Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. 
select ( b.Unitprice -a.UnitPrice ) as Amount_Saved
            from product a
            join orderitem b
            on a.id = b.id
            order by amount_saved desc;
            
  -- 2.	Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
-- a. List few products that he should choose based on demand.
-- b. Who will be the competitors for him for the products suggested in above questions

       select count(orderid) as Nooforders, productid, ProductName,contactname,Companyname
 from orderitem a
join product b
on a.ProductId = b.Id
join supplier cd
on cd.Id = b.SupplierId
group by productid
order by Nooforders desc
limit 5;   


-- 3.	Create a combined list to display customers and suppliers details considering the following criteria 
-- ●	Both customer and supplier belong to the same country
-- ●	Customer who does not have supplier in their country
-- ●	Supplier who does not have customer in their country

SELECT
  c.FirstName AS "Customer Name",
  c.City AS "Customer City",
  s.CompanyName AS "Supplier Name",
  s.City AS "Supplier City"
FROM customer c
JOIN supplier s
ON c.country = s.country
WHERE
  (c.country = s.country AND c.city = s.city)
  OR
  (c.country = s.country AND c.city <> s.city)
  OR
  (c.country <> s.country AND c.city = s.city)
ORDER BY c.FirstName, s.CompanyName;

-- 4.	Every supplier supplies specific products to the customers. Create a view of suppliers and total sales made by their
		 -- products and write a query on this view to find out top 2 suppliers (using windows function) in each country by total 
        -- sales done by the products.


select * from product;
 select * from supplier;
 CREATE or REPLACE VIEW supplier_sales_view AS
SELECT
    s.Id AS supplier_id,
    s.CompanyName AS supplier_name,
    s.Country,
    sum(unitprice) AS total_sales
FROM
    Supplier s
JOIN
    Product p ON s.Id = p.SupplierId
GROUP BY 
s.Id, s.CompanyName, s.Country;

SELECT * FROM supplier_sales_view;

WITH ranked_suppliers AS (
    SELECT
        supplier_id,
        supplier_name,
        Country,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY total_sales DESC) AS rankVALUE
    FROM
    supplier_sales_view
)
SELECT
    supplier_id,
    supplier_name,
    Country,
    total_sales
FROM
    ranked_suppliers
WHERE
    rankVALUE <= 2;
    
    # 5.	Find out for which products, UK is dependent on other countries for the supply.
    # List the countries which are supplying these products in the same list.
    
SELECT AB.PRODUCTNAME, AB.COUNTRY, CD.COUNTRY, AB.COMPANYNAME, CONCAT(FIRSTNAME,' ',LASTNAME) AS CUSTOMER_NAME
FROM (SELECT PRODUCTNAME, COUNTRY, COMPANYNAME,SUPPLIERID FROM PRODUCT A JOIN
SUPPLIER B ON 
A.SUPPLIERID = B.ID
WHERE COUNTRY <> 'UK') AB
JOIN CUSTOMER CD
ON AB.SUPPLIERID = CD.ID
WHERE CD.COUNTRY ='UK';

--  6.	Create two tables as ‘customer’ and ‘customer_backup’ as follow - 
 -- ‘customer’ table attributes -
 -- Id, FirstName,LastName,Phone
 -- ‘customer_backup’ table attributes - 
 -- Id, FirstName,LastName,Phone

  -- Create a trigger in such a way that It should insert the details into the  ‘customer_backup’ table when you delete the record
  -- from the ‘customer’ table automatically.


DELIMITER //
CREATE TRIGGER customer_delete_trigger
AFTER DELETE ON customernew
FOR EACH ROW
BEGIN 
    INSERT INTO customer_backup (Id, Firstname,LastName,Phone)
    VALUES (OLD.Id, OLD.FirstName, OLD.LastName, OLD.Phone);
    
    
END;
//
DELIMITER ;


create table customernew (
Id int ,
FirstName varchar(20) ,
LastName varchar(20) ,
Phone varchar(20) 
);


create table customer_backup (
Id int ,
FirstName varchar(20) ,
LastName varchar(20) ,
Phone varchar(20) 
);


INSERT INTO customernew (Id,FirstName,LastName,Phone)VALUES
(1,'Maria','Anders',030-0074321),
(2,'Ana','Trujillo',555-4729),
(3,'Antonio','Moreno',555-3932),
(4,'Thomas','Hardy',555-7788);


