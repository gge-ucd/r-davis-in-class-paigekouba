library(lubridate)
library(tidyverse)
am_riv <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFA_solinst_08_05.csv", skip = 13)
#should have a data frame with 35,038 obs of 5 variables #check!
# Make a datetime column by using paste to combine the date and time columns; remember to convert it to a datetime!
str(am_riv)
am_riv$datetime <- paste(am_riv$Date, " ", am_riv$Time, sep = "")

# put this in a date-time format
am_riv$datetime <- ymd_hms(am_riv$datetime, tz = "America/Los_Angeles")

# Calculate the weekly mean, max, and min water temperatures and plot as a point plot (all on the same graph)
glimpse(am_riv)
# weekly mean
am_riv$Week <- week(am_riv$datetime)

am_riv_temps <- am_riv %>% 
  group_by(Week) %>% 
  summarize(weekly_mean = mean(Temperature), weekly_min = min(Temperature), weekly_max = max(Temperature))

am_riv_temps %>% 
  ggplot()+
  geom_point(aes(x=Week, y = weekly_min), color = "blue")+
  geom_point(aes(x=Week, y = weekly_max), color = "red")+
  geom_point(aes(x=Week, y = weekly_mean), color= "green")+
  xlab("Week Number")+ ylab("Temperature")+
  theme_bw()

# Calculate the hourly mean Level for April through June and make a line plot (y axis should be the hourly mean 
# level, x axis should be datetime)
am_riv$Hour <- hour(am_riv$datetime)
am_riv$Month <- month(am_riv$datetime)
am_riv_hourly <- am_riv %>% 
  filter(Month == 4 | Month == 5 | Month == 6) %>% 
  group_by(Hour, Month, datetime) %>% 
  summarize(mean_level = mean(Level))

am_riv_hourly %>% 
  ggplot()+
  geom_line(aes(x=datetime, y=mean_level), color="pink")+
  xlab("Date")+ylab("Hourly Mean Level")

# Use the mloa_2001 data set (if you don’t have it, download the .rda file from the resources tab on the website). 
# Remeber to remove the NAs (-99 and -999) and to create a datetime column (we did this in class).

# Then, write a function called plot_temp that returns a graph of the temp_C_2m for a single month. 
# The x-axis of the graph should be pulled from a datetime column (so if your data set does not already have a 
# datetime column, you’ll need to create one!)

load("data/mauna_loa_met_2001_minute.rda")
mloa_2001$datetime <- paste0(mloa_2001$year, "-", mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", 
                             mloa_2001$min)
mloa_2001$datetime<- ymd_hm(mloa_2001$datetime)
mloa_2001HW <- mloa_2001 %>% 
  filter(rel_humid != -99, rel_humid != -999) %>% 
  filter(temp_C_2m != -99, temp_C_2m != -999) %>% 
  filter(windSpeed_m_s != -99, windSpeed_m_s != -999)

glimpse(mloa_2001HW)
plot_temp_C_2m <- function(monthinput, dat = mloa_2001HW){
  df <- filter(dat, month == monthinput)
  plot <- df %>% 
  ggplot()+ geom_line(aes(x=datetime, y=temp_C_2m), color="green")+
    xlab("Date")+ylab("temp_C_2m")+  theme_bw()
  return(plot)
}

plot_temp_C_2m(5)
