## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
library("dplyr")
library("tidyr")
library("ggplot2")
library("MCMCpack") # for dinvgamma function

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----data, echo=TRUE-----------------------------------------------------
m <- 200
s <- 20
n <- 9
y <- rnorm(n, mean = m, sd = s)

## ----data_plot, echo=TRUE, fig.height=4, dependson="data"----------------
curve(dnorm(x, mean = mean(y), sd = s/sqrt(n)), mean(y)-3*s/sqrt(n), mean(y)+3*s/sqrt(n), 
      xlab = expression(mu),
      ylab = expression(paste("p(",mu,"|y)")),
      main = "Posterior")
abline(v=mean(y), col='red')

## ----echo=TRUE-----------------------------------------------------------
a <- .05
qnorm(c(a/2,1-a/2), mean(y), sd = s/sqrt(n))

## ----echo=TRUE, dependson="data"-----------------------------------------
mean(y) + c(-1,1)*qnorm(1-a/2)*s/sqrt(n)

## ----variance_posterior, echo=TRUE, fig.height=4, dependson="data"-------
S <- sum((y-m)^2)
curve(MCMCpack::dinvgamma(x, shape = n/2, scale = S/2), 0, 3*S/n,
      xlab = expression(sigma^2),
      ylab = expression(paste("p(",sigma^2,"|y)")),
      main = "Posterior")
abline(v = (S/2)/((n/2)-1), col='red')

## ----qinvgamma, echo=TRUE------------------------------------------------
qinvgamma <- function(p, shape, scale = 1) {
  1/qgamma(1-p, shape = shape, rate = scale)
}

## ----ci_for_variance, dependson=c("variance_posterior","qinvgamma","data")----
(q <- qinvgamma(c(.025,.975), shape = n/2, scale = S/2))

## ----echo=TRUE-----------------------------------------------------------
draws <- MCMCpack::rinvgamma(1e5, shape = n/2, scale = S/2)
quantile(draws, c(a/2, 1-a/2))

## ----variance_draws, echo=TRUE-------------------------------------------
draws <- 1/rgamma(1e5, shape = n/2, rate = S/2)
quantile( draws, c(a/2, 1-a/2))

## ----sd_posterior, echo=TRUE, fig.height=2.5, dependson="variance_draws"----
sqrt(q) # Take square root of end points of the CI for the variance
hist(sqrt(draws), 1001, xlab = expression(sigma), ylab = expression(paste("p(",sigma,"|y)")),
     main = "Posterior for standard deviation", probability = TRUE)
abline(v=sqrt(q), col="red")

## ----t_distribution, fig.height=4.5, warning=FALSE-----------------------
dtms = function(x,v,m=0,s=1) dt((x-m)/s,v)/s

d = expand.grid(v=10^(0:2), t = seq(-3,6,by=.1)) %>%
  mutate(density = dtms(t,v),
         v = factor(v))

ggplot(d, aes(x=t,y=density, group=v, linetype=v, color=v)) +
  geom_line() + 
  theme(legend.position='bottom') +
  theme_bw()

## ----echo=TRUE-----------------------------------------------------------
mean(y) + c(-1,1)*qt(.975, df=n-1)*sd(y)/sqrt(n)

## ----echo=TRUE-----------------------------------------------------------
a    <- 0.1

mean(y) +c(-1,1)*qt(1-a/2, df=n-1)*sd(y)/sqrt(n)

## ----echo=TRUE-----------------------------------------------------------
m = 200
C = 33^2
Cp = 1/(1/C+n/s^2)
mp = Cp*(m/C+n*mean(y)/s^2)

## ----echo=TRUE, fig.height=3.5-------------------------------------------
ybar = mean(y)
se = s/sqrt(n)
curve(dnorm(x, mean=ybar, sd=se), ybar-3*se, ybar+3*se,
      xlab=expression(mu),
      ylab=expression(paste("p(",mu,"|y)")),
      main="Default vs informative Bayesian analysis")
curve(dnorm(x, mean=mp, sd=sqrt(Cp)), col='red', lty=2, add=TRUE)
legend("topleft", c("Default","Informative"), col=c("black","red"),
       lty = 1:2)

