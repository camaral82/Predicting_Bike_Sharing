'
GRADIENT BOOSTING
'

'Finding the right number of trees for a gradient boosting machine'

set.seed(123)
# Create the treatment plan from bikesJuly (the training data)
treatplan <- designTreatmentsZ(bikesJuly, vars, verbose = FALSE)

# Get the "clean" and "lev" variables from the scoreFrame
(newvars <- treatplan %>%
    use_series(scoreFrame) %>%        
    filter(code %in% c("clean", "lev")) %>%  # get the rows you care about
    use_series(varName))           # get the varName column

# Prepare the training data
bikesJuly.treat <- prepare(treatplan, bikesJuly,  varRestriction = newvars)

# Prepare the test data
bikesAugust.treat <- prepare(treatplan, bikesAugust,  varRestriction = newvars)

# Call str() on the treated data
str(bikesJuly.treat)
str(bikesAugust.treat)

#####################################################

# Run xgb.cv
cv <- xgb.cv(data = as.matrix(bikesJuly.treat), 
             label = bikesJuly$cnt,
             nrounds = 100,
             nfold = 5,
             objective = "reg:linear",
             eta = 0.3,
             max_depth = 6,
             early_stopping_rounds = 10,
             verbose = 0    # silent
)

# Get the evaluation log 
elog <- as.data.frame(cv$evaluation_log)

# Determine and print how many trees minimize training and test error
elog %>% 
  summarize(ntrees.train = which.min(train_rmse_mean),   
            # find the index of min(train_rmse_mean)
            ntrees.test  = which.min(test_rmse_mean))   
# find the index of min(test_rmse_mean)
'In most cases, ntrees.test is less than ntrees.train. 
The training error keeps decreasing even after the test 
error starts to increase. It is important to use cross-validation 
to find the right number of trees 
(as determined by ntrees.test) and avoid an overfit model.'

# The number of trees to use, as determined by xgb.cv (ntrees.test)
ntrees <- 47

# Run xgboost
bike_model_xgb <- xgboost(data = as.matrix(bikesJuly.treat), # training data as matrix
                          label = bikesJuly$cnt,  # column of outcomes
                          nrounds = ntrees,       # number of trees to build
                          objective = "reg:linear", # objective
                          eta = 0.3,
                          depth = 6,
                          verbose = 0  # silent
)

# Make predictions
bikesAugust$predGB <- predict(bike_model_xgb, as.matrix(bikesAugust.treat))

# Plot predictions (on x axis) vs actual bike rental count
ggplot(bikesAugust, aes(x = predGB, y = cnt)) + 
  geom_point() + 
  geom_abline()

'Overall, the scatterplot looked pretty good, but 
the model made some negative predictions'

# Calculate RMSE
RMSE_GB <- bikesAugust %>%
            mutate(residuals = cnt - predGB) %>%
            summarize(RMSE_Gradient = sqrt(mean(residuals^2)))

'Even though this gradient boosting made some negative predictions, 
overall it makes smaller errors than the previous two models. 
Perhaps rounding negative predictions up to zero is a reasonable tradeoff.'



'Visualize the xgboost bike rental model'


# Plot predictions and actual bike rentals as a function of time (days)
gradient_plot <- bikesAugust %>% 
  mutate(instant = (instant - min(instant))/24) %>%  # set start to 0, convert unit to days
  gather(key = valuetype, value = value, cnt, predGB) %>%
  filter(instant < 14) %>% # first two weeks
  ggplot(aes(x = instant, 
             y = value, 
             color = valuetype, 
             linetype = valuetype)) + 
  geom_point() + 
  geom_line() + 
  scale_x_continuous("Day", breaks = 0:14, labels = 0:14) + 
  scale_color_brewer(palette = "Dark2") + 
  ggtitle("Predicted August bike rentals, Gradient Boosting model")


gradient_plot
' The gradient boosting pattern captures rental 
variations due to time of day and
other factors better than the previous models'



