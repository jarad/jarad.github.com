library("tidyverse")

set.seed(20190219)

n <- 22
y <- 15
(mle <- y/n)

a <- b <- 1
(bayes <- (a+y)/(a+b+n))

qbeta(c(.025,.975), a+y, b+n-y)



# Biomial model with
# n attempts and probability of success theta
n      <- 10
theta  <- 0.5

# Storage for estimators
n_reps <- 1e4
mle    <- numeric(n_reps)
bayes  <- numeric(n_reps)

# Simulate n_reps binomial random variables
# compute MLE and Bayes estimators
for (i in 1:n_reps) {
  y        <- rbinom(1, size = n, prob = theta)
  mle[i]   <- y/n
  bayes[i] <- (a + y) / (a + b + n)
}


mean(mle)  - theta # estimate of MLE bias
mean(bayes)- theta # estimate of Bayes bias

# Binomial bias with Monte Carlo uncertainty
mean(mle  ) + c(-1, 1) * qnorm(.975) * sd(mle  ) / sqrt(length(mle  )) - theta
mean(bayes) + c(-1, 1) * qnorm(.975) * sd(bayes) / sqrt(length(bayes)) - theta

# Succinct binomial Monte Carlo study
y     <- rbinom(n_reps, size = n, prob = theta)
mle   <- y / n
bayes <- (a + y) / (a + b + n)

# Calculate bias with Monte Carlo uncertainty
mean(mle  ) + c(-1, 1) *qnorm(.975) * sd(mle  ) / sqrt(length(mle  )) - theta
mean(bayes) + c(-1, 1) *qnorm(.975) * sd(bayes) / sqrt(length(bayes)) - theta



# Perform the bias calculation for different combinations
# of n and theta
settings <- expand.grid(n     = 10^(0:3),
                        theta = seq(0, 1, by = 0.1))

# A function to estimate the bias based on a data.frame x
# that contains a single row with two columns: n and theta
sim_function <- function(x) {
  y     <- rbinom(1e4, size = x$n, prob = x$theta)
  mle   <- y / x$n
  bayes <- (a + y) / (a + b + x$n)
  
  d <- data.frame(
    estimator = c("mle", "bayes"),
    bias      = c(mean(mle), mean(bayes)) - x$theta,
    var       = c(var( mle), var( bayes)))
  
  # d$se    <- sqrt(d$var / x$n)
  # d$lower <- d$bias-qnorm(.975)*d$se
  # d$upper <- d$bias+qnorm(.975)*d$se
  
  return(d)
}

# Run the simulation study
sim_study <- settings |>
  group_by(n, theta) |> # for each combination of n and theta
  do(sim_function(.))

# Plot estimated bias from the simulation study
ggplot(sim_study, 
       aes(
         x        = theta, 
         y        = bias,         # plotting bias
         color    = estimator,
         linetype = estimator)) +
  geom_line() +
  facet_wrap(~n, scales = "free_y") + 
  theme_bw()

# Plot estimated bias from the simulation study
ggplot(sim_study, 
       aes(
        x        = theta, 
        y        = var,          # plotting variance
        color    = estimator,
        linetype = estimator)) +
  geom_line() +
  facet_wrap(~n, scales = "free_y") + 
  theme_bw()

# Plot estimated mse from the simulation study
sim_study$mse <- sim_study$var + sim_study$bias^2

ggplot(sim_study, 
       aes(
        x        = theta, 
        y        = mse,          # plotting MSE
        color    = estimator,
        linetype = estimator)) +
  geom_line() +
  facet_wrap(~n, scales = "free_y") + 
  theme_bw()



theta <- 0.51
n_max <- 999

sim_function <- function(d) {
  # Simulate binomials
  x <- rbinom(n_max, size = 1, prob = theta)
  
  # Storage structure for estimators
  mle <- bayes <- numeric(n_max)
  
  # Compute estimators for all from 1 to n_max
  for (n in 1:n_max) {
    y        <- sum(x[1:n])
    mle[n]   <- y / n
    bayes[n] <- (a + y) / (a + b + n)
  }
  
  # Record results
  data.frame(n     = 1:n_max,
             mle   = mle,
             bayes = bayes)
}

# Repeat 1000 times
d <- data.frame(rep=1:1e3) |>
  group_by(rep) |>
  do(sim_function(.))

# Calculate probability
epsilon <- 0.05 # feel free to change this
sum <- d |> 
  gather(estimator, estimate, mle, bayes) |>
  group_by(n, estimator) |>
  summarize(prob = mean(abs(estimate - theta) < epsilon))

ggplot(sum, 
       aes(
        x        = n, 
        y        = prob, 
        color    = estimator, 
        linetype = estimator)) + 
  geom_line() +
  theme_bw() 



# Binomial parameters
n     <- 100
theta <- 0.5

# Simulate binomial random variables
n_reps <- 1e4
y      <- rbinom(n_reps, size = n, prob = theta)

# Calculate all endpoints
lower <- qbeta(.025, a + y, b + n - y)
upper <- qbeta(.975, a + y, b + n - y)

# Calculate coverage
mean( lower <= theta & theta <= upper )

# Monte Carlo uncertainty
p <- mean( lower <= theta & theta <= upper)

p + c(-1, 1) * qnorm(.975) * sqrt(p * (1 - p) / n_reps)



# Binomial coverage function
binomial_coverage_function <- function(d) {
  y     <- rbinom(1e4, size = d$n, prob = d$theta)
  
  # Calculate endpoints of credible intervals
  lower <- qbeta(.025, a + y, b + d$n - y)
  upper <- qbeta(.975, a + y, b + d$n - y)
  
  data.frame(coverage = mean( lower <= d$theta & d$theta <= upper))
}

sim_study <- expand.grid(n = 10^(0:3),
                        theta = seq(0,1,by=0.1)) |>
  group_by(n,theta) |>
  do(binomial_coverage_function(.))

# Binomial coverage plot
ggplot(sim_study, 
       aes(
         x = theta, 
         y = coverage)) +
  geom_line() +
  facet_wrap(~n) + 
  geom_hline(
    yintercept = 0.95, 
    color = "red") +
  ylim(0,1) + 
  theme_bw()

binomial_coverage_function_fixed <- function(d) {
  n <- d$n
  theta <- d$theta
  y     <- rbinom(1e4, size = n, prob = theta)
  mle   <- y/d$n
  bayes <- (a+y)/(a+b+n)
  
  lower <- qbeta(.025, a+y, b+n-y)
  upper <- qbeta(.975, a+y, b+n-y)
  
  # Fix intervals when y=0
  lower[y==0] <- 0
  upper[y==0] <- qbeta(.95, a+0, b+n)
  
  # Fix intervals when y=n
  upper[y==n] <- 1
  lower[y==n] <- qbeta(.05, a+n, b+0)
  
  data.frame(coverage = mean( lower <= theta & theta <= upper))
}

sim_study <- expand.grid(n = 10^(0:3),
                        theta = seq(0,1,by=0.1)) |>
  group_by(n,theta) |>
  do(binomial_coverage_function_fixed(.))

ggplot(sim_study, 
       aes(
         x = theta, 
         y = coverage)) +
  geom_line() +
  facet_wrap(~n) + 
  geom_hline(
    yintercept = 0.95, 
    color = "red") +
  ylim(0,1) + 
  theme_bw()
