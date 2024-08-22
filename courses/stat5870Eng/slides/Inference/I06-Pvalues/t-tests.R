## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ---------------------------------------------------------------------------------------------------------------------
mu = 3
sigma = 4

n = 6
ybar = 6.3
s = 4.1
y = rnorm(n)*s + ybar

t = (ybar - mu)/(s/sqrt(n))
mu0 = 3


## ---------------------------------------------------------------------------------------------------------------------
t_ribbon = data.frame(T = seq(-5, 5, length = 1001), ymin = 0) %>%
  dplyr::mutate(pdf = dt(T, df = n-1))
  
d = bind_rows(
  t_ribbon %>% filter(T >= t) %>% mutate(region = "less than"),
  t_ribbon %>% filter(T <= t) %>% mutate(region = "greater than"),
  t_ribbon %>% filter(abs(T) <= abs(t)) %>% mutate(region = "not equal")) %>%
  mutate(region = factor(region, levels = c("less than","not equal","greater than")))

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


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(y, mu = mu0, alternative = "less")$p.value


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(y, mu = mu0, alternative = "greater")$p.value


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(y, mu = mu0, alternative = "two.sided")$p.value


## ---------------------------------------------------------------------------------------------------------------------
set.seed(20200929)
y = round(rnorm(12, mean = 12.06, sd = 0.1), 2)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
y


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(y, mu = 12)

