## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----binomial-data----------------------------------------------------------------------------------------------------
n = 13
y = 3
p = 0.5


## ----binomial-extreme-regions-----------------------------------------------------------------------------------------
d <- data.frame(Y = 0:n) %>%
  dplyr::mutate(pmf = dbinom(Y, n, 0.5),
         outside = ifelse(abs(Y-n*0.5) >= abs(y-n*0.5),
                                     "Yes","No"),
         less_than = ifelse(abs(Y <= y), "Yes", "No"),
         greater_than = ifelse(abs(Y >= y), "Yes", "No")) %>%
  tidyr::gather("region", "fill", -Y, -pmf) %>%
  dplyr::mutate(region = factor(region, levels = c("less_than","outside","greater_than")))

ggplot(d, aes(Y, pmf, fill = fill)) + 
  geom_bar(stat = "identity", color = "black") + 
  facet_grid(.~region) +
  theme_bw() + 
  theme(legend.position="bottom") +
  scale_fill_manual(values = c("Yes" = "magenta", "No" = "white")) +
  labs(title = "As or more extreme regions for Y ~ Bin(13,0.5) with y = 3",
       y = "Probability mass function")


## ----binomial-lower-extreme, echo=TRUE--------------------------------------------------------------------------------
pbinom(y, size = n, prob = p)


## ----binomial-upper-extreme, echo=TRUE--------------------------------------------------------------------------------
1 - pbinom(y - 1, size = n, prob = p)


## ----binomial-two-sided-extreme, echo=TRUE----------------------------------------------------------------------------
2 * pbinom(y, size = n, prob = p)


## ----normal-data------------------------------------------------------------------------------------------------------
# Population parameters
mu    <- 3
sigma <- 4

# Data summary statistics
n    <- 6
ybar <- 6.3
s    <- 4.1

# T statistic
t <- (ybar - mu) / (s / sqrt(n))


## ----normal-extreme-regions-------------------------------------------------------------------------------------------
t_ribbon <- data.frame(T = seq(-5, 5, length = 1001), ymin = 0) %>%
  dplyr::mutate(pdf = dt(T, df = n-1))
  
d <- bind_rows(
  t_ribbon %>% filter(T >= t) %>% mutate(region = "less_than"),
  t_ribbon %>% filter(T <= t) %>% mutate(region = "greater_than"),
  t_ribbon %>% filter(abs(T) <= abs(t)) %>% mutate(region = "outside")) %>%
  mutate(region = factor(region, levels = c("less_than","outside","greater_than")))

ggplot(d, aes(x = T, ymin = ymin, ymax = pdf)) + 
  stat_function(fun = dt, args = list(df = n-1), geom = "area", fill = "aquamarine") +
  geom_ribbon(fill = "white") +
  stat_function(fun = dt, args = list(df = n-1)) +
  facet_grid(.~region) +
  theme_bw() + 
  # scale_fill_manual(values = c("Yes" = "red", "No" = "white")) +
  labs(title = paste("As or more extreme regions for t =",round(t,2),"with",
                     n-1,"degrees of freedom"),
       y = "Probability density function")


## ----normal-lower, echo=TRUE------------------------------------------------------------------------------------------
pt(t, df = n-1)


## ----normal-upper,echo=TRUE-------------------------------------------------------------------------------------------
1 - pt(t, df = n-1)


## ----normal-two-sided,echo=TRUE---------------------------------------------------------------------------------------
2 * (1 - pt(t, df = n-1))

