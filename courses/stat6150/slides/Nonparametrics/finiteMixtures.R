library(MCMCpack)

## Flexibility of normal mixtures

dmix = function(M) {
  alpha = 1
  pi = as.numeric(rdirichlet(1, rep(alpha,M)))

  mu = rnorm(M)
  sigma = sqrt(rgamma(M,1))

  f = function(x) sum(pi*dnorm(x,mu,sigma))
  vf  = Vectorize(f)
}

plots = function(M) {
  plot(0,0, type="n", xlim=c(-5,5), ylim=c(0,1), 
       xlab="x", ylab="f(x)")
   for (i in 1:5) {
    f = dmix(M)
    curve(f, add=TRUE, col=i)
  }
}

plots(2)

## Infinite likelihood
dnorm(0,0,10^-(1:10),log=TRUE)


## Non-identifiability
mix = function(M) {
  alpha = 1
  pi = as.numeric(rdirichlet(1, rep(alpha,M)))

  mu = rnorm(M)
  sigma = sqrt(rgamma(M,1))
  
  return(list(pi=pi,mu=mu,sigma=sigma))
}

rmix = function(n,mix) {
  eta = sample(length(mix$pi), n, replace=TRUE, prob=mix$pi)
  y   = rnorm(n, mix$mu[eta], mix$sigma[eta])
  return(list(eta=eta,y=y))
}

set.seed(1)
M = 2
m = list(pi=c(.4,.6), mu=c(-2,2), sigma=c(1,1))
d = rmix(20, m)

dat = list(M=M, y=d$y, alpha=rep(1,M), n=length(d$y))

library(rjags)

jags_model = "
model {
  for (i in 1:n) {
    y[i] ~ dnorm(mu[eta[i]], tau[eta[i]])
    eta[i] ~ dcat(pi[])
  }

  for (i in 1:M) {
    mu[i] ~ dnorm(0,1)
    tau[i] ~ dgamma(1,1)
    sigma[i] <- 1/sqrt(tau[i])
  }

  pi ~ ddirich(alpha)
}"

jm = jags.model(textConnection(jags_model), 
                data=dat, n.chains=3)
update(jm, 100)
res = coda.samples(jm, c("mu","sigma","eta","pi"), n.iter=3e3)
gelman.diag(res, mult=FALSE)
summary(res)
plot(res[,"mu[1]"])
plot(res,ask=TRUE)


# Order the components by their means to make 
# the mixture components identifiable
identified_jags_model = "
model {
  for (i in 1:n) {
    y[i] ~ dnorm(mu[eta[i]], tau[eta[i]])
    eta[i] ~ dcat(pi[])
  }

  for (i in 1:M) {
    mu0[i] ~ dnorm(0,1)
    tau[i] ~ dgamma(1,1)
    sigma[i] <- 1/sqrt(tau[i])
  }
  mu[1:M] <- sort(mu0)

  pi ~ ddirich(alpha)
}"

ijm = jags.model(textConnection(identified_jags_model), 
                data=dat, n.chains=3)
ires = coda.samples(ijm, c("mu","sigma","eta","pi"), n.iter=2e3)
gelman.diag(ires, mult=FALSE)
summary(ires)
plot(ires[,"mu[1]"])
plot(ires,ask=TRUE)

