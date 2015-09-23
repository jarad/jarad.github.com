library(plyr)
library(Rcpp)
sourceCpp("M1-2.cpp")

G = 10
theta = rep(c(rep(0,9),10), each=G/10); theta_true = theta
d = data.frame(group = rep(1:G, each=5))
d$theta = theta[d$group]
d$y = rnorm(nrow(d), d$theta)

s = ddply(d, .(group), summarize, n=length(y), mean=mean(y), var=var(y))

initial_values = list(
  mu = mean(s$mean), 
  theta = s$mean, 
  sigma2 = mean(s$var), 
  tau2 = var(s$mean))
prior = list(m = 0, C = 1, a = 1, b = 1, c = 1)

set.seed(1)
r = mcmc_normal(n_reps = 1e5, y = d$y, group = d$group, 
                initial_values = initial_values,
                prior = prior,
                verbose = 1)

# Find initial values
s = ddply(d, .(group), summarize, n=length(y), mean=mean(y), var=var(y))
sigma2 = mean(s$var) # best guess for sigma2
tau2   = var(s$mean) # best guess for tau




r = mcmc_pointmass_normal(n_reps = 1e5, y = d$y, group = d$group, 
                          mu = mean(s$mean), 
                          theta = rep(0,G), 
                          sigma2 = mean(s$var), 
                          tau2 = var(s$mean), 
                          m = 0, C = 100, a = 1, b = 1, c = 1, a_pi=1, b_pi=1)

# This isn't working yet
r = mcmc_pointmass_t(n_reps = 1e2, y = d$y, group = d$group, 
                     mu = mean(s$theta), 
                     theta = s$theta, 
                     sigma2 = 1, 
                     tau2 = var(s$theta), 
                     m = 0, C = 1, a = 1, b = 1, c = 1, a_pi=1, b_pi=1, df=5)

