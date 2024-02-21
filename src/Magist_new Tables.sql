/* Writing a new table dividing sellers into tech and non tech category */

CREATE table new_category(seller_id varchar(255), new_category varchar(255));

Insert into new_category (seller_id, new_category)
SELECT seller_id, 
CASE WHEN product_category_name_english in ("audio", "cds_dvds_musicals", 
"cine_photo", "air_conditioning", "consoles_games", "electronics", "home_appliances", "dvds_blue_ray",
 "home_appliances_2", "industry_commerce_and_business", "computer_accessories", "pc_gamer", "computers",  "small_appliances%" , "security_services",
 "signaling_and_security","tablets_printing_image", "telephony") THEN "TECH"
ELSE "other"  END As `New_category`
FROM sellers
JOIN order_items USING(seller_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name);

/* Writing a new table that aggregates the average order volume per month and average delivery time */ 

Create table order_volume(`year` varchar(255),`month` varchar(255), order_volume int, delivery_time varchar(255));
Insert into order_volume (`year`, `month`, order_volume, delivery_time)
SELECT year(order_purchase_timestamp), 
month(order_purchase_timestamp), 
count(order_id), 
avg(datediff(order_delivered_customer_date,order_purchase_timestamp))
FROM orders
GROUP BY  year(order_purchase_timestamp), month(order_purchase_timestamp)
;
