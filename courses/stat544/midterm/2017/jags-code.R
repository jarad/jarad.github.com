library(rjags)

N = 100
K = 10
x = rnorm(N)
g = rep(1:(N/K),each=K)
a = rnorm(10)[g]
b = rnorm(10)[g]

eta = a+b*x
p = exp(eta)/(1+exp(eta))
y = rbinom(n,1,p)

model = "
model
{
  for (i in 1:N)
  {
    y[i] ~ dbern(p[i])
    p[i]   <- exp(eta[i])/(1+exp(eta[i]))
    eta[i] <- a[g[i]] + b[g[i]] * x[i]
  }

  for (k in 1:K)
  {
    a[k] ~ dnorm(mu.a, tau.a)
    b[k] ~ dnorm(mu.b, tau.b)
  }

  mu.a ~ dnorm(0, 0.0001)
  mu.b ~ dnorm(0, 0.0001)

  tau.a <- 1/sigma.a^2
  tau.b <- 1/sigma.b^2
  sigma.a ~ dunif(0, 1000)
  sigma.b ~ dunif(0, 1000)
}
"

dat = list(y=y,N=N,g=g,K=K,x=x)
m = jags.model(textConnection(model), dat)

res = coda.samples(m, c("a","b","mu.a","mu.b","sigma.a","sigma.b"),n.iter=1000)
summary(res)