a <- 0
b <- 1

# The curve function expects you to give a function of `x` and then it 
# (internally) creates a sequence of values from `from` and to `to` and creates
# plots similar to what we had before, but using a line rather than points.
curve(dunif(x, min = a, max = b), 
      from = -1, to = 2, n = 1001, 
      xlab='y', ylab='f(y)', 
      main='Probability density function for Unif(0,1)')

curve(punif(x, min = a, max = b), 
      from = -1, to = 2, n = 1001,
      xlab='y', ylab='F(y)', 
      main='Cumulative distribution function for Unif(0,1)')

# Visualize the CDF
curve(dunif(x, min = a, max = b), 
      from = -1, to = 2, n = 1001,
      xlab='y', ylab='f(y)', 
      main='CDF is area under the PDF (integral)')

U <- 0.3
x <- seq(-1, U, length = 1001)
polygon(c(x, rev(x)), 
          c(rep(0, length(x)), dunif(rev(x), min = a, max = b)),
          col = 'red', lty = 0)

punif(U, min = a, max = b)

# Visualize area under the curve
curve(dunif(x, min = a, max = b), 
      from = -1, to = 2, n = 1001,
      xlab='y', ylab='f(y)', 
      main='Area under the curve (integral)')

L <- 0.3; U <- 0.7
x <- seq(L, U, length = 1001)
polygon(c(x, rev(x)), 
          c(rep(0, length(x)), dunif(rev(x), min = a, max = b)),
          col = 'red', lty = 0)

punif(U, min = a, max = b) - punif(L, min = a, max = b)

random_uniforms <- runif(100, min = a, max = b)

hist(random_uniforms, 
     probability = TRUE, 
     main = 'Random draws from Unif(0,1)')

curve(dunif(x, min = a, max = b), 
      add = TRUE, col='red')



mu    <- 0
sigma <- 1 # standard deviation

curve(dnorm(x, mean = mu, sd = sigma), # notice the 3rd argument is the sd
      from = mu - 4*sigma, to = mu + 4*sigma, n = 1001,
      ylab = 'f(x)', xlab = 'x',
      main = 'PDF for a standard normal')

curve(pnorm(x, mean = mu, sd = sigma), 
      from = mu - 4*sigma, to = mu + 4*sigma, n = 1001,
      main = 'CDF for a standard normal',
      ylab = 'F(x)')

# Visualize the CDF
curve(dnorm(x, mean = mu, sd = sigma), 
      from = mu - 4*sigma, to = mu + 4*sigma, n = 1001,
      xlab='y', ylab='f(y)', 
      main='CDF is area under the PDF (integral)')

U <- 0.3
x <- seq(mu - 4*sigma, U, length = 1001)
polygon(c(x, rev(x)), 
          c(rep(0, length(x)), dnorm(rev(x), mean = mu, sd = sigma)),
          col = 'red', lty = 0)

pnorm(U, mean = mu, sd = sigma)

# Visualize area under the curve
curve(dnorm(x, mean = mu, sd = sigma), 
      from = mu - 4*sigma, to = mu + 4*sigma, n = 1001,
      xlab='y', ylab='f(y)', 
      main='Area under the curve (integral)')

L <- -0.2; U <- 0.3
x <- seq(L, U, length = 1001)
polygon(c(x, rev(x)), 
          c(rep(0, length(x)), dnorm(rev(x), mean = mu, sd = sigma)),
          col = 'red', lty = 0)

pnorm(U, mean = mu, sd = sigma) - pnorm(L, mean = mu, sd = sigma)

curve(qnorm(x, mean = mu, sd = sigma),
      from = 0, to = 1, n = 1001, 
      main = 'Quantile function for a standard normal')

draws <- rnorm(100, mean = mu, sd = sigma)
hist(draws, 20, probability = TRUE)
curve(dnorm(x, mean = mu, sd = sigma), n = 1001, 
      add = TRUE, col = 'red')
