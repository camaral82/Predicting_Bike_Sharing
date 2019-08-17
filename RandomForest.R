' 

Building a RANDOM FOREST model for bike rentals

'

# Random seed to reproduce results
seed <- set.seed(123)


# Fit and print the random forest model
(bike_model_rf <- ranger(fmla, # formula 
                         bikesJuly, # data
                         num.trees = 500, 
                         respect.unordered.factors = "order", 
                         seed = seed))


'Predict bike rentals with the random forest model'

# Make predictions on the August data
bikesAugust$predRF <- predict(bike_model_rf, bikesAugust)$predictions

# Calculate the RMSE of the predictions
RMSE_RF <- bikesAugust %>% 
            mutate(residual = cnt - predRF)  %>% # calculate the residual
            summarize(RMSE_RandomForest  = sqrt(mean(residual^2)))      # calculate rmse
RMSE_RF

# Plot actual outcome vs predictions (predictions on x-axis)
ggplot(bikesAugust, aes(x = predRF, y = cnt)) + 
  geom_point() + 
  geom_abline()
'This random forest model outperforms the poisson 
count model on the same data; 
it is discovering more complex non-linear or 
non-additive relationships in the data.
'

first_two_weeks <- bikesAugust %>% 
  # Set start to 0, convert unit to days
  mutate(instant = (instant - min(instant)) / 24) %>% 
  # Gather cnt and pred into a column named value with key valuetype
  gather(key = valuetype, value = value, cnt, predRF) %>%
  # Filter for rows in the first two
  filter(instant < 14) 


str(first_two_weeks)

# Plot predictions and cnt by date/time 
randomforest_plot <- ggplot(first_two_weeks, aes(x = instant, 
                            y = value, 
                            color = valuetype, 
                            linetype = valuetype)) + 
  geom_point() + 
  geom_line() + 
  scale_x_continuous("Day", breaks = 0:14, labels = 0:14) + 
  scale_color_brewer(palette = "Dark2") + 
  ggtitle("Predicted August bike rentals, Random Forest plot")

randomforest_plot

'Conclusion: The random forest model captured the day-to-day variations in 
peak demand better than the quasipoisson model, 
but it still underestmates peak demand, 
and also overestimates minimum demand. 
So there is still room for improvement.'