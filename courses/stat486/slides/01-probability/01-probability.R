# Author:  Jarad Niemi
# Date:    2024-01-15
# Purpose: Demonstrate use of R for probability calculations

# Example combination: C(10,4)
choose(10, 4) 

# Example permutation: P(10,4)
factorial(10) / factorial(4)

# Probabilities for the sum of two 6-sided dice
d <- data.frame(sum = 2:12, probability = c(1:6,5:1)/36)
plot(probability ~ sum, data = d)

# Probability of a pair when being delt two cards
3/51



#############################################################################
# Binomial
#############################################################################


# Binomial parameters
n <- 25
p <- 0.9

# Expected value (mean)
n*p

# Variance
n*p*(1-p)

# Calculate probability using probability mass function
dbinom(24, size = n, prob = p)

# Calculate probability using the cumulative distribution function
# Remember P(Y < y) = P(Y <= y-1)
pbinom(23 - 1, size = n, prob = p)

# Alternatively using the probability mass function
sum(dbinom(0:22, size = n, prob = p))



#############################################################################
# Poisson
#############################################################################

# Poisson parameter
rate <- 5.4

# Mean
rate

# Variance
rate

# Calculate Poisson probability using probability mass function
dpois(4, lambda = rate)

# Calculate probability of a range using the cumulative distribution function
ppois(8, lambda = rate) - ppois(3, lambda = rate) # OR
diff(ppois(c(3,8), lambda = rate))

# Calculate probability of a range using the sum of probability mass function values
dpois(4, lambda = rate) + 
  dpois(5, lambda = rate) +
  dpois(6, lambda = rate) +
  dpois(7, lambda = rate) +
  dpois(8, lambda = rate)   # OR

sum(dpois(4:8, lambda = rate))



#############################################################################
# Normal
#############################################################################

# Standard normal density, Y ~ N(0,1)
mu    <- 0
sigma <- 1 # Standard deviation

# Probability density function (PDF)
curve(dnorm(x, mean = mu, sd = sigma), from = mu-3*sigma, to = mu+3*sigma)

# P(Y < 0.5)
xmax <- 0.5

# Using CDF
pnorm(xmax, mean = mu, sd = sigma) # OR
integrate(dnorm, -Inf, xmax, mean = mu, sd = sigma)

# Visualizing the area under the PDF
x <- seq(from = mu - 3*sigma, to = mu + 3*sigma, length = 1001)
y <- dnorm(x, mean = mu, sd = sigma)

plot(x, y, type = "l")
polygon(c( x[x<=xmax], xmax, min(x)), c(y[x<=xmax], 0, 0), col="red")

# Normal parameters
mu    <- 3
sigma <- 4

# Mean
mu

# Variance
sigma^2

# Standard deviation
sigma

# What is the probability density function for Y=2?
dnorm(2, mean = mu, sd = sigma)

# Probability of a range using CDF
pnorm(2, mean = mu, sd = sigma) - pnorm(-0.5, mean = mu, sd = sigma)
diff(pnorm(c(-0.5, 2), mean = mu, sd = sigma))

# Probability of a range using PDF
integrate(dnorm, lower = -0.5, upper = 2)
