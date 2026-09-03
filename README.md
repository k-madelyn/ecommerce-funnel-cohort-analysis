# **Ecommerce Funnel & Cohort Analysis**
## Key Findings and Recommendations
A funnel and revenue analysis of a 20M+ event e-commerce dataset, finding cart-to-purchase drop off (84%) is steeper than view-to-cart drop off (77%). Cart abandonment is relatively flat across all price tiers, suggesting product pricing strategy is not a major hindrance to conversion.

## 1. Dataset Overview
This project is an analysis of the user behavior within the REES46 "eCommerce Events History in Cosmetics Shop" from Kaggle. It contains 20M+ lines of data captured from October 2019 through February 2020.

This dataset tracks the user journey via events:
- view
- cart
- remove_from_cart
- purchase

Each event contains an event time, a user id and unique user session id, as well as product and pricing data.

Link to dataset: [Kaggle](https://www.kaggle.com/datasets/mkechinov/ecommerce-events-history-in-cosmetics-shop/discussion/128401)

## 2. Limitations of the Dataset
There are a few missing pieces from this dataset that prevent certain types of analysis.
1. No acquisition channel data - unable to evaluate how the customer was captured (social media, email, etc.).
2. No profit or margin data - all price calculations will connect to gross revenue.
3. No information on why a user did not purchase or why they dropped off.
4. Single device tracking for sessions - no way to evaluate if the same user is using a different device.

---
## 3. Data Cleaning

Duplicate and blank rows were removed. Several data issues were found and noted in the final clean events table.
- 24 products associated with more than one brand value
    - flagged with 'multiple_brands' column
- 662 products with ONLY a zero dollar price
    - flagged with 'zero_price_product' column
- 21,332 products with some $0 mixed in with real prices
    - 'price_corrected' column added to flag changed prices, median price for the same product used to replace any $0 prices
- 5 products with negative prices
    - 'negative_price' column added to flag, will be excluded from price calculations
- 'category_code' missing in 98% of rows (non-random)
    - any calculations done with this column will reference the 'category_id' (near complete coverage) and be used exploratorily
- 8% of purchase events without valid cart events prior
    - could be an indicator of a repurchase or buy now flow, flagged with 'purchase_without_cart' column

---
## 4. Funnel Health Analysis

| Funnel Stage | Sessions | Conversion from prior stage |
| --- | --- | --- |
| View | 4,280,702 | — |
| Cart | 985,781 | 23.03% |
| Purchase | 155,617 | 15.79% |

### Key Insight
Cart-to-purchase has the steeper percentage drop-off (84.21% vs. 76.97%), but view-to-cart loses more pure sessions (3.3M vs. 830K). Both stages offer opportunity for improvement, but view-to-cart is a volume problem, cart-to-purchase is a conversion problem.

*Note: Purchase counts include the purchase events with no prior valid cart event in the same session. This is being treated as a legitimate potential purchase path rather than a data logging error.*

---
## 5. Price & Order Value Analysis

**Average Order Value by month**

| Month | Average Order Value | Median Order Value |
| --- | --- | --- |
| Oct 2019 | $40.96 | $29.79 |
| Nov 2019 | $41.57 | $30.95 |
| Dec 2019 | $37.07 | $26.03 |
| Jan 2020 | $40.54 | $29.93 |
| Feb 2020 | $40.68 | $28.57 |

*Note: Sessions were capped at an interval of one day to allow for bulk orders to be included in the calculation but to prevent from unusually long sessions to skew the Average Order Value.*

### Key Insight
AOV is stable from month to month with no strong upward or downward trend. The consistent gap between average and median indicates a right-skewed distribution — a small number of high value orders pulling the average higher than the typical order.

**Cart abandonment by price quartile**

| Price Quartile | Sessions w/ Cart | Abandonment Rate |
| --- | --- | --- |
| 1 (cheapest) | 454,510 | 78.67% |
| 2 | 513,190 | 79.93% |
| 3 | 515,424 | 79.45% |
| 4 (most expensive) | 447,529 | 76.66% |

### Key Insight
Abandonment is consistent across price tiers, suggesting pricing tier is not a primary reason for cart abandonment. This points toward other factors (shipping cost, payment options, checkout page friction) as more likely reasons for cart abandonment.

---
## 6. Business Recommendations
### Priority 1: Investigate checkout/cart friction over pricing changes
Cart abandonment (76.7%-79.9%) is essentially flat across price tiers, so pricing adjustments are unlikely to cause major changes to abandonment on their own. Effort is better directed at checkout-flow friction (shipping cost transparency, payment options, form complexity) than at price positioning.

### Priority 2: Prioritize view-to-cart volume alongside cart-to-purchase rate
While cart-to-purchase has higher percentage drop-off, view-to-cart accounts for larger session loss (3.3M). A small percentage-point improvement here would recover more total sessions than an equivalent improvement for the cart-to-purchase rate.

---
## 7. Tech Stack & Reproducibility
- **Cleaning:** Python (pandas)
- **Database:** PostgreSQL
- **Analysis:** SQL

**To reproduce:**
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/mkechinov/ecommerce-events-history-in-cosmetics-shop/discussion/128401) and place CSVs in `data/raw/`
2. `pip install -r requirements.txt`
3. Create a `.env` file with Postgres credentials
4. Run the cleaning script, then the loading script
5. Run the SQL files in `sql/` against the loaded database

---
## 8. Why This Project
This project demonstrates end-to-end funnel and revenue analysis on large and messy real-world dataset — including data-quality investigation and judgment calls, SQL-based business-question answering, and translating findings into evidence-based recommendations.