a <- 0
b <- 1

# The curve function expects you to give a function of `x` and then it 
# (internally) creates a sequence of values from `from` and to `to` and creates
# plots similar to what we had before, but using a line rather than points.
curve(dunif(x, min = a, max = b), 
      from = -1, to = 2,
      xlab='y', ylab='f(y)', 
      main='Probability density function for Unif(0,1)')

curve(punif(x, min = a, max = b), 
      from = -1, to = 2,
      xlab='y', ylab='F(y)', 
      main='Cumulative distribution function for Unif(0,1)')

curve(qunif(x, min = a, max = b), 
      from = 0, to = 1,
      xlab='p', ylab='F^{-1}(p)', 
      main='Quantile function for Unif(0,1)')

random_uniforms <- runif(100, min = a, max = b)

hist(random_uniforms, 
     probability = TRUE, 
     main = "Random draws from Unif(0,1)")

curve(dunif(x, min = a, max = b), 
      add = TRUE, col="red")



mu    <- 0
sigma <- 1 # standard deviation

curve(dnorm(x, mean = mu, sd = sigma), # notice the 3rd argument is the sd
      from = -4, to = 4,
      main = "PDF for a standard normal")

curve(pnorm(x, mean = mu, sd = sigma), 
      from = -4, to = 4,
      main = "CDF for a standard normal",
      ylab = "F(x)")

curve(qnorm(x, mean = mu, sd = sigma),
      from = 0, to = 1, 
      main = "Quantile function for a standard normal")

draws <- rnorm(100, mean = mu, sd = sigma)
hist(draws, probability = TRUE)
curve(dnorm(x, mean = mu, sd = sigma), 
      add = TRUE, col = "red")
