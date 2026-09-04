WITH user_first_event AS (
    SELECT user_id, MIN(event_time) AS first_event,
        DATE_TRUNC('month', MIN(event_time))::DATE AS month
    FROM events
    GROUP BY user_id
),

repeat_purchases AS (
    SELECT u.user_id, u.first_event, u.month,
        MAX(CASE WHEN e.event_type = 'purchase'
            AND e.event_time > u.first_event
            AND e.event_time <= u.first_event + INTERVAL '30 days'
            THEN 1 ELSE 0 END) AS purchase_within_30_days
    FROM events AS e JOIN user_first_event AS u ON e.user_id = u.user_id
    WHERE e.event_type = 'purchase'
    GROUP BY u.user_id, u.first_event, u.month
)

SELECT month,
    COUNT(*) AS cohort_size,
    SUM(purchase_within_30_days) AS customers_repeat_purchase,
    ROUND(100.0 * SUM(purchase_within_30_days) / NULLIF(COUNT(*), 0), 2) AS repeat_purchase_pct
FROM repeat_purchases
GROUP BY month
HAVING month <= (SELECT MAX(event_time)::DATE - INTERVAL '30 days' FROM events)
ORDER BY month;
