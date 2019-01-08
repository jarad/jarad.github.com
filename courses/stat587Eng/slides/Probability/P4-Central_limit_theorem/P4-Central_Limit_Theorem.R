## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
library("dplyr")
library("tidyr")
library("ggplot2")

## ----set_seed------------------------------------------------------------
set.seed(2)

## ----echo = TRUE, fig.height=4-------------------------------------------
n_sims <- 10000
n_obs  <- 1000
d <- data.frame(rep = rep(1:n_sims, each = n_obs),
                x   = runif(n_sims * n_obs)) %>%
  group_by(rep) %>%
  summarize(mean = mean(x),
            sum  = sum(x))

opar = par(mfrow=c(1,2))
hist(d$mean, 50, probability = TRUE)
curve(dnorm(x, mean = 1/2, sqrt(1/12/n_obs)), add = TRUE, col = "red")
hist(d$sum,  50, probability = TRUE)
curve(dnorm(x, mean = n_obs/2, sqrt(n_obs/12)), add = TRUE, col = "red")
par(opar)

## ----echo=TRUE-----------------------------------------------------------
n = 99
p = 19/39
1-pbinom(49, n, p)

## ----echo=TRUE-----------------------------------------------------------
1-pnorm(50, n*p, sqrt(n*p*(1-p)))

## ----echo = TRUE---------------------------------------------------------
-qnorm(.025)

