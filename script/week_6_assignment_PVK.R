library(tidyverse)
gapminder <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/gapminder.csv")
#1A Modify the following code to make a figure that shows how life expectancy has changed over time: 
# original plot
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point()

# update to reflect life expectancy data
ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()
# This graph was too busy, so I decided to use jitter and color-code the points by continent
ggplot(gapminder, aes(x = year, y = lifeExp)) + 
  geom_jitter(aes(color=continent), size=.25) 
# also it would be cool to have trend lines for each continent:
lifeExp_series <- gapminder %>% 
  group_by(year, continent) %>% 
  mutate(year_average_LE = mean(lifeExp, na.rm=TRUE)) %>% 
  select(year, continent, lifeExp, year_average_LE)
ggplot(lifeExp_series, aes(x=year, y=lifeExp, group=continent, color = continent)) + 
  geom_jitter(alpha=0.6, size=.25) +
  geom_line( aes(x=year, y=year_average_LE, group=continent, color=continent) )

#1B Look at the following code. What do you think the scale_x_log10() line is doing? What do you think the 
# geom_smooth() line is doing?
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()
# scale_x_log10() changes the x-axis to be on a log scale. R says that geom_smooth is useful for observing trends
# in over-plotted datasets. Help function says it's "smoothed conditional means." I can mess around with the 
# aesthetics and the type of line-fitting model (lm, glm, loess, etc).

#1C Modify the above code to size the points in proportion to the population of the county.
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop, alpha=0.4)) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

