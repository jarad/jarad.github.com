## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
library("dplyr")
library("ggplot2")
library("gridExtra")

## ----set_seed------------------------------------------------------------
set.seed(2)

## ----quantiles, fig.height=4, echo=TRUE----------------------------------
curve(expr = dnorm, from = -3, to = 3, ylab = "f(x)")
quantiles = c(.025,.16,.84,.975)
abline(v = qnorm(p = quantiles)) # default is standard normal

## ----sample_quantiles, dependson='quantiles', fig.height=4, echo=TRUE----
n = 1000
sample = rnorm(n)
hist(x = sample, breaks = 101, probability = TRUE, border = "gray", col = "gray")
curve(expr = dnorm, from = -3, to = 3, ylab = "f(x)", col = "black", add = TRUE)
abline(v = qnorm(p = quantiles), col = "black")
abline(v = quantile(sample, prob = quantiles), col = "gray")
legend("topright", c("sample","population"), lty=1, col=c("gray","black"))

