CREATE OR REPLACE VIEW category_cohort_retention AS

WITH first_purchase_date AS (
    SELECT
        user_id,
        MIN(event_time) AS first_purchase_date,
        category_id
    FROM events
    WHERE event_type = 'purchase' AND negative_price = False
    GROUP BY user_id, category_id
),
repeat_purchases AS (
    SELECT
        f.category_id, f.user_id, f.first_purchase_date,
        MAX(CASE WHEN e.event_type = 'purchase'
                AND e.event_time > f.first_purchase_date
                AND e.event_time - f.first_purchase_date < INTERVAL '30 days'
                THEN 1 ELSE 0 END) AS repeat_purchase_within_30d
    FROM events AS e JOIN first_purchase_date AS f
        ON e.user_id = f.user_id AND f.category_id = e.category_id
    GROUP BY f.user_id, f.category_id, f.first_purchase_date
)

SELECT
    COUNT(*) AS cohort_size,
    category_id,
    SUM(repeat_purchase_within_30d) AS num_repeat_purchasers,
    ROUND(100.0 * SUM(repeat_purchase_within_30d) / NULLIF(COUNT(*), 0), 2) AS retention_rate_pct
FROM repeat_purchases
GROUP BY category_id
HAVING COUNT(*) > 100
ORDER BY retention_rate_pct DESC
LIMIT 10;

SELECT * FROM category_cohort_retention;