library(Rcpp)
library(plyr)
sourceCpp("M1-2.cpp", verbose=TRUE)
n = 3
mcmc_normal(1, rep(1,n), rep(1,n))


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

##############################################################################

G = 10
theta = rnorm(G)
d = data.frame(group = rep(1:G, each=5))
d$theta = theta[d$group]
d$y = rnorm(nrow(d), d$theta)

r = mcmc_normal(n_reps = 1e3, y = d$y, group = d$group, mu = 0, theta = rnorm(G), 
                sigma2 = 1, tau = 1, m = 0, C = 1, a = 1, b = 1, c = 1)

