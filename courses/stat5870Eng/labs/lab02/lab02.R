# Author: Jarad Niemi
# Date:   2024-09-05
# Purpose: Introduce the binomial and Poisson distributions in R including
#          the use of probability mass functions, cumulative distribution 
#          functions, and random variable generation.
#-------------------------------------------------------------------------------


n <- 13
p <- 0.7
dbinom(6, size = n, prob = p)

x <- 0:n
plot(x, dbinom(x, size = n, prob = p), 
     main = "Probability mass function for Bin(13,0.7)")

pbinom(9, size = n, prob = p)

plot(x, pbinom(x, size = n, prob = p), 
     type="s", 
     main = "Cumulative distribution function for Bin(13,0.7)")

draws <- rbinom(100, size = n, prob = p) # draw 100
brks  <- (0:(n+1)) - 0.5
hist(draws, breaks = brks, 
     main = "Random draws from Bin(13,0.7)") 

hist(draws, breaks = brks, probability = TRUE)
points(x, dbinom(x, size = n, prob = p), col="red")



rate <- 2
x <- 0:10 # with no upper limit we need to decide on an upper limit

plot(x, dpois(x, lambda = rate), 
     main = "Probability mass function for Po(2)") 

plot(x, ppois(x, lambda = rate), 
     type="s", 
     main = "Cumulative distribution function for Po(2)")

draws <- rpois(100, lambda = rate)

hist(draws, 
     breaks = (0:(max(draws)+1)) - 0.5, 
     probability = TRUE, 
     main = "Random draws from Po(2)")

points(x, dpois(x, lambda = rate), col="red")
