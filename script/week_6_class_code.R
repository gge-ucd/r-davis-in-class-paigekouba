# Week 6 RDAVIS 2/12/19
library(tidyverse)
#### finishing up deplyr ====================
surveys <- read_csv("data/portal_data_joined.csv")
# we want to create a dataframe. No NAs, no rare species (<50 observations)
# Take all NAs out of weight, hindfoot_length, and sex column
surveys_complete <- surveys %>% 
  filter(!is.na(weight),!is.na(sex),!is.na(hindfoot_length))

# remove the species with fewer than 50 observations
species_counts <- surveys_complete %>% 
  group_by(species_id) %>% 
  tally() %>% 
  filter(n>=50) 

#from surveys_complete dataframe, we only want to keep the species that show up in species_counts 
# dataframe
surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)
head(surveys_complete)

species_keep <- c("DM","DO")
# we could subset the dataframe by only these species

# Writing a dataframe to a .csv
write_csv(surveys_complete, path = "data_output/surveys_complete.csv")

# One of the big reasons to gather and tidy your data is so you can use ggplot
#### ggplot time =================
# Tue Feb 12 14:31:17 2019 ------------------------------
# ts + tab  inserts date and time
# ggplot(data = DATA, mapping = aes(MAPPINGS)) + 
# geom_function()
# in the tidyverse, the first call is always the data

# define a mapping

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

# saving a plot object
surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))
surveys_plot + geom_point()

# Challenge
install.packages("hexbin")
library(hexbin)
surveys_plot + geom_hex()
# we had too many points, with geom_point, to be useful/clear

# now, build plots from the ground up
# modifying whole geom appearances
ggplot(data=surveys_complete,mapping=aes(x=weight, y=hindfoot_length)) + 
  geom_point(alpha = 0.1, color="tomato")
# alpha value of points is plotting for transparency. 1 = opaque

# using data in a geom
surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length)) +
  geom_point(alpha=0.1, aes(color=species_id))

# color as a global aesthetic
surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length, color=species_id)) +
  geom_point(alpha=0.1)
# geoms don't look inside each other; just back, and inside themselves

# issue of over-plotting: use jitter
surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length, color=species_id)) +
  geom_jitter(alpha=0.1)

# move on to boxplots
surveys_complete %>% 
  ggplot(aes(x=species_id, y=weight)) + geom_boxplot() 

# adding points to boxplot
surveys_complete %>% 
  ggplot(aes(x=species_id, y=weight)) + geom_jitter(alpha=0.01, color="tomato")+
  geom_boxplot(alpha=0, color="green")
# there's color (outside), and there's fill.

# plotting time series
yearly_counts <- surveys_complete %>% 
  count(year, species_id)
str(yearly_counts)
# same as doing group_by year, species_id and then tally()
yearly_counts %>% 
  ggplot(aes(x=year, y=n)) + geom_line()
# yuck. what we really want is a line for each species
yearly_counts %>% 
  ggplot(aes(x=year, y=n, group=species_id, color = species_id)) + geom_line() + geom_jitter()

# facetting; a sub-plot for each thing in the grouping variable
yearly_counts %>% 
  ggplot(aes(x=year, y=n, color=species_id)) + geom_line() + facet_wrap(~species_id)


# including sex
yearly_sex_counts <- surveys_complete %>% 
  count (year, species_id,sex)
yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color = sex)) +
  geom_line() + 
  facet_wrap(~species_id)

# let's make it prettier. Moose hates the gray background. And it looks lazy

ysx_plot <- yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color = sex)) +
  geom_line() + 
  facet_wrap(~species_id) +
  theme_bw() +
  theme(panel.grid=element_blank())

ysx_plot + theme_minimal()
# can save like   theme_bw() +
#                 theme(panel.grid=element_blank())     as a theme for your whole paper

# more faceting

yearly_sex_weight <- surveys_complete %>% 
  group_by(year,sex,species_id) %>% # for each unique combo of these, gather up weights 
  summarize(avg_weight=mean(weight)) # and return means

yearly_sex_weight %>% 
  ggplot(aes(x=year,y=avg_weight, color = species_id)) + geom_line() +
  facet_grid(sex ~ .) # rows ~ columns (. = all columns)

# adding labels etc
yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color = sex)) +
  geom_line() + 
  facet_wrap(~species_id) + 
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(title = "Observed species through time", x= "Year of observation", y="Number of species")+
  theme(text=element_text(size=16)) +
  theme(axis.text.x = element_text(color="grey20",size=12, angle = 90, hjust = 0.5, vjust=0.5))

# tip: take a type of plot you make a lot; save your theme 

ggsave("figures/my_test_facet_plot.jpeg") #can give a plot object; default to last plot made
