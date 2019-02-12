# Week 5 Assignment, R-DAVIS
# 1. Read portal_data_joined.csv into R using the tidyverse’s command called read_csv(), and assign it to an 
# object named surveys.
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
# 2. Using tidyverse functions and pipes, subset to keep all the rows where weight is between 30 and 60, then 
# print the first few (maybe… 6?) rows of the resulting tibble.
weight30to60 <- surveys %>% 
  filter(weight <60 & weight>30)
weight30to60[1:6,]

# 3. Make a tibble that shows the max (hint hint) weight for each species+sex combination, and name it 
# biggest_critters. Use the arrange function to look at the biggest and smallest critters in the tibble 
# (use ?, tab-complete, or Google if you need help with arrange).
biggest_critters <- surveys %>% 
  group_by(sex, species_id) %>% 
  summarize(max_weight = as.numeric(max(weight)))

arrange(biggest_critters,max_weight) %>% View
# The biggest max_weight is 280, and the smallest max_weight is 8.

# 4. Try to figure out where the NA weights are concentrated in the data- is there a particular species, taxa, 
# plot, or whatever, where there are lots of NA values? There isn’t necessarily a right or wrong answer here, 
# but manipulate surveys a few different ways to explore this. Maybe use tally and arrange here.
surveys %>%  # find where the NAs are in the species
  group_by(species) %>% 
  filter(is.na(weight)) %>% 
  tally() %>% 
  arrange(desc(n))

surveys %>%  # find where the NAs are in the plots
  group_by(plot_id) %>% 
  filter(is.na(weight)) %>% 
  tally()%>% 
  arrange(desc(n))

surveys %>%  # find where the NAs are in the taxa
  group_by(taxa) %>% 
  filter(is.na(weight)) %>% 
  tally()%>% 
  arrange(desc(n))

# Rodents seem to have the most NA weights (1964, compared to 450 for birds in second). Although that's not 
# actually that informative because, as you can see below, mostly the whole table is made up of rodents. 
# Interesting to note that apparently all the weight observations for birds are NA, though. Maybe they're hard 
# to catch.
surveys %>% 
  filter(taxa == "Rodent") # 34,247 observations for rodents
surveys %>% 
  filter(taxa == "Bird") # 450 observations for birds
surveys %>% 
  filter(taxa == "Rabbit") # 75 observations for rabbits
surveys %>% 
  filter(taxa == "Reptile") # 14 observations for reptile

# 5. Take surveys, remove the rows where weight is NA and add a column that contains the average weight of each
# species+sex combination. Then get rid of all the columns except for species, sex, weight, and your new average
# weight column. Save this tibble as surveys_avg_weight. The resulting tibble should have 32,283 rows.
surveys_avg_weight <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>%
  mutate(average_weight = as.numeric(mean(weight, na.rm=TRUE))) %>% 
  select(species_id,sex,weight,average_weight) 

# 6. Challenge: Take surveys_avg_weight and add a new column called above_average that contains logical values 
# stating whether or not a row’s weight is above average for its species+sex combination (recall the new column 
# we made for this tibble).
surveys_avg_weight %>% 
  mutate(above_average = as.numeric(weight) > as.numeric(average_weight)) %>% View

# 7. Extra Challenge: Figure out what the scale function does, and add a column to surveys that has the scaled 
# weight, by species. Then sort by this column and look at the relative biggest and smallest individuals. Do any
# of them stand out as particularly big or small?

surveys %>% 
  group_by(species_id) %>% 
  mutate(scaled_weight = scale(weight)) %>% 
  arrange(scaled_weight) %>% View
# The scale function determines, for each data point, how many standard deviations it is from the mean for that 
# data point's group. The biggest weight observed (relative to species average) was for PP, Chaetodipus 
# penicillatus. The smallest weight observed (relative to species average) was for Dipodomys merriami.
