-- Targeting Success: A Case Study of Expansion into Brazil

/*
Overview of Target:
- Target Corporation, a leading U.S. retail giant, originated in 1902 as the Dayton Company and rebranded to Target Corporation in 1962.
- Known for offering stylish, affordable products, often through exclusive collaborations with designers and brands.
- Maintains a strong online presence via its website and app, offering online shopping, delivery, and in-store pickup to meet modern consumer needs.

Purpose of Case Study:
- As part of its expansion strategy, Target has entered the Brazilian market.
- This case study analyzes a dataset of 100,000 orders from 2016 to 2018.
- The objective is to derive insights and actionable recommendations from the data to support Target’s strategic growth in the Brazilian retail sector.
*/


-- 1. Import the dataset and do usual exploratory analysis steps like          
-- checking the structure & characteristics of the dataset: 

-- 1. Data type of all columns in the "customers" table. 
SELECT COLUMN_NAME, DATA_TYPE 
FROM `scalar-dsml-sql-390605.target.INFORMATION_SCHEMA.COLUMNS` 
WHERE TABLE_NAME = 'customers'; 

/*
INSIGHTS: 
Understanding datatypes is essential for correct interpretation and analysis. 
It helps ensure that we are working with appropriate manner. 
*/

/*
RECOMMENDATIONS: 
Ensure that datatype of the customer table matches nature of the data they contain. 
Incorrect datatypes may cause errors or inaccurate analysis. 
*/

-- 2. Get the time range between which the orders were placed. 
SELECT  
  MIN(order_purchase_timestamp) AS min_order_timestamp, 
  MAX(order_purchase_timestamp) AS max_order_timestamp 
FROM `target.orders`; 

/*
INSIGHTS: 
Target's order history spans a period of two years, beginning with their first order on 
September 4th, 2016, and concluding with their most recent order on October 17th, 2018. 
This indicates a consistent customer relationship over a significant duration. 
*/

/* RECOMMENDATIONS: N/A */

-- 3. Count the Cities & States of customers who ordered during the given period. 
SELECT 
  COUNT(DISTINCT customer_city) AS num_cities, 
  COUNT(DISTINCT customer_state) AS num_states 
FROM `target.orders` o 
JOIN `target.customers` c  
  ON o.customer_id = c.customer_id 
WHERE o.order_purchase_timestamp BETWEEN '2016-01-01' AND '2018-12-31'; 

/*
INSIGHTS:  
The dataset reveals that customers have placed orders from 4,199 cities across 27 
states. This demonstrates a widespread customer base and potential for further growth. 
*/

/*
RECOMMENDATIONS:  
i. To expand into new states and cities, we can introduce exclusive offers and 
implement targeted strategies to attract new customers. 

ii. Conduct advertisement campaigns in cities where brand awareness is low. This 
will help capture the attention of potential customers and increase market reach. 
*/

-- 2. In-depth Exploration: 

-- 1. Is there a growing trend in the no. of orders placed over the past years? 
SELECT 
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year, 
  COUNT(order_id) AS total_orders 
FROM `target.orders` 
GROUP BY year 
ORDER BY year; 

/*
INSIGHTS:  
➢ The order trend shows a steady increase over the past three years:
i. In 2016, customers placed 329 orders. 
ii. In 2017, the number jumped significantly to 45,101 orders. 
iii. In 2018, the trend continued upward with 54,011 orders. 
iv. This indicates that the company has implemented effective strategies to 
drive growth, leading to a significant rise in order volume. 
*/

/*
RECOMMENDATIONS:  
To maintain and further enhance sales trends, the company should focus on regularly 
updating inventory. Since many brands frequently launch new products, ensuring that 
these trending items are readily available can attract more customers. Staying ahead of 
the competition by offering the latest products will help sustain customer interest and 
drive sales growth. 
*/

-- 2. Can we see some kind of monthly seasonality in terms of the no. of orders being placed? 
SELECT 
  EXTRACT(MONTH FROM order_purchase_timestamp) AS Month_Number,                  
  FORMAT_DATE("%B", order_purchase_timestamp) AS Month_Name,  
  COUNT(order_id) AS Total_Orders 
FROM `Target.orders` 
GROUP BY Month_Name, Month_Number 
ORDER BY Month_Number; 

/*
INSIGHTS:  
Analyzing monthly seasonality reveals that May, July, and August are peak months for 
customer orders, likely influenced by events such as Black Friday and other festivals 
when people stock up. In contrast, September and October record the lowest sales, 
possibly because customers still have ample stock from previous festive purchases. 
*/

