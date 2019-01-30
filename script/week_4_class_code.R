# Intro to Dataframes
download.file(url = "https://ndownloader.figshare.com/files/2292169", destfile = "data/portal_data_joined.csv")

surveys <- read.csv(file = "data/portal_data_joined.csv")
head(surveys)
# let's look at structure
str(surveys)
# factors are for anything that was a character
dim(surveys)
nrow(surveys)
ncol(surveys)
tail(surveys)
names(surveys) # a character vector of the names
summary(surveys)
# subsetting vectors by giving them a location index
animal_vec <- c("mouse", "rat", "cat")
animal_vec[2]

# dataframes are 2D!
surveys[1,1]
head(surveys)
surveys[2,1] # second row, first column

# whole first column
surveys[,1] # leaving a dimension blank says to return everything
surveys[1]
head(surveys[1]) # it's a dataframe with one column. won't work in a fn that takes a vector
surveys[1:3,6] # 1:3 is a shortcut to generate a vector that goes 1, 2, 3; this says to pull
# first three values in the sixth columnnnnnn
animal_vec[c(1,3)]
3:20
# pull out a whole single observation
surveys[5,] # a dataframe with the length of one row
surveys[1:5,-1] # takes out column 1, record_id
surveys[-c(10:34786),] # just the first nine
surveys[c(10,15,20),]
surveys[c(10,15,20,10),]

# more ways to subset
head(surveys["plot_id"]) # single column as data.frame
head(surveys[,"plot_id"]) # single column as vector
surveys[["plot_id"]] # single column as vector; what's inside the train car. 
# we'll come back to using double brackets with lists
surveys$year # single column as vector
str(surveys)
#Based on the output of str(surveys), can you answer the following questions? 
#* What is the class of the object surveys?  data.frame
#* How many rows and how many columns are in this object? 34786 rows, 13 columns
#* How many species have been recorded during these surveys? 48

surveys_200 <- surveys[200,]
surveys_200
nrow(surveys)
surveys[nrow(surveys),]
tail(surveys)
surveys_last <- surveys[nrow(surveys),]
surveys_middle <- surveys[nrow(surveys)/2,]
surveys[-c(7:nrow(surveys)),]
head(surveys)

# Finally, factors. They are stored as integers with labels assigned to them.
# under the hood, they're really being treated as integers. Factor has associated set of levels
# sorted alphabetically by default

# Creating our own factor
sex <- factor(c("male","female","female","male"))
sex
# [1] male   female female male  
# Levels: female male          assigning each a 1 or a 2
class(sex) # higher-level attribute
typeof(sex) # what are you in your guts
levels(sex) # gives back a character vector of the levels
levels(surveys$genus)
nlevels(sex) # 2
concentration <- factor (c("high","medium","high","low"))
concentration 
#[1] high   medium high   low   
#Levels: high low medium
# re-assign levels
concentration <- factor(concentration, levels = c("high","medium","low"))
#[1] high   medium high   low   
#Levels: high medium low
# try adding to a factor
concentration <-  c(concentration, "very high") # coerces to characters if you add a value that 
# doesn't match a current level

# just make them characters
as.character(sex)

# factors with numeric levels
year_factor <- factor(c(1990, 1923, 1965, 2018))
as.numeric(year_factor) #[1] 3 1 2 4 You don't get those years back :(
as.numeric(as.character(year_factor))

# recommended way, as opposed to the immediately above
as.numeric(levels(year_factor)) [year_factor]

# why all the factors?
# read.csv has one of the more controversial defaults in the R world: stringsAsFactors = T
?read.csv

surveys_no_factors <- read.csv(file = "data/portal_data_joined.csv", stringsAsFactors = FALSE)
str(surveys_no_factors)

# renaming factors
sex <- surveys$sex
levels(sex) # [1] ""  "F" "M"
levels(sex) [1] <- "undetermined"
levels(sex)
head(sex)


# working with dates
library(lubridate)
#install.packages("lubridate")    usually just run in console
library(lubridate)
my_date <- ymd("2015-01-01")
my_date
str(my_date) #Date[1:1], format: "2015-01-01"

my_date <- ymd(paste("2015", "05", "17", sep = "-"))
my_date
str(my_date)
paste(surveys$year, surveys$month, surveys$day, sep = "-")
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))
str(surveys$date)
surveys$date[is.na(surveys$date)]
