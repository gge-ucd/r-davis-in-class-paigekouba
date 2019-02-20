# Week 7 RDAVIS 
# Tue Feb 19 14:13:12 2019 ------------------------------
# a lot of this comes from Tufte. At one point, no one had ever made a scatter plot. 
# ggplot stands for "grammar of graphics."
# color blindness add-on for Mac
# package called viridis, developed by founder of D-RUG
# stay away from rainbow color scheme (hard divides)
# Color Brewer, color palettes for mapping data.  in R: scale_color_brewer in ggplot
# avoid more than 6 categorical colors in a layout unless looking at continuous data
# Hadley Wickham's book is good

# install a package from GitHub
install.packages("devtools")
library(devtools)
install_github("thomasp85/patchwork") # their name / the name of the package

library(tidyverse)
wide_data <- read_csv("data/wide_eg.csv")
wide_data

# now using skip
wide_data <- read_csv("data/wide_eg.csv", skip = 2)
# read_delim is a more general case of read_csv where you can name the separator

# loaded an RDA file that contained a single R object. RDA files can contain one or more R objects

load("data/mauna_loa_met_2001_minute.rda")

# write wide_data to an RDS
saveRDS(wide_data, "data/wide_data.rds")

rm(wide_data)
wide_data_rds <- readRDS("data/wide_data.rds") 
#diff between RDS and RDA: RDS is for a single object
# saveRDS() and readRDS() for .rds files, and we use save() and load() for .rda files
# csv is universal, but rds and rda are more compact

# readxl package can read workbooks. also googlesheets, and googledrive

library(rio)
# rio imports and exports data
# rio::import("data/wide_data.rds") it knows

# Now Martha talking about dates and times
library(lubridate)
# there are three basic classes of dates in R
# dates...................................................good for just dates
# POSIXct.................................................good for times and time zones. # of seconds since t0
# POSIXlt.................................................old way, makes a "list"
sample_dates1 <- c("2016-02-01", "2016-03-17", "2017-01-01")
as.Date(sample_dates1)
# looks for data that looks like YYYY MM DD
sample.date2 <- c("02-01-2001", "04-04-1991")
as.Date(sample.date2)
as.Date(sample.date2, format="%m-%d-%Y") # uppercase Y means YYYY lowercase y means yy

as.Date("2016/01/01", format = "%Y/%m/%d")

# Jul 04, 2017
as.Date("Jul 04, 2017", format = "%b%d,%Y") # lowercase b is shortened month, uppercase B is full month

# Date Calculations
dt1 <- as.Date("2017-07-11")
dt2 <- as.Date ("2016-04-22")
print(dt1-dt2)
# time difference in weeks
print(difftime(dt1, dt2, units = "week"))

six.weeks <- seq(dt1, length = 6, by="week")
# returns a sequence of six dates, starting at dt1, going up by weeks

# Challenge: create a sequence of 10 dates starting at dt1 with 2-week intervals
seq(dt1, length = 10, by=14)
seq(dt1, length = 10, by="2 week")
seq(dt1, length = 10, by="14 day")

# the easy way to do all this: use lubridate
library(lubridate)
ymd("2016/01/01")
dmy("04.04.91")
mdy("Feb 19, 2005")
