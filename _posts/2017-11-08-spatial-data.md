---
layout: post
title: "Simulating spatial data"
description: ""
category: [Teaching]
tags: [spatial,data,simulation,STAT615]
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
## R version 3.4.0 (2017-04-21)
## Platform: x86_64-redhat-linux-gnu (64-bit)
## Running under: Red Hat Enterprise Linux Workstation 7.3 (Maipo)
## 
## Matrix products: default
## BLAS/LAPACK: /usr/lib64/R/lib/libRblas.so
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] hglm_2.1-1      hglm.data_1.0-0 Matrix_1.2-10   knitr_1.17     
##  [5] bindrcpp_0.2    ggplot2_2.2.1   dplyr_0.7.4     CARBayes_5.0   
##  [9] Rcpp_0.12.13    MASS_7.3-47    
## 
## loaded via a namespace (and not attached):
##  [1] gtools_3.5.0       spam_2.1-1         splines_3.4.0     
##  [4] lattice_0.20-35    colorspace_1.3-2   expm_0.999-2      
##  [7] htmltools_0.3.6    yaml_2.1.14        MCMCpack_1.4-0    
## [10] rlang_0.1.2        foreign_0.8-69     glue_1.1.1        
## [13] sp_1.2-5           bindr_0.1          plyr_1.8.4        
## [16] stringr_1.2.0      MatrixModels_0.4-1 dotCall64_0.9-04  
## [19] CARBayesdata_2.0   munsell_0.4.3      gtable_0.2.0      
## [22] coda_0.19-1        evaluate_0.10.1    labeling_0.3      
## [25] SparseM_1.77       quantreg_5.33      spdep_0.6-13      
## [28] highr_0.6          backports_1.1.0    scales_0.4.1      
## [31] gdata_2.18.0       truncnorm_1.0-7    deldir_0.1-14     
## [34] mcmc_0.9-5         digest_0.6.12      stringi_1.1.5     
## [37] gmodels_2.16.2     rprojroot_1.2      grid_3.4.0        
## [40] tools_3.4.0        LearnBayes_2.15    magrittr_1.5      
## [43] lazyeval_0.2.0     tibble_1.3.4       pkgconfig_2.0.1   
## [46] shapefiles_0.7     matrixcalc_1.0-3   assertthat_0.2.0  
## [49] rmarkdown_1.6      R6_2.2.2           boot_1.3-20       
## [52] nlme_3.1-131       compiler_3.4.0
{% endhighlight %}

Construct spatial lattice.


{% highlight r %}
Grid <- expand.grid(x.easting = 1:10, x.northing = 1:10)
n <- nrow(Grid)
{% endhighlight %}


Simulate data


{% highlight r %}
# Explanatory variables and coefficients
x1 <- rnorm(n) %>% round(2)
x2 <- rnorm(n) %>% round(2)

# Spatial field
distance <- as.matrix(dist(Grid))
omega <- MASS::mvrnorm(n     = 1, 
                       mu    = rep(0,n), 
                       Sigma = 0.4 * exp(-0.1 * distance))

eta <- x1 + x2 + omega

d <- Grid %>% 
  mutate(Y_normal = rnorm(n, eta, sd = 0.1) %>% round(2),
         Y_pois   = rpois(n, exp(eta)),
         trials   = 10,
         Y_binom  = rbinom(n = n, size = trials, prob = 1/(1+exp(-eta))),
         x1       = x1,
         x2       = x2)
{% endhighlight %}

Normal data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_normal)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-spatial-data/normal_data-1.png)

Poisson data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_pois)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-spatial-data/poisson_data-1.png)

Binomial data


{% highlight r %}
ggplot(d, aes(x = x.easting, y = x.northing, fill = Y_binom/trials)) + 
  geom_raster() +
  theme_bw()
{% endhighlight %}

![center](/../figs/2017-11-08-spatial-data/binomial_data-1.png)

For use in future posts.


{% highlight r %}
save(d, file="data/spatial20171108.rda")
{% endhighlight %}

