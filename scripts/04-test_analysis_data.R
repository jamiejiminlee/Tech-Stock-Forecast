#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace Setup ####
library(testthat)
library(tidyverse)
library(arrow)

#### Load Cleaned Data ####
# Load the cleaned data
cleaned_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Tests ####

# Test 1: Check that all necessary columns exist
test_that("Cleaned data contains all required columns", {
  required_columns <- c("symbol", "date", "open", "high", "low", "close", 
                        "volume", "adjusted", "Price_Lag1", "Price_Diff", "Price_Change_Percent")
  expect_true(all(required_columns %in% colnames(cleaned_data)))
})

# Test 2: Check that date column is in Date format
test_that("Date column is in correct Date format", {
  expect_true(is.Date(cleaned_data$date))
})

# Test 3: Check that there are no NA values in key columns
test_that("No missing values in key columns", {
  key_columns <- c("symbol", "date", "close", "Price_Lag1", "Price_Diff", "Price_Change_Percent")
  expect_true(all(!is.na(cleaned_data[, key_columns])))
})

# Test 4: Check that Price_Diff is correctly calculated
test_that("Price_Diff is correctly calculated", {
  recalculated_diff <- cleaned_data$close - cleaned_data$Price_Lag1
  expect_equal(cleaned_data$Price_Diff, recalculated_diff)
})

# Test 5: Check that Price_Change_Percent is correctly calculated
test_that("Price_Change_Percent is correctly calculated", {
  recalculated_percent <- (cleaned_data$Price_Diff / cleaned_data$Price_Lag1) * 100
  expect_equal(cleaned_data$Price_Change_Percent, recalculated_percent)
})

# Test 6: Check that data is sorted by symbol and date
test_that("Data is sorted by symbol and date", {
  sorted_data <- cleaned_data %>%
    arrange(symbol, date)
  expect_equal(cleaned_data, sorted_data)
})

# Test 7: Check for duplicated rows
test_that("No duplicated rows in the cleaned data", {
  expect_equal(nrow(cleaned_data), nrow(distinct(cleaned_data)))
})

