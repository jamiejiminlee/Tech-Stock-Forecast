#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]



#### Workspace Setup ####
library(tidyquant)
library(tidyverse)

#### Define Parameters ####
# Define the list of stocks
stocks <- c("GOOG", "AAPL", "AMZN", "MSFT") # Google, Apple, Amazon, Microsoft

# Define the date range
start_date <- "2018-01-01"
end_date <- "2024-12-31"

#### Download Data ####
# Fetch historical stock price data
raw_google_stock_data <- tq_get(stocks, from = start_date, to = end_date, get = "stock.prices")

#### Save data ####
write_csv(raw_google_stock_data, "data/01-raw_data/raw_data.csv")

