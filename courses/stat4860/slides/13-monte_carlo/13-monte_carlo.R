## ---------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())


## ---------------------------------------------------------------------------------
create_mean_dataframe <- function(x) {
  data.frame(n = 1:length(x)) %>%
    mutate(
      xbar = cumsum(x)/n,
      s    = cumsum((x-xbar)^2)/(n-1),
      lcl  = xbar - qnorm(.975)*s/sqrt(n),
      ucl  = xbar + qnorm(.975)*s/sqrt(n)
    )
}


## ---------------------------------------------------------------------------------
plot_mean <- function(d, truth = NULL) {
  g <- ggplot(d, aes(x = n, y = xbar, ymin = lcl, ymax = ucl)) + 
    geom_ribbon(fill = "blue", alpha = 0.3) + 
    geom_line(color = "blue")
  
  if (!is.null(truth))
    g <- g + geom_hline(yintercept = truth, color = "red", linetype = 2)
  
  return(g)
}


## ---------------------------------------------------------------------------------
m <- 0
s <- 1

x <- rnorm(1e3, mean = m, sd = s)

d <- create_mean_dataframe(x)

plot_mean(d, truth = m)


## ---------------------------------------------------------------------------------
rtnorm <- function(n, mean, sd, a, b) {
  x <- rnorm(n, mean, sd)
  for (i in seq_along(x)) {
    while (x[i] < a || x[i] > b) {
      x[i] <- rnorm(1, mean, sd)
    }
  }
  return(x)
}


## ---------------------------------------------------------------------------------
dtnorm <- function(x, mean, sd, a, b) {
  c <- diff(pnorm(c(a,b), mean, sd))
  d <- dnorm(x, mean, sd)/c
  return(d * (a < x & x < b))
}


## ---------------------------------------------------------------------------------
m <- 3
s <- 8
a <- 10
b <- 20


## ---------------------------------------------------------------------------------
curve(dtnorm(x, m, s, a, b), a-1, b+1, n = 1001)


## ---------------------------------------------------------------------------------
x <- rtnorm(1e3, m, s, a, b)
d <- create_mean_dataframe(x)
plot_mean(d)


## ---------------------------------------------------------------------------------
alpha <- (a-m)/s
beta  <- (b-m)/s
mean <- m + (dnorm(alpha)-dnorm(beta))/(pnorm(beta) - pnorm(alpha)) * s
plot_mean(d, truth = mean)


## ---------------------------------------------------------------------------------
m <- 0
s <- 1

x <- rcauchy(1e3, m, s)

d <- create_mean_dataframe(x)
plot_mean(d)
plot_mean(d) + xlim(25,100) # will likely need to adjust the limits


## ---------------------------------------------------------------------------------
create_proportion_dataframe <- function(x) {
  data.frame(n = 1:length(x)) %>%
    mutate(
      theta_hat = cumsum(x)/n,
      se        = sqrt(theta_hat*(1-theta_hat)/n),
      lcl       = theta_hat - qnorm(.975)*se,
      ucl       = theta_hat + qnorm(.975)*se
    )
}


## ---------------------------------------------------------------------------------
plot_proportion <- function(d, truth = NULL) {
  g <- ggplot(d, aes(x = n, y = theta_hat, ymin = lcl, ymax = ucl)) + 
    geom_ribbon(fill = "blue", alpha = 0.3) + 
    geom_line(color = "blue")
  
  if (!is.null(truth))
    g <- g + geom_hline(yintercept = truth, color = "red", linetype = 2)
  
  return(g)
}


## ---------------------------------------------------------------------------------
p <- 0.3

x <- rbinom(1e3, size = 1, prob = p)

d <- create_proportion_dataframe(x)
plot_proportion(d, truth = p)


## ---------------------------------------------------------------------------------
m <- 0
s <- 1
a <- 2
b <- 4

y <- rnorm(1e3, m, s)
x <- a < y & y < b

d <- create_proportion_dataframe(x)
plot_proportion(d, truth = diff(pnorm(c(a,b), mean = m, sd = s)))


## ---------------------------------------------------------------------------------
n <- 1e3
y <- rnorm(n)
e <- rexp(n)

x <- abs(y) < e

d <- create_proportion_dataframe(x)
plot_proportion(d)

tail(d,1)

