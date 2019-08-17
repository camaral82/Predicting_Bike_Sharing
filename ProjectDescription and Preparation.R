'16/08/2019 - Friday


Predicting Bike Rentals

In this project I will build a 3 different models to predict the number 
of bikes rented in an hour as a function of the weather, 
the type of day (holiday, working day, or weekend), 
and the time of day. 
I will train the model on data from the month of July.

The data frame has the columns:
>>> cnt: the number of bikes rented in that hour (the outcome)
>>> hr: the hour of the day (0-23, as a factor)
>>> holiday: TRUE/FALSE
>>> workingday: TRUE if neither a holiday nor a weekend, else FALSE
>>> weathersit: categorical, "Clear to partly cloudy"/"Light Precipitation"/"Misty"
>>> temp: normalized temperature in Celsius
>>> atemp: normalized "feeling" temperature in Celsius
>>> hum: normalized humidity
>>> windspeed: normalized windspeed
>>> instant: the time index -- number of hours since beginning of data set 
(not a variable)
>>> mnth and yr: month and year indices (not variables)


Data Preparation'

load("~/3. DATACAMP/Projects/Bike_Project/Bikes.RData")
setwd("~/3. DATACAMP/Projects/Bike_Project")

library(tidyr)
library(broom)
library(dplyr)
library(tidyr)
library(ggplot2)
library(randomForest)
library(ranger)

library(vtreat)
library(magrittr)
library(xgboost)


str(bikesJuly)
str(bikesAugust)

# The outcome column
outcome <- "cnt" 

# The inputs to use
vars <- c("hr", "holiday", "workingday", "weathersit", 
          "temp", "atemp", "hum", "windspeed") 

# Create the formula string for bikes rented as a function of the inputs
(fmla <- paste(outcome, "~", paste(vars, collapse = " + ")))

