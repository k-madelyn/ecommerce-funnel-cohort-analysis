# ================================
# IMPORT LIBRARIES
# ================================
import glob as glob
import pandas as pd

# ================================
# GRAB ALL CSV FILE PATHS, MAKE DATAFRAME, AND ORDER BY DATE
# ================================
csv_files = glob.glob("data/raw/*.csv")
data = pd.concat((pd.read_csv(file) for file in csv_files), ignore_index=True)

data['event_time'] = pd.to_datetime(data['event_time']).dt.tz_localize(None)
sorted_data = data.sort_values(by='event_time', ignore_index=True)

# ================================
# REMOVE BLANK ROWS AND DUPLICATES
# ================================
no_dup_data = sorted_data.drop_duplicates(ignore_index=True)
no_dup_data.dropna(how='all', inplace=True)

# ================================
# ADD ROW TO DOCUMENT MULTIPLE BRANDS FOR ONE PRODUCT_ID
# ================================
brand_check = no_dup_data.dropna(subset=['brand']).groupby('product_id')['brand'].unique()
multiple_brands = brand_check[brand_check.str.len() > 1]

no_dup_data['multiple_brands'] = no_dup_data['product_id'].isin(multiple_brands.index)

# ================================
# ADD ROW TO DOCUMENT NEGATIVE PRICE PRODUCTS
# ================================
no_dup_data['negative_price'] = no_dup_data['price'] < 0

# ================================
# ADD ROW TO DOCUMENT ZERO DOLLAR PRODUCTS (POTENTIAL FREEBIES)
# ================================
zero_price = no_dup_data[no_dup_data['price'] == 0]
zero_ids = zero_price['product_id'].unique()
real_price = no_dup_data[(no_dup_data['product_id'].isin(zero_ids)) & (no_dup_data['price'] > 0)]['product_id'].unique()
only_zero_ids = no_dup_data[(no_dup_data['product_id'].isin(zero_ids)) & (~no_dup_data['product_id'].isin(real_price))]['product_id'].unique()

no_dup_data['zero_price_product'] = no_dup_data['product_id'].isin(only_zero_ids)

# ================================
# CORRECT PRICES FOR PRODUCTS THAT HAVE SOME ENTRIES AS $0 -> REPLACE WITH MEDIAN PRICE FROM SAME PRODUCT ID
# ================================
prices_real = no_dup_data[(no_dup_data['price'] > 0) & no_dup_data['product_id'].isin(real_price)]
median_prices = prices_real.groupby('product_id')['price'].median()

no_dup_data['price_corrected'] = (no_dup_data['price'] == 0) & no_dup_data['product_id'].isin(real_price)

no_dup_data.loc[
    (no_dup_data['product_id'].isin(real_price)) & (no_dup_data['price'] == 0), 'price'
] = no_dup_data.loc[
    (no_dup_data['product_id'].isin(real_price)) & (no_dup_data['price'] == 0), 'product_id'
].map(median_prices)

# ================================
# PURCHASE EVENTS WITHOUT VALID CART EVENTS PRIOR -> ADD COLUMN TO FLAG
# ================================
cart_events = no_dup_data[no_dup_data['event_type'] == 'cart'][['user_id', 'product_id']].drop_duplicates()

purchase_events = no_dup_data[no_dup_data['event_type'] == 'purchase'].reset_index()
merged = purchase_events.merge(cart_events, on=['user_id', 'product_id'], how='left', indicator=True)

no_cart_index = merged[merged['_merge'] == 'left_only']['index']

no_dup_data['purchase_without_cart'] = no_dup_data.index.isin(no_cart_index)

# ================================
# CREATE NEW CLEAN CSV FILE
# ================================
no_dup_data.to_csv('data/cleaned/clean_ecom_events.csv', index=False)