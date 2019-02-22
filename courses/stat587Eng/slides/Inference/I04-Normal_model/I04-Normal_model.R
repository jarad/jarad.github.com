## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
library("tidyverse")
library("MCMCpack") # for dinvgamma function

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(20190222)

## ------------------------------------------------------------------------
n <- 9
d <- data.frame(farm = paste0("farm",1:n), yield = rnorm(n, 200, 25))
write_csv(d, path="yield.csv")

## ----echo=TRUE-----------------------------------------------------------
d <- read.csv("yield.csv")
names(d)
(n <- length(d$yield))
(ybar <- mean(d$yield))
(s <- sd(d$yield))

## ----t_distribution, fig.height=4.5, warning=FALSE-----------------------
dtms = function(x,v,m=0,s=1) dt((x-m)/s,v)/s

d = expand.grid(v=10^(0:2), t = seq(-3,6,by=.1)) %>%
  mutate(density = dtms(t,v),
         v = factor(v))

ggplot(d, aes(x=t,y=density, group=v, linetype=v, color=v)) +
  geom_line() +
  theme(legend.position='bottom') +
  theme_bw()

## ----mu_ci, dependson="data", echo=TRUE----------------------------------
ybar + c(-1,1)*qt(.975, df=n-1)*s/sqrt(n)

## ----echo=TRUE-----------------------------------------------------------
pt((200-ybar)/(s/sqrt(n)), df = n-1)

## ----echo=TRUE-----------------------------------------------------------
pt((200-ybar)/(s/sqrt(n)), df = n-1) - pt((180-ybar)/(s/sqrt(n)), df = n-1)
diff(pt((c(180,200)-ybar)/(s/sqrt(n)), df = n-1))

## ----ig_distribution, fig.height=4.5, warning=FALSE----------------------
d = expand.grid(y = seq(0,10,by=0.1),
                a = 1:4,
                b = 1:4) %>%
  mutate(density = MCMCpack::dinvgamma(y, shape = a, scale = b),
         af = paste("a=",a), 
         bf = paste("b=",b))

ggplot(d, aes(x = y, y = density)) +
  geom_line() +
  facet_grid(af~bf) +
  theme_bw()

## ----qinvgamma, echo=TRUE------------------------------------------------
qinvgamma <- function(p, shape, scale = 1) {
  1/qgamma(1-p, shape = shape, rate = scale)
}

## ----echo=TRUE-----------------------------------------------------------
a <- 0.2
qinvgamma(c(a/2,1-a/2), shape = (n-1)/2, scale = (n-1)*s^2/2)

## ----pinvgamma, echo=TRUE------------------------------------------------
pinvgamma <- function(q, shape, scale = 1) {
  1-pgamma(1/q, shape = shape, rate = scale)
}

## ----echo=TRUE-----------------------------------------------------------
pinvgamma(190, shape = (n-1)/2, scale = (n-1)*s^2/2)

## ----echo=TRUE-----------------------------------------------------------
diff(pinvgamma(c(170,190), shape = (n-1)/2, scale = (n-1)*s^2/2))

## ----echo=TRUE-----------------------------------------------------------
a <- 0.2
ci_variance = qinvgamma(c(a/2,1-a/2), shape = (n-1)/2, scale = (n-1)*s^2/2)
sqrt(ci_variance)

## ----echo=TRUE-----------------------------------------------------------
pinvgamma(20^2, shape = (n-1)/2, scale = (n-1)*s^2/2)

## ----echo=TRUE-----------------------------------------------------------
diff(pinvgamma(c(20,25)^2, shape = (n-1)/2, scale = (n-1)*s^2/2))

## ----echo=TRUE-----------------------------------------------------------
sigma2 <- MCMCpack::rinvgamma(1e5, shape = (n-1)/2, scale = (n-1)*s^2/2)
c(mean(sigma2), (n-1)*s^2/(n-3)) # estimate first, truth second
mean(sqrt(sigma2))               # only have an estimate

