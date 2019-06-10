## ---- eval=FALSE---------------------------------------------------------
#  MWBDSSworkshop::workshop(write_data = TRUE, write_scripts = TRUE)

## ------------------------------------------------------------------------
a = 3.14159265 
b = "ISDS Workshop" 
c = TRUE

## ------------------------------------------------------------------------
a
b
c

## ------------------------------------------------------------------------
a = c(1,2,-5,3.6)
b = c("ISDS","Workshop")
c = c(TRUE, FALSE, TRUE)

## ------------------------------------------------------------------------
length(a)
length(b)
length(c)

## ------------------------------------------------------------------------
class(a)
class(b)
class(c)

## ------------------------------------------------------------------------
1:10
5:-2
seq(from = 2, to = 5, by = .05)

## ------------------------------------------------------------------------
rep(1:4, times = 2)
rep(1:4, each  = 2)
rep(1:4, each  = 2, times = 2)

## ------------------------------------------------------------------------
a = c("one","two","three","four","five")
a[1]
a[2:4]
a[c(3,5)]
a[rep(3,4)]

## ------------------------------------------------------------------------
a[c(TRUE, TRUE, FALSE, FALSE, FALSE)]

## ------------------------------------------------------------------------
a[-1]
a[-(2:3)]

## ------------------------------------------------------------------------
a[2] = "twenty-two"
a
a[3:4] = "three-four" # assigns "three-four" to both the 3rd and 4th elements
a
a[c(3,5)] = c("thirty-three","fifty-five")
a

## ------------------------------------------------------------------------
m1 = cbind(c(1,2), c(3,4))       # Column bind
m2 = rbind(c(1,3), c(2,4))       # Row bind

m1
all.equal(m1, m2)

m3 = matrix(1:4, nrow = 2, ncol = 2)
all.equal(m1, m3)

m4 = matrix(1:4, nrow = 2, ncol = 2, byrow = TRUE)
all.equal(m3, m4)

m3
m4

## ------------------------------------------------------------------------
m = matrix(1:12, nrow=3, ncol=4)
m
m[2,3]

## ------------------------------------------------------------------------
m[1:2,3:4]

## ------------------------------------------------------------------------
m[1:2,]

## ------------------------------------------------------------------------
m[-c(3,4),]

## ------------------------------------------------------------------------
m[1:4]

## ------------------------------------------------------------------------
c(1,"a")

## ------------------------------------------------------------------------
c(TRUE, 1, FALSE)

## ------------------------------------------------------------------------
c(TRUE, 1, "a")

## ------------------------------------------------------------------------
m = rbind(c(1, 12, 8, 6),
          c(4, 10, 2, 9),
          c(11, 3, 5, 7))
m

## ---- echo=FALSE---------------------------------------------------------
# Reconstruct the matrix 

# Print the element in the 3rd-row and 4th column

# Print the 2nd column

# Print all but the 3rd row

## ------------------------------------------------------------------------
GI = read.csv("GI.csv")
dim(GI)

## ------------------------------------------------------------------------
GI[1:2, 3:4]

## ------------------------------------------------------------------------
GI[1:2, c("facility","icd9","gender")]

## ---- message=FALSE------------------------------------------------------
library('dplyr') 
GI %>% 
  select(facility, icd9, gender) %>%
  head(n = 2)

## ---- eval=FALSE---------------------------------------------------------
#  # Approach 1
#  head(select(GI, facility, icd9, gender), n = 2)
#  
#  # Approach 2
#  GI_select <- select(GI, facility, icd9, gender)
#  head(GI_select, n = 2)

## ------------------------------------------------------------------------
str(GI)

## ------------------------------------------------------------------------
nlevels(GI$gender)
levels(GI$gender)          # internal table
GI$gender[1:3]
as.numeric(GI$gender[1:3]) # internal coding

## ------------------------------------------------------------------------
GI$facility = as.factor(GI$facility)
summary(GI$facility)

## ------------------------------------------------------------------------
head(as.character(GI$facility))             # This returns the levels as a character vector
head(as.numeric(as.character(GI$facility))) # This returns the original numeric factor levels

## ------------------------------------------------------------------------
GI$ageC = cut(GI$age, c(-Inf, 5, 18, 45 ,60, Inf)) # Inf is infinity
table(GI$ageC)

## ------------------------------------------------------------------------
GI$date = as.Date(GI$date)
str(GI$date)

## ---- eval=FALSE---------------------------------------------------------
#  ?as.Date

## ---- eval=FALSE---------------------------------------------------------
#  as.Date("12/09/14", format="%m/%d/%y")

## ---- eval=FALSE---------------------------------------------------------
#  # Create icd9code
#  
#  # Find the icd9code that is most numerous

## ---- echo=FALSE---------------------------------------------------------
d = data.frame(week = 1:3, 
               GI = c(246,195,212), 
               ILI = c(948, 1020, 1024))
d

## ---- echo=FALSE---------------------------------------------------------
d %>% 
  tidyr::gather(key = syndrome, value = count, -week)

## ------------------------------------------------------------------------
library('tidyr')

## ------------------------------------------------------------------------
d = data.frame(week = 1:3, 
               GI   = c(246,195,212), 
               ILI  = c(948, 1020, 1024))
d

## ------------------------------------------------------------------------
m <- d %>%
  gather(key = syndrome, # Creates a column called syndrome
         value = count,  # Creates a column called count
         -week)          # Keeps the column `week` as a column
                         # All other columns (GI and ILI) are gathered

## ------------------------------------------------------------------------
m2 <- d %>%
  gather(key = syndrome, # Creates a column called syndrome
         value = count,  # Creates a column called count
         GI, ILI)        # Gathers these columns

all.equal(m,m2)

## ------------------------------------------------------------------------
m %>%
  spread(key = syndrome, value = count)

## ------------------------------------------------------------------------
library('dplyr')

## ------------------------------------------------------------------------
m %>%                           # We need to use the melted (long) version of the data set
  group_by(syndrome) %>%        # Do the following for each syndrome
  summarize(total = sum(count)) # Calculate `total` which is the sum of count for each syndrome

## ------------------------------------------------------------------------
GI$date = as.Date(GI$date) # Make sure the dates are actually dates
GI$week = cut(GI$date, 
              breaks = "weeks", 
              start.on.monday = TRUE) 

## ------------------------------------------------------------------------
GI_count <- GI %>%                 # each row is a single observation
  group_by(week, gender, ageC) %>% # split the data by these variables
  summarize(total = n())           # this counts the number of rows, see ?n

nrow(GI_count)
head(GI_count, 20)

## ---- echo=FALSE---------------------------------------------------------
# Aggregate our GI data set by gender, ageC, and icd9code (the ones created in the last activity).

## ------------------------------------------------------------------------
library('ggplot2')

## ------------------------------------------------------------------------
ggplot(data = GI, aes(x = age)) + geom_histogram(binwidth = 1)

## ---- eval=FALSE---------------------------------------------------------
#  qplot(data = GI, x = age, geom = "histogram", binwidth = 1)

## ------------------------------------------------------------------------
ggplot(data = GI, aes(x = 1, y = age)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(GI, aes(x = facility, y = age)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(GI, aes(x=date, y=age)) + geom_point()

## ------------------------------------------------------------------------
ggplot(GI, aes(x=facility)) + geom_bar()

## ---- eval=FALSE---------------------------------------------------------
#  # Construct a histogram for age at facility 37.
#  
#  # Construct a boxplot for age at facility 37.

## ---- eval=FALSE---------------------------------------------------------
#  # Construct a bar chart for the 3-digit zipcode at facility 37

## ------------------------------------------------------------------------
ggplot(GI, aes(x = age)) + 
  geom_histogram(binwidth = 1, color = 'blue',   fill = 'yellow')

## ------------------------------------------------------------------------
ggplot(GI, aes(x=date, y=age)) + 
  geom_point(color = 'purple')

## ---- eval=FALSE---------------------------------------------------------
#  colors()

## ------------------------------------------------------------------------
ggplot(GI, aes(x = facility, y = age)) + 
  geom_boxplot() + 
  labs(x     = 'Facility ID', 
       y     = 'Age (in years)', 
       title = 'Age by Facility ID')

## ------------------------------------------------------------------------
ggplot(GI, aes(x=date, y=age)) + geom_point(shape = 2, color = 'red')

## ---- eval=FALSE---------------------------------------------------------
#  ?points

## ------------------------------------------------------------------------
g = ggplot(GI %>% 
             group_by(week) %>%
             summarize(count = n()), 
           aes(x = as.numeric(week), 
               y = count)) +
  labs(x = 'Week #', 
       y = 'Weekly count')

g + geom_line()
g + geom_line(size=2, color='firebrick', linetype=2)

## ------------------------------------------------------------------------
g = g + geom_line(size = 1, color = 'firebrick')
g + theme_bw()

## ---- eval=FALSE---------------------------------------------------------
#  ?theme
#  ?theme_bw

## ---- eval=FALSE---------------------------------------------------------
#  ?ggplot
#  ?geom_point

