# **Ecommerce Funnel & Cohort Analysis**
## Key Findings and Recommendations
A funnel and revenue analysis of a 20M+ event e-commerce dataset, finding cart-to-purchase drop off (84%) is steeper than view-to-cart drop off (77%). Cart abandonment is relatively flat across all price tiers, suggesting product pricing strategy is not a major hindrance to conversion. New user acquisition is on an overall decline through the dataset timeline, so prioritizing focus on increasing new users is key in increasing top-of-funnel revenue potential.

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


## 4. Funnel Health Analysis

| Funnel Stage | Sessions | Conversion from prior stage |
| --- | --- | --- |
| View | 4,280,702 | — |
| Cart | 985,781 | 23.03% |
| Purchase | 155,617 | 15.79% |

### Key Insight
Cart-to-purchase has the steeper percentage drop-off (84.21% vs. 76.97%), but view-to-cart loses more pure sessions (3.3M vs. 830K). Both stages offer opportunity for improvement, but view-to-cart is a volume problem, cart-to-purchase is a conversion problem.

*Note: Purchase counts include the purchase events with no prior valid cart event in the same session. This is being treated as a legitimate potential purchase path rather than a data logging error.*

***Overall Conversion Rate by Month***

| Month | Total Views | Total Purchases | Conversion Rate |
| --- | --- | --- | --- |
| Oct 2019 | 188,860 | 35,563 | 18.83%
| Nov 2019 | 152,920 | 22,621 | 14.70%
| Dec 2019 | 135,002 | 15,006 | 11.12%
| Jan 2020 | 147,037 | 15,123 | 10.29%
| Feb 2020 | 124,045 | 10,773 | 8.68%

### Key Insight
Overall views, purchases, and conversion rates declined from October 2019 to February 2020. Despite the data set spanning the full holiday shopping season (Black Friday and winter holidays), no sustained lift is seen in November and December. This is a notable discovery, typically holiday shopping sees a rise in both views and purchases. Without acquisition or campaign data, I am unable to determine potential causes for this unusual trend, but recommend investigating traffic/demand, change in marketing activity, or data collection gap.

***Cart abandonment by price quartile***

| Price Quartile | Sessions w/ Cart | Abandonment Rate |
| --- | --- | --- |
| 1 (cheapest) | 454,510 | 78.67% |
| 2 | 513,190 | 79.93% |
| 3 | 515,424 | 79.45% |
| 4 (most expensive) | 447,529 | 76.66% |

### Key Insight
Abandonment is consistent across price tiers, suggesting pricing tier is not a primary reason for cart abandonment. This points toward other factors (shipping cost, payment options, checkout page friction) as more likely reasons for cart abandonment.


## 5. Price & Order Value Analysis

***Overall price distribution of products***

| Quartile/Position | Price
| --- | ---
| Min | 0.05 
| Q1 (25%) | 2.62
| Median | 4.59
| Average | 7.33
| Q3 (75%) | 7.70
| Max | 327.78

### Key Insight
The average product price ($7.33) is significantly higher than the median ($4.59), with the third quartile price at $7.70. This indicates a right-skewed distribution, where a small number of high priced items pull the average up.

***Average Order Value by month***

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


## 6. Cohort Retention Analysis

***Monthly Cohort Retention***

| Initial Interaction Month | Cohort Size | Customers Who Converted | Purchase within 30 days Rate |
| --- | --- | --- | --- |
| Oct 2019 | 38,290 | 28,788 | 75.18% |
| Nov 2019 | 25,041 | 21,574 | 86.15% |
| Dec 2019 | 17,358 | 15,436 | 88.93% |
| Jan 2020 | 17,241 | 16,463 | 95.49% |

### Key Insight
The conversion rate within 30 days rose consistently across every cohort from October 2019 (75.18%) to January 2020 (95.49%). However, there is a steady decline in new users, from ~38,000 to ~17,000, a 55% drop. This mirrors a similar overall traffic drop seen in the Overall Funnel Health section. This could suggest the business is reaching a smaller and more highly-converting audience rather than generally increasing conversion for a growing user base. Further information on acquisition channels could determine quality of users in each cohort.


## 7. Customer Segmentation (RFM)

***Revenue by Customer Segment (Recency, Frequency, and Monetary Tiers)***
- Top 5 segments ordered by greatest revenue

| R-F-M Tiers | Number of Customers | Total Revenue |
| --- | --- | --- |
| 4-4-4 | 7,537 | $1,565,966.68 |
| 3-4-4 | 5,236 | $834,501.79 |
| 2-4-4 | 4,130 | $582,666.50 |
| 1-4-4 | 2,882 | $385,941.90 |
| 2-3-3 | 2,872 | $126,482.75 |

### Key Insight
The highest-revenue customers are the most frequent and highest-spending customers, even without a recent purchase. Event the segment with the least recency (1-4-4) generated more revenue at $385,941.90 then the next segment (2-3-3) at $126,482.75. This indicates high frequency and spend are better indicators of customer value than how recently a customer last purchased. A potential strong win-back opportunity is the 1-4-4 segment, they have a proven tendency to purchase regularly with a high overall revenue but have recently gone quiet. A tiered approach reaction campaign to match the recency measure per cohort might be a worthwhile avenue to explore.


## 8. Category Level Findings
Category code was missing in 98% of rows, so actual product classification was difficult. Therefore, all category findings will be in reference to the category id number and could be connected back to actual products in a real business scenario.

