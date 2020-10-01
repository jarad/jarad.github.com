## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ---------------------------------------------------------------------------------------------------------------------
n = 13
y = 6
theta0 = 0.5


## ---------------------------------------------------------------------------------------------------------------------
y = 2


## ---------------------------------------------------------------------------------------------------------------------
n = 13000
y = 6500


## ---------------------------------------------------------------------------------------------------------------------
n = 13
y = 2

d = data.frame(Y = 0:n) %>%
  dplyr::mutate(pmf = dbinom(Y, n, theta0),
         `not equal`= ifelse(abs(Y-n*theta0) >= abs(y-n*theta0),
                                     "Yes","No"),
         `less than` = ifelse(abs(Y <= y), "Yes", "No"),
         `greater than` = ifelse(abs(Y >= y), "Yes", "No")) %>%
  tidyr::gather("region", "fill", -Y, -pmf) %>%
  dplyr::mutate(region = factor(region, levels = c("less than","not equal","greater than")))

ggplot(d, aes(Y, pmf, fill = fill)) + 
  geom_bar(stat = "identity", color = "black") + 
  facet_grid(.~region) +
  theme_bw() + 
  theme(legend.position="none") +
  scale_fill_manual(values = c("Yes" = "magenta", "No" = "white")) +
  labs(title = paste0("As or more extreme regions for Y ~ Bin(",n,",",theta0,") with y = ",y),
       y = "Probability mass function")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
pbinom(y, size = n, prob = theta0)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
1-pbinom(y-1, size = n, prob = theta0)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
2*pbinom(y, size = n, prob = theta0)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
binom.test(y, n, p = theta0, alternative = "less")$p.value


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
binom.test(y, n, p = theta0, alternative = "greater")$p.value


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
binom.test(y, n, p = theta0, alternative = "two.sided")$p.value


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
binom.test(3, 6, p = 1/6, alternative = "greater")$p.value

