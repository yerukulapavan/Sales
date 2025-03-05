use [PAVAN]
go 

select * from BlinkIT

---------columns 
SELECT [Item_Fat_Content]
      ,[Item_Identifier]
      ,[Item_Type]
      ,[Outlet_Establishment_Year]
      ,[Outlet_Identifier]
      ,[Outlet_Location_Type]
      ,[Outlet_Size]
      ,[Outlet_Type]
      ,[Item_Visibility]
      ,[Item_Weight]
      ,[Sales]
      ,[Rating]
  FROM [dbo].[BlinkIT]

GO

---No of rows
select count(*) from BlinkIT
---output 8523

---count of missing values overall
select 
		(sum(case when Item_Fat_Content is null or Item_Fat_Content = '' then 1 else 0 end)+ 
	     sum(case when Item_Identifier is null or Item_Identifier = '' then 1 else 0 end)+
		 sum(case when Item_Type is null or Item_Type = '' then 1 else 0 end)+
		 sum(case when Outlet_Establishment_Year is null or Outlet_Establishment_Year = '' then 1 else 0 end)+
		 sum(case when Outlet_Identifier is null or Outlet_Identifier = '' then 1 else 0 end)+
	     sum(case when Outlet_Location_Type is null or Outlet_Location_Type = '' then 1 else 0 end)+
		 sum(case when Outlet_Size is null or Outlet_Size = '' then 1 else 0 end)+
	     sum(case when Outlet_Type is null or Outlet_Type = '' then 1 else 0 end)+
		 sum(case when Item_Visibility is null or Item_Visibility = '' then 1 else 0 end)+
		 sum(case when Item_Weight is null or Item_Weight = '' then 1 else 0 end)+
		 sum(case when Sales is null or Sales = '' then 1 else 0 end)+
		 sum(case when Rating is null or Rating = '' then 1 else 0 end)) as total_count_emptycells

from BlinkIT
------output 6365

--------count of missing values fro each row 
select 
		 sum(case when Item_Fat_Content is null or Item_Fat_Content = '' then 1 else 0 end) as Item_fat_content_null,
	     sum(case when Item_Identifier is null or Item_Identifier = '' then 1 else 0 end) as item_identifier_null,
		 sum(case when Item_Type is null or Item_Type = '' then 1 else 0 end) as item_type_null,
		 sum(case when Outlet_Establishment_Year is null or Outlet_Establishment_Year = '' then 1 else 0 end) as out_establishment_year_null,
		 sum(case when Outlet_Identifier is null or Outlet_Identifier = '' then 1 else 0 end) as outlet_identifier_null,
	     sum(case when Outlet_Location_Type is null or Outlet_Location_Type = '' then 1 else 0 end) as outlet_location_type_null,
		 sum(case when Outlet_Size is null or Outlet_Size = '' then 1 else 0 end) as outlet_size_null,
	     sum(case when Outlet_Type is null or Outlet_Type = '' then 1 else 0 end) as outlet_type_null,
		 sum(case when Item_Visibility is null or Item_Visibility = '' then 1 else 0 end) as item_visibility_null,
		 sum(case when Item_Weight is null or Item_Weight = '' then 1 else 0 end) as item_weight_null,
		 sum(case when Sales is null or Sales = '' then 1 else 0 end) as sales_null,
		 sum(case when Rating is null or Rating = '' then 1 else 0 end) as rating_null

from BlinkIT
------output shows item_visibilty = 526, item_weight = 1463, rating = 4376 null values 


---Data cleaning 

select Item_Fat_Content from BlinkIT
group by Item_Fat_Content

---Replace reg,LF in Item_Fat_Content column

update BlinkIT
set Item_Fat_Content = 'Low Fat'
where Item_Fat_Content = 'LF'

update BlinkIT
set Item_Fat_Content = 'Regular'
where Item_Fat_Content = 'reg'

---Distinct Attribute Categories
select 'Item_Type' as Category, Item_Type as value from BlinkIT
group by Item_Type
union all
select 'Outlet_Location_Type', Outlet_Location_Type from BlinkIT
group by Outlet_Location_Type
union all
select 'Outlet_Size', Outlet_Size from BlinkIT
group by Outlet_Size
union all
select 'Outlet_Type', Outlet_Type from BlinkIT
group by Outlet_Type


--------replace item_weight with random values
select count(*) from BlinkIT
where Item_Visibility  = ''

select max(Item_Visibility) from BlinkIT
----max value 0.328390955924988 and least value 0
----replace null values with random alues 
update BlinkIT
set Item_Visibility = rand()*0.328390955924988
where Item_Visibility = ''



-------replace item_weight with random values 
select count(*) from BlinkIT
where Item_Weight is null

update BlinkIT
set Item_Weight = floor(Item_Weight)

select max(Item_Weight) from BlinkIT
-------------max value 21
update BlinkIT
set Item_Weight = floor(rand()*21)+1
where Item_Weight is null 


------------replace Rating with random values 
select count(*) from BlinkIT
where Rating is null

update BlinkIT
set Rating = floor(rand()*5)+1
where Rating is null

------------saless
update BlinkIT
set Sales = floor(sales)

-------------KPI's Requirements 
-------------1. Total sales: The overall revenue generated from all items sold 
-------------2. Average sales: The average revenue per sale 
-------------3. Number of items: The total count of different items sold 
-------------4. Average rating: The average customer rating for items sold 
select sum(Sales) as Total_Sales, avg(Sales) as Average_Sales, avg(Rating) as Average_Rating, count(*) as No_of_Items  from BlinkIT

------Total sales by Fat_content 
select Item_Fat_Content, 
sum(Sales) as sales_by_fatcontent,
avg(Sales) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Item_Fat_Content

------Fat content by Outlet for total sales----
select Item_Fat_Content, Outlet_Location_Type,
sum(Sales) as Sales_by_Fatcontent,
floor(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Item_Fat_Content,Outlet_Location_Type

---------SALES BY ITEM TYPE 
select Item_Type, 
sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Item_Type


-----------sales by outlet establishmnet 
SELECT Outlet_Establishment_Year,
sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Outlet_Establishment_Year


-----------sales by outlet size 
SELECT Outlet_Size,
sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Outlet_Size

------------sales by outlet location 
SELECT Outlet_Location_Type,
sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Outlet_Location_Type

---------all metrics by outlet type 
SELECT Outlet_Type,
sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fype, 
count(*) as No_of_ItemsbyFat_Fype  from BlinkIT
group by Outlet_Type



create view metrics as 
select * ,sum(Sales) as sales_by_fatcontent,
FLOOR(avg(Sales)) as Avg_SalesbyFat_Fype, 
avg(Rating) as Avg_RatingbyFat_Fyp
from BlinkIT  