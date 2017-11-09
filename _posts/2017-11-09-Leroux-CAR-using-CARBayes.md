---
layout: post
title: "Leroux CAR using CARBayes"
description: ""
category: [Teaching]
tags: [areal,spatial,STAT615]
---
{% include JB/setup %}


{% highlight r %}
options(width=100)
{% endhighlight %}


{% highlight r %}
library("CARBayes")

set.seed(20171109)
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.4.0 (2017-04-21)
## Platform: x86_64-redhat-linux-gnu (64-bit)
## Running under: Red Hat Enterprise Linux Workstation 7.3 (Maipo)
## 
## Matrix products: default
## BLAS/LAPACK: /usr/lib64/R/lib/libRblas.so
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
##  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
## [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.17    bindrcpp_0.2  ggplot2_2.2.1 dplyr_0.7.4   CARBayes_5.0  Rcpp_0.12.13 
## [7] MASS_7.3-47  
## 
## loaded via a namespace (and not attached):
##  [1] spdep_0.6-13       CARBayesdata_2.0   highr_0.6          plyr_1.8.4         compiler_3.4.0    
##  [6] bindr_0.1          LearnBayes_2.15    shapefiles_0.7     tools_3.4.0        digest_0.6.12     
## [11] boot_1.3-20        dotCall64_0.9-04   evaluate_0.10.1    gtable_0.2.0       tibble_1.3.4      
## [16] nlme_3.1-131       lattice_0.20-35    pkgconfig_2.0.1    rlang_0.1.2        Matrix_1.2-10     
## [21] expm_0.999-2       SparseM_1.77       spam_2.1-1         coda_0.19-1        stringr_1.2.0     
## [26] gtools_3.5.0       MatrixModels_0.4-1 grid_3.4.0         glue_1.1.1         R6_2.2.2          
## [31] foreign_0.8-69     sp_1.2-5           gdata_2.18.0       deldir_0.1-14      magrittr_1.5      
## [36] scales_0.4.1       matrixcalc_1.0-3   mcmc_0.9-5         gmodels_2.16.2     splines_3.4.0     
## [41] assertthat_0.2.0   colorspace_1.3-2   labeling_0.3       quantreg_5.33      stringi_1.1.5     
## [46] MCMCpack_1.4-0     lazyeval_0.2.0     munsell_0.4.3      truncnorm_1.0-7
{% endhighlight %}

