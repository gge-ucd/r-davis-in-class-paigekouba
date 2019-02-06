# Week 5 RDAVIS 2/5/19
# Hadley Wickham created tidyverse. Includes dplyr, tidyr, ggplot2 (sp?). Created to address a few issues
# with base R subsetting function, e.g. 
install.packages("tidyverse")
# if dataset is bigger than memory on your computer, base R can't read it in. tidyverse allows you to pull 
# relevant stuff. Don't have to install every time, but need to call it. Outdated packages can break code.
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
# read_csv doesn't need "string as factor = false" or w/e. Plus automatically tells you info type
str(surveys)
# class tbl. Columns are characters, never converted to factors. By clicking on thingy in envt, get excel tab
# it's a fancy data frame, from "table."
# start playing with dplyr. Select, filter, mutate, rootby, summarize

# select is used for selecting columns in a data frame. 1st argument = data frame, then list of column names
select(surveys, plot_id, species_id, weight)

# filter is used for selecting rows. note double ==. if just =, it prompts you to ==
filter(surveys, year == 1995)
surveys2 <- filter(surveys, weight<5)
surveys_sml <- select(surveys2, species_id, sex, weight)

# Pipes: %>% on a PC control-shift-M, on a Mac, command-shift-M. Takes info from left of pipe and passes right
# Puts what's on the left and makes it the first argument of what's on the right of the %>% . Sometimes as '.,'
surveys %>% 
  filter(weight < 5) %>% 
  select(species_id, sex, weight)

# Challenge: 
# Subset surveys to include individuals collected before 1995 and retain only columns year, sex, and weight
surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

# mutate, brand new, used to create new columns
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000) %>% 
  mutate(weight_kg2 = weight_kg*2)
# if you want multiple columns, must name them different things

# get rid of rows where weight = NA
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  summary()

# "complete cases" to filter out all of the NAs

#Create a new data frame from the surveys data that meets the following criteria: contains only the  
# species_id column and a new column called hindfoot_half containing values that are half the  hindfoot_length 
# values. In this hindfoot_half column, there are no NAs and all values are less than 30.

# Hint: think about how the commands should be ordered to produce this data frame!
challenge <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  filter(hindfoot_length < 30) %>% 
  mutate(hindfoot_half = hindfoot_length/2) %>% 
  select(species_id, hindfoot_half)
str(challenge)

# Answer 
#surveys_hindfoot_half <- surveys %>%
#filter(!is.na(hindfoot_length)) %>%
  #mutate(hindfoot_half = hindfoot_length / 2) %>%
  #filter(hindfoot_half < 30) %>%
  #select(species_id, hindfoot_half)

# group by is good for split-apply-combine
# say we want mean weight of males and mean weight of females
surveys %>% 
  group_by(sex) %>%  # if just ran to here, wouldn't look different, but adds "Groups: sex [3]"
  summarize(mean_weight = mean(weight,na.rm = TRUE)) # summarize acts on the grouping variable
# summarize is creating an entirely new dataframe

surveys %>% 
  group_by(sex) %>% 
  mutate (mean_weight = mean(weight, na.rm=TRUE)) %>%  View

surveys %>%  # tells us where the NAs are in the species
  group_by(species) %>% 
  filter(is.na(sex)) %>% 
  tally()

# calculate the mean of each sex by each species. use group_by with multiple columns

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight), min_weight = min(weight)) %>% View

# tally function. No. of observations for each sort of factor or combination of factors
# same as group_by(something) %>% summarize(new_column = n())
surveys %>% 
  group_by(sex, species_id) %>% 
  tally() %>% View()

# Gathering and spreading
# compare the mean weight of each species in each plot (?)
# Spread take three arguments: data you want, key column variable, value column variable
# key is what you want to make into new columns, value is what to populate it with
# what you do if you get v. tall data
surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(genus, plot_id) %>% 
  summarize(mean_weight = mean(weight))
# I want each genus to be its own column
surveys_spread <- surveys_gw %>% 
  spread(key=genus,value=mean_weight)
# if remove NAs, rows would be removed.. make zeros
surveys_gw %>% 
  spread(genus,mean_weight, fill = 0) %>% View

# Gathering is for if you get very wide data (less common)
surveys_gather <- surveys_spread %>% 
  gather(key= genus, value = mean_weight, -plot_id) %>%  #use all columns but plot_id to fill in key variabl
View


