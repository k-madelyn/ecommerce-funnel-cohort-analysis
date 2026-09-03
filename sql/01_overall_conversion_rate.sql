CREATE OR REPLACE VIEW monthly_conversion_rate AS 

WITH compact_sessions AS (
    SELECT user_id,
        MIN(event_time)::DATE AS session_date,
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS total_views,
        SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS total_cart,
        SUM(CASE WHEN event_type = 'remove_from_cart' THEN 1 ELSE 0 END) AS total_remove,
        SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS total_purchases
    FROM events
    GROUP BY DISTINCT(user_id)
    ORDER BY MIN(event_time)::DATE
),

monthly_sessions AS (
    SELECT DATE_TRUNC('month', session_date)::DATE AS month,
        COUNT(*) AS total_sessions,
        SUM(CASE WHEN total_views > 1 THEN 1 ELSE 0 END) AS sessions_with_view,
        SUM(CASE WHEN total_purchases > 1 THEN 1 ELSE 0 END) AS sessions_with_purchase
    FROM compact_sessions
    GROUP BY DATE_TRUNC('month', session_date) 
)

SELECT month,
    sessions_with_view,
    sessions_with_purchase,
    ROUND(100.0 * sessions_with_purchase / NULLIF(sessions_with_view, 0), 2) AS view_to_purchase_pct
FROM monthly_sessions
ORDER BY month ASC;