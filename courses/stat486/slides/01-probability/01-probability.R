## ----setup, include=FALSE, perl=FALSE----------------------
knitr::opts_chunk$set(echo = TRUE)


## ----------------------------------------------------------
d <- data.frame(sum = 2:12, probability = c(1:6,5:1)/36)
plot(probability ~ sum, data = d)


## ----------------------------------------------------------
3/51


## ----normal_density----------------------------------------
curve(dnorm, -3, 3)

