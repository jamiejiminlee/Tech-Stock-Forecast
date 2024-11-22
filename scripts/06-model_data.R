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
library(lubridate)
library(arrow)

#### Load Cleaned Data ####
price_analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Prepare Training Data ####
training_data <- price_analysis_data %>%
  filter(date <= as.Date("2024-12-31"))

# Define predictors and target
predictors <- c("Price_Lag1", "Price_Change_Percent", "volume", 
                "open", "high", "low", "adjusted")
target <- "Price_Diff"

# Prepare training data matrices
X_train <- model.matrix(~ . - 1, data = training_data[, predictors])
y_train <- training_data[[target]]

xgb_model <- xgboost(
  data = X_train,
  label = y_train,
  nrounds = 100,
  objective = "reg:squarederror",
  verbose = 1,
  eta = 0.05,       
  max_depth = 4,    
  colsample_bytree = 0.7,
  subsample = 0.7,
  lambda = 2,          
  alpha = 1           
)

#### Save Model ####
saveRDS(xgb_model, file = "models/xgb_model.rds")

