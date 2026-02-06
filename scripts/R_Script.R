# Statistical Analysis and Hypothesis Tetsing

cat("\014") # clears console
rm(list = ls()) # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) #clears packages
options(scipen = 100) # disables scientific notion for entire R session

# Libraries
library(pacman)
library(tidyr)
library(tidyverse)
library(ggeasy)
library(ggplot2)
library(janitor)
library(lubridate)
library(Hmisc)
library(cowplot)
library(corrplot)

# Import data set.
data_set1 <- read.csv("power.csv")
data_set <- data_set1
view(data_set)

# Basic data cleaning
data_set <- clean_names(data_set)
names(data_set)

# Separate date and time column.
data_set <- separate(data_set, date_time, c('date','time'), sep = " ")
names(data_set)

# Extract month from date column.
data_set$date <- as.Date(data_set$date, "%d/%m/%Y")
data_set$month <- month(data_set$date)
unique(data_set$month)
data_set <- na.omit(data_set)

# Basic Data Pre processing(Conversion of power from KW to MW)
data_set$zone_1_power_consumption <- data_set$zone_1_power_consumption/1000
data_set$zone_2_power_consumption <- data_set$zone_2_power_consumption/1000
data_set$zone_3_power_consumption <- data_set$zone_3_power_consumption/1000

# ------------------------------------------------------------------------------------------

# Descriptive statistics for Temperature.
describe(data_set$temperature)

# Avg temperature in winter versus avg temperature overall year.
# H0: The mean difference of temperature in Winter and without Winter is 0. 
# H1: The mean difference of temperature in Winter and without Winter is not 0.
selected_month <- c(1,2,11,12)
winter <- data_set %>% filter(month %in% selected_month)
after_winter <- data_set %>% filter(!(month %in% selected_month))
mean_overall <- mean(after_winter$temperature)
t.test(winter$temperature,mu = mean_overall)

# Descriptive statistics for Humidity.
describe(data_set$humidity)
# H0: The mean difference of humidity in Winter and without Winter is 0. 
# H1: The mean difference of humidity in Winter and without Winter is 0.
mean_humidity <- mean(after_winter$humidity)
t.test(winter$humidity,mu = mean_humidity)

# Comparing power consumption before and after winter.
zone_1 <- var.test(winter$zone_1_power_consumption,after_winter$zone_1_power_consumption)
zone_2 <- var.test(winter$zone_2_power_consumption, after_winter$zone_2_power_consumption)
zone_3 <- var.test(winter$zone_3_power_consumption, after_winter$zone_3_power_consumption)

# Comparing Power consumption between three zones.
# H0: Power Consumption is similar in all three zones.
# H1: Power Consumption is not similar in all three zones.
h1 <- ggplot(data = data_set)+
  geom_histogram(aes(x = zone_1_power_consumption),fill="#69b3a2", color="#e9ecef", binwidth = 10)+
  labs(x = "Power in MW", y = "Frequency", title = "Distribution for Zone 1")+
  theme_minimal()
h1

d1 <- ggplot(data = data_set)+
  geom_density(aes(x = zone_1_power_consumption),fill="#69b3a2", color="#e9ecef",)+
  labs(x = "Power in MW", y = "Density", title = "Density Curve for Zone 1")+
  theme_minimal()
d1
h2 <- ggplot(data = data_set)+
  geom_histogram(aes(x = zone_2_power_consumption),fill="#69b3a2", color="#e9ecef", binwidth = 10)+
  labs(x = "Power in MW", y = "Frequency", title = "Distribution for Zone 2")+
  theme_minimal()
h2

d2 <- ggplot(data = data_set)+
  geom_density(aes(x = zone_2_power_consumption),fill="#69b3a2", color="#e9ecef",)+
  labs(x = "Power in MW", y = "Density", title = "Density Curve for Zone 2")+
  theme_minimal()
d2
h3 <- ggplot(data = data_set)+
  geom_histogram(aes(x = zone_3_power_consumption),fill="#69b3a2", color="#e9ecef", binwidth = 10)+
  labs(x = "Power in MW", y = "Frequency", title = "Distribution for Zone 3")+
  theme_minimal()
h3

d3 <- ggplot(data = data_set)+
  geom_density(aes(x = zone_3_power_consumption),fill="#69b3a2", color="#e9ecef",)+
  labs(x = "Power in MW", y = "Density", title = "Density Curve for Zone 3")+
  theme_minimal()
d3

plot_grid(h1,d1,h2,d2,h3,d3, labels = "AUTO")

zone1 <- t.test(winter$zone_1_power_consumption,after_winter$zone_1_power_consumption)
zone2 <- t.test(winter$zone_2_power_consumption,after_winter$zone_2_power_consumption)
zone3 <- t.test(winter$zone_3_power_consumption,after_winter$zone_3_power_consumption)


# Correlation Matrix
result <- cor(data_set[c("temperature","humidity","wind_speed","zone_1_power_consumption")])
corrplot(result)

result <- cor(data_set[c("temperature","humidity","wind_speed","zone_2_power_consumption")])
corrplot(result)

result <- cor(data_set[c("temperature","humidity","wind_speed","zone_3_power_consumption")])
corrplot(result)

# Regression Analysis.
# H0: Power consumption in zones depend on Wind_speed, Temperature and Humidity.
# H1: Power consumption in zones does not depend on Wind_speed, Temperature and Humidity.

# Creating Model for zone 1
model <- lm(zone_1_power_consumption ~ wind_speed+ humidity+ temperature , data = as.data.frame(winter))

#Summary of Model
summary(model)
#plot(model)
predictions <- predict(model,winter)
plot(winter$zone_1_power_consumption, predictions,
     main = "Expected vs. Predicted Values",
     xlab = "Observed Values",
     ylab = "Predicted Values",
     col = "black")
abline(0, 1, col = "red",lwd = 3)
legend("topleft", legend = "Ideal Line", col = "red", lty = 1, cex = 0.8)

# Creating Model for zone 2
model <- lm(zone_2_power_consumption ~ wind_speed+ humidity+ temperature , data = as.data.frame(winter))

#Summary of Model
summary(model)
#plot(model)

predictions <- predict(model,winter)
plot(winter$zone_2_power_consumption, predictions,
     main = "Expected vs. Predicted Values",
     xlab = "Observed Values",
     ylab = "Predicted Values",
     col = "black")
abline(0, 1, col = "red",lwd = 3)
legend("topleft", legend = "Ideal Line", col = "red", lty = 1, cex = 0.8)

# Creating Model for zone 3
model <- lm(zone_3_power_consumption ~ wind_speed+ humidity+ temperature , data = as.data.frame(winter))

#Summary of Model
summary(model)
#plot(model)
predictions <- predict(model,winter)
plot(winter$zone_2_power_consumption, predictions,
     main = "Expected vs. Predicted Values",
     xlab = "Observed Values",
     ylab = "Predicted Values",
     col = "black")
abline(0, 1, col = "red",lwd =3)
legend("topleft", legend = "Ideal Line", col = "red", lty = 1, cex = 0.8)
