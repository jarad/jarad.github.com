## --------------------------------------------------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
set.seed(20230305)


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
mu <- 0
sigma <- 1

y <- rnorm(10, mean = mu, sd = sigma)
ybar <- mean(y)
n <- length(y)
z <- qnorm(1-a/2)

ybar + c(-1,1) * z * sigma / n


## --------------------------------------------------------------------------------------------------------------------------------------
s <- sd(y)
t <- qt(1-a/2, df = n-1)

ybar + c(-1,1) * t * s / n


## --------------------------------------------------------------------------------------------------------------------------------------
ybar + c(-1,1) * z * s / sqrt(n)


## --------------------------------------------------------------------------------------------------------------------------------------
p <- 0.5
n <- 30

x <- rbinom(1, size = n, prob = p)

theta_hat <- x/n

theta_hat + c(-1,1) * z * sqrt(theta_hat*(1-theta_hat)/n)


## --------------------------------------------------------------------------------------------------------------------------------------
binom.test(x, n)$conf.int


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(x, n)$conf.int
prop.test(x, n, correct = FALSE)$conf.int


## --------------------------------------------------------------------------------------------------------------------------------------
create_ci <- function(x, a = 0.05) {
  theta_hat <- mean(x)
  n <- length(x)
  
  theta_hat + c(-1,1) * qnorm(1-a/2) * sqrt(theta_hat*(1-theta_hat)/n)
}


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 10
mu <- 0
sigma <- 1

z <- qnorm(1-a/2)

expand.grid(rep = 1:1e3,
            n = 1:n) %>%
  mutate(
    y = rnorm(n(), 
              mean = mu, 
              sd = sigma)
  ) %>%
  group_by(rep) %>%
  summarize(
    n = n(),
    ybar = mean(y),
    lcl = ybar - z * sigma / sqrt(n),
    ucl = ybar + z * sigma / sqrt(n),
    .groups = "drop"
  ) %>%
  mutate(
    within = lcl <= mu & mu <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 10
mu <- 0
sigma <- 1

t <- qt(1-a/2, df = n-1)

expand.grid(rep = 1:1e3,
            n = 1:n) %>%
  mutate(
    y = rnorm(n(), 
              mean = mu, 
              sd = sigma)
  ) %>%
  group_by(rep) %>%
  summarize(
    n = n(),
    ybar = mean(y),
    s = sd(y), 
    lcl = ybar - t * s / sqrt(n),
    ucl = ybar + t * s / sqrt(n),
    .groups = "drop"
  ) %>%
  mutate(
    within = lcl <= mu & mu <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 10
mu <- 0
sigma <- 1

z <- qnorm(1-a/2)

expand.grid(rep = 1:1e3,
            n = 1:n) %>%
  mutate(
    y = rnorm(n(), 
              mean = mu, 
              sd = sigma)
  ) %>%
  group_by(rep) %>%
  summarize(
    n = n(),
    ybar = mean(y),
    s = sd(y), 
    lcl = ybar - z * s / sqrt(n),
    ucl = ybar + z * s / sqrt(n),
    .groups = "drop"
  ) %>%
  mutate(
    within = lcl <= mu & mu <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 30
p <- 0.5

z <- qnorm(1-a/2)

data.frame(
  x = rbinom(1e3, size = n, prob = p)
) %>%
  mutate(
    theta_hat = x/n,
    
    lcl = theta_hat - z * sqrt(theta_hat*(1-theta_hat)/n),
    ucl = theta_hat + z * sqrt(theta_hat*(1-theta_hat)/n),
    within = lcl <= p & p <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 30
p <- 0.5

data.frame(
  x = rbinom(1e3, size = n, prob = p)
) %>%
  rowwise() %>%
  mutate(
    lcl = binom.test(x, n)$conf.int[1],
    ucl = binom.test(x, n)$conf.int[2],
    within = lcl <= p & p <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 30
p <- 0.5

data.frame(
  x = rbinom(1e3, size = n, prob = p)
) %>%
  rowwise() %>%
  mutate(
    lcl = prop.test(x, n, correct = FALSE)$conf.int[1],
    ucl = prop.test(x, n, correct = FALSE)$conf.int[2],
    within = lcl <= p & p <= ucl
  ) %>%
  pull(within) %>%
  create_ci()


## --------------------------------------------------------------------------------------------------------------------------------------
a <- 0.05
n <- 10
p <- 0.5

data.frame(
  x = rbinom(1e3, size = n, prob = p)
) %>%
  rowwise() %>%
  mutate(
    lcl = prop.test(x, n, correct = TRUE)$conf.int[1],
    ucl = prop.test(x, n, correct = TRUE)$conf.int[2],
    within = lcl <= p & p <= ucl
  ) %>%
  pull(within) %>%
  create_ci()

