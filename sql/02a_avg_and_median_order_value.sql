CREATE OR REPLACE VIEW avg_and_median_order_value AS

WITH order_totals AS (
    SELECT user_session,
        MIN(event_time) AS order_date,
        SUM(price) AS order_total
    FROM events
    WHERE event_type = 'purchase' AND zero_price_product = False
    GROUP BY user_session
    HAVING MAX(event_time) - MIN(event_time) < INTERVAL '1 day'
)

SELECT DATE_TRUNC('month', order_date)::DATE AS month,
    ROUND(AVG(order_total)::NUMERIC, 2) AS average_order_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY order_total)::NUMERIC, 2) AS median_order_value
FROM order_totals
GROUP BY DATE_TRUNC('month', order_date)::DATE
ORDER BY month;

SELECT * FROM avg_and_median_order_value;