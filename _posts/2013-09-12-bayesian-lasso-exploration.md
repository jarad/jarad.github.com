---
layout: post
title: "Bayesian LASSO exploration"
description: ""
category: 615
tags: [R, LASSO]
---
{% include JB/setup %}

We took a look at the Bayesian LASSO in [STAT 615]({{BASE_PATH}}/stat615) and here is the code from the exploration.


LASSO
========================================================

Taking a look at the diabetes data


{% highlight r %}
library(lars)
{% endhighlight %}



{% highlight text %}
## Loaded lars 1.2
{% endhighlight %}



{% highlight r %}
data(diabetes)
summary(diabetes$x)
{% endhighlight %}



{% highlight text %}
##       age                sex               bmi          
##  Min.   :-0.10723   Min.   :-0.0446   Min.   :-0.09028  
##  1st Qu.:-0.03730   1st Qu.:-0.0446   1st Qu.:-0.03423  
##  Median : 0.00538   Median :-0.0446   Median :-0.00728  
##  Mean   : 0.00000   Mean   : 0.0000   Mean   : 0.00000  
##  3rd Qu.: 0.03808   3rd Qu.: 0.0507   3rd Qu.: 0.03125  
##  Max.   : 0.11073   Max.   : 0.0507   Max.   : 0.17056  
##       map                 tc                ldl          
##  Min.   :-0.11240   Min.   :-0.12678   Min.   :-0.11561  
##  1st Qu.:-0.03666   1st Qu.:-0.03425   1st Qu.:-0.03036  
##  Median :-0.00567   Median :-0.00432   Median :-0.00382  
##  Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.00000  
##  3rd Qu.: 0.03564   3rd Qu.: 0.02836   3rd Qu.: 0.02984  
##  Max.   : 0.13204   Max.   : 0.15391   Max.   : 0.19879  
##       hdl                tch                ltg          
##  Min.   :-0.10231   Min.   :-0.07639   Min.   :-0.12610  
##  1st Qu.:-0.03512   1st Qu.:-0.03949   1st Qu.:-0.03325  
##  Median :-0.00658   Median :-0.00259   Median :-0.00195  
##  Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.00000  
##  3rd Qu.: 0.02931   3rd Qu.: 0.03431   3rd Qu.: 0.03243  
##  Max.   : 0.18118   Max.   : 0.18523   Max.   : 0.13360  
##       glu          
##  Min.   :-0.13777  
##  1st Qu.:-0.03318  
##  Median :-0.00108  
##  Mean   : 0.00000  
##  3rd Qu.: 0.02792  
##  Max.   : 0.13561
{% endhighlight %}


The standardization that has occurred here is that each explanatory variable "has been standardized to have unit L2 norm in each column and zero mean". So


{% highlight r %}
colSums(diabetes$x^2)
{% endhighlight %}



{% highlight text %}
## age sex bmi map  tc ldl hdl tch ltg glu 
##   1   1   1   1   1   1   1   1   1   1
{% endhighlight %}


Let's look at the least squares estimates just to get an idea of the magnitude of effects we are expecting to see. 


{% highlight r %}
m = lm(y ~ x, diabetes)
m
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = y ~ x, data = diabetes)
## 
## Coefficients:
## (Intercept)         xage         xsex         xbmi         xmap  
##       152.1        -10.0       -239.8        519.8        324.4  
##         xtc         xldl         xhdl         xtch         xltg  
##      -792.2        476.7        101.0        177.1        751.3  
##        xglu  
##        67.6
{% endhighlight %}


Now we can look at the LASSO trace. 


{% highlight r %}
plot(l <- lars(diabetes$x, diabetes$y))
{% endhighlight %}

![center](/figs/2013-09-12-bayesian-lasso-exploration/unnamed-chunk-4.png) 


Here the x-axis represents a re-scaled penalty parameter and the y-axis is the estimated coefficient with that penalty. The vertical lines indicate the times when a variable comes in or goes out of the model. Since there are only 10 covariates and 12 vertical lines, one variables comes in and out of the model. This can be verified by printing the lars object (below) where we can see `hdl` comes into the model at step 4, out at step 11, and back in at step 12. 


{% highlight r %}
l
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lars(x = diabetes$x, y = diabetes$y)
## R-squared: 0.518 
## Sequence of LASSO moves:
##      bmi ltg map hdl sex glu tc tch ldl age hdl hdl
## Var    3   9   4   7   2  10  5   8   6   1  -7   7
## Step   1   2   3   4   5   6  7   8   9  10  11  12
{% endhighlight %}


### Bayesian LASSO

Now we take a look at the Bayesian LASSO as implemented in the package `monomvn`. 


{% highlight r %}
library(monomvn)
{% endhighlight %}



{% highlight text %}
## Loading required package: pls
## 
## Attaching package: 'pls'
## 
## The following object is masked from 'package:stats':
## 
## loadings
## 
## Loading required package: MASS
{% endhighlight %}



{% highlight r %}
attach(diabetes)

## Ordinary Least Squares regression
reg.ols <- regress(x, y)

## Lasso regression with the penalty choosen by leave-one-out cross
## validation
reg.las <- regress(x, y, method = "lasso", validation = "LOO")

# Fully Bayesian LASSO
reg.blas <- blasso(x, y, RJ = FALSE)
{% endhighlight %}



{% highlight text %}
## t=100, m=10
## t=200, m=10
## t=300, m=10
## t=400, m=10
## t=500, m=10
## t=600, m=10
## t=700, m=10
## t=800, m=10
## t=900, m=10
{% endhighlight %}



{% highlight r %}

## summarize the beta (regression coefficients) estimates
plot(reg.blas, burnin = 200)
points(drop(reg.las$b), col = 2, pch = 20)
points(drop(reg.ols$b), col = 3, pch = 18)
legend("topleft", c("blasso-map", "lasso", "lsr"), col = c(2, 2, 3), pch = c(21, 
    20, 18))
{% endhighlight %}

![center](/figs/2013-09-12-bayesian-lasso-exploration/unnamed-chunk-6.png) 


This plot provides a comparison betweenthe fully Bayesian answer (provided via boxplots) and the LASSO (with the penalty chosen using LOO x-validation) vs OLS estimates. 
