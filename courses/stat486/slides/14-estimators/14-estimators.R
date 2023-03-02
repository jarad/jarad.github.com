## ---------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())


## ---------------------------------------------------------------------------------
create_ci <- function(x, a = 0.05) {
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  
  return(m + c(-1,1)*qnorm(1-a/2)*s/sqrt(n))
}


## ---------------------------------------------------------------------------------
n <- 10
p <- 0.3

x <- rbinom(1e3, size = n, prob = p)
theta_hat = x / n


## ---------------------------------------------------------------------------------
ggplot() + 
  geom_histogram(mapping = aes(x = theta_hat), bins = 30) +
  geom_vline(xintercept = p, col = 'red') +
  labs(title="Sampling distribution for sample proportion")


## ---------------------------------------------------------------------------------
mean(theta_hat)        # expectation
mean(theta_hat - p)    # bias
create_ci(theta_hat - p) # bias CI


## ---------------------------------------------------------------------------------
# variance
mean( (theta_hat - mean(theta_hat))^2 ) 

create_ci( (theta_hat - mean(theta_hat))^2 )


## ---------------------------------------------------------------------------------
# MSE
mean( (theta_hat - p)^2 )

# MSE CI
create_ci( (theta_hat-p)^2  )


## ---------------------------------------------------------------------------------
epsilon <- 0.01
n_seq <- floor(10^seq(1, 5, length = 10))
p_seq <- numeric(length(n_seq))

for (i in seq_along(n_seq)) {
  x <- rbinom(1e3, size = n_seq[i], prob = p)
  p_seq[i] <- mean(abs(x/n_seq[i] - p) > epsilon)
}

ggplot(data.frame(n = n_seq, p = p_seq),
       aes(x = n, y = p_seq)) + 
  geom_point() + 
  geom_line() +
  labs(x = "Sample size", y = "Probability",
       title = "Consistency of sample proportion") 


## ---------------------------------------------------------------------------------
n <- 10
p <- 0.3

x <- rbinom(1e3, size = n, prob = p)
theta_hat = (0.5 + x) / (1 + n)


## ---------------------------------------------------------------------------------
ggplot() + 
  geom_histogram(mapping = aes(x = theta_hat), bins = 30) +
  geom_vline(xintercept = p, col = 'red') +
  labs(title="Sampling distribution for sample proportion")


## ---------------------------------------------------------------------------------
mean(theta_hat)        # expectation
mean(theta_hat - p)    # bias
create_ci(theta_hat - p) # bias CI


## ---------------------------------------------------------------------------------
# variance
mean( (theta_hat - mean(theta_hat))^2 ) 

create_ci( (theta_hat - mean(theta_hat))^2 )


## ---------------------------------------------------------------------------------
# MSE
mean( (theta_hat - p)^2 )

# MSE CI
create_ci( (theta_hat-p)^2  )


## ---------------------------------------------------------------------------------
epsilon <- 0.01
n_seq <- floor(10^seq(1, 5, length = 10))
p_seq <- numeric(length(n_seq))

for (i in seq_along(n_seq)) {
  x <- rbinom(1e3, size = n_seq[i], prob = p)
  p_seq[i] <- mean(abs(x/n_seq[i] - p) > epsilon)
}

ggplot(data.frame(n = n_seq, p = p_seq),
       aes(x = n, y = p_seq)) + 
  geom_point() + 
  geom_line() +
  labs(x = "Sample size", y = "Probability",
       title = "Consistency of sample proportion") 


## ---------------------------------------------------------------------------------
n <- 10
m <- 0
s <- 1

d <- data.frame(rep = 1:1e3,
                n = 1:n) %>%
  mutate(y = rnorm(n())) %>%
  group_by(rep) %>%
  summarize(
    n    = n(),
    ybar = mean(y),
    sd   = sd(y)
  )


## ---------------------------------------------------------------------------------
ggplot(d, aes(x = ybar)) + 
  geom_histogram(bins = 30) + 
  geom_vline(xintercept = m, color = "red") +
  labs(x = "Sample mean", 
       title = "Sampling distribution of sample mean")


## ---------------------------------------------------------------------------------
# Bias
mean(d$ybar - m) 

# Bias with CI 
create_ci( d$ybar - m )


## ---------------------------------------------------------------------------------
# Variance
mean( (d$ybar - mean(d$ybar))^2 )

# Variance with uncertainty
create_ci( (d$ybar - mean(d$ybar))^2 )


## ---------------------------------------------------------------------------------
# MSE
mean( (d$ybar - m)^2 )

# Variance with uncertainty
create_ci( (d$ybar - m)^2 )


## ---------------------------------------------------------------------------------
epsilon <- 0.01
n_seq <- floor(10^seq(1, 5, length = 10))
p_seq <- numeric(length(n_seq))

for (i in seq_along(n_seq)) {
  xbar <- replicate(1e3, {       # replicate is another looping option
    mean( rnorm(n_seq[i], m, s))
  })
  p_seq[i] <- mean( abs(xbar - m) > epsilon)
}
   
ggplot(data.frame(n = n_seq, p = p_seq), 
       aes(x = n, y = p)) +
  geom_line() +
  geom_point() + 
  labs(x = "Sample size", y = "Probability",
       title = "Consistency of sample mean")