Using the data from [this post](http://www.jarad.me/teaching/2017/11/08/CAR-binomial-data), 
we will utilize the Leroux CAR prior to account for spatial association.



The code to read in the data is suppressed but the head of the data looks like


{% highlight r %}
head(d)
{% endhighlight %}



{% highlight text %}
##   x.easting x.northing Y_normal Y_pois trials Y_binom    x1    x2
## 1         1          1    -1.37      1     10       2 -2.01  0.00
## 2         2          1     1.81      5     10      10  0.55  0.38
## 3         3          1     1.62      5     10       9  0.10  0.79
## 4         4          1     0.65      2     10       7  0.08 -0.14
## 5         5          1     1.05      1     10       6 -0.54  1.13
## 6         6          1     0.40      2     10       3  0.35 -0.84
{% endhighlight %}

Build a neighborhood structure based on 4 nearest neighbors, 
i.e. cardinal directions.


{% highlight r %}
distance <- as.matrix(dist(d[,c("x.easting","x.northing")]))

# Proximity matrix
W              <- matrix(0, nrow = n, ncol = n)
W[distance==1] <- 1       	
{% endhighlight %}


{% highlight r %}
image(W)
{% endhighlight %}

![center](/../figs/2017-11-09-Leroux-CAR-using-CARBayes/proximity_matrix-1.png)

## Normal model


{% highlight r %}
system.time(
  mn <- S.CARleroux(formula  = Y_normal ~ x1 + x2, 
                   family   = "gaussian", 
                   data     = d,
                   W        = W, 
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  35.583   0.210  35.790
{% endhighlight %}


{% highlight r %}
mn
{% endhighlight %}



{% highlight text %}
## 
## #################
## #### Model fitted
## #################
## Likelihood model - Gaussian (identity link function) 
## Random effects model - Leroux CAR
## Regression equation - Y_normal ~ x1 + x2
## Number of missing observations - 0
## 
## ############
## #### Results
## ############
## Posterior quantities and DIC
## 
##             Median   2.5%  97.5% n.sample % accept n.effective Geweke.diag
## (Intercept) 0.6224 0.5990 0.6454    80000      100     72067.3         1.8
## x1          1.0138 0.9768 1.0505    80000      100     11347.7        -0.4
## x2          0.9824 0.9423 1.0224    80000      100     11829.9        -0.4
## nu2         0.0114 0.0029 0.0296    80000      100      1900.2        -0.6
## tau2        0.0744 0.0340 0.1187    80000      100      2894.2         0.1
## rho         0.8199 0.5055 0.9808    80000       46      6222.3        -0.9
## 
## DIC =  -90.79569       p.d =  72.11037       Percent deviance explained =  99.82
{% endhighlight %}



## Binomial model


{% highlight r %}
system.time(
  mb <- S.CARleroux(formula  = Y_binom ~ x1 + x2, 
                   family   = "binomial", 
                   data     = d,
                   trials   = d$trials,
                   W        = W, 
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  46.101   0.052  46.148
{% endhighlight %}


{% highlight r %}
mb
{% endhighlight %}



{% highlight text %}
## 
## #################
## #### Model fitted
## #################
## Likelihood model - Binomial (logit link function) 
## Random effects model - Leroux CAR
## Regression equation - Y_binom ~ x1 + x2
## Number of missing observations - 0
## 
## ############
## #### Results
## ############
## Posterior quantities and DIC
## 
##             Median   2.5%  97.5% n.sample % accept n.effective Geweke.diag
## (Intercept) 0.7048 0.5513 0.8632    80000     46.7     27452.1        -0.4
## x1          1.2724 1.0752 1.4805    80000     46.7     14460.2        -1.0
## x2          1.0814 0.8790 1.2942    80000     46.7     16984.4         0.0
## tau2        0.0065 0.0019 0.0443    80000    100.0       388.0         0.4
## rho         0.4431 0.0320 0.9110    80000     46.0      2590.5         0.1
## 
## DIC =  310.0368       p.d =  3.174497       Percent deviance explained =  50.89
{% endhighlight %}




## Poisson model


{% highlight r %}
system.time(
  mp <- S.CARleroux(formula  = Y_pois ~ x1 + x2, 
                   family   = "poisson", 
                   data     = d,
                   W        = W, 
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  36.577   0.009  36.588
{% endhighlight %}


{% highlight r %}
mp
{% endhighlight %}



{% highlight text %}
## 
## #################
## #### Model fitted
## #################
## Likelihood model - Poisson (log link function) 
## Random effects model - Leroux CAR
## Regression equation - Y_pois ~ x1 + x2
## Number of missing observations - 0
## 
## ############
## #### Results
## ############
## Posterior quantities and DIC
## 
##             Median   2.5%  97.5% n.sample % accept n.effective Geweke.diag
## (Intercept) 0.7813 0.6309 0.9266    80000     46.1      4681.6        -0.3
## x1          0.9201 0.8285 1.0121    80000     46.1      7545.1        -0.5
## x2          0.7712 0.6556 0.8866    80000     46.1      7936.1         0.7
## tau2        0.0060 0.0018 0.0320    80000    100.0       475.3         0.9
## rho         0.4231 0.0302 0.8951    80000     46.2      2471.3        -1.2
## 
## DIC =  373.8462       p.d =  4.142147       Percent deviance explained =  61.03
{% endhighlight %}
