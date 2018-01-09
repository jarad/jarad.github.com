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
b = "STAT 401 (Eng)" 
c = TRUE

## ------------------------------------------------------------------------
a
b
c

## ------------------------------------------------------------------------
a = c(1,2,-5,3.6)
b = c("STAT","401", "(Eng)")
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
# Reconstruct the matrix 

# Print the element in the 3rd-row and 4th column

# Print the 2nd column

# Print all but the 3rd row

## ------------------------------------------------------------------------
# Installs the HootOwlHoot package if it is not already installed
if (!requireNamespace("HootOwlHoot", quietly = TRUE))
  devtools::install_github("BoardGameSimulator/HootOwlHoot")

# Exp for experiment
set.seed(20180109) # makes the code reproducible
Exp <- HootOwlHoot::run_experiments(n_reps = 10, n_players = 2:4, n_owls = 1:6)

class(Exp)

## ------------------------------------------------------------------------
Exp[1:2, 1:3]

## ------------------------------------------------------------------------
names(Exp)
Exp[1:2, c("rep","n_players", "n_owls")]

## ---- message=FALSE------------------------------------------------------
library("dplyr") # install.packages("dplyr")
Exp %>% 
  select(rep, n_players, n_owls) %>%
  head(n = 2)

## ---- eval=FALSE---------------------------------------------------------
## # Approach 1
## head(select(Exp, rep, n_players, n_owls), n = 2)
## 
## # Approach 2
## Exp_select <- select(Exp, rep, n_players, n_owls)
## head(Exp_select, n = 2)

## ------------------------------------------------------------------------
str(Exp)

## ------------------------------------------------------------------------
library("dplyr") # if it is already loaded, nothing will happen

## ------------------------------------------------------------------------
Exp %>%                           
  group_by(n_owls) %>%        
  summarize(n_games_won = sum(win == TRUE),
            n_games     = n(),                    # n() counts the number of rows in the grouped data.frame
            proportion  = n_games_won / n_games) 

## ------------------------------------------------------------------------
Exp %>%                           
  group_by(n_owls) %>%        
  summarize(proportion = mean(win)) # the logical `win` is implicitly converted to 0's and 1's 

## ------------------------------------------------------------------------
Exp %>%                           
  group_by(n_players, n_owls) %>%        
  summarize(proportion = mean(win)) # the logical `win` is implicitly converted to 0's and 1's 

## ---- echo=FALSE---------------------------------------------------------
# Calculate the average number of cards played by the number of players in the game.

## ------------------------------------------------------------------------
library("ggplot2")

## ------------------------------------------------------------------------
ggplot(data = Exp, aes(x = n_cards_played)) + geom_histogram(binwidth = 1)

## ---- eval=FALSE---------------------------------------------------------
## qplot(data = Exp, x = age, geom = "histogram", binwidth = 1)

## ------------------------------------------------------------------------
ggplot(data = Exp, aes(x = 1, y = n_cards_played)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(Exp, aes(x = n_owls, y = n_cards_played, group = n_owls)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(Exp, aes(x=n_owls, y = n_cards_played)) + geom_point()

## ------------------------------------------------------------------------
ggplot(Exp, aes(x=n_owls, y = n_cards_played)) + geom_jitter(width=0.2, height=0)

## ------------------------------------------------------------------------
ggplot(Exp, aes(x=n_cards_played)) + geom_bar()

## ---- eval=FALSE---------------------------------------------------------
## # Construct bar chart for the number of suns played.
## 
## # Construct a jittered scatter plot for the number of suns played as a function
## # of the number of owls.

## ---- eval=FALSE---------------------------------------------------------
## ?mean

## ---- eval=FALSE---------------------------------------------------------
## help.search("mean")

## ---- eval=FALSE---------------------------------------------------------
## ?ggplot
## ?geom_point

