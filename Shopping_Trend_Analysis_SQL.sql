/*Q1.How many unique customers have visited the store during the time period provided? 
(To get a sense of the sample size you're working with.)*/
SELECT count(distinct `Customer ID`) as Total_Customers
From shopping_trends_updated;
/* We have a total of 3900*/


/*Q2. Should the store stock more male or female clothing? (What % of customers are male vs. female?)*/
With data as(
SELECT Gender, count(distinct `Customer ID`) as Total_Customers
From shopping_trends_updated
Group by Gender)
select  round((sum(case when Gender='Female' then Total_Customers else 0 end)/sum(Total_Customers)*100),2) as pct_female,
round((sum(case when Gender='Male' then Total_Customers else 0 end)/sum(Total_Customers)*100),2) as pct_male
from data;
/*--32% customer are female & 68% are male*/


/*Q3. What are the most purchased categories and/or items by season? (This will help guide seasonal stocking strategies.)*/
WITH data AS (
    SELECT Season, `Item Purchased`, COUNT(`Item Purchased`) AS Total_Item_Purchased,
        dense_rank() OVER (PARTITION BY Season ORDER BY COUNT(`Item Purchased`) DESC) AS rn
    FROM shopping_trends_updated
    GROUP BY Season, `Item Purchased`)
SELECT *
FROM data
WHERE rn <= 3;
/*--Fall(Jacket, Hat, Handbag), Spring(Sweater, Shorts, blouse, coat, skirt), 
Summer(Pants, jewelry, dress, shoes) and Winter(Sunglasses, pants, shirt) represent the trend by time period*/


/*Q4. Identify the season with the highest volume of purchases across the dataset*/
select Season, count(`Customer ID`) as Total_Purchases
from shopping_trends_updated
group by Season
order by Total_Purchases desc;
/*--Spring has the highest number of purchases (999), followed by Fall (975) and Winter (971). 
Summer has the lowest (955), making Spring the most popular shopping season overall.*/


/*Q5. What are the most popular item colors by season? (Color preference can affect buying decisions.)*/
with data as
(select season, color, count(Color) as Total_Item, dense_rank() over (partition by Season order by count(Color) desc) as rnk
from shopping_trends_updated
group by Season, Color)
select * from data
where rnk =1;
/*Based on the data, Silver is the most purchased color in Summer, Olive is most popular in Spring, 
Green leads in Winter, and Yellow/Magenta are the top colors in Fall*/


/*Q6. Should stocking strategies vary by store location? (You can also explore if customer gender varies by location.)*/
select Location, count(Gender) as Total_customer, round((sum(case when Gender='Male' then 1 else 0 end)/count(gender)*100),2) as Total_Male,
round((sum(case when Gender='female' then 1 else 0 end)/count(Gender)*100),2) as Total_Female
from shopping_trends_updated
group by location
order by Total_customer desc;
/*--Montana Store have the highest customer base, with male customers making up a higher share in most locations*/


/*Q7. Which locations are top-performing in terms of customer experience? (Use metrics like frequency of repeat visits or average spend.*/
select location, round(avg(`review rating`),2) as Customer_Rating, round(sum(`previous purchases`),2) as Loyalty_Customer
from shopping_trends_updated
group by Location
order by loyalty_customer desc;
/*--Locations such as Illinois, Alabama, and Montana appear to be top-performing in customer experience, 
showing higher average customer ratings combined with strong loyalty counts (repeat visits).*/


/*Q8. Does having more than 10 previous purchases correlate with higher total spend? (Understanding customer loyalty and value.)*/
select case when `Previous Purchases`>10 then 'more than 10' else 'less then 10' end as Previous_Purchases_Status, 
sum(`Purchase Amount (USD)`) as Total_Spend
FROM shopping_trends_updated
group by Previous_Purchases_Status
/*--Yes, customers who made higher number of purchases previously, maintain the trend of higher purchases when they return*/









