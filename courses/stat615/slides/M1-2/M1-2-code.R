library(plyr)
library(Rcpp)
sourceCpp("M1-2.cpp")

G = 1000
theta = rnorm(G)
d = data.frame(group = rep(1:G, each=5))
d$theta = theta[d$group]
d$y = rnorm(nrow(d), d$theta)

s = ddply(d, .(group), summarize, theta=mean(y), sigma2=var(y))

set.seed(1)
r = mcmc_normal(n_reps = 10, y = d$y, group = d$group, 
                mu = mean(s$theta), 
                theta = s$theta, 
                sigma2 = 1, 
                tau = var(s$theta), 
                m = 0, C = 1, a = 1, b = 1, c = 1)


r = mcmc_pointmass_normal(n_reps = 10, y = d$y, group = d$group, 
                          mu = mean(s$theta), 
                          theta = s$theta, 
                          sigma2 = 1, 
                          tau = var(s$theta), 
                          m = 0, C = 1, a = 1, b = 1, c = 1, a_pi=1, b_pi=1)

# This isn't working yet
r = mcmc_pointmass_t(n_reps = 1e2, y = d$y, group = d$group, 
                     mu = mean(s$theta), 
                     theta = s$theta, 
                     sigma2 = 1, 
                     tau2 = var(s$theta), 
                     m = 0, C = 1, a = 1, b = 1, c = 1, a_pi=1, b_pi=1, df=5)