***Categories Ranked by View-to-Purchase Rate***
- Top and bottom five categories

| Rank | Category Id | View to Purchase Rate | Views | Purchases
| --- | --- | --- | --- | ---|
| 1 | 1487580011476025461 | 73.39% | 977 | 717 |
| 2 | 1487580007592100809 | 67.38% | 4454 | 3001 |
| 3 | 1487580009622143014 | 66.87% | 2137 | 1429 |
| 4 | 1487580010821714008 | 50.82% | 9524 | 4840 |
| 5 | 2055161088059638328 | 50.36% | 8442 | 4251 |
| — | — | — |
| 420 | 1487580005025186644 | 0.53% | 3044 | 16 |
| 421 | 1487580006157648777 | 0.42% | 480 | 2 |
| 422 | 1547480590851244887 | 0.29% | 1389 | 4 |
| 423 | 1487580009739583530 | 0.0% | 720 | 0 |
| 424 | 1487580014093271270 | 0.0% | 1303 | 0 |

### Key Insight
The top 5 categories convert at 50%-73%, far beyond the typical e-commerce rate of approximately 1%-5%. A concerning 0% retention rate appears in the bottom two ranks, indicating an issue with the product or product page considering the decent number of product page views. The significant spread between the top and bottom performing categories indicates a possible structural difference in the view to purchase process. A manual review of these specific product pages to determine areas to reduce friction and promote better conversion could increase the conversion rates.

***Categories by Cohort Retention***
- Top 10 categories

| Rank | Category Id | Retention Rate | Cohort Size | Repeat Purchasers
| --- | --- | --- | --- | --- |
| 1 | 2151191071051219817 | 13.16% | 1,611 | 212 |
| 2 | 1487580007675986893 | 9.57% | 13,437 | 1,286 |
| 3 | 1487580006317032337 | 9.44% | 15,927 | 1,504 |
| 4 | 1783999068909863670 | 9.22% | 3,711 | 342 |
| 5 | 1487580005092295511 | 8.97% | 23,478 | 2,196 |
| 6 | 1487580004916134735 | 8.90% | 4,348 | 387 |
| 7 | 1911999801088541491 | 8.89% | 135 | 12 |
| 8 | 2193074740619379535 | 8.71% | 264 | 23 |
| 9 | 2018395024110125980 | 8.66% | 335 | 29 |
| 10 | 1487580013522845895 | 8.33% | 4,864 | 405 |

### Key Insight
Within the top ten categories based on retention, the most statistically reliable (1,600+ initial purchase cohort size) categories have retention rates sitting within 8.33%-9.57%. Category 2151191071051219817 stands out uniquely at 13.16% retention. This warrants referencing the actual category contents to determine if the high relative retention is related to pricing structure, replenishable/consumable product type, or other driver that could inform future merchandising/promotion strategies for similar categories.


## 9. Business Recommendations
### Priority 1: Investigate checkout/cart friction over pricing changes
Cart abandonment (76.7%-79.9%) is essentially flat across price tiers, so pricing adjustments are unlikely to cause major changes to abandonment on their own. Effort is better directed at checkout-flow friction (shipping cost transparency, payment options, form complexity) than at price positioning.

### Priority 2: Investigate declining new-user acquisition
Two analyses indicate one underlying issue: monthly views and conversion rate both declined from October 2019 - February 2020 (section 4). Cohort size dropped over 55% during that same time period, even as 30-day cohort conversion rate rose (section 6). This suggests the business is retaining a smaller, higher-quality audience rather than growing overall user base. With acquisition and campaign data (not available in this dataset), would help determine if this is a deliberate shift in targeting, market-demand issue, or a data collection issue. This has potential to drastically increase top-of-funnel metrics and revenue potential, so it is worth prioritization.

### Priority 3: Launch a win-back campaign targeting the 1-4-4 RFM segment
This segment has a proven history of frequent high-value purchasing, and has generated $385,941.90 in historical revenue - more than any other segment other than the top F4-M4 tiers. A tiered targeting campaign adjusted for the level of recency has more potential for returns than broad, undifferentiated outreach in order to increase revenue from proven past purchasing behavior.

### Priority 4: Prioritize view-to-cart volume alongside cart-to-purchase rate
While cart-to-purchase has higher percentage drop-off, view-to-cart accounts for larger session loss (3.3M). A small percentage-point improvement here would recover more total sessions than an equivalent improvement for the cart-to-purchase rate.

**Worth Exploratory Investigation**
- Zero Conversion Categories: had over 700 product views but no purchases, worth manual review of product pages within the category to determine if there is potential friction preventing purchases
- Category 2151191071051219817's outlier high retention: worth determining what this category of products includes to identify potential drivers to inform future product strategy elsewhere.



## 10. Tech Stack & Reproducibility
- **Cleaning:** Python (pandas)
- **Database:** PostgreSQL
- **Analysis:** SQL

**To reproduce:**
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/mkechinov/ecommerce-events-history-in-cosmetics-shop/discussion/128401) and place CSVs in `data/raw/`
2. `pip install -r requirements.txt`
3. Create a `.env` file with Postgres credentials
4. Run the cleaning script, then the loading script
5. Run the SQL files in `sql/` against the loaded database


## 11. Why This Project
This project demonstrates end-to-end funnel and revenue analysis on large and messy real-world dataset, including data-quality investigation and judgment calls, SQL-based business-question answering, and translating findings into evidence-based recommendations.