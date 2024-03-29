# Predicting_Bike_Sharing

In this project I will build a 3 different models to predict the number of bikes rented in an hour as a function of the weather, the type of day (holiday, working day, or weekend), and the time of day. 

Regression models used:
* Quasipoisson
* Random Forests
* Gradient Boost

I will train the model on data from the month of July, and test on data from the month of August.

Dataset: https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset 

Data Set Information:
Bike sharing systems are new generation of traditional bike rentals where whole process from membership, rental and return back has become automatic. Through these systems, user is able to easily rent a bike from a particular position and return back at another position. Currently, there are about over 500 bike-sharing programs around the world which is composed of over 500 thousands bicycles. Today, there exists great interest in these systems due to their important role in traffic, environmental and health issues. 

Apart from interesting real world applications of bike sharing systems, the characteristics of data being generated by these systems make them attractive for the research. Opposed to other transport services such as bus or subway, the duration of travel, departure and arrival position is explicitly recorded in these systems. This feature turns bike sharing system into a virtual sensor network that can be used for sensing mobility in the city. Hence, it is expected that most of important events in the city could be detected via monitoring these data.

The data frame has the columns:
* cnt: the number of bikes rented in that hour (the outcome)
* hr: the hour of the day (0-23, as a factor)
* holiday: TRUE/FALSE
* workingday: TRUE if neither a holiday nor a weekend, else FALSE
* weathersit: categorical, "Clear to partly cloudy"/"Light Precipitation"/"Misty"
* temp: normalized temperature in Celsius
* atemp: normalized "feeling" temperature in Celsius
* hum: normalized humidity
* windspeed: normalized windspeed
* instant: the time index -- number of hours since beginning of data set (not a variable)
* mnth and yr: month and year indices (not variables)


