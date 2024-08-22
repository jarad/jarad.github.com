## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20200915)


## ---------------------------------------------------------------------------------------------------------------------
d <- expand.grid(rate = c(0.5,1,2), 
                 x = seq(0, 4, length = 101)) %>%
  dplyr::mutate(pdf = dexp(x, rate = rate),
                cdf = pexp(x, rate = rate),
                rate = as.character(rate))

ggplot(d, aes(x=x, y = pdf, group = rate, color = rate, linetype = rate)) +
  geom_line() + 
  labs(y = "Probablity density function, f(x)",
       title = "Exponential random variables") +
  theme_bw()


## ---------------------------------------------------------------------------------------------------------------------
ggplot(d, aes(x=x, y = cdf, group = rate, color = rate, linetype = rate)) +
  geom_line() + 
  labs(y = "Cumulative distribution function, F(x)",
       title = "Exponential random variables") +
  theme_bw()

