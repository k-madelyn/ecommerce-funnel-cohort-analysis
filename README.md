# **Ecommerce Funnel & Cohort Analysis**
## Key Findings and Recommendations
[Analysis in progress - recommendations coming soon.]

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
**Review docs/cleaning_notes.md for more detail**

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
