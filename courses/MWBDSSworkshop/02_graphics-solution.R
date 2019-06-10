## ------------------------------------------------------------------------
m = rbind(c(1, 12, 8, 6),
          c(4, 10, 2, 9),
          c(11, 3, 5, 7))
m

# Reconstruct the matrix 
n = matrix(c(1,12,8,6,4,10,2,9,11,3,5,7), nrow=3, ncol=4, byrow=TRUE)
n
all.equal(m,n)

# Print the element in the 3rd-row and 4th column
n[3,4]

# Print the 2nd column
n[,2]

# Print all but the 3rd row
n[-3,]

## ---- message=FALSE------------------------------------------------------
library('MWBDSSworkshop')
library('dplyr')

data(GI)
write.csv(GI, file="GI.csv", row.names=FALSE) # In case the file isn't already there
GI = read.csv("GI.csv")
GI$ageC = cut(GI$age, c(-Inf, 5, 18, 45 ,60, Inf)) 

## ------------------------------------------------------------------------
# Create icd9code
cuts = c(0, 140, 240, 280, 290, 320, 360, 390, 460, 520, 580, 630, 680, 710, 740, 760, 780, 800, 1000, Inf)
GI$icd9code = cut(GI$icd9, cuts, right=FALSE)

# Find the icd9code that is most numerous
# There are many ways to do this
table(GI$icd9code)

# Eliminate zeros
GI$icd9code = factor(GI$icd9code)
table(GI$icd9code)

## ---- echo=FALSE---------------------------------------------------------
library('dplyr')

## ------------------------------------------------------------------------
# Aggregate the GI data set by gender, ageC, and icd9code (the ones created in the last activity).
GI %>%
  group_by(gender, ageC, icd9code) %>%
  summarize(total = n())

## ---- echo=FALSE---------------------------------------------------------
library('ggplot2')

## ------------------------------------------------------------------------
# Construct a histogram for age at facility 37.
ggplot(GI %>% filter(facility == 37), aes(x = age)) + geom_histogram(binwidth = 1)

# Construct a boxplot for age at facility 37. 
ggplot(GI %>% filter(facility == 37), aes(x = 1, y = age)) + geom_boxplot()

## ------------------------------------------------------------------------
# Construct a bar chart for the zipcode at facility 37.
ggplot(GI %>% filter(facility == 37), aes(x = trunc(zipcode/100))) + geom_bar()

