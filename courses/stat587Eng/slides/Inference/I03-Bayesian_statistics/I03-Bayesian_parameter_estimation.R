## ----libraries, message=FALSE, warning=FALSE, cache=FALSE------------------------------------------------------
library("dplyr")
library("tidyr")
library("ggplot2")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## --------------------------------------------------------------------------------------------------------------
my_dbeta <- function(x) {
  data.frame(theta = seq(0, 1, length=101)) %>%
    mutate(density = dbeta(theta, x$a, x$b))
}

d <- expand.grid(a = c(.5,1,2, 10),
            b = c(.5,1,2, 10)) %>%
  group_by(a,b) %>%
  do(my_dbeta(.)) %>%
  ungroup() %>%
  mutate(a = factor(paste0("a = ", a), levels=paste0("a = ", c(.5,1,2,10))),
         b = factor(paste0("b = ", b), levels=paste0("b = ", c(.5,1,2,10))))

ggplot(d, aes(x=theta, y=density)) +
  geom_line() +
  facet_grid(a~b) +
  theme_bw() +
  ylim(0,5)


## --------------------------------------------------------------------------------------------------------------
n <- 100
y <- 2

ggplot(data.frame(x=c(0,.1)), aes(x)) +
  stat_function(fun = dbeta, args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  labs(x = expression(theta),
       y = expression(paste("p(",theta,"|y)")),
       title = "Posterior density") +
  theme_bw()


## ----echo=TRUE-------------------------------------------------------------------------------------------------
(1+y)/(2+n)


## ----echo=TRUE-------------------------------------------------------------------------------------------------
# 95% credible interval is 
ci = qbeta(c(.025,.975), 1+y, 1+n-y) 
round(ci, 3)


## ----echo=FALSE------------------------------------------------------------------------------------------------
ggplot(data.frame(x=c(0,.1)), aes(x)) +
  stat_function(fun = dbeta, args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  stat_function(fun = dbeta, args = list(shape1 = 1+y, shape2 = 1+n-y), 
                xlim = ci,
                geom = "area", fill = "red") +
  labs(x = expression(theta),
       y = expression(paste("p(",theta,"|y)")),
       title = "Posterior density with 95% area shaded") +
  theme_bw()


## ----eval = FALSE, echo = TRUE, size = 'tiny'------------------------------------------------------------------
## a <- 1; b <- 1                  # default uniform prior
## y <- 3; n <- 10                 # data
## 
## curve(dbeta(x,ay,b+n-y))        # posterior (pdf)
## (a+y)/(a+b+n)                   # posterior mean
## qbeta(.5, a+y, b+n-y)           # posterior median
## qbeta(c(.025,.975), a+y, b+n-y) # 95% equal tail credible interval
## 
## # Probabilities
## pbeta(0.5, a+y, b+n-y)          # P(theta<0.5|y)
## 
## # Special cases
## qbeta(c(0,.95), a+y, b+n-y)     # if y=0, use a lower one-sided CI
## qbeta(c(.05,1), a+y, b+n-y)     # if y=n, use a upper one-sided CI

