library("dplyr")
library("Rcpp")
sourceCpp("homework2.cpp")


# Simulate data
set.seed(1)
G = 100
theta = c(rep(0,G-10), rnorm(10,10))
d = data.frame(group = rep(1:G, each=5))
d$theta = theta[d$group]
d$y = rnorm(nrow(d), d$theta)

# Get initial values
s <- d %>% group_by(group) %>%
  summarize(n = n(),
            mean = mean(y),
            var  = var(y))

initial_values = list(
  mu = mean(s$mean), 
  theta = s$mean, 
  sigma2 = mean(s$var), 
  tau2 = var(s$mean))

# Set prior
prior = list(m = 0, C = 100, a = 1, b = 1, c = 1)

# Run MCMC
r = mcmc_normal(n_reps = 1e5, y = d$y, group = d$group, 
                initial_values = initial_values,
                prior = prior,
                verbose = 0)


### Compare posteriors to truth
par(mfrow = c(2,2))
hist(r$mu, probability = TRUE, main=expression(mu))
abline(v=mean(theta), col='red')
g = sample(100,1) # random group
hist(r$theta[,g], probability = TRUE, main = paste("group",g,"mean"))
abline(v=theta[g], col='red')
hist(sqrt(r$sigma2), probability = TRUE, main = expression(sigma))
abline(v=1, col='red')
hist(sqrt(r$tau2), probability = TRUE, main = expression(tau))
abline(v = sd(theta), col='red')



# Additional initial and prior values
initial_values$gamma = abs(s$mean) > 2*sqrt(initial_values$sigma2)
initial_values$pi = 1-mean(initial_values$gamma)
initial_values$psi = with(initial_values, ifelse(gamma, theta, rnorm(G, mu, sqrt(tau2))))
initial_values$mu = 0
initial_values$tau2 = var(s$mean[initial_values$gamma])
if (is.na(initial_values$tau2)) initial_values$tau2 = 1
prior$a_pi = prior$b_pi = 1

# Run MCMC
r = mcmc_pointmass_normal(n_reps = 1e5, y = d$y, group = d$group, 
                          initial_values = initial_values,
                          prior = prior,
                          verbose = 0)


par(mfrow = c(1,3))
hist(r$pi, probability = TRUE, main=expression(mu))
abline(v=mean(theta==0), col='red')
g = sample(100,1) # random group
hist(r$theta[,g], probability = TRUE, main = paste("group",g,"mean"))
abline(v=theta[g], col='red')
hist(sqrt(r$sigma2), probability = TRUE, main = expression(sigma))
abline(v=1, col='red')





initial_values$phi = rep(1,G)
prior$df = 3
r = mcmc_pointmass_t(n_reps = 1e5, y = d$y, group = d$group, 
                          initial_values = initial_values,
                          prior = prior,
                          verbose = 0)

par(mfrow = c(1,3))
hist(r$pi, probability = TRUE, main=expression(pi))
abline(v=mean(theta==0), col='red')
g = sample(100,1) # random group
hist(r$theta[,g], probability = TRUE, main = paste("group",g,"mean"))
abline(v=theta[g], col='red')
hist(sqrt(r$sigma2), probability = TRUE, main = expression(sigma))
abline(v=1, col='red')


