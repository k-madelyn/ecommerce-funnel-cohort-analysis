CREATE OR REPLACE VIEW cart_abandon_price_tier AS

WITH price_quartiles AS (
    SELECT 
        DISTINCT product_id, price, 
        NTILE(4) OVER (ORDER BY price) AS price_quartile
    FROM events
    WHERE zero_price_product = False AND negative_price = False
), 

cart_tier_sessions AS (
    SELECT events.user_session,
        price_quartiles.price_quartile,
        MAX(CASE WHEN events.event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
    FROM events JOIN price_quartiles ON events.product_id = price_quartiles.product_id
    WHERE events.event_type IN ('cart', 'purchase')
    GROUP BY events.user_session, price_quartiles.price_quartile
)

SELECT price_quartile,
    COUNT(*) AS sessions_w_cart_in_this_tier,
    SUM(had_purchase) AS sessions_with_purchase,
    ROUND(100.0 * (COUNT(*) - SUM(had_purchase)) / NULLIF(COUNT(*), 0), 2) AS cart_abandonment_pct
FROM cart_tier_sessions
GROUP BY price_quartile
ORDER BY price_quartile;

SELECT * FROM cart_abandon_price_tier;