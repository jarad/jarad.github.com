## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20200915)


## ---------------------------------------------------------------------------------------------------------------------
d <- expand.grid(shape = c(0.5,1,2),
                 rate = c(0.5,1,2), 
                 x = seq(0, 4, length = 101)) %>%
  dplyr::mutate(pdf = dgamma(x, shape = shape, rate = rate),
                cdf = pgamma(x, shape = shape, rate = rate),
                shaperate = paste0(shape, rate),
                shape = paste("shape =", shape),
                rate  = paste("rate = ", rate))

ggplot(d, aes(x=x, y = pdf)) +
  geom_line() + 
  labs(y = "Probablity density function, f(x)",
       title = "Gamma random variables") +
  facet_grid(shape~rate, scales = "free_y") + 
  theme_bw()


## ---------------------------------------------------------------------------------------------------------------------
ggplot(d, aes(x=x, y = cdf)) +
  geom_line() + 
  labs(y = "Cumulative distribution function, F(x)",
       title = "Gamma random variables") +
  facet_grid(shape~rate, scales = "free_y") + 
  theme_bw()

