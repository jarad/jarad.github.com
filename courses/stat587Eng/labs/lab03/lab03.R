## -----------------------------------------------------------------------------
n <- 13
p <- 0.7
dbinom(6, size = n, prob = p)


## -----------------------------------------------------------------------------
x <- 0:n
plot(x, dbinom(x, size = n, prob = p), main = "Probability mass function for Bin(13,0.7)")


## -----------------------------------------------------------------------------
pbinom(9, size = n, prob = p)


## -----------------------------------------------------------------------------
plot(x, pbinom(x, size = n, prob = p), type="s", main = "Cumulative distribution function for Bin(13,0.7)")


## -----------------------------------------------------------------------------
p_seq <- seq(from = 0, to = 1, length = 101)
plot(p_seq, qbinom(p_seq, size = n, prob = p), type="s", main = "Quantile function for Bin(13,0.7)")


## -----------------------------------------------------------------------------
draws <- rbinom(100, size = n, prob = p) # draw 100
brks  <- (0:(n+1)) - 0.5
hist(draws, breaks = brks, main = "Random draws from Bin(13,0.7)") 


## -----------------------------------------------------------------------------
hist(draws, breaks = brks, probability = TRUE)
points(x, dbinom(x, size = n, prob = p), col="red")




## -----------------------------------------------------------------------------
rate <- 2
x <- 0:10 # with no upper limit we need to decide on an upper limit

plot(x, dpois(x, lambda = rate), main = "Probability mass function for Po(2)") 


## -----------------------------------------------------------------------------
plot(x, ppois(x, lambda = rate), type="s", main = "Cumulative distribution function for Po(2)")


## -----------------------------------------------------------------------------
plot(p_seq, qpois(p_seq, lambda = rate), type="s", ylim=c(0,10), main = "Quantile function for Po(2)") # Change the y limits for comparison purposes


## -----------------------------------------------------------------------------
draws <- rpois(100, lambda = rate)

hist(draws, breaks = (0:(max(draws)+1)) - 0.5, probability = TRUE, main = "Random draws from Po(2)")
points(x, dpois(x, lambda = rate), col="red")




## -----------------------------------------------------------------------------
a <- 0
b <- 1

# The curve function expects you to give a function of `x` and then it 
# (internally) creates a sequence of values from `from` and to `to` and creates
# plots similar to what we had before, but using a line rather than points.
curve(dunif(x, min = a, max = b), from = -1, to = 2,
      xlab='y', ylab='f(y)', main='Probability density function for Unif(0,1)')


## -----------------------------------------------------------------------------
curve(punif(x, min = a, max = b), from = -1, to = 2,
      xlab='y', ylab='F(y)', main='Cumulative distribution function for Unif(0,1)')


## -----------------------------------------------------------------------------
curve(qunif(x, min = a, max = b), from = 0, to = 1,
      xlab='p', ylab='F^{-1}(p)', main='Quantile function for Unif(0,1)')


## -----------------------------------------------------------------------------
random_uniforms <- runif(100, min = a, max = b)
hist(random_uniforms, probability = TRUE, main = "Random draws from Unif(0,1)")
curve(dunif(x, min = a, max = b), add = TRUE, col="red")




## -----------------------------------------------------------------------------
mu    <- 0
sigma <- 1 # standard deviation

curve(dnorm(x, mean = mu, sd = sigma), # notice the 3rd argument is the sd
      from = -4, to = 4,
      main = "PDF for a standard normal")


## -----------------------------------------------------------------------------
curve(pnorm(x, mean = mu, sd = sigma), 
      from = -4, to = 4,
      main = "CDF for a standard normal",
      ylab = "F(x)")


## -----------------------------------------------------------------------------
curve(qnorm(x, mean = mu, sd = sigma),
      from = 0, to = 1, 
      main = "Quantile function for a standard normal")


## -----------------------------------------------------------------------------
draws <- rnorm(100, mean = mu, sd = sigma)
hist(draws, probability = TRUE)
curve(dnorm(x, mean = mu, sd = sigma), add = TRUE, col = "red")