/*
RECOMMENDATIONS:  
➢ Peak Months: 
i. Ensure inventory is well-stocked to meet high demand. 
ii. Consider increasing staffing to maintain a seamless shopping experience. 

➢ Low-Sales Months: 
i. Introduce special deals like "Buy 1 Get 1 Free" or free home delivery to 
encourage purchases. 

➢ Unique Strategy: 
i. During festivals, customers often buy items they don't end up using. To 
minimize waste and reduce inventory loss, introduce a buy-back program 
where customers can return unused items at half price. These items can then 
be refurbished or resold, allowing the company to recover value and reduce 
wastage. 
*/

-- 3. During what time of the day, do the Brazilian customers mostly place their orders? 
-- (Dawn, Morning, Afternoon or Night) 
-- 0-6 hrs : Dawn 
-- 7-12 hrs : Mornings 
-- 13-18 hrs : Afternoon 
-- 19-23 hrs : Night 

SELECT  
  CASE 
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6 THEN 'Dawn' 
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12 THEN 'Morning' 
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon' 
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 19 AND 23 THEN 'Night' 
  END AS time_of_day, 
  COUNT(order_id) AS total_orders 
FROM `target.orders` 
GROUP BY time_of_day   
ORDER BY time_of_day; 

/*
INSIGHTS: 
Analyzing order data by time reveals that customers place the highest number of 
orders in the Afternoon, followed by Night, Morning, and Dawn. This pattern 
highlights a preference for shopping during midday, with relatively lower activity 
during the early morning hours. 
*/

/*
RECOMMENDATIONS: 
To make the most of customer behavior patterns, we can implement targeted strategies 
based on peak and low-activity times. During peak hours, especially in the afternoon 
when orders are highest, we can introduce attractive offers to further boost sales. For 
instance, during the summer season, offering a free cold drink with every order can draw 
more customers. On the other hand, during low-activity times like dawn, we can reduce 
late-night charges to encourage more purchases. Additionally, offering quick delivery of 
essential medical products during these early hours can cater to emergency needs, 
fostering customer loyalty and trust. By aligning our strategies with customer ordering 
patterns, we can maximize engagement and revenue throughout the day. 
*/

-- 3. Evolution of E-commerce orders in the Brazil region: 

-- 1. Get the month on month no. of orders placed in each state. 
SELECT 
  CONCAT(EXTRACT(YEAR FROM order_purchase_timestamp), '-', EXTRACT(MONTH FROM order_purchase_timestamp)) AS year_month, 
  c.customer_state,
  COUNT(*) AS order_numbers 
FROM `target.orders` o 
JOIN `target.customers` c  
  ON o.customer_id = c.customer_id 
GROUP BY year_month, c.customer_state 
ORDER BY year_month, c.customer_state; 

/*
INSIGHTS:  
In October 2016, states like MG (Minas Gerais) and MT (Mato Grosso) had low order 
numbers, with MG at 40 orders and MT at 3. By August 2018, SP (São Paulo) saw a 
significant surge with 3,253 orders, followed by RJ (Rio de Janeiro) with 745 orders. 
States like RS (Rio Grande do Sul) and SC (Santa Catarina) showed consistent orders, 
while PE (Pernambuco) and PB (Paraíba) had fewer orders, especially in 2016. 
*/

/*
RECOMMENDATIONS:  
From the data, we observe that in October 2016, several states, such as MG (Minas 
Gerais) and MT (Mato Grosso), contributed to the order numbers, with MG having 40 
orders and MT having 3. As time progresses, the order volume increases significantly, 
particularly in August 2018, where SP (São Paulo) stands out with a total of 3,253 
orders, followed by RJ (Rio de Janeiro) with 745 orders. Other states such as RS (Rio 
Grande do Sul) and SC (Santa Catarina) show consistent order numbers in the later 
months. In contrast, some states, such as PE (Pernambuco) and PB (Paraíba), show 
fewer orders, especially in earlier months like October 2016. 
*/

-- 2. How are the customers distributed across all the states? 
SELECT 
  customer_state, 
  COUNT(DISTINCT customer_id) AS numbers_of_customers 
FROM `target.customers` 
GROUP BY customer_state 
ORDER BY numbers_of_customers DESC; 

/*
INSIGHTS: 
Our analysis of customer distribution across Brazilian states reveals that São Paulo (SP), 
Rio de Janeiro (RJ), and Minas Gerais (MG) are the top states with a significant 
customer base, while Acre (AC), Amapá (AP), and Roraima (RR) have fewer clients. 
*/

/*
RECOMMENDATIONS: 
To increase the customer base in states with fewer clients like Acre (AC), Amapá (AP), 
and Roraima (RR), we should conduct targeted marketing campaigns to boost brand 
awareness. Offering special promotions and localized deals can help attract new 
customers and build a stronger presence in these regions. 
*/

-- 4. Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others. 

