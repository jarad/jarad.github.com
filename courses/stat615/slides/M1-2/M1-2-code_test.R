# This file is really just for my personal use in debugging my code. 
# I don't expect much of it to run at any given time. 


setwd('courses/stat615/slides/M1-2')

library(Rcpp)
library(plyr)
library(ggplot2)
library(reshape2)
sourceCpp("M1-2.cpp", verbose=TRUE)


# calc_SSE
y = rnorm(10); theta = rnorm(1)
stopifnot(all.equal(calc_SSE(y,theta), sum((y-theta)^2)))

# calc_all_SSE
g = 10
n = rpois(g,4)+1
theta = rnorm(g)
d = data.frame(group = rep(1:g, times=n))
d$y = rnorm(nrow(d), theta[d$group])
d$theta = theta[d$group]
stopifnot(all.equal(calc_all_SSE(d$y, d$group, theta),
                    ddply(d, .(group), summarize, sse=sum((y-theta)^2))$sse))



# Sample normal variance
n = 1e4
m = 100
sse = m*.01
r = sample_normal_variance(rep(m,n), rep(sse,n), rep(1,n), rep(1,n))
hist(1/r, freq=F, 100)
curve(dgamma(x, 1+m/2, 1+sse/2), add=TRUE, col='red')

# Sample normal mean
n = 1e4
theta = rnorm(n)
y = rnorm(n, theta); y= rep(1,n)
r = sample_normal_mean(y, rep(1,n), rep(0, n), rep(1,n))
hist(r, freq=F, 100)
curve(dnorm(x, y[1]/2, sqrt(1/2)), add=T, col='red')
# Test varsigma for Laplace

dvarsigma = Vectorize(function(x, theta, mu, tau, log=FALSE) {
  logf = -1/2*log(x)-(theta-mu)^2/(2*x)-x/(2*tau^2)
  if (log) return(logf)
  return(exp(logf))
})


# Test sample_pi
n_reps = 1e4
pi = rep(NA,n_reps)
n = 100; true_pi = 0.8
s = rbinom(n, 1, 1-true_pi)
for (i in 1:n_reps) pi[i] = sample_pi(s,1,1)
hist(pi, freq=F, 100, xlim=c(0,1))
curve(dbeta(x,1+n-sum(s),1+sum(s)), add=TRUE, lwd=2, col='red')


# Test sample mu
n_reps = 1e4
n = 10
true_mu = 0
phi = rgamma(n, 1, 1)
psi = rnorm(n, true_mu, phi)
phi2 = phi^2
m = 0; C = 1
Cp = 1/(1/C + sum(1/phi2))
mp = Cp*(m/C + sum(psi/phi2))
set.seed(1)
mu = rnorm(n_reps, mp, sqrt(Cp))
mus = rep(NA, n_reps)
set.seed(1)
for (i in 1:n_reps) mus[i] = sample_mu(psi,phi,m,C)
all.equal(mu,mus)


# sample_gamma

G = 10
n = rpois(G,1)+1
psi = rep(c(0,10), each=G/2)
ybar = rnorm(G, psi)
pi = .9
sigma2 = 1
set.seed(1); sample_gamma(pi, G, n, ybar, psi, sigma2)
  
# sample_tau2
true_f = function(tau2, theta, mu, c) {
  exp(sum(dnorm(theta,mu,sqrt(tau2), log=TRUE)) + dcauchy(tau2,0,c,log=TRUE))
}
mu = .5
c = 1
theta = rnorm(10,mu)
Vf = Vectorize(function(x) true_f(x, theta=theta, mu=mu, c=c))
ii = integrate(Vf, 0, Inf)

n_reps = 1e5
tau2 = rep(1, n_reps)
I = length(theta)
for (i in 2:n_reps) 
  tau2[i] = tau2_MH(1/rgamma(1,(I-1)/2, sum((theta-mu)^2/2)), tau2[i-1], 1)
hist(tau2, 100, freq=F)
curve(dcauchy(x,0,1)*2, col='blue', lwd=2, add=TRUE)
curve(Vf(x)/ii$value, col='red', lwd=2, add=TRUE)

##############################################################################

G = 10
theta = rnorm(G)
d = data.frame(group = rep(1:G, each=5))
d$theta = theta[d$group]
d$y = rnorm(nrow(d), d$theta)


s = ddply(d, .(group), summarize, theta=mean(y), sigma2=var(y))


Cp = 1/(nrow(s)/var(s$theta) + 1/1)
mp = Cp*(sum(s$theta)/var(s$theta) + 0/1)

sourceCpp("M1-2.cpp", verbose=TRUE)


r = mcmc_normal(n_reps = 1e4, y = d$y, group = d$group, 
                mu = mean(s$theta), 
                theta = s$theta, 
                sigma2 = 1, 
                tau = var(s$theta), 
                m = 0, C = 1, a = 1, b = 1, c = 1)
hist(r$mu, freq=FALSE, 100)
curve(dnorm(x, mp, sqrt(Cp)), add=TRUE, col='red', lty=2)
abline(v=mean(s$theta), col='blue')

ggplot(melt(r$theta, varnames=c('iteration','group')), aes(value)) +
  geom_histogram() +
  geom_vline(data=s, aes(xintercept=theta)) + 
  facet_wrap(~group)

hist(r$tau, freq=FALSE, 100)
abline(v=var(s$theta), col='blue', lwd=2)
mean(r$tau); var(s$theta)

hist(r$sigma, freq=FALSE, 100)
abline(v=sqrt(mean(s$sigma2)), col='blue', lwd=2)

hist(r$pi, freq=FALSE, 100)
