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
  scale_y_continuous(limits = c(0,1)) +
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
n <- 10; p <- 1/6; y <- 2
dbinom(y, size = n, prob = p)


## ---------------------------------------------------------------------------------------------------------------------
n <- 10
p <- 0.3
d <- data.frame(y = 0:n) %>%
  mutate(pmf = dbinom(y, size = n, prob = p))

g1 <- ggplot(d, aes(y, pmf)) +
  geom_col(width=0.1) +
  scale_x_continuous(breaks = 0:n) +
  scale_y_continuous(limits = c(0,1)) +
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


## ----fig.height=2-----------------------------------------------------------------------------------------------------
n <- 10; y <- 8
d <- data.frame(x = seq(0, 1, length = 1001)) %>%
  mutate(Prior = dunif(x),
         Posterior = dbeta(x, 1+y, 1+n-y)) %>%
  pivot_longer(-x, names_to = "Belief", values_to = "density") %>%
  mutate(Belief = factor(Belief, levels = c("Prior","Posterior")))

ggplot(d, aes(x, density)) +
  facet_grid(.~Belief) +
  geom_line() +
  labs(x = expression(theta),
       y = "Probability density function",
       title = "Prior vs Posterior based on 8 successes in 10 attempts")


## ---------------------------------------------------------------------------------------------------------------------
create_posterior <- function(d) {
  data.frame(x = seq(0, 1, length=1001)) %>%
    mutate(density = dbeta(x, 1 + d$y, 1 + d$n - d$y))
}

d <- data.frame(y = c(8,80,800), n = c(10,100,1000)) %>%
  group_by(y,n) %>%
  do(create_posterior(.)) %>%
  mutate(n = factor(n)) %>%
  rename(`Sample size` = n)

ggplot(d, aes(x, density, color = `Sample size`, linetype = `Sample size`)) +
  geom_line() +
  labs(x = expression(theta),
       y = "Probability density function",
       title = expression(paste("Posteriors for different sample sizes with ",
                                hat(theta),"=0.8")))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
y <- 8; n <- 10; c <- 0.5

pbeta(c, 1+y, 1+n-y)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
1-pbeta(c, 1+y, 1+n-y)


## ---------------------------------------------------------------------------------------------------------------------
y <- 8
n <- 10
ggplot(data.frame(x = seq(0, 1, length=1001)), aes(x)) +
  stat_function(fun = dbeta, xlim = c(0,0.5),
                geom = "area" , fill = "red",
                args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  stat_function(fun = dbeta,
                args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  labs(x = expression(theta),
       y = "Posterior",
       title = "Posterior belief")


## ---------------------------------------------------------------------------------------------------------------------
y <- 8
n <- 10
ggplot(data.frame(x = seq(0, 1, length=1001)), aes(x)) +
  stat_function(fun = dbeta, xlim = qbeta(c(0.025, 0.975), 1+y, 1+n-y),
                geom = "area" , fill = "red",
                args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  stat_function(fun = dbeta,
                args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  labs(x = expression(theta),
       y = "Posterior",
       title = "95% Credible Interval (red area = 0.95)")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
a <- 1 - 0.95 # for 95\% CIs

y <- 8; n <- 10
qbeta(c(a/2, 1-a/2), shape1 = 1+y, shape2 = 1+n-y)
y <- 80; n <- 100
qbeta(c(a/2, 1-a/2), shape1 = 1+y, shape2 = 1+n-y) %>% round(2)
y <- 800; n <- 1000
qbeta(c(a/2, 1-a/2), shape1 = 1+y, shape2 = 1+n-y) %>% round(2)


## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(y = c(8,9),
                n = c(10,10),
                condition = c("no chatbot","with chatbot")) %>%
  group_by(condition) %>%
  do(create_posterior(.))

g <- ggplot(d, aes(x, density, color = condition, linetype = condition)) +
  geom_line() +
  labs(x = "Probability of success",
       y = "Posterior",
       title = "Comparison of probability of success with and without chatbot access")

g


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
a = 1-0.95

# no chatbot access
y <- 8
n <- 10
qbeta(c(a/2, 1-a/2), 1+y, 1+n-y) %>% round(2)

# with chatbot access
y <- 9
n <- 10
qbeta(c(a/2, 1-a/2), 1+y, 1+n-y) %>% round(2)


## ---------------------------------------------------------------------------------------------------------------------
y <- c(8,9)
n <- c(10,10)
g + geom_segment(data = data.frame(condition = c("no chatbot","with chatbot"),
                            y = c(-0.4, -0.2),
                            x = qbeta(.025, 1+y, 1+n-y),
                            xend = qbeta(.975, 1+y, 1+n-y)),
                 aes(x=x, y=y, yend=y, xend=xend))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n_reps = 1e5 # some large number
theta_nochatbot   <- rbeta(n_reps, 1+8, 1+10-8)
theta_withchatbot <- rbeta(n_reps, 1+9, 1+10-9)
mean(theta_withchatbot > theta_nochatbot)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
quantile(theta_withchatbot - theta_nochatbot, probs = c(a/2,1-a/2))


## ---------------------------------------------------------------------------------------------------------------------
y <- c(8,9,5)
n <- c(10,10,10)

d <- data.frame(y = c(8,9,5),
                n = c(10,10,10),
                condition = c("no chatbot","with chatbot","accessplus")) %>%
  group_by(condition) %>%
  do(create_posterior(.)) %>%
  mutate(condition = factor(condition, levels = c("no chatbot","with chatbot","accessplus")))

ggplot(d, aes(x, density, color = condition, linetype = condition)) +
  geom_line() +
  labs(x = "Probability of success",
       y = "Posterior",
       title = "Comparison of three registration systems") +
  geom_segment(data = data.frame(condition = c("no chatbot","with chatbot","accessplus"),
                            y = c(-0.4, -0.3,-0.2),
                            x = qbeta(.025, 1+y, 1+n-y),
                            xend = qbeta(.975, 1+y, 1+n-y)),
                 aes(x=x, y=y, yend=y, xend=xend))

