#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace Setup ####
library(xgboost)
library(tidyverse)
library(arrow)

#### Load Cleaned Data ####
# Load the cleaned data
price_analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Prepare the Data ####
# Define training period (up to Dec 2024)
training_data <- price_analysis_data %>%
  filter(date <= as.Date("2024-12-31"))

# Define testing period (Q1 2025)
testing_data <- price_analysis_data %>%
  filter(date >= as.Date("2025-01-01") & date <= as.Date("2025-03-31"))

# Define predictors and target
predictors <- c("Price_Lag1", "Price_Change_Percent", "volume", 
                "open", "high", "low", "adjusted")
target <- "Price_Diff"

# Prepare training data matrices
X_train <- model.matrix(~ . - 1, data = training_data[, predictors])
y_train <- training_data[[target]]

# Prepare testing data matrices
X_test <- model.matrix(~ . - 1, data = testing_data[, predictors])
y_test <- testing_data[[target]]

#### Train the XGBoost Model ####
xgb_model <- xgboost(
  data = X_train,
  label = y_train,
  nrounds = 100,               # Number of boosting rounds
  objective = "reg:squarederror", # Regression task for continuous outcome
  verbose = 1,                 # Print progress
  eta = 0.1,                   # Learning rate
  max_depth = 6,               # Maximum tree depth
  colsample_bytree = 0.8,      # Fraction of columns sampled per tree
  subsample = 0.8              # Fraction of rows sampled per iteration
)

#### Save Model ####
# Save the trained model
saveRDS(
  xgb_model,
  file = "models/xgb_model.rds"
)


