CREATE OR REPLACE VIEW funnel_user_loss AS

WITH session_funnel AS (
SELECT 
    MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS had_view,
    MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
FROM events
GROUP BY user_session
)

SELECT
    SUM(had_view) AS sessions_with_view,
    SUM(had_cart) AS sessions_with_cart,
    SUM(had_purchase) AS sessions_with_purchase,
    ROUND(100.0 * SUM(had_cart)/ NULLIF(SUM(had_view), 0), 2) AS view_to_cart_pct,
    ROUND(100.0 * SUM(had_purchase)/ NULLIF(SUM(had_cart), 0), 2) AS cart_to_purchase_pct,
    ROUND(100 - (ROUND(100.0 * SUM(had_purchase)/ NULLIF(SUM(had_cart), 0), 2)), 2) AS abandoned_cart_pct
FROM session_funnel;

SELECT * FROM funnel_user_loss;