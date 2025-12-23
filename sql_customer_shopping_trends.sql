USE new_data026;
SELECT * FROM shopping_trends;

--
-- Determine the total number of unique customers in the dataset
-- to establish the customer base size for analysis
SELECT 
    COUNT(DISTINCT `Customer ID`) AS Total_customers
FROM
    shopping_trends;
-- We have a total of 3900

-- Should the store stock more male or female clothing?
--  (What % of customers are male vs. female?)

with data as ( 
select Gender, 
count(distinct`Customer ID`) AS Total_Customers
from shopping_trends
Group by 1 )

Select sum(Total_customers) as Total_customers,
round(100* (sum(case when gender='Female' then Total_customers else 0 end )/ sum(Total_customers)),2) as PCT_female,
round(100* (sum( case when gender ='Male' then Total_customers else 0 end )/ sum(Total_customers)),2) as PCT_male
from Data ;
-- 32% are female, and 68% are male.  

--
-- What seasons are represented in the data ?
-- Help me to  track trends by time  period.
select distinct season from shopping_trends;
-- 'Winter'
-- 'Spring'
-- 'Summer'
-- 'Fall'
--
-- What are the most purchased categories and items by season?
--  (This will help guide seasonal stocking strategies.)
select `Item Purchased`, count(`Customer ID`) as count_of_items from shopping_trends
where season = 'fall'  and Location = 'Kentucky'
group by 1 
order by 2 desc;

-- Winter: Sunglasses, followed by pants and shirts and Hsodie.
-- Spring: Sweater, shorts and Blouse and coat .
-- Summer: Pants, Dresses, and Jewelry and shoes.
-- Fall: Jacket, hat, handbag and Skirts.
--

-- What are the most popular item colors by season?
--  (Color preference can affect buying decisions.)


 -- step one most popular location
SELECT 
    Location, 
    COUNT(`Customer ID`) AS count_of_items
FROM shopping_trends
GROUP BY 1;
-- 'Kentucky'(79), 'Rhode Island'(63), 'Montana'(96)


 SELECT 
     `Color`, 
     COUNT(`Customer ID`) AS color_count 
 FROM shopping_trends
 WHERE Season = 'Fall' 
 -- and Location ='Kentucky'
 GROUP BY 1
 ORDER BY color_count DESC;

-- Winter: Green,Yellow and Peach and Pink.
-- Spring: Olive, Gray and Teal and Violet .
-- Summer: Silver, Teal, and Blue and Green.
-- Fall: Magenta, Yellow, Olive and Orange.
--

SELECT 
	`Item Purchased`, 
    count(`Customer ID`) as count_of_items
FROM shopping_trends
where Season  = 'Fall'
and Location = 'Montana'
Group by 1
order by 2 desc;
-- In fall in Montana, most popular items are Handbag, sweater and t-shirt, so yes each location should have a different stocking strategy. 
--

-- Which locations are top-performing in terms of customer experience?
--  (I use metrics like frequency of repeat visits or average spend.)
SELECT 
	Location, 
    round(avg(`Review Rating`),2) as avg_ratings
 FROM shopping_trends
 group by 1
 order by 2 desc;   
 -- Locations such as Texas  (3.91) and Wisconsin  (3.89) have ratings above 3.88  and hence onther location can learn from. 

-- Does having more than 10 previous purchases correlate with higher total spend?
--  Understanding customer loyalty and value
select
case 
	when `Previous Purchases`>= 10 
		then 'loyal_customers'
			else'Less Loyal Customers' end as previous_purchases_status,
  round(sum(`Purchase Amount (USD)`),2) as Total_purchase_amount
	from shopping_trends
    group by 1
    order by 2 desc; 
-- YEs, customers who made higher number of purchases previously, maintain the trend of higher purchases when they return. 
 -- They would be a good segment to target with any campaigns.
