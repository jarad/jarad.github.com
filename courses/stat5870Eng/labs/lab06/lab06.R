# Author: Jarad Niemi
# Date:   2024-10-10
# Purpose: Introduce built-in analyses in R including one population 
#          binomial and normal data.
#-------------------------------------------------------------------------------


library("tidyverse")

#-------------------------------------------------------------------------------
# Normal model


# Normal data
set.seed(20180219)
(y <- rnorm(10, mean = 3.2, sd = 1.1)) # 3.2 and 1.1 are the population parameters

# Normal mean MLE and posterior expectation
(ybar <- mean(y))

# Manual confidence/credible interval
n <- length(y)
s <- sd(y)
a <- 0.05

ybar + c(-1,1) * qt(1 - a/2, df = n-1) * s / sqrt(n)

# T-test (one-sample normal model)
t.test(y)

# T-test objects
tt <- t.test(y)
names(tt)
str(tt)

# Normal estimators for the mean (mu)
tt$estimate # MLE and Posterior expectation
tt$conf.int # Credible and confidence interval

# Normal arguments 
t.test(y, alternative = "less",    mu = 1,  conf.level = 0.9)

t.test(y, alternative = "greater", mu = -1, conf.level = 0.99)

# Normal activity data
set.seed(1)
y <- rnorm(1001, mean = 256, sd = 34.6)



#-------------------------------------------------------------------------------
# Binomial model


# Data
n <- 13
y <- 9

# Prior, Be(a,b)
a <- b <- 1

# Posterior
ggplot(data.frame(x=c(0,1)), aes(x=x)) + 
  stat_function(fun = dbeta, 
                args = list(shape1 = a+y,
                            shape2 = b+n-y)) + 
  labs(x = expression(theta),
       y = paste(expression("p(",theta,"|y)")),
       title = "Posterior distribution for probability of success") +
  theme_bw()

# Posterior expectation
(a + y) / (a + b + n)

# 95% equal-tail credible interval
qbeta(c(.025, .975), a + y, b + n - y)

# Binomial probabilities
1 - pbeta(0.5, a + y, b + n - y) # P(theta > 0.5 | y)



# Small n data
n <- 13
y <- 9

(bt <- binom.test(y, n))

# Binomial manual p value calculation
sum(dbinom(c(0:4, 9:13), size = n, prob = 0.5))

# Binomial confidence interval
(ci <- bt$conf.int)

# Using the end points as the hypothesized probability should result in 
# a p-value that is half of 1 - confidence level
binom.test(y, n, p = ci[2])$p.value # This one matches exactly
binom.test(y, n, p = ci[1])$p.value # This one is close

# Find the "correct" endpoint
# Create a function that should be zero when we have the correct probability
f <- function(p) {
  binom.test(y, n, p = p)$p.value - 0.025 # 0.025 is what the p-value should be
}

# Use unitroot to find value for p such that its p-value is 0.025
(u <- uniroot(f, lower = 0, upper = y/n))

# Check the p-value for this probability
binom.test(y, n, p = u$root)$p.value      



# Data with large n (and p not too close to 0 or 1)
n <- 100
y <- 78

# prop.test for large n (and p not too close to 0 or 1)
(pt <- prop.test(y, n))

# Binomial MLE
pt$estimate

# Binomial CI
pt$conf.int

# Manual CI
p <- y/n
p + c(-1, 1) * qnorm(.975) * sqrt(p * (1 - p) / n)

# You should always use the continuity correct
# this is just for illustrative purposes
prop.test(y, n, correct = FALSE)





set.seed(20180220)
# Generate some simulated data
n <- 100
d <- data.frame(rep = 1:n,
                response = sample(c("Yes","No"), n, replace=TRUE, prob = c(.2,.8)),
                measurement = rnorm(n, mean = 55, sd = 12))

# Write it to a file
# make sure you have set your working directory to someplace where you want this
# file to be written
write.csv(d, 
          file = "data.csv",
          row.names = FALSE)

## install.packages("readr")
## library("readr")
## write_csv(d, path = "data.csv")

my_data <- read.csv("data.csv")



head(my_data)
str(my_data)

y <- sum(my_data$response == "Yes")
n <- length(my_data$response)
prop.test(y, n)
binom.test(y, n)

t.test(my_data$measurement)



## install.packages("Sleuth3")
## library("Sleuth3")
## ?case0101
