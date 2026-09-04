CREATE OR REPLACE VIEW revenue_customer_segment AS

WITH rfm_metrics AS (
    SELECT
        COUNT(*) AS frequency,
        SUM(price) AS monetary,
        MAX(event_time) AS last_purchase_date
    FROM events
    WHERE event_type = 'purchase'
        AND zero_price_product = False
        AND negative_price = False
    GROUP BY user_id
),

recency_date AS (
    SELECT
        ((SELECT MAX(event_time)::DATE FROM events) - last_purchase_date) AS recency_days_check,
        frequency, monetary
    FROM rfm_metrics
),

rfm_split AS (
    SELECT
        NTILE(4) OVER (ORDER BY recency_days_check DESC) AS r_tier,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_tier,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_tier,
        monetary
    FROM recency_date
)

SELECT 
    r_tier || '-' || f_tier || '-' || m_tier AS rfm_tiers,
    COUNT(*) AS num_of_customers,
    ROUND(SUM(monetary::NUMERIC), 2) AS total_revenue
FROM rfm_split
GROUP BY r_tier, f_tier, m_tier
ORDER BY total_revenue DESC;

SELECT * FROM revenue_customer_segment;