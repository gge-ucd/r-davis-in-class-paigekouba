# Week 3
read.csv("data/tidy.csv")
# vectors
weight_g <- c(50, 60, 31, 89)
weight_g
# now characters
animals <- c("mouse","rat","dog", "cat")
animals
# vector exploration tools
length(weight_g)
length(animals)
class(weight_g)
class(animals)
str(weight_g)
# modifying in place
weight_g <- c(weight_g, 105)
weight_g
# careful with repeating this line
weight_g <- c(25, weight_g)
weight_g
# we'll work with 4 types of atomic vectors (of 6 total): "numeric" ("double"), "character", 
# "logical", "integer", ["complex", "raw"]
typeof(weight_g)
typeof(animals)
num_char <- c(1, 2, 3, "a")
num_char

num_logical <- c(1, 2, 3, TRUE)
num_logical

char_logical <- c("a", "b", "c", TRUE)
char_logical

combined_logical <- c(num_logical, char_logical)
combined_logical

# subsetting vectors
animals
animals[3]
animals[c(2,3)]
animals[c(3,1,3)]
animals[7]

# conditional subsetting
weight_g
weight_g[c(T,F,T,T,F,T,T)]
# annoying
weight_g > 50
weight_g [weight_g > 50]
# combine multiple conditions
weight_g[weight_g < 30 | weight_g > 50]
weight_g[weight_g >= 30 & weight_g == 90]
# numeric(0) Moose: "there is nothing contained in this vector that meets this requirement"
# searching for characters
animals[animals == "cat" | animals == "rat"]
animals %in% c("rat", "antelope", "jackalope", "hippogriff")
animals[animals %in% c("rat", "antelope", "jackalope", "hippogriff")]
 
# challenge
"four" > "five" # TRUE
"six" > "five" # TRUE
"eight" > "five" # FALSE
# alphabetical order

# missing values
heights <- c(2,4,4,NA,6)
str(heights)
mean(weight_g)
mean(heights)
max(heights)
min(heights)
mean(x = heights,na.rm = T)
max(heights,na.rm=T)
is.na(heights)
na.omit(heights)
complete.cases(heights)
