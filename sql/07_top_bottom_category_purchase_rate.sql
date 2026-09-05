CREATE OR REPLACE VIEW category_purchase_rate AS

WITH views_and_purchases AS (
    SELECT
        category_id,
        COUNT(*) FILTER (WHERE event_type = 'view') AS views_per_category,
        COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchases_per_category
    FROM events
    GROUP BY category_id
),
view_purchase_calc AS (
    SELECT
        category_id,
        ROUND(100.0 * purchases_per_category / NULLIF(views_per_category, 0), 2) AS view_to_purchase_pct
    FROM views_and_purchases
    WHERE views_per_category > 400
),
rank_calc AS (
    SELECT
        category_id,
        ROW_NUMBER() OVER (ORDER BY view_to_purchase_pct DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY view_to_purchase_pct ASC) AS bottom_rank
    FROM view_purchase_calc
)

SELECT
    category_id,
    top_rank AS rank
FROM rank_calc
WHERE top_rank <= 5 OR bottom_rank <= 5
ORDER BY top_rank ASC, bottom_rank ASC;

SELECT * FROM category_purchase_rate;