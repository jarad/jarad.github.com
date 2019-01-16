## ------------------------------------------------------------------------
a = 1 
b = 2
a+b

## ------------------------------------------------------------------------
x = 1:10
y = rep(c(1,2), each=5)
m = lm(y~x)
s = summary(m)

## ---- eval=FALSE---------------------------------------------------------
## x
## y
## m
## s
## s$r.squared

## ------------------------------------------------------------------------
1+2
1-2
1/2
1*2

## ------------------------------------------------------------------------
(1+3)*2 + 100^2  # standard order of operations
sin(2*pi)        # the result is in scientific notation, i.e. -2.449294 x 10^-16 
sqrt(4)
10^2
log(10)          # the default is base e
log(10, base=10)

## ------------------------------------------------------------------------
a = 1
b = 2
a+b
a-b
a/b
a*b

## ------------------------------------------------------------------------
a <- 1
2 -> b
c = 3  # is the same as <-

## ------------------------------------------------------------------------
a
b
c

## ------------------------------------------------------------------------
# Rectangle
length <- 4
width  <- 3

area <- length * width
area


# Circle
radius <- 2
area   <- pi*radius^2 # this overwrites the previous `area` variable
circumference <- 2*pi*radius
area
circumference


# (Right) Triangle
opposite     <- 1
angleDegrees <- 30
angleRadians <- angleDegrees * pi/180
(adjacent     <- opposite / tan(angleRadians)) # = sqrt(3)
(hypotenuse   <- opposite / sin(angleRadians)) # = 2

## ---- echo=FALSE---------------------------------------------------------
# Find the probability the individual has the disease if 
# specificity is 0.95, sensitivity is 0.99, and prevalence is 0.001

## ------------------------------------------------------------------------
a = 3.14159265 
b = "STAT 587 (Eng)" 
c = TRUE

## ------------------------------------------------------------------------
a
b
c

## ------------------------------------------------------------------------
a = c(1,2,-5,3.6)
b = c("STAT","587", "(Eng)")
c = c(TRUE, FALSE, TRUE, TRUE)

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
# Print the element in the 3rd-row and 4th column

# Print the 2nd column

# Print all but the 3rd row

# Reconstruct the matrix if time allows

## ------------------------------------------------------------------------
class(warpbreaks) # warpbreaks is a built-in data.frame

## ------------------------------------------------------------------------
warpbreaks[1:3,1:2]

## ------------------------------------------------------------------------
names(warpbreaks)
warpbreaks[1:3, c("breaks","wool")]

## ---- message=FALSE------------------------------------------------------
library("dplyr") # install.packages("dplyr")
warpbreaks %>% 
  select(breaks, wool) %>%
  head(n = 3)

## ---- eval=FALSE---------------------------------------------------------
## # Approach 1
## head(select(warpbreaks, breaks, wool), n = 3)
## 
## # Approach 2
## warpbreaks_select <- select(warpbreaks, breaks, wool)
## head(warpbreaks_select, n = 3)

## ------------------------------------------------------------------------
str(warpbreaks)

## ------------------------------------------------------------------------
library("dplyr") # if it is already loaded, nothing will happen

## ------------------------------------------------------------------------
warpbreaks %>%                           
  group_by(wool) %>%        
  summarize(n    = n(),          # counts the number lines in the grouped data.frame
            mean = mean(breaks),
            sd   = sd(breaks)) 

## ------------------------------------------------------------------------
warpbreaks %>%                           
  group_by(wool, tension) %>%        
  summarize(n    = n(),
            mean = mean(breaks),
            sd   = sd(breaks))

## ---- echo=FALSE---------------------------------------------------------
# Calculate the mean and standard deviation for each level of tension ignoring wool.

## ------------------------------------------------------------------------
library("ggplot2")

## ------------------------------------------------------------------------
ggplot(data = warpbreaks, aes(x = breaks)) + geom_histogram(binwidth = 1)

## ---- eval=FALSE---------------------------------------------------------
## qplot(data = warpbreaks, x = breaks, geom = "histogram", binwidth = 1)

## ------------------------------------------------------------------------
ggplot(data = warpbreaks, aes(x = 1, y = breaks)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(warpbreaks, aes(x = wool, y = breaks, group = wool)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(warpbreaks, aes(x = wool, y = breaks)) + geom_point()

## ------------------------------------------------------------------------
ggplot(warpbreaks, aes(x = wool, y = breaks)) + geom_jitter(width = 0.2, height = 0)

## ---- eval=FALSE, echo=FALSE---------------------------------------------
## # Construct a scatterplot of the number of breaks by amount of tension.
## # Jitter the points horizontally.
## # (Advanced) Use a different shape and color for the wool type.

## ---- eval=FALSE---------------------------------------------------------
## install.packages("swirl")

## ---- eval=FALSE---------------------------------------------------------
## library("swirl")
## swirl()

## ---- eval=FALSE---------------------------------------------------------
## ?mean

## ---- eval=FALSE---------------------------------------------------------
## help.search("mean")

## ---- eval=FALSE---------------------------------------------------------
## ?ggplot
## ?geom_point

