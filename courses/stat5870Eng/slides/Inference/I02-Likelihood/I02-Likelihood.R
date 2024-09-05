## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("dplyr")
library("tidyr")
library("ggplot2")


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----binomial_likelihood----------------------------------------------------------------------------------------------
d2 <- data.frame(theta = seq(0,1,by=0.01)) %>%
  mutate(`y=3` = dbinom(3,10,prob=theta),
         `y=6` = dbinom(6,10,prob=theta)) %>%
  gather(data,likelihood,-theta) 

ggplot(d2, aes(theta, likelihood, color=data, linetype=data)) +
  geom_line() +
  labs(x = expression(theta),
       y = expression(L(theta)),
       title = "Binomial likelihoods (n=10)") + 
  theme_bw()


## ----normal_likelihood------------------------------------------------------------------------------------------------
x <- rnorm(3)

d <- expand.grid(mu = seq(-2,2,length=100),
                 sigma = seq(0,2,length=100)) %>%
  dplyr::mutate(density = dnorm(x[1], mu, sigma)*dnorm(x[2], mu, sigma)*dnorm(x[3], mu, sigma))

ggplot(d, aes(x = mu, y = sigma, z = density)) +
  geom_contour_filled(show.legend = FALSE) +
  labs(x = expression(mu), 
       y = expression(sigma),
       title = "Example normal likelihood") +
  # theme(legend.title = element_blank()) +
  theme_bw()


## ----binomial_mle-----------------------------------------------------------------------------------------------------
y <- 3
n <- 10
d3 <- data.frame(theta = seq(0,1,by=0.01)) %>%
  mutate(likelihood = dbinom(y,n,prob=theta)) 

ggplot(d3, aes(theta, likelihood)) +
  geom_line() +
  geom_vline(xintercept = y/n, col='red') +
  labs(x = expression(theta)) +
  theme_bw()


## ----binomial_mle_numerical, echo=TRUE--------------------------------------------------------------------------------
log_likelihood <- function(theta) {
  dbinom(3, size = 10, prob = theta, log = TRUE)
}

o <- optim(0.5, log_likelihood, 
           method='L-BFGS-B',            # this method to use bounds
           lower = 0.001, upper = .999,  # cannot use 0 and 1 exactly
           control = list(fnscale = -1)) # maximize

o$convergence # 0 means convergence was achieved
o$par         # MLE
o$value       # value of the likelihood at the MLE


## ----normal_numerical_maximization, echo=TRUE, dependson="normal_likelihood"------------------------------------------
x
log_likelihood <- function(theta) {
  sum(dnorm(x, mean = theta[1], sd = exp(theta[2]), log = TRUE))
}

o <- optim(c(0,0), log_likelihood,
            control = list(fnscale = -1))
c(o$par[1], exp(o$par[2])^2)               # numerical MLE
n <- length(x); c(mean(x), (n-1)/n*var(x)) # true MLE


## ----normal_mle, dependson=c("normal_likelihood","normal_numerical_maximization")-------------------------------------
ggplot(d, aes(mu,sigma,z=density)) +
  geom_contour_filled(show.legend = FALSE) +
  geom_point(aes(x = mean(x), y = sqrt((n-1)/n*var(x))), shape=4, color='red') + 
  labs(x = expression(mu), y = expression(sigma)) +
  theme_bw()

