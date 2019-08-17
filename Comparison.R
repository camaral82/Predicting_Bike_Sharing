'Model Comparison'

RMSE <- c(RMSE_QP, RMSE_RF, RMSE_GB)

RMSE



# Print quasipoisson_plot
quasipoisson_plot
pseudoR2
'Conclusion: This model mostly identifies the slow and busy hours of the day, 
although it often underestimates peak demand.'


# Print randomforest_plot
randomforest_plot
'Conclusion: The random forest model captured the day-to-day variations in 
peak demand better than the quasipoisson model, 
but it still underestmates peak demand, 
and also overestimates minimum demand. 
So there is still room for improvement.'

#Print gradient_plot
gradient_plot
' The gradient boosting pattern captures rental 
variations due to time of day and
other factors better than the previous models'

