## --------------------------------------------------------------------------------------------------------
library("tidyverse")


## --------------------------------------------------------------------------------------------------------
y <- 13
n <- 19


## --------------------------------------------------------------------------------------------------------
y/n


## --------------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(from = 0, to = 1, length = 1001))

ggplot(d) + 
  stat_function(fun = dbeta, 
                args = list(shape1 = 1+y, shape2 = 1+n-y)) + 
  labs(x = expression(theta),
       y = "Posterior belief",
       title = "Posterior belief based on 13 successes out of 19 attempts")


## --------------------------------------------------------------------------------------------------------
pbeta(0.6, shape1 = 1+y, shape2 = 1+n-y)


## --------------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(from = 0, to = 1, length = 1001))

ggplot(d) + 
  stat_function(fun = dbeta, xlim = c(0,0.6), geom = "area", fill = "red",
                args = list(shape1 = 1+y, shape2 = 1+n-y)) + 
  stat_function(fun = dbeta, 
                args = list(shape1 = 1+y, shape2 = 1+n-y)) +
  labs(x = expression(theta),
       y = "Posterior belief",
       title = "Belief that the probability of success is less than 0.6")


## --------------------------------------------------------------------------------------------------------
1-pbeta(0.6, shape1 = 1+y, shape2 = 1+n-y)


## --------------------------------------------------------------------------------------------------------
a <- 0.05
qbeta(c(a/2, 1-a/2), shape1 = 1+y, shape2 = 1+n-y)


## --------------------------------------------------------------------------------------------------------
d <- tribble(
  ~group, ~successes, ~attempts,
       1,         13,        19,
       2,         23,        25
)


## --------------------------------------------------------------------------------------------------------
d %>% mutate(point_estimate = successes/attempts)


## --------------------------------------------------------------------------------------------------------
# Function to create the posterior
create_posterior <- function(d) {
  y <- d$successes
  n <- d$attempts
  
  data.frame(theta = seq(0, 1, length=1001)) %>%
    mutate(posterior = dbeta(theta, shape1 = 1+y, shape2 = 1+n-y))
}

# Construct the curves
curves <- d %>%
  group_by(group) %>%
  do(create_posterior(.)) %>%
  mutate(group = factor(group)) # so that we can use it as a linetype

# Plot curves
ggplot(curves, aes(x = theta, y = posterior, color = group, linetype = group)) +
  geom_line() + 
  labs(x = expression(theta),
       y = "Posterior belief",
       title = "Posterior beliefs for two groups.") + 
  theme_bw()


## --------------------------------------------------------------------------------------------------------
n_reps <- 100000
theta1 <- rbeta(n_reps, shape1 = 1+d$successes[1], shape2 = 1+d$attempts[1]-d$successes[1])
theta2 <- rbeta(n_reps, shape1 = 1+d$successes[2], shape2 = 1+d$attempts[2]-d$successes[2])


## --------------------------------------------------------------------------------------------------------
mean(theta1 > theta2)


## --------------------------------------------------------------------------------------------------------
a <- 1-0.95
quantile(theta1 - theta2, probs = c(a/2, 1-a/2))

