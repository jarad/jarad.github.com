## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("dplyr")
library("ggplot2")
# library("gridExtra")


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----quantiles--------------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(-3, 3, by = 0.01)) %>%
  dplyr::mutate(y = dnorm(x))

quartiles = (1:3)/4
ggplot(d, aes(x=x,y=y)) + 
  geom_line() + 
  geom_vline(xintercept = qnorm(p = quartiles), 
             color = "slategray", linetype = "dashed") + 
  labs(y = "Probability density function, p(x)",
       title = "Standard normal") +
  theme_bw()

curve(expr = dnorm, from = -3, to = 3, ylab = "f(x)")


## ----sample_quantiles, dependson='quantiles'--------------------------------------------------------------------------
n = 1000
sample = data.frame(x=rnorm(n))
ggplot(sample, aes(x=x)) + 
  geom_histogram(aes(y=after_stat(density)), fill = "gray") + 
  geom_vline(xintercept = quantile(sample$x, prob = quartiles),
             color = "red") + 
  geom_vline(xintercept = qnorm(p = quartiles), 
             color = "slategray", linetype = "dashed") + 
  labs(title = "Standard normal samples") +
  theme_bw()

