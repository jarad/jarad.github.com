---
layout: post
title: "Simulating spatial data"
description: ""
category: [Teaching]
tags: [areal,data,simulation]
---
{% include JB/setup %}

The posts generates some spatial data on a lattice which can be used to evaluate
areal models or point-referenced models on a lattice.
The code is a modified version of the code in `?CARBayes::S.CARleroux`.


{% highlight r %}
library("MASS")
library("dplyr")
library("ggplot2")

set.seed(20171108)
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
## [1] knitr_1.17         bindrcpp_0.2       dplyr_0.7.4       
## [4] ggplot2_2.2.1.9000 CARBayes_5.0       Rcpp_0.12.13      
## [7] MASS_7.3-47       
## 
## loaded via a namespace (and not attached):
##  [1] spdep_0.6-15       CARBayesdata_2.0   highr_0.6         
##  [4] bindr_0.1          compiler_3.4.1     plyr_1.8.4        
##  [7] LearnBayes_2.15    shapefiles_0.7     tools_3.4.1       
## [10] digest_0.6.12      boot_1.3-20        dotCall64_0.9-04  
## [13] evaluate_0.10.1    tibble_1.3.4       nlme_3.1-131      
## [16] gtable_0.2.0       lattice_0.20-35    pkgconfig_2.0.1   
## [19] rlang_0.1.2        Matrix_1.2-11      expm_0.999-2      
## [22] SparseM_1.77       spam_2.1-1         coda_0.19-1       
## [25] stringr_1.2.0      gtools_3.5.0       MatrixModels_0.4-1
## [28] grid_3.4.1         glue_1.1.1         R6_2.2.2          
## [31] foreign_0.8-69     sp_1.2-5           gdata_2.18.0      
## [34] magrittr_1.5       deldir_0.1-14      scales_0.5.0.9000 
## [37] matrixcalc_1.0-3   mcmc_0.9-5         gmodels_2.16.2    
## [40] splines_3.4.1      assertthat_0.2.0   colorspace_1.3-2  
## [43] labeling_0.3       quantreg_5.33      stringi_1.1.5     
## [46] MCMCpack_1.4-0     lazyeval_0.2.0     munsell_0.4.3     
## [49] truncnorm_1.0-7
{% endhighlight %}

Construct spatial lattice.


{% highlight r %}
Grid <- expand.grid(x.easting = 1:10, x.northing = 1:10)
n <- nrow(Grid)
{% endhighlight %}

Build a neighborhood structure based on 4 nearest neighbors, 
i.e. cardinal directions.


{% highlight r %}
distance <- as.matrix(dist(Grid))

# Proximity matrix
W              <- matrix(0, nrow = n, ncol = n)
W[distance==1] <- 1       	
{% endhighlight %}

Simulate data


{% highlight r %}
# Explanatory variables and coefficients
x1 <- rnorm(n)
x2 <- rnorm(n)

# Spatial field
omega <- MASS::mvrnorm(n     = 1, 
                       mu    = rep(0,n), 
                       Sigma = 0.4 * exp(-0.1 * distance))

eta <- x1 + x2 + omega

d <- Grid %>% 
  mutate(Y_normal = rnorm(n, eta, sd = 0.1) %>% round(2),
         Y_pois   = rpois(n, exp(eta)),
         trials   = 10,
         Y_binom  = rbinom(n = n, size = trials, prob = 1/(1+exp(-eta))))
{% endhighlight %}

Normal data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_normal)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-CAR-binomial-data/normal_data-1.png)

Poisson data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_pois)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-CAR-binomial-data/poisson_data-1.png)

Binomial data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_binom/trials)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-CAR-binomial-data/binomial_data-1.png)

For use in future posts, 
put it all in a list.


{% highlight r %}
dput(d)
{% endhighlight %}



{% highlight text %}
## structure(list(x.easting = c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 
## 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 
## 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 
## 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 
## 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 
## 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 
## 4L, 5L, 6L, 7L, 8L, 9L, 10L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 
## 9L, 10L), x.northing = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
## 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 3L, 3L, 3L, 3L, 3L, 
## 3L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 5L, 
## 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 
## 6L, 6L, 6L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 8L, 8L, 8L, 
## 8L, 8L, 8L, 8L, 8L, 8L, 8L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 
## 9L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L), Y_normal = c(-1.28, 
## 1.5, 1.36, 0.54, 0.89, 0.01, -0.13, 0.36, -0.71, 0.1, 2.35, 0.21, 
## 1.32, 1.43, 0.27, -0.01, 0.66, 1.12, -0.4, 2.11, 3.89, -1.79, 
## 1.06, -2.04, 2.09, 0.94, -1.04, -0.62, 1.56, 0.23, 0.76, 3.05, 
## 0.7, 3.02, 0.18, 0.77, 0.66, 0.37, -1.76, 1.69, 0.77, -1.16, 
## 0.48, 0.72, -0.45, 2.04, 1.6, -0.54, 0.88, 0.07, 0.96, 3.73, 
## 1.66, 2.4, -0.49, -0.19, 2.99, 1.65, 0.48, 0.92, 1.72, 1.56, 
## -0.39, 1.73, 1.44, -1.21, 0.52, -1.04, 0.48, -0.03, 0.56, -1.63, 
## 2.13, 2.25, 0.03, 2.99, 0.15, 0.19, 0.42, 1.17, 0.93, 3.47, 1.94, 
## -0.12, -3.26, 2.3, 0.48, -0.11, 1.73, 0.74, 0.92, 3.22, 1.19, 
## 2.32, 0.06, 1.16, 3.17, -3.01, -0.33, 0.02), Y_pois = c(1L, 4L, 
## 3L, 2L, 0L, 2L, 0L, 1L, 0L, 1L, 13L, 1L, 3L, 7L, 2L, 0L, 0L, 
## 5L, 0L, 10L, 50L, 0L, 7L, 1L, 6L, 4L, 0L, 0L, 2L, 2L, 1L, 28L, 
## 3L, 14L, 0L, 2L, 3L, 0L, 2L, 11L, 5L, 0L, 0L, 1L, 1L, 9L, 6L, 
## 0L, 3L, 2L, 3L, 63L, 4L, 13L, 0L, 0L, 14L, 5L, 3L, 2L, 7L, 2L, 
## 2L, 5L, 3L, 1L, 3L, 1L, 2L, 1L, 0L, 0L, 5L, 4L, 1L, 18L, 1L, 
## 4L, 0L, 6L, 4L, 29L, 7L, 3L, 0L, 9L, 1L, 0L, 9L, 0L, 4L, 28L, 
## 4L, 8L, 1L, 3L, 21L, 0L, 0L, 1L), trials = c(10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
## 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
## ), Y_binom = c(2L, 10L, 9L, 7L, 6L, 2L, 6L, 9L, 3L, 4L, 9L, 9L, 
## 7L, 9L, 8L, 6L, 6L, 5L, 6L, 8L, 10L, 3L, 7L, 0L, 10L, 8L, 4L, 
## 3L, 10L, 6L, 6L, 10L, 6L, 10L, 3L, 7L, 8L, 5L, 1L, 8L, 7L, 2L, 
## 6L, 6L, 2L, 10L, 10L, 5L, 8L, 8L, 8L, 10L, 8L, 10L, 5L, 6L, 10L, 
## 9L, 3L, 7L, 8L, 7L, 4L, 9L, 6L, 0L, 8L, 3L, 5L, 5L, 6L, 0L, 10L, 
## 9L, 7L, 10L, 6L, 5L, 6L, 8L, 8L, 9L, 10L, 6L, 0L, 10L, 5L, 6L, 
## 8L, 7L, 7L, 10L, 7L, 10L, 5L, 10L, 10L, 1L, 5L, 6L)), class = "data.frame", .Names = c("x.easting", 
## "x.northing", "Y_normal", "Y_pois", "trials", "Y_binom"), row.names = c(NA, 
## -100L))
{% endhighlight %}
