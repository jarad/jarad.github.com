## ---- echo=FALSE, message=FALSE------------------------------------------
library('dplyr')
library('MWBDSSworkshop')
workshop(write_data = TRUE, launch_index=FALSE)

## ------------------------------------------------------------------------
x = 1:10
y = rep(c(1,2), each = 5)
m = lm(y ~ x)
s = summary(m)

## ------------------------------------------------------------------------
x
y
m
s
s$r.squared

## ------------------------------------------------------------------------
specificity = 0.95
sensitivity = 0.99
prevalence = 0.001
probability = (sensitivity*prevalence) / (sensitivity*prevalence + (1-specificity)*(1-prevalence))
probability

## ------------------------------------------------------------------------
# Read in the csv file
fluTrends = read.csv("fluTrends.csv")
names(fluTrends)

# To maintain pretty column names, use 
fluTrends = read.csv("fluTrends.csv", check.names = FALSE)
names(fluTrends)
# unfortunately these names won't work with the 
# fluTrends$colname syntax, but you can use back-ticks
summary(fluTrends$`United States`)

## ---- echo=FALSE---------------------------------------------------------
GI = read.csv("GI.csv")

## ------------------------------------------------------------------------
# Min, max, mean, and median age for zipcode 20032.
GI_20032 <- GI %>%
  filter(zipcode == 20032)

min(   GI_20032$age)
max(   GI_20032$age)
mean(  GI_20032$age)
median(GI_20032$age)

## ------------------------------------------------------------------------
summary(GI_20032$age)

## ------------------------------------------------------------------------
# Construct a histogram and boxplot for age at facility 37.
GI_37 <- GI %>%
  filter(facility == 37) 

hist(GI_37$age)

# Construct a boxplot for age at facility 37.
boxplot(GI_37$age)

## ------------------------------------------------------------------------
# Construct a bar chart for the zipcode at facility 37.
barplot(table(GI_37$zipcode))

## ------------------------------------------------------------------------
# Construct a bar chart for the first three digits of zipcode at facility 37.
barplot(table(trunc(GI_37$zipcode/100)))

