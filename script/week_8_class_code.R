# Week 8 RDAVIS
# Tue Feb 26 14:31:11 2019 ------------------------------

library(lubridate)
library(tidyverse)
load("data/mauna_loa_met_2001_minute.rda")

tm1 <- as.POSIXct("2016-07-24. 23:55:26 PDT")
tm1

tm2 <- as.POSIXct("25072016 8:32:07", format="%d%m%Y %H:%M:%S")
tm2

tm3 <- as.POSIXct("2010-12-01 11:42:03", tz= "GMT")
tm3

#specifying timezone and date format in the same call
tm4 <- as.POSIXct(strptime("2016/04/04 14:47", format = "%Y/%m/%d %H:%M"), tz = "America/Los_Angeles")
tm4

# what timezone is my computer thinking in? what's the default?
Sys.timezone()

# Do the same thing with lubridate
ymd_hm("2016/04/04 14:47", tz = "America/Los_Angeles")

nfy <- read_csv("data/2015_NFY_solinst.csv", skip = 12)
# Using lubridate on a dataframe

# tell it what format for each column (date, time, ms, level, temp)
nfy2 <- read_csv("data/2015_NFY_solinst.csv", skip = 12, col_types = "ccidd") # chr chr int dbl dbl
glimpse(nfy2)

nfy2$datetime <- paste(nfy2$Date, " ", nfy2$Time, sep = "")  #paste0 defaults to a comma
glimpse(nfy2)

# put this in a date-time format
nfy2$datetime_test <- ymd_hms(nfy2$datetime, tz = "America/Los_Angeles")
tz(nfy2$datetime_test) # "America/Los_Angeles"

summary(mloa_2001)
mloa_2001$datetime <- paste0(mloa_2001$year, "-", mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", 
                             mloa_2001$min)
glimpse(mloa_2001)
mloa_2001$datetime<- ymd_hm(mloa_2001$datetime)

# Challenge with dplyr & ggplot
# Remove the NA’s (-99 and -999) in rel_humid, temp_C_2m, windSpeed_m_s
# Use dplyr to calculate the mean monthly temperature (temp_C_2m) using the  datetime column 
# (HINT: look at lubridate functions like month())
# Make a ggplot of the avg monthly temperature
# Make a ggplot of the daily average temperature for July (HINT: try yday() function with some summarize() in dplyr)

glimpse(mloa_2001)
# Remove the NA’s (-99 and -999) in rel_humid, temp_C_2m, windSpeed_m_s
challenge8 <- mloa_2001 %>% 
  filter(rel_humid != -99, rel_humid != -999) %>% 
  filter(temp_C_2m != -99, temp_C_2m != -999) %>% 
  filter(windSpeed_m_s != -99, windSpeed_m_s != -999)
glimpse(challenge8)

# Use dplyr to calculate the mean monthly temperature (temp_C_2m) using the  datetime column 
mloa3 <- challenge8 %>% 
  mutate(which_month = month(datetime, label = TRUE))    # pull out month from datetime column; dttm is good here

mloa3 <- challenge8 %>% 
  mutate(which_month = month(datetime, label = TRUE)) %>% 
  group_by(which_month) %>% 
  summarize(avg_temp = mean(temp_C_2m)) # summarize is creating a whole new dataframe; if we want to add, use mutate
mloa3

# Make a ggplot of the avg monthly temperature
mloa3 %>% ggplot() +
  geom_point(aes(x=which_month, y=avg_temp), size=3, color= "blue") +
  geom_line(aes(x=which_month, y=avg_temp))


# Functions
my_sum <- function(a, b){
  the_sum <- a + b
  return(the_sum)
}
my_sum(3,7)  
  

# set default values
my_sum <- function(a=1, b=2){
  the_sum <- a + b
  return(the_sum)
}
my_sum()
my_sum(b=8)  
my_sum(a=5, b=8)  

# Create a function that converst the temp in K to the temp in C (subtract 273.15)
K_to_C <- function(K){
  C_temp <- K - 273.15
  return(C_temp)
}
K_to_C(283.15)
list <- c(8,9,130)
K_to_C(list)

# Iteration
x <- 1:10
log(x)
# [1] 0.0000000 0.6931472 1.0986123 1.3862944 1.6094379 1.7917595 1.9459101 2.0794415 2.1972246 2.3025851

# for loops repeat some bit of code, each time with a new input value

for(i in 1:10){
  print(i)
}
# now I have a value in my envt, "i", whose value is "10L"  (L for integer). 10 is just the last value, a spare


for(i in 1:10){
  print(i)
  print(i^2)
}

letters[1]  #a

# we can use the i value as an index
for( i in 1:10){
  print(letters[i])
  print(mtcars$wt[i])
}

# make a results vector ahead of time
results <- rep(NA, 10)
for(i in 1:10){
  results[i] <- letters[i]
}
results
