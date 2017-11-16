---
layout: post
title: "Bayesian logistic regression"
description: ""
category: [Teaching]
tags: [STAT 615,R,logistic regression]
---
{% include JB/setup %}

This exploration looks at [Bayesian logistic regression using Pólya-Gamma latent variables](http://arxiv.org/abs/1205.0310). 


### Implied priors for a binomial probability

In a binomial model, we have two objective priors that people might argue over: Be(1,1) and Be(1/2,1/2). The former is uniform on the interval (0,1) and the latter is the [Jeffreys' prior](http://en.wikipedia.org/wiki/Jeffreys_prior), i.e. it is invariant to the transformation used. We also have objective priors that people are happy with for Bayesian regression, namely the joint prior for coefficients and variance is proportional to one divided by the variance. This implies a uniform prior over the whole real line for the coefficients.

When we try to use the regression-style priors in the logistic (or probit) regression, the implied prior on the probability ends up having huge tails at 0 and 1 with little mass anywhere between 0 and 1. This would seem to contradict the objective priors we like for a binomial probability. 

The regression-style prior is suggested in the linked paper and here is some code the simulates the implied prior on p. The model here is a mixed effect logistic regression model where beta is the coefficient for the fixed effect and delta are the random effects. Here we are just looking at, for example, one particular observation. But since we have set the long explanatory variable to zero (and thus the impact of the prior for beta is eliminated), all observations are exchangeable and the implied prior on p is the same for all observations.

The first function here just creates a sample from the prior suggested in the paper. Formally, the authors take the limit as kappa goes to infinity. We will approximate this by increasing kappa and determining what happens. 


{% highlight r %}
p = function(psi) 1/(1+exp(-psi))

samps = function(kappa, 
                 phi.a=1, 
                 phi.b=1, 
                 beta.sigma=100, 
                 x = 0,
                 n=1e5) {
  phi = rgamma(n, phi.a, phi.b)
  sd = 1/sqrt(phi)

  beta = rnorm(n,0,beta.sigma)
  delta = rnorm(n,0,sd)
  m = rnorm(n,0,kappa*sd)
  
  p(m+delta+x*beta)
}
{% endhighlight %}

Below are three plots where kappa has increased from 1 to 10 to 100. With kappa=1, the prior looks almost uniform but appears to have a peak near 0 and 1. As kappa is increased this peak gets higher and higher. This implied prior does not seem objective at all. 


{% highlight r %}
kappas = 10^c(0:2)
par(mfrow=c(1,length(kappas)))
for (i in 1:length(kappas)) {
  hist(samps(kappas[i]), 1000, freq=F, 
       main=paste("kappa=",kappas[i]), ylim=c(0,2))
}
{% endhighlight %}

![center](/../figs/2013-09-12-bayesian-logistic-regression/unnamed-chunk-2-1.png)


### Accept/reject algorithm

This was not discussed in class, but is just a simple example of an accept/reject algorithm to sample a standard normal using a t distribution.


{% highlight r %}
# sample Z~N(0,1) using X~t_df
df = 5
n = 1e6 # number of attempts
c = exp(dnorm(0,log=T)-dt(0,df,log=T))
x = rt(n,df)
lu = log(runif(n))+log(c)+dt(x,df,log=T)
z = x[lu<=dnorm(x,log=T)]
{% endhighlight %}

In the plot below is a histogram of the samples with two curves representing the target distribution (normal) and the proposal distribution (t). It appears to do reasonably well although I'm concerned with the slightly higher peak at the mode of the distribution. Is this just due to binning?


{% highlight r %}
hist(z, 100, freq=F)
curve(dnorm, add=T, col=4, lwd=2)
curve(dt(x,df), add=T, col=2, lwd=2, lty=2)
legend("topright",c("normal","t"), col=c(4,2), lty=1:2, lwd=2)
{% endhighlight %}

![center](/../figs/2013-09-12-bayesian-logistic-regression/unnamed-chunk-4-1.png)

I also decided to check the acceptance rate relative to the expected acceptance rate and these don't seem to quite agree. Do I have a bug somewhere?


{% highlight r %}
length(z)/n # acceptance rate, should be 1/c
{% endhighlight %}



{% highlight text %}
## [1] 0.932718
{% endhighlight %}



{% highlight r %}
1/c
{% endhighlight %}



{% highlight text %}
## [1] 0.9515329
{% endhighlight %}

### Bayesian logistic regression in R (using Pólya-Gamma latent variables)

The code below is straight from the examples in the help file for the function `logit` in the package `BayesLogit`. Nonetheless, I thought I would leave the code here so users could see how easy it is to run the Bayesian logistic regression using this data augmentation. 


{% highlight r %}
# 
library(BayesLogit)
{% endhighlight %}



{% highlight text %}
## Error in library(BayesLogit): there is no package called 'BayesLogit'
{% endhighlight %}



{% highlight r %}
## From UCI Machine Learning Repository.
data(spambase);
{% endhighlight %}



{% highlight text %}
## Warning in data(spambase): data set 'spambase' not found
{% endhighlight %}



{% highlight r %}
## A subset of the data.
sbase = spambase[seq(1,nrow(spambase),10),];
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'spambase' not found
{% endhighlight %}



{% highlight r %}
X = model.matrix(is.spam ~ word.freq.free + word.freq.1999, data=sbase);
{% endhighlight %}



{% highlight text %}
## Error in terms.formula(object, data = data): object 'sbase' not found
{% endhighlight %}



{% highlight r %}
y = sbase$is.spam;
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'sbase' not found
{% endhighlight %}



{% highlight r %}
## Run logistic regression.
output = logit(y, X, samp=10000, burn=1000);
{% endhighlight %}



{% highlight text %}
## Error in logit(y, X, samp = 10000, burn = 1000): could not find function "logit"
{% endhighlight %}




Some traceplots that look pretty good. 


{% highlight r %}
# Traceplots
par(mfrow=c(1,3))
for (i in 1:3)
  plot(output$beta[,i], type="l")
{% endhighlight %}



{% highlight text %}
## Error in plot(output$beta[, i], type = "l"): object 'output' not found
{% endhighlight %}

And some posterior plots (panel.hist and panel.cor are taken from the `pairs` help file).


{% highlight r %}
# Posteriors
pairs(output$beta, labels=paste("beta",1:3), lower.panel = panel.smooth, upper.panel = panel.cor, diag.panel = panel.hist)
{% endhighlight %}



{% highlight text %}
## Error in pairs(output$beta, labels = paste("beta", 1:3), lower.panel = panel.smooth, : object 'output' not found
{% endhighlight %}




