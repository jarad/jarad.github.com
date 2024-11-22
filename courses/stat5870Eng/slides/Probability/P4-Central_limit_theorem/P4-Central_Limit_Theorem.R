## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----out.width = "0.8\\textwidth"-------------------------------------------------------------------------------------
d <- data.frame(x = seq(-3, 3, by = 0.01)) %>%
  dplyr::mutate(pdf = dnorm(x))

ggplot(d, aes(x = x, y = pdf)) +
  geom_line(linewidth = 2) +
  theme_bw() +
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()) +
  labs(title = "Bell-shaped curve", x = "Value",
       y = "Probability density function")


## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(rep = 1:4, samples = rnorm(4*1e3))

ggplot(d, aes(x = samples)) +
  geom_histogram(bins = 50) +
  facet_wrap(~rep) +
  theme_bw() +
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()) +
  labs(title = "Histograms of 1,000 standard normal random variables",
       x = "Value", y = "Number")



## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(rep = 1:4, samples = rnorm(4*20))

ggplot(d, aes(x = samples)) +
  geom_histogram(bins = 20) +
  facet_wrap(~rep) +
  theme_bw() +
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()) +
  labs(title = "Histograms of 20 standard normal random variables",
       x = "Value", y = "Number")



## ----averages_of_uniforms, echo = FALSE, eval = FALSE, fig.height=4, out.width="\\textwidth"--------------------------
## n_sims <- 10000; n_obs  <- 1000
## d <- data.frame(rep = rep(1:n_sims, each = n_obs),
##                 x   = runif(n_sims * n_obs)) %>%
##   group_by(rep) %>%
##   summarize(mean = mean(x),
##             sum  = sum(x))
## 
## hist(d$mean, 50, probability = TRUE)
## curve(dnorm(x, mean = 1/2, sqrt(1/12/n_obs)), add = TRUE, col = "red")


## ---------------------------------------------------------------------------------------------------------------------
n_sims <- 10000; n_obs  <- 1000
d <- data.frame(rep = rep(1:n_sims, each = n_obs),
                x   = runif(n_sims * n_obs)) %>%
  group_by(rep) %>%
  summarize(mean = mean(x),
            sum  = sum(x))

hist(d$mean, 50, probability = TRUE)
curve(dnorm(x, mean = 1/2, sqrt(1/12/n_obs)), add = TRUE, col = "red")


## ----echo = FALSE-----------------------------------------------------------------------------------------------------
hist(d$sum,  50, probability = TRUE)
curve(dnorm(x, mean = n_obs/2, sqrt(n_obs/12)), add = TRUE, col = "red")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n <- 99
p <- 19/39
1 - pbinom(49, n, p)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
1 - pnorm(50, n * p, sqrt( n * p * (1 - p) ) )


## ----echo = TRUE------------------------------------------------------------------------------------------------------
diff(pnorm( c(-1.37, 1.37) ))


## ----echo = TRUE------------------------------------------------------------------------------------------------------
1 - 2 * pnorm(-1.96)

