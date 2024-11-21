#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace Setup ####
library(tidyverse)
library(lubridate)
library(arrow)

#### Load Raw Data ####
# Load the raw data
raw_google_stock_data <- read_csv("data/01-raw_data/raw_data.csv")

#### Data Cleaning ####
# Clean and preprocess the data
price_analysis_data <- raw_google_stock_data %>%
  # Convert the date column to Date type
  mutate(date = as.Date(date)) %>%
  
  # Sort by symbol and date to ensure proper calculation of lagged values
  arrange(symbol, date) %>%
  
  # Add lagged closing price for each stock
  group_by(symbol) %>%
  mutate(
    Price_Lag1 = lag(close), # Previous day's closing price
    Price_Diff = close - Price_Lag1, # Daily price difference
    Price_Change_Percent = (Price_Diff / Price_Lag1) * 100 # Daily percentage change
  ) %>%
  
  # Ungroup after calculations
  ungroup() %>%
  
  # Select relevant columns
  select(
    symbol, date, open, high, low, close, volume, adjusted, 
    Price_Lag1, Price_Diff, Price_Change_Percent
  ) %>%
  
  # Remove rows with NA (e.g., the first day for each stock)
  drop_na()

#### Save Cleaned Data ####
# Save the cleaned data as a Parquet file
write_parquet(price_analysis_data, "data/02-analysis_data/analysis_data.parquet")



