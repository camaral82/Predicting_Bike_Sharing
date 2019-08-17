

'QUASIPOISSON Regression to predict counts'

set.seed(123)
# Calculate the mean and variance of the outcome
(mean_bikes <- mean(bikesJuly$cnt))
(var_bikes <- var(bikesJuly$cnt))


'Once the Poisson model assumes that mean(y) = var(y) 
I decided to use Quasipoisson because in this case
var(y) is much different from mean(y)'

# Fit the QuasiPoisson Model
bike_model_QP <- glm(fmla, 
                  data = bikesJuly, 
                  family = quasipoisson)

# Call glance to look at the model's fit statistics. 
(perf <- glance(bike_model_QP))

# Calculate pseudo-R-squared
(pseudoR2 <- 1 - perf$deviance/perf$null.deviance)


'Predicting bike rentals on new data'

# Using predict function to predict the number of bikes per hour on the bikesAugust data
#type = "response" to get the predict rates.
bikesAugust$predQP  <- predict(bike_model_QP, 
                             newdata = bikesAugust, 
                             type = "response")

# Calculate the RMSE
RMSE_QP <- bikesAugust %>% 
            mutate(residual = predQP - cnt) %>%
            summarize(RMSE_Quasipoisson  = sqrt(mean(residual^2)))

RMSE_QP


# Plot predictions vs cnt (pred on x-axis) 
#using the standard "outcome vs. prediction" scatter plot
ggplot(bikesAugust, aes(x = predQP, y = cnt)) +
  geom_point() + 
  geom_abline(color = "darkblue")

'Quasipoisson models predict non-negative rates, 
making them useful for count or frequency data.'



'Visualizing the Bike Rental Predictions'

# Plot predictions and cnt by date/time
quasipoisson_plot <- bikesAugust %>% 
        # set start to 0, convert unit to days
        mutate(instant = (instant - min(instant))/24) %>%  
        # gather cnt and pred into a value column
        gather(key = valuetype, value = value, cnt, predQP) %>%
        filter(instant < 14) %>% # restric to first 14 days
        # plot value by instant
        ggplot(aes(x = instant, 
                   y = value, 
                   color = valuetype, 
                   linetype = valuetype)) + 
        geom_point() + 
        geom_line() + 
        scale_x_continuous("Day", breaks = 0:14, labels = 0:14) + 
        scale_color_brewer(palette = "Dark2") + 
        ggtitle("Predicted August bike rentals, Quasipoisson model")

quasipoisson_plot

'Conclusion: This model mostly identifies the slow and busy hours of the day, 
although it often underestimates peak demand.'
