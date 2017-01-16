## ------------------------------------------------------------------------
a <- 0
b <- 1
curve(dunif(x, min = a, max = b), from = -1, to = 2,
      xlab='y', ylab='f(y)', main='Probability density function for Unif(0,1)')

## ------------------------------------------------------------------------
curve(punif(x, min = a, max = b), from = -1, to = 2,
      xlab='y', ylab='f(y)', main='Cumulative distribution function for Unif(0,1)')

## ------------------------------------------------------------------------
curve(qunif(x, min = a, max = b), from = 0, to = 1,
      xlab='y', ylab='f(y)', main='Quantile function for Unif(0,1)')

## ------------------------------------------------------------------------
random_uniforms <- runif(100, min = a, max = b)
hist(random_uniforms, probability = TRUE)

