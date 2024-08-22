## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-----------------------------------------------
library(tidyverse)
library(gridExtra)


## ----set_seed-------------------------------------------------------------------------------------------
set.seed(2)


## ----dragonwood, echo=TRUE, tidy=FALSE------------------------------------------------------------------
# Three dice
die   = c(1,2,2,3,3,4)
rolls = expand.grid(die1 = die, die2 = die, die3 = die)
sum   = rowSums(rolls); tsum = table(sum)
dragonwood3 = data.frame(x   = round(as.numeric(names(tsum)),0),
                         pmf = round(as.numeric(table(sum)/length(sum)),3)) %>%
	mutate(cdf = cumsum(pmf))

t(dragonwood3)


## ----dragonwood_plots, dependson='dragonwood', fig.width=9----------------------------------------------
g_pmf = ggplot(dragonwood3, aes(x=x, y=pmf)) + 
	geom_point() + 
	scale_x_continuous(breaks=3:12) + 
	ylim(0,1) +
  theme_bw()

# set  up cdf plot
cdf = bind_rows(data.frame(x=2,pmf=0,cdf=0), dragonwood3) %>% 
	mutate(xend = c(x[-1],13))


g_cdf = ggplot(cdf, aes(x=x, y=cdf, xend=xend, yend=cdf)) +
	#      geom_vline(aes(xintercept=x), linetype=2, color="grey") +
	geom_point() +  # Solid points to left
	geom_point(aes(x=xend, y=cdf), shape=1) +  # Open points to right
	geom_segment() + 
	scale_x_continuous(breaks=3:12) +
	coord_cartesian(xlim=c(3,12)) +
  theme_bw()

grid.arrange(g_pmf,g_cdf, nrow=1)


## ----dragonwood_expectation, dependson='dragonwood', echo=TRUE------------------------------------------
expectation = with(dragonwood3, sum(x*pmf))
expectation


## ----dragonwood_center_of_gravity, dependson='dragonwood_expectation', fig.height=2---------------------
ggplot(dragonwood3 %>% mutate(y=0), aes(x=x, xend=x, y=y, yend=pmf)) + 
	geom_segment(size=2) + 
  geom_point(data = data.frame(x=7.5,y=-0.01,pmf=0), aes(x,y), shape=24, color='red', fill='red') + 
	scale_x_continuous(breaks=3:12) +
  theme_bw()


## ----biased_coin, fig.height=3, fig.width = 8, out.width = "0.6\\textwidth", fig.align="left"-----------
d = data.frame(x=c(0,1), pmf=c(0.1,0.9))

ggplot(d %>% mutate(y=0), aes(x=x, xend=x, y=y, yend=pmf)) + 
	geom_segment(size=2) + 
  geom_point(data = data.frame(x=0.9,y=-0.04,pmf=0), aes(x,y), shape=24, color='red', fill='red') + 
	scale_x_continuous(breaks=0:1) + 
	labs(x='y', y='pmf') + 
  theme_bw()


## ----dragonwood_variance, dependson='dragonwood_expectation', echo=TRUE---------------------------------
variance = with(dragonwood3, sum((x-expectation)^2*pmf))
variance


## ----dragonwood_standard_deviation, dependson='dragonwood_variance', echo=TRUE--------------------------
sqrt(variance)


## ----biased_coin_variance, fig.height=3, fig.width = 8, out.width="0.6\\textwidth", fig.align="left"----
opar = par(mar=c(4,4,1,0)+.1)
variance = function(p) p*(1-p)
curve(variance, xlab='y', ylab='variance')
par(opar)


## ----binomial_pmf---------------------------------------------------------------------------------------
n = 15
p = 0.05
d <- data.frame(x = 0:n) %>%
  dplyr::mutate(pmf = dbinom(x, n, p))

ggplot(d, aes(x, pmf, yend = 0, xend = x)) +
  geom_point() +
  geom_segment() +
  labs(title = paste("Binomial pmf with", n, "attempts and probability ", p),
        x = "Value", y="Probability mass function") +
  theme_bw()


## ----component_failure_rate,echo=TRUE-------------------------------------------------------------------
n <- 15
p <- 0.05
choose(15,2)
dbinom(2,n,p)           # P(Y=2)
pbinom(2,n,p)           # P(Y<=2)
1-pbinom(3,n,p)         # P(Y>3) 
sum(dbinom(c(2,3),n,p)) # P(1<Y<4) = P(Y=2)+P(Y=3)


## ----poisson_pmf----------------------------------------------------------------------------------------
lambda <- 10
n = 30
d <- data.frame(x = 0:n) %>%
  dplyr::mutate(pmf = dpois(x, lambda))

ggplot(d, aes(x, pmf, yend = 0, xend = x)) +
  geom_point() +
  geom_segment() +
  labs(title = paste("Poisson pmf with mean of", lambda),
        x = "Value", y="Probability mass function") +
  theme_bw()


## ----echo=TRUE------------------------------------------------------------------------------------------
# Using pmf
1-sum(dpois(0:8, lambda=10))
# Using cdf
1-ppois(8, lambda=10)


## ----echo=TRUE------------------------------------------------------------------------------------------
# Using pmf
1-sum(dpois(0:16, lambda=20))
# Using cdf
1-ppois(16, lambda=20)


## ----poisson_vs_binomial, fig.width=8-------------------------------------------------------------------
n = 5
p = 0.01
e = 0.01
d = data.frame(x = 0:n) %>%
  dplyr::mutate(binomial = dbinom(x, n, p),
                Poisson = dpois(x, n*p)) %>%
  tidyr::gather("Distribution","pmf", binomial, Poisson) %>%
  dplyr::mutate(x = x-e + 2*e*(Distribution == "Poisson"))

ggplot(d, aes(x=x, y = pmf, yend = 0, xend = x,
              color = Distribution, linetype = Distribution)) +
  geom_point() +
  geom_segment() +
  labs(title = "Poisson vs binomial", x = "Value", 
       y = "Probability mass function") +
  theme_bw()


## ----typo_binomial, echo=TRUE---------------------------------------------------------------------------
n = 1000; p = 0.002
dbinom(0, size=n, prob=p)


## ----typo_poisson, echo=TRUE, dependson='typo_binomial'-------------------------------------------------
dpois(0, lambda = n*p)

