USE magist;

#Basic exploration of the main facts within the database #

# How many orders are in the dataset?#
SELECT count((product_id))
from products;

/*  How many of the Orders are delivered
 INSIGHT: 97% of all orders are delivered -- so there is no issue with availability or canceling */
 
SELECT  order_status, count(*) as `number of orders`,  round(count(*) *100.0 / Sum(count(*)) over(),2) As `percentage of orders`
FROM orders
GROUP BY order_status;


/* Is Magist having user growth ? */
Select  year(order_purchase_timestamp) as `year`, count(customer_id) as `customers`
from orders
Group by year(order_purchase_timestamp)
Order BY `year`;

/* How many products are there per Category  with category translated into English */
SELECT count(span.product_id) AS `number of products`, english.product_category_name_english AS category
FROM products as span
JOIN product_category_name_translation AS english USING (product_category_name)
Group BY english.product_category_name
ORDER BY `number of products` DESC ;

/* Average Time  needed for a delivery, divided into several steps*/
SELECT
round(avg(datediff(order_delivered_carrier_date, order_purchase_timestamp) ),0)as `time to post`,
round(avg(datediff(order_delivered_customer_date, order_delivered_carrier_date)),0) as `time post to customer` ,
round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),0) as `total delivery time`
FROM orders;

/* Average time needed for delivery - grouped by review_score
Assumption confirmed: 1 Star reviews with longer delivery time*/
Select review_score, 
round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),0) as `total delivery time`
FROM order_reviews
JOIN orders using(order_id)
GROUP BY review_score;

/* Order Reviews - what is the share of 5 star reviews? */ 
SELECT format(count(order_id), '#,0,00') as `number of orders`, count(order_id)*100 / sum(count(order_id)) Over() as `% of orders`, review_score
FROM order_reviews
GROUP BY review_score
ORDER by review_score DESC;

/* How many products are there per Category  with category translated into English */
SELECT count(span.product_id) AS `number of products`, english.product_category_name_english AS category
FROM products as span
JOIN product_category_name_translation AS english USING (product_category_name)
Group BY english.product_category_name
ORDER BY `number of products` DESC ;

/* Number of sellers in the category "Tech" */
SELECT count(seller_id)
FROM  order_items
 join products
 using (product_id)
 join product_category_name_translation 
 using(product_category_name)
 where product_category_name_english in("audio", "cds_dvds_musicals", 
"cine_photo", "air_conditioning", "consoles_games", "electronics", "home_appliances", "dvds_blue_ray",
 "home_appliances_2", "industry_commerce_and_business", "computer_accessories", "pc_gamer", "computers",  "small_appliances%" , "security_services",
 "signaling_and_security","tablets_printing_image", "telephony") ;
/* Average Seller income per month */

SELECT seller_id, (Sum(price) / count(DISTINCT(month(shipping_limit_date))))
as `average_income`
FROM Order_items
GROUP BY  seller_id;


