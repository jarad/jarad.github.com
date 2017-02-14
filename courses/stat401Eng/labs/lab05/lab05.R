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
    var       = c(var(  mle), var(  bayes)))
  
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