-- 1. Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only). 
SELECT 
  ROUND(
    (
      SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018 
               AND EXTRACT(MONTH FROM o.order_purchase_timestamp) <= 8 
               THEN p.payment_value ELSE 0 END) -  
      SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017 
               AND EXTRACT(MONTH FROM o.order_purchase_timestamp) <= 8 
               THEN p.payment_value ELSE 0 END)
    ) / 
    SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017 
             AND EXTRACT(MONTH FROM o.order_purchase_timestamp) <= 8 
             THEN p.payment_value ELSE 1 END) * 100, 2
  ) AS percentage_increase 
FROM `target.payments` AS p 
JOIN `target.orders` AS o  
  ON p.order_id = o.order_id; 

/*
INSIGHTS: 
There was a 134.07% increase in the cost of orders from 2017 to 2018, indicating 
substantial growth in revenue. 
*/

/*
RECOMMENDATIONS: 
Given this impressive increase, we should aim for a 160% growth next year by focusing 
on high-value product expansion, customer loyalty programs and targeted marketing 
strategies to sustain the upward trend. 
*/

-- 2. Calculate the Total & Average value of order price for each state. 
SELECT 
  customer_state, 
  ROUND(SUM(p.payment_value), 2) AS total_order_price, 
  ROUND(AVG(p.payment_value), 2) AS average_order_price 
FROM `target.payments` AS p 
JOIN `target.orders` AS o 
  ON p.order_id = o.order_id 
JOIN `target.customers` AS c 
  ON o.customer_id = c.customer_id 
GROUP BY customer_state; 

/*
INSIGHTS: 
The São Paulo (SP) state shows high sales compared to other states. However, the 
average price per order is significantly lower than in other states. 
*/

/*
RECOMMENDATIONS: 
To increase the total order value, we can experiment with offering similar product 
pricing in other states as in São Paulo (SP). This approach will help us determine 
whether consistent pricing across regions can boost overall sales. 
*/

-- 3. Calculate the Total & Average value of order freight for each state. 
SELECT 
  customer_state, 
  SUM(i.freight_value) AS total_freight_value, 
  AVG(i.freight_value) AS average_freight_value 
FROM `target.order_items` AS i 
JOIN `target.orders` AS o 
  ON i.order_id = o.order_id 
JOIN `target.customers` AS c 
  ON o.customer_id = c.customer_id 
GROUP BY customer_state; 

/*
INSIGHTS: 
The average freight value is significantly higher in RR (Roraima) and PB (Paraíba), 
possibly because these are remote states, leading to higher delivery costs. In contrast, 
SP (São Paulo) offers delivery at a much lower freight value. 
*/

/*
RECOMMENDATIONS: 
Since SP has high overall sales, we can consider waiving the freight value to encourage 
more purchases. For other states, reducing freight costs could help attract more 
customers and increase sales. 
*/

-- 5. Analysis based on sales, freight and delivery time. 

-- 1. Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
-- Also, calculate the difference (in days) between the estimated & actual delivery date of an order.
SELECT 
  order_id, 
  TIMESTAMP_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) AS time_to_deliver, 
  TIMESTAMP_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY) AS diff_estimated_delivery 
FROM `target.orders`; 

/*
INSIGHTS: 
The delivery time for products ranges from 0 days to around 209 days, indicating that 
some items are delivered immediately, while others take over half a year to reach 
customers. This inconsistency may impact customer satisfaction. 
*/

/*
RECOMMENDATIONS: 
To enhance the delivery experience, we should work on reducing long delivery times 
by possibly hiring more delivery personnel and optimizing logistics processes. 
Additionally, we must address discrepancies between estimated and actual delivery 
times. Identifying the root causes of delays will help us ensure that products arrive on 
or before the promised date, boosting customer trust and satisfaction. 
*/

-- 2. Find out the top 5 states with the highest & lowest average freight value. 
WITH StateFreight AS (
  SELECT 
    customer_state, 
    AVG(freight_value) AS avg_freight 
  FROM `target.order_items` AS i 
  JOIN `target.orders` AS o 
    ON i.order_id = o.order_id 
  JOIN `target.customers` AS c 
    ON o.customer_id = c.customer_id 
  GROUP BY customer_state 
) 
(
  SELECT customer_state, avg_freight 
  FROM StateFreight 
  ORDER BY avg_freight DESC 
  LIMIT 5
) 
UNION ALL 
(
  SELECT customer_state, avg_freight  
  FROM StateFreight 
  ORDER BY avg_freight ASC 
  LIMIT 5
); 

/*
INSIGHTS: 
States like RR (Roraima), PB (Paraíba), RO (Rondônia), AC (Acre), and PI (Piauí) 
have high freight values, while SP (São Paulo), PR (Paraná), MG (Minas Gerais), 
RJ (Rio de Janeiro), and DF (Distrito Federal) have lower freight values. 
*/

