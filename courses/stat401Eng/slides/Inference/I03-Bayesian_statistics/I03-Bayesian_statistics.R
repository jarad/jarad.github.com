## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
library("dplyr")
library("tidyr")
library("ggplot2")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ------------------------------------------------------------------------
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

## ----echo=TRUE, fig.height=3.5-------------------------------------------
n <- 100
y <- 2
curve(dbeta(x, 1+y, 1+n-y), 0, 0.1,
      main = "Posterior density",
      xlab = expression(theta),
      ylab = expression(paste("p(",theta,"|y)")))

## ----echo=TRUE-----------------------------------------------------------
(1+y)/(2+n)

## ----echo=TRUE-----------------------------------------------------------
# 95% credible interval is 
ci = qbeta(c(.025,.975), 1+y, 1+n-y) 
round(ci, 3)

## ----echo=FALSE----------------------------------------------------------
curve(dbeta(x, 1+y, 1+n-y), 0, 0.1,
      main = "Posterior density",
      xlab = expression(theta),
      ylab = expression(paste("p(",theta,"|y)")))

ci_area <- data.frame(x = seq(ci[1],ci[2],length=101)) %>%
  mutate(y = dbeta(x, 1+y, 1+n-y)) %>%
  bind_rows(data.frame(x = ci[2:1], y = 0))

polygon(ci_area$x, ci_area$y, col='red', border=NA)

