---
layout: post
title: "Intrinsic CAR using CARBayes"
description: ""
category: [Teaching]
tags: [areal,spatial,STAT 615,R,CAR]
---
{% include JB/setup %}




{% highlight r %}
library("CARBayes")
{% endhighlight %}



{% highlight text %}
## Loading required package: Rcpp
{% endhighlight %}



{% highlight text %}
## Warning: package 'Rcpp' was built under R version 3.4.2
{% endhighlight %}



{% highlight r %}
set.seed(20171109)
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.4.1 (2017-06-30)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: OS X El Capitan 10.11.6
## 
## Matrix products: default
## BLAS: /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] CARBayes_5.0       Rcpp_0.12.13       bindrcpp_0.2       dplyr_0.7.4        xtable_1.8-2       Hmisc_4.0-3        Formula_1.2-2      survival_2.41-3    lattice_0.20-35    MCMCpack_1.4-0    
## [11] MASS_7.3-47        coda_0.19-1        dlm_1.1-4          ggplot2_2.2.1.9000 plyr_1.8.4         knitr_1.17        
## 
## loaded via a namespace (and not attached):
##  [1] deldir_0.1-14       gtools_3.5.0        assertthat_0.2.0    digest_0.6.12       truncnorm_1.0-7     R6_2.2.2            backports_1.1.1     acepack_1.4.1       MatrixModels_0.4-1 
## [10] evaluate_0.10.1     spam_2.1-1          highr_0.6           rlang_0.1.2         lazyeval_0.2.0      spdep_0.6-15        gdata_2.18.0        data.table_1.10.4   SparseM_1.77       
## [19] gmodels_2.16.2      rpart_4.1-11        Matrix_1.2-11       checkmate_1.8.4     labeling_0.3        splines_3.4.1       stringr_1.2.0       foreign_0.8-69      htmlwidgets_0.9    
## [28] munsell_0.4.3       compiler_3.4.1      shapefiles_0.7      pkgconfig_2.0.1     base64enc_0.1-3     mcmc_0.9-5          htmltools_0.3.6     nnet_7.3-12         expm_0.999-2       
## [37] tibble_1.3.4        gridExtra_2.3       htmlTable_1.9       matrixcalc_1.0-3    grid_3.4.1          nlme_3.1-131        gtable_0.2.0        magrittr_1.5        scales_0.5.0.9000  
## [46] stringi_1.1.5       reshape2_1.4.2      LearnBayes_2.15     sp_1.2-5            latticeExtra_0.6-28 boot_1.3-20         CARBayesdata_2.0    RColorBrewer_1.1-2  tools_3.4.1        
## [55] glue_1.1.1          colorspace_1.3-2    cluster_2.0.6       dotCall64_0.9-04    bindr_0.1           quantreg_5.33
{% endhighlight %}

Using the data from [this post](http://www.jarad.me/teaching/2017/11/08/spatial-data), 
we will utilize the intrinsic CAR prior to account for spatial association.


{% highlight r %}
load("data/spatial20171108.rda")
head(d)
{% endhighlight %}



{% highlight text %}
##   x.easting x.northing Y_normal Y_pois trials Y_binom    x1    x2
## 1         1          1    -1.28      1     10       2 -2.01  0.00
## 2         2          1     1.49      4     10      10  0.55  0.38
## 3         3          1     1.36      3     10       9  0.10  0.79
## 4         4          1     0.55      2     10       7  0.08 -0.14
## 5         5          1     0.89      0     10       6 -0.54  1.13
## 6         6          1     0.02      2     10       3  0.35 -0.84
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

![center](/../figs/2017-11-09-intrinsic-CAR-using-CARBayes/proximity_matrix-1.png)

## Normal model


{% highlight r %}
system.time(
  mn <- S.CARleroux(formula  = Y_normal ~ x1 + x2, 
                   family   = "gaussian", 
                   data     = d,
                   W        = W, 
                   fix.rho  = TRUE, rho = 1, # intrinsic CAR
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  44.141   3.975  49.694
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
## (Intercept) 0.6248 0.5968 0.6522    80000      100     75134.2        -0.6
## x1          0.9836 0.9447 1.0236    80000      100     14171.7         1.1
## x2          0.9859 0.9429 1.0288    80000      100     15026.4        -1.1
## nu2         0.0171 0.0037 0.0398    80000      100      1724.8        -1.0
## tau2        0.0848 0.0323 0.1532    80000      100      1896.8         1.1
## rho         1.0000 1.0000 1.0000       NA       NA          NA          NA
## 
## DIC =  -55.9519       p.d =  65.39269       Percent deviance explained =  99.67
{% endhighlight %}



## Binomial model


{% highlight r %}
system.time(
  mb <- S.CARleroux(formula  = Y_binom ~ x1 + x2, 
                   family   = "binomial", 
                   data     = d,
                   trials   = d$trials,
                   W        = W, 
                   fix.rho  = TRUE, rho = 1, # intrinsic CAR
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  38.574   3.925  47.830
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
## (Intercept) 0.7655 0.6074 0.9242    80000     46.5     26245.6        -1.8
## x1          1.1657 0.9771 1.3665    80000     46.5     15932.2        -1.1
## x2          1.0543 0.8567 1.2662    80000     46.5     17006.5        -1.2
## tau2        0.0134 0.0026 0.1437    80000    100.0       304.1         0.1
## rho         1.0000 1.0000 1.0000       NA       NA          NA          NA
## 
## DIC =  313.3336       p.d =  3.998382       Percent deviance explained =  48.75
{% endhighlight %}




## Poisson model


{% highlight r %}
system.time(
  mp <- S.CARleroux(formula  = Y_pois ~ x1 + x2, 
                   family   = "poisson", 
                   data     = d,
                   W        = W, 
                   fix.rho  = TRUE, rho = 1, # intrinsic CAR
                   burnin   = 20000, 
                   n.sample = 100000,
                   verbose  = FALSE)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##  32.139   3.258  37.832
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
## (Intercept) 0.7115 0.5425 0.8745    80000       46      2063.7        -2.3
## x1          0.9905 0.8651 1.1047    80000       46      1571.7         2.5
## x2          0.8755 0.7375 1.0117    80000       46      2495.8         1.2
## tau2        0.0600 0.0065 0.2742    80000      100       103.6        -0.4
## rho         1.0000 1.0000 1.0000       NA       NA          NA          NA
## 
## DIC =  382.3014       p.d =  12.18594       Percent deviance explained =  70.27
{% endhighlight %}