/*
RECOMMENDATIONS: 
To make products more affordable in states with high freight costs (RR, PB, RO, 
AC, PI), we should aim to reduce freight charges as much as possible. This strategy 
will make our products more accessible and help attract more customers from 
these regions. Focus efforts on bringing merchants of frequently purchased goods 
closer to the same zone or plan ahead to preserve storage space for these goods. 
*/

-- 3. Find out the top 5 states with the highest & lowest average delivery time. 
WITH DeliveryTimeDays AS (
  SELECT 
    customer_state, 
    AVG(TIMESTAMP_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)) AS avg_delivery_time_days 
  FROM `target.orders` o 
  JOIN `target.customers` AS c 
    ON o.customer_id = c.customer_id 
  GROUP BY customer_state 
) 
(
  SELECT customer_state, avg_delivery_time_days 
  FROM DeliveryTimeDays 
  ORDER BY avg_delivery_time_days DESC 
  LIMIT 5
) 
UNION ALL 
(
  SELECT customer_state, avg_delivery_time_days 
  FROM DeliveryTimeDays 
  ORDER BY avg_delivery_time_days ASC 
  LIMIT 5
);

/*
INSIGHTS: 
States like SP (São Paulo), PR (Paraná), MG (Minas Gerais), DF (Distrito Federal), 
and SC (Santa Catarina) have shorter delivery times, while RR (Roraima), AP 
(Amapá), AM (Amazonas), AL (Alagoas), and PA (Pará) experience longer delivery 
times. 
*/

/*
RECOMMENDATIONS: 
To reduce delivery times in states with delays (RR, AP, AM, AL, PA), we can consider 
hiring more delivery personnel or partnering with reliable delivery services. This 
will help ensure faster and more efficient deliveries, leading to better customer 
satisfaction. 
*/

-- 4. Find out the top 5 states where the order delivery is really fast compared to the estimated delivery date.
SELECT 
  c.customer_state, 
  ABS(ROUND(AVG(DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date, DAY)), 2)) AS estimated_delivered_diff 
FROM `Target.orders` o  
JOIN `Target.customers` c 
  ON o.customer_id = c.customer_id 
WHERE  
  order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL 
  AND order_estimated_delivery_date IS NOT NULL 
GROUP BY c.customer_state 
ORDER BY estimated_delivered_diff 
LIMIT 5;

/*
INSIGHTS:
The states with the fastest order deliveries compared to the estimated delivery date are AL (Alagoas), MA (Maranhão), SE (Sergipe), ES (Espírito Santo), and BA (Bahia). These states have shown quicker delivery times, indicating efficient logistics and faster fulfillment.

RECOMMENDATIONS:
To further enhance customer satisfaction, analyze the logistics strategies in these states and consider implementing similar approaches in regions with slower deliveries. This can reduce delivery times across the board and improve overall service efficiency.
*/

-- 6.1 Month on month number of orders placed by different payment types
SELECT 
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year, 
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month, 
  payment_type, 
  COUNT(DISTINCT o.order_id) AS num_orders 
FROM `target.orders` o 
JOIN `target.payments` p  
  ON o.order_id = p.order_id 
GROUP BY year, month, payment_type 
ORDER BY year, month, payment_type;

/*
INSIGHTS:
- Credit card payments dominate across months, especially in July and August 2018, with peaks of 4738 and 4963 orders.
- UPI payments were significant in early 2017 but decreased afterward.
- Voucher payments remain steady, peaking during July and August 2018.
- Debit cards show moderate usage.
- A small number of orders are recorded as "not_defined" payment type, indicating potential data issues.

RECOMMENDATIONS:
- Focus marketing and promotions on credit card users to capitalize on the dominant payment trend.
- Introduce incentives or cashback offers to revive UPI usage.
- Boost voucher-based campaigns during peak months to maximize sales.
- Investigate and resolve the "not_defined" payment type entries to enhance data quality and improve customer experience.
*/

-- 6.2 Number of orders placed based on payment installments paid
SELECT 
  payment_installments, 
  COUNT(DISTINCT order_id) AS num_orders_placed 
FROM `target.payments` 
GROUP BY payment_installments 
ORDER BY payment_installments;

/*
INSIGHTS:
- Most orders are placed with 12 installments (133 orders), followed by 15 installments (74 orders).
- Higher installment plans like 23 and 24 installments are rarely used, indicating customer preference for standard installment options.

RECOMMENDATIONS:
- Focus marketing and promotional efforts on the popular 12-installment plan to maximize sales.
- Consider offering incentives or discounts for customers opting for higher installment plans to increase uptake.
- Analyze customer preferences for lower installment options to develop more flexible and attractive payment plans tailored to diverse customer needs.
*/

