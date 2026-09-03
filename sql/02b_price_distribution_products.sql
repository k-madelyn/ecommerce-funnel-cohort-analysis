CREATE OR REPLACE VIEW price_distribution_products AS

SELECT MIN(price) AS min_price,
    ROUND(PERCENTILE_CONT(.25) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS first_quartile_price,
    ROUND(PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS median_price,
    ROUND(AVG(price)::NUMERIC, 2) AS avg_price,
    ROUND(PERCENTILE_CONT(.75) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS third_quartile_price,
    MAX(price) AS max_price
FROM (
    SELECT DISTINCT(product_id), price FROM events 
    WHERE zero_price_product = False AND negative_price = False
) AS unique_products;

SELECT * FROM price_distribution_products;