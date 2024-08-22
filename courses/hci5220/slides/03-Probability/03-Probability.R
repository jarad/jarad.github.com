## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("gridExtra")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220119)


## ---------------------------------------------------------------------------------------------------------------------
p <- 0.3
d <- data.frame(x = c(0,1),
                pmf = c(1-p,p))

g1 <- ggplot(d, aes(x, pmf)) +
  geom_col(width=0.1) +
  scale_x_continuous(breaks = 0:1) +
  labs(title = "X ~ Ber(0.3)",
       y = "Probability mass function")

d <- data.frame(x = seq(-0.1, 1.1, length = 1001)) %>%
  mutate(cdf = pbinom(x, 1, p))

g2 <- ggplot(d, aes(x, cdf)) +
  geom_line() +
  scale_x_continuous(breaks = 0:1) +
  labs(title = "X ~ Ber(0.3)",
       y = "Cumulative distribution function")

grid.arrange(g1, g2, nrow = 1)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n <- 10
p <- 0.3
dbinom(0:n, size = n, prob = p) %>% round(2)


## ---------------------------------------------------------------------------------------------------------------------
n <- 10
p <- 0.3
d <- data.frame(y = 0:n) %>%
  mutate(pmf = dbinom(y, size = n, prob = p))

g1 <- ggplot(d, aes(y, pmf)) +
  geom_col(width=0.1) +
  scale_x_continuous(breaks = 0:n) +
  labs(title = "Y ~ Bin(10,0.3)",
       y = "Probability mass function")

d <- data.frame(y = seq(-0.1, n+0.1, length = 1001)) %>%
  mutate(cdf = pbinom(y, size = n, prob = p))

g2 <- ggplot(d, aes(y, cdf)) +
  geom_line() +
  scale_x_continuous(breaks = 0:n) +
  labs(title = "Y ~ Bin(10,0.3)",
       y = "Cumulative distribution function")

grid.arrange(g1, g2, nrow = 1)


## ---------------------------------------------------------------------------------------------------------------------
mu <- 0
sigma  <- 1
d <- data.frame(x = seq(-3, 3, length=1001)) %>%
  mutate(pdf = dnorm(x, mean = mu, sd = sigma),
         cdf = pnorm(x, mean = mu, sd = sigma))

g1 <- ggplot(d, aes(x, pdf)) +
  geom_line() +
  labs(title = "X ~ N(0,1)",
       y = "Probability mass function")

g2 <- ggplot(d, aes(x, cdf)) +
  geom_line() +
  labs(title = "X ~ N(0,1)",
       y = "Cumulative distribution function")

grid.arrange(g1, g2, nrow = 1)

