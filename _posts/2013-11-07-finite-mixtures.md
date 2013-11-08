---
layout: post
title: "Finite mixtures"
description: ""
category: 615
tags: [JAGS, mixtures, normal]
---
{% include JB/setup %}


This post looks at finite mixtures of normals. The first bit of code here looks at the flexibility of mixtures of normals. Feel free to change the argument to the plots function to try more mixtures.


{% highlight r %}
library(MCMCpack)
{% endhighlight %}



{% highlight text %}
## Loading required package: coda Loading required package: lattice Loading
## required package: MASS ## ## Markov Chain Monte Carlo Package (MCMCpack)
## ## Copyright (C) 2003-2013 Andrew D. Martin, Kevin M. Quinn, and Jong Hee
## Park ## ## Support provided by the U.S. National Science Foundation ##
## (Grants SES-0350646 and SES-0350613) ##
{% endhighlight %}



{% highlight r %}

dmix = function(M) {
    alpha = 1
    pi = as.numeric(rdirichlet(1, rep(alpha, M)))
    
    mu = rnorm(M)
    sigma = sqrt(rgamma(M, 1))
    
    f = function(x) sum(pi * dnorm(x, mu, sigma))
    vf = Vectorize(f)
}

plots = function(M) {
    plot(0, 0, type = "n", xlim = c(-5, 5), ylim = c(0, 1), xlab = "x", ylab = "f(x)")
    for (i in 1:5) {
        f = dmix(M)
        curve(f, add = TRUE, col = i)
    }
}

plots(2)
{% endhighlight %}

![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-1.png) 


We now look at estimating the model using JAGS. This first versions shows identifiability issues that arise due to label switching. 


{% highlight r %}
mix = function(M) {
    alpha = 1
    pi = as.numeric(rdirichlet(1, rep(alpha, M)))
    
    mu = rnorm(M)
    sigma = sqrt(rgamma(M, 1))
    
    return(list(pi = pi, mu = mu, sigma = sigma))
}

rmix = function(n, mix) {
    eta = sample(length(mix$pi), n, replace = TRUE, prob = mix$pi)
    y = rnorm(n, mix$mu[eta], mix$sigma[eta])
    return(list(eta = eta, y = y))
}

set.seed(1)
M = 2
m = list(pi = c(0.4, 0.6), mu = c(-2, 2), sigma = c(1, 1))
d = rmix(20, m)

dat = list(M = M, y = d$y, alpha = rep(1, M), n = length(d$y))

library(rjags)
{% endhighlight %}



{% highlight text %}
## Linked to JAGS 3.1.0 Loaded modules: basemod,bugs
{% endhighlight %}



{% highlight r %}

jags_model = "\nmodel {\n  for (i in 1:n) {\n    y[i] ~ dnorm(mu[eta[i]], tau[eta[i]])\n    eta[i] ~ dcat(pi[])\n  }\n\n  for (i in 1:M) {\n    mu[i] ~ dnorm(0,1)\n    tau[i] ~ dgamma(1,1)\n    sigma[i] <- 1/sqrt(tau[i])\n  }\n\n  pi ~ ddirich(alpha)\n}"

jm = jags.model(textConnection(jags_model), data = dat, n.chains = 3)
{% endhighlight %}



{% highlight text %}
## Compiling model graph
##    Resolving undeclared variables
##    Allocating nodes
##    Graph Size: 96
## 
## Initializing model
{% endhighlight %}



{% highlight r %}
update(jm, 100)
res = coda.samples(jm, c("mu", "sigma", "eta", "pi"), n.iter = 3000)
plot(res)
{% endhighlight %}

![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-21.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-22.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-23.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-24.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-25.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-26.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-27.png) 


The non-identifiability can be seen by the observations having the same probability of coming from each component as well as the near identical posteriors for mu and sigma from each component. 

In order to make the parameters identified, we order the means using the `sort` function in [JAGS](http://mcmc-jags.sourceforge.net/). 


{% highlight r %}
# Order the components by their means to make the mixture components
# identifiable
identified_jags_model = "\nmodel {\n  for (i in 1:n) {\n    y[i] ~ dnorm(mu[eta[i]], tau[eta[i]])\n    eta[i] ~ dcat(pi[])\n  }\n\n  for (i in 1:M) {\n    mu0[i] ~ dnorm(0,1)\n    tau[i] ~ dgamma(1,1)\n    sigma[i] <- 1/sqrt(tau[i])\n  }\n  mu[1:M] <- sort(mu0)\n\n  pi ~ ddirich(alpha)\n}"

ijm = jags.model(textConnection(identified_jags_model), data = dat, n.chains = 3)
{% endhighlight %}



{% highlight text %}
## Compiling model graph
##    Resolving undeclared variables
##    Allocating nodes
##    Graph Size: 100
## 
## Initializing model
{% endhighlight %}



{% highlight r %}
ires = coda.samples(ijm, c("mu", "sigma", "eta", "pi"), n.iter = 2000)
plot(ires)
{% endhighlight %}

![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-31.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-32.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-33.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-34.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-35.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-36.png) ![center](/../figs/2013-11-07-finite-mixtures/unnamed-chunk-37.png) 




