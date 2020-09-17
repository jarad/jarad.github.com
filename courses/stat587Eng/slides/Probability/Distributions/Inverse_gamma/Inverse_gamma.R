## ----libraries, message=FALSE, warning=FALSE, cache=FALSE---------------------------
library("tidyverse")
library("MCMCpack")
pinvgamma <- function(x, shape, scale = 1) {
  exp(lgamma(shape, scale/x)-lgamma(shape))
}


## ----set_seed, echo=FALSE-----------------------------------------------------------
set.seed(20200915)


## -----------------------------------------------------------------------------------
d <- expand.grid(shape = c(0.5,1,2),
                 scale = c(0.5,1,2), 
                 x = seq(0.01, 4, length = 101)) %>%
  dplyr::mutate(pdf = dgamma(1/x, shape = shape, rate = scale)/x,
                # cdf = pinvgamma(x, shape = shape, scale = scale),
                shapescale = paste0(shape, scale),
                shape = paste("shape =", shape),
                scale  = paste("scale = ", scale))

ggplot(d, aes(x=x, y = pdf)) +
  geom_line() + 
  labs(y = "Probablity density function, f(x)",
       title = "Inverse gamma random variables") +
  facet_grid(shape~scale, scales = "free_y") + 
  theme_bw()

