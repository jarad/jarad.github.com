## ------------------------------------------------------------------------
n <- 22
y <- 15
(mle <- y/n)

## ------------------------------------------------------------------------
(bayes <- (1+y)/(2+n))

## ------------------------------------------------------------------------
qbeta(c(.025,.975), 1+y, 1+n-y)

## ------------------------------------------------------------------------
n <- 10
theta <- 0.5

n_reps <- 1e4
mle <- numeric(n_reps)
bayes <- numeric(n_reps)

for (i in 1:n_reps) {
  y <- rbinom(1, size = n, prob = theta)
  mle[i] <- y/n
  bayes[i] <- (1+y)/(2+n)
}


mean(mle)  -0.5 # estimate of MLE bias
mean(bayes)-0.5 # estimate of Bayes bias

## ------------------------------------------------------------------------
mean(mle  ) + c(-1,1)*qnorm(.975)*sd(mle  )/sqrt(length(mle  )) - theta
mean(bayes) + c(-1,1)*qnorm(.975)*sd(bayes)/sqrt(length(bayes)) - theta

## ------------------------------------------------------------------------
y <- rbinom(n_reps, size = n, prob = theta)
mle   <- y/n
bayes <- (1+y)/(2+n)

mean(mle  ) + c(-1,1)*qnorm(.975)*sd(mle  )/sqrt(length(mle  )) - theta
mean(bayes) + c(-1,1)*qnorm(.975)*sd(bayes)/sqrt(length(bayes)) - theta

## ------------------------------------------------------------------------
settings <- expand.grid(n = 10^(0:3),
                        theta = seq(0,1,by=0.1))

## ---- eval=FALSE---------------------------------------------------------
## install.packages("plyr")

## ------------------------------------------------------------------------
library("plyr")

## ---- eval=FALSE---------------------------------------------------------
## ?plyr

## ------------------------------------------------------------------------
sim_study <- ddply(settings, .(n, theta), function(x) {
  y     <- rbinom(1e4, size = x$n, prob = x$theta)
  mle   <- y/x$n
  bayes <- (1+y)/(2+x$n)
  
  d <- data.frame(
    estimator = c("mle", "bayes"),
    bias      = c(mean(mle), mean(bayes)) - x$theta,
    var       = c(var( mle), var( bayes)))
  
  # d$se    <- sqrt(d$var / x$n)
  # d$lower <- d$bias-qnorm(.975)*d$se
  # d$upper <- d$bias+qnorm(.975)*d$se
  
  return(d)
})

## ------------------------------------------------------------------------
library("ggplot2")

ggplot(sim_study, aes(x=theta, y=bias, color=estimator)) +
  geom_line() +
  facet_wrap(~n) + 
  theme_bw()

## ------------------------------------------------------------------------
library("ggplot2")

ggplot(sim_study, aes(x=theta, y=var, color=estimator)) +
  geom_line() +
  facet_wrap(~n) + 
  theme_bw()

## ------------------------------------------------------------------------
sim_study$mse <- sim_study$var + sim_study$bias^2

ggplot(sim_study, aes(x=theta, y=mse, color=estimator)) +
  geom_line() +
  facet_wrap(~n) + 
  theme_bw()

## ------------------------------------------------------------------------
theta = 0.51
n_max <- 1e3

d <- ddply(data.frame(rep=1:1e3), .(rep), function(x) {
  x <- rbinom(n_max, size = 1, prob = theta)
  
  mle <- bayes <- numeric(n_max)
  for (n in 1:n_max) {
    y <- sum(x[1:n])
    mle[n] <- y/n
    bayes[n] <- (1+y)/(2+n)
  }
  
  data.frame(n     = 1:n_max,
             mle   = mle,
             bayes = bayes)
})

epsilon <- 0.05
sum <- ddply(d, .(n), function(x) {
  data.frame(estimator = c("mle","bayes"),
             prob = c(mean(abs(x$mle   - theta) < epsilon),
                      mean(abs(x$bayes - theta) < epsilon)))
})

## ------------------------------------------------------------------------
ggplot(sum, aes(x=n, y=prob, color=estimator)) + 
  geom_line() +
  theme_bw() 

## ------------------------------------------------------------------------
n <- 100
theta <- 0.5

n_reps <- 1e4
y <- rbinom(n_reps, size = n, prob = theta)

lower <- qbeta(.025, 1+y, 1+n-y)
upper <- qbeta(.975, 1+y, 1+n-y)

mean( lower < theta & theta < upper)

## ------------------------------------------------------------------------
p <- mean( lower < theta & theta < upper)

p + c(-1,1)*qnorm(.975)*sqrt(p*(1-p)/n_reps)

## ------------------------------------------------------------------------
sim_study <- ddply(settings, .(n, theta), function(x) {
  y     <- rbinom(1e4, size = x$n, prob = x$theta)
  mle   <- y/x$n
  bayes <- (1+y)/(2+x$n)
  
  lower <- qbeta(.025, 1+y, 1+x$n-y)
  upper <- qbeta(.975, 1+y, 1+x$n-y)
  
  data.frame(coverage = mean( lower <= x$theta & x$theta <= upper))
})

## ------------------------------------------------------------------------
ggplot(sim_study, aes(x=theta, y=coverage)) +
  geom_line() +
  facet_wrap(~n) + 
  theme_bw()

## ------------------------------------------------------------------------
sim_study <- ddply(settings, .(n, theta), function(x) {
  y     <- rbinom(1e4, size = x$n, prob = x$theta)
  mle   <- y/x$n
  bayes <- (1+y)/(2+x$n)
  
  lower <- qbeta(.025, 1+y, 1+x$n-y)
  upper <- qbeta(.975, 1+y, 1+x$n-y)
  
  # Fix intervals when y=0
  lower[y==0] <- 0
  upper[y==0] <- qbeta(.95, 1+0, 1+x$n-0)
  
  # Fix intervals when y=n
  upper[y==x$n] <- 1
  lower[y==x$n] <- qbeta(.05, 1+x$n, 1+x$n-x$n)
  
  data.frame(coverage = mean( lower <= x$theta & x$theta <= upper))
})

## ------------------------------------------------------------------------
ggplot(sim_study, aes(x=theta, y=coverage)) +
  geom_line() +
  facet_wrap(~n) + 
  theme_bw()

