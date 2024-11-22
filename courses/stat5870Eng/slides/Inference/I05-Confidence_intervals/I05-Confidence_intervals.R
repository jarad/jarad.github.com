## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("plyr")
library("dplyr")
library("tidyr")
library("ggplot2")
theme_set(theme_bw())


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----data, echo = FALSE-----------------------------------------------------------------------------------------------
y <- read.csv("../I04-Normal_model/yield.csv")$yield


## ----data_example, dependson="data", echo = FALSE---------------------------------------------------------------------
n <- length(y)
ybar <- mean(y)
s <- sd(y)
a <- .05
t_crit <- qt(1-a/2, df = n-1)
L <- ybar - t_crit*s/sqrt(n)
U <- ybar + t_crit*s/sqrt(n)


## ----critical_values_comparison---------------------------------------------------------------------------------------
d <- expand.grid(n = 10^(1:3), a = 1-c(.9,.95,.99)) %>%
  group_by(n, a) %>%
  mutate(z_crit = qnorm(1-a/2),
         t_crit = qt(   1-a/2, df=n-1)) %>%
  ungroup() %>%
  mutate(n = as.factor(n))

ggplot(d, aes(z_crit, t_crit, group=n, linetype=n, color=n)) +
  geom_line() +
  geom_abline(intercept = 0, slope = 1, color='gray') +
  # coord_fixed() +
  labs(x = "z critical values", y = "t critical values") 


## ----binomial-credible-interval, eval=FALSE, echo=TRUE----------------------------------------------------------------
## qbeta(c(a/2, 1-a/2), 1 + y, 1 + n - y)

