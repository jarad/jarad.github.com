---
layout: post
title: "Bayesian LASSO"
description: ""
category: [Teaching]
tags: [STAT 615,R,logistic regression,LASSO]
---

{% include JB/setup %}

## LASSO

Taking a look at the diabetes data


{% highlight r %}
library(lars)
{% endhighlight %}



{% highlight text %}
## Error in library(lars): there is no package called 'lars'
{% endhighlight %}



{% highlight r %}
data(diabetes)
{% endhighlight %}



{% highlight text %}
## Warning in data(diabetes): data set 'diabetes' not found
{% endhighlight %}



{% highlight r %}
summary(diabetes$x)
{% endhighlight %}



{% highlight text %}
## Error in summary(diabetes$x): object 'diabetes' not found
{% endhighlight %}

The standardization that has occurred here is that each explanatory variable "has been standardized to have unit L2 norm in each column and zero mean". So


{% highlight r %}
colSums(diabetes$x^2)
{% endhighlight %}



{% highlight text %}
## Error in is.data.frame(x): object 'diabetes' not found
{% endhighlight %}

Let's look at the least squares estimates just to get an idea of the magnitude of effects we are expecting to see. 


{% highlight r %}
m = lm(y~x, diabetes)
{% endhighlight %}



{% highlight text %}
## Error in is.data.frame(data): object 'diabetes' not found
{% endhighlight %}



{% highlight r %}
m
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'm' not found
{% endhighlight %}

Now we can look at the LASSO trace. 


{% highlight r %}
plot(l <- lars(diabetes$x, diabetes$y))
{% endhighlight %}



{% highlight text %}
## Error in lars(diabetes$x, diabetes$y): could not find function "lars"
{% endhighlight %}

Here the x-axis represents a re-scaled penalty parameter and the y-axis is the estimated coefficient with that penalty. The vertical lines indicate the times when a variable comes in or goes out of the model. Since there are only 10 covariates and 12 vertical lines, one variables comes in and out of the model. This can be verified by printing the lars object (below) where we can see `hdl` comes into the model at step 4, out at step 11, and back in at step 12. 


{% highlight r %}
l
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'l' not found
{% endhighlight %}

### Bayesian LASSO

Now we take a look at the Bayesian LASSO as implemented in the package `monomvn`. 


{% highlight r %}
library(monomvn)
{% endhighlight %}



{% highlight text %}
## Error in library(monomvn): there is no package called 'monomvn'
{% endhighlight %}



{% highlight r %}
attach(diabetes)
{% endhighlight %}



{% highlight text %}
## Error in attach(diabetes): object 'diabetes' not found
{% endhighlight %}



{% highlight r %}
## Ordinary Least Squares regression
reg.ols <- regress(x, y)
{% endhighlight %}



{% highlight text %}
## Error in regress(x, y): could not find function "regress"
{% endhighlight %}



{% highlight r %}
## Lasso regression with the penalty choosen by leave-one-out cross validation
reg.las <- regress(x, y, method="lasso", validation="LOO")
{% endhighlight %}



{% highlight text %}
## Error in regress(x, y, method = "lasso", validation = "LOO"): could not find function "regress"
{% endhighlight %}



{% highlight r %}
# Fully Bayesian LASSO
reg.blas <- blasso(x, y, RJ=FALSE)
{% endhighlight %}



{% highlight text %}
## Error in blasso(x, y, RJ = FALSE): could not find function "blasso"
{% endhighlight %}



{% highlight r %}
## summarize the beta (regression coefficients) estimates
plot(reg.blas, burnin=200)
{% endhighlight %}



{% highlight text %}
## Error in plot(reg.blas, burnin = 200): object 'reg.blas' not found
{% endhighlight %}



{% highlight r %}
points(drop(reg.las$b), col=2, pch=20)
{% endhighlight %}



{% highlight text %}
## Error in drop(reg.las$b): object 'reg.las' not found
{% endhighlight %}



{% highlight r %}
points(drop(reg.ols$b), col=3, pch=18)
{% endhighlight %}



{% highlight text %}
## Error in drop(reg.ols$b): object 'reg.ols' not found
{% endhighlight %}



{% highlight r %}
legend("topleft", c("blasso-map", "lasso", "lsr"),
       col=c(2,2,3), pch=c(21,20,18))
{% endhighlight %}



{% highlight text %}
## Error in strwidth(legend, units = "user", cex = cex, font = text.font): plot.new has not been called yet
{% endhighlight %}

This plot provides a comparison betweenthe fully Bayesian answer (provided via boxplots) and the LASSO (with the penalty chosen using LOO x-validation) vs OLS estimates. 
