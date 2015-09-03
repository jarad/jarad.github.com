source("M1-2-code.R")


# Test varsigma for Laplace

dvarsigma = Vectorize(function(x, theta, mu, tau, log=FALSE) {
  logf = -1/2*log(x)-(theta-mu)^2/(2*x)-x/(2*tau^2)
  if (log) return(logf)
  return(exp(logf))
})

mu = 3
theta = rnorm(1,mu)
tau = .3
py = integrate(function(x) dvarsigma(x,theta,mu,tau),0,Inf)


n_samps = 100000
samps = rep(NA,n_samps)
for (i in 1:n_samps) samps[i] = sample_varsigma(theta,mu,tau,model='laplace')

hist(samps, freq=F)
curve(dvarsigma(x, theta, mu, tau)/py$value, add=TRUE, col='red')




# Test tau for normal

deta = Vectorize(function(x, theta, mu, cc, log=FALSE) {
  logf = -length(theta)/2*log(x) - sum((theta-mu)^2)/(2*x) -log(1+x/cc^2) - log(x)/2
  if (log) return(logf)
  return(exp(logf))
}, vectorize.args = 'x')

mu = 3
theta = rnorm(10,mu)
cc = 1
py = integrate(function(x) deta(x,theta,mu,cc), 0, Inf)

n_samps = 100000
samps = rep(1,n_samps)
for (i in 2:n_samps) samps[i] = sample_tau(NULL, theta, mu, tau_current=samps[i-1], model='normal', prior=list(c=cc))

hist(samps^2, 1000, freq=F)
curve(deta(x, theta, mu, cc)/py$value, add=TRUE, col='red')




# Test tau for Laplace

deta = Vectorize(function(x, varsigma, cc, log=FALSE) {
  logf = -length(varsigma)*log(x) - sum(varsigma)/(2*x) -log(1+x/cc^2) - log(x)/2
  if (log) return(logf)
  return(exp(logf))
}, vectorize.args = 'x')

varsigma = rnorm(10)^2
cc = 1
py = integrate(function(x) deta(x,varsigma,cc), 0, Inf)

n_samps = 1e5
samps = rep(1,n_samps)
for (i in 2:n_samps) samps[i] = sample_tau(varsigma, theta, mu, tau_current=samps[i-1], model='laplace', prior=list(c=cc))

hist(samps^2, 1000, freq=F)
curve(deta(x, varsigma, cc)/py$value, add=TRUE, col='red')




# Test tau for t

deta = Vectorize(function(x, varsigma, vv, cc, log=FALSE) {
  logf = length(varsigma)*vv/2*log(x) - x*sum(1/varsigma) -log(1+x/cc^2) - log(x)/2
                                              
  if (log) return(logf)
  return(exp(logf))
}, vectorize.args = 'x')

varsigma = rnorm(10)^2
vv = 1
cc = 1
py = integrate(function(x) deta(x,varsigma,vv,cc), 0, Inf)

n_samps = 1e5
samps = rep(.01,n_samps)
for (i in 2:n_samps) samps[i] = sample_tau(varsigma, theta, mu, tau_current=samps[i-1], model='t', prior=list(c=cc,v=vv))

hist(samps^2, 1000, freq=F)
curve(deta(x, varsigma, vv, cc)/py$value, add=TRUE, col='red')


