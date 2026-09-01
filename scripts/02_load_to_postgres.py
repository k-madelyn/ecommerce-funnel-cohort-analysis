# ================================
# IMPORT LIBRARIES
# ================================
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine
import os

# ================================
# ACCESS DATABASE ENVIRONMENT VARIABLES
# ================================
load_dotenv()

db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")

# ================================
# READ THE CLEANED DATA INTO A TABLE OBJECT
# ================================
cleaned_data = pd.read_csv('data/cleaned/clean_ecom_events.csv')

# ================================
# CONNECT TO POSTGRES AND PREPARE FOR ANALYSIS
# ================================
connection_string = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
engine = create_engine(connection_string)

cleaned_data.to_sql("events", engine, if_exists='replace', index=False)

# success message
print("Data loaded successfully into Postgres, ready for analysis.")