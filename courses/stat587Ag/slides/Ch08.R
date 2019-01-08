
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(abd)


## ----echo=FALSE, out.width='0.8\\textwidth'------------------------------
set.seed(20141018)
x = rnorm(100)
hist(x, freq=F, main="Normal data", ylim=c(0,dnorm(0)))
curve(dnorm, add=TRUE, lwd=2)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------

n = 1000
x = rnorm(n)
opar = par(mfrow=c(1,3))
for (i in c(10,100,1000)) { 
  qqnorm(x[1:i], main=paste("n=",i))
  qqline(x[1:i]) 
}
par(opar)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_normal_qqplots = function(n) {
  opar = par(mfrow=c(2,5), mar=rep(0,4)+.5)
  for (i in 1:10) {
    qqnorm(rnorm(n), main='', xlab="", ylab="", axes=FALSE, frame=TRUE)
    qqline(x)
  }
  par(opar)
}

my_normal_qqplots(10)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_normal_qqplots(100)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_normal_qqplots(100)


## ----echo=FALSE----------------------------------------------------------
my_qqplots = function(n) {
  x = rnorm(n)
  
  opar = par(mfrow=c(2,3), mar=c(0,0,4,0)+.5)
  qqnorm(x, main="normal", axes=FALSE, frame=TRUE); qqline(x)
  qqnorm(exp(x), main="right-skewed", xlab="", ylab="", axes=FALSE, frame=TRUE); qqline(exp(x))
  qqnorm(55-exp(x), main="left-skewed", xlab="", ylab="", axes=FALSE, frame=TRUE); qqline(55-exp(x))
  plot(0,0,type='n', axes=FALSE, xlab='', ylab='')
  qqnorm(y <- runif(n), main="light-tailed", xlab="", ylab="", axes=FALSE, frame=TRUE); qqline(y)
  qqnorm(y <- rt(n,5), main="heavy-tailed", xlab="", ylab="", axes=FALSE, frame=TRUE); qqline(y)
  par(opar)
}


my_qqplots(10)


## ----echo=FALSE----------------------------------------------------------
my_qqplots(100)


## ----echo=FALSE----------------------------------------------------------
my_qqplots(1000)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------

par(mfrow=c(1,3), mar=c(5,4,4,2)+.1)
for (n in c(10,100,1000)) { 
  plot(runif(n), rnorm(n), axes=FALSE, frame=TRUE, xlab="Predicted mean", ylab="Residual")
}


## ----echo=FALSE, out.width='0.8\\textwidth'------------------------------

par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)
n = 1000
plot(runif(n), rnorm(n), axes=FALSE, frame=TRUE, xlab="Predicted mean", ylab="Residual")
xx = (1:4)/5
yy = 2.5
arrows(xx, -yy, xx, yy, col="red", lwd=2, code = 3)
abline(h=0, col="blue")


## ----echo=FALSE, out.width='0.8\\textwidth'------------------------------

opar = par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)
n = 1000
ub = 1
x = runif(n,0, ub)
e = rnorm(n,0,x)
plot(x, e, axes=FALSE, frame=TRUE, xlab="Predicted mean", ylab="Residual")

# par = opar on next slide


## ----echo=FALSE, out.width='0.8\\textwidth'------------------------------
plot(x, e, axes=FALSE, frame=TRUE, xlab="Predicted mean", ylab="Residual")
xx = ub*(1:4)/5
yy = ub*(.5+(1:4))/2
arrows(xx, -yy, xx, yy, col="red", lwd=2, code = 3)
abline(h=0, col="blue")
par(opar)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_nonconstant_variance_plots = function(n) {
  opar = par(mfrow=c(2,5), mar=rep(0,4)+.5)
  lb = 1
  ub = 4
  for (i in 1:10) {
    x = runif(n, lb, ub)
    e = rnorm(n,0,x)
    plot(x, e, axes=FALSE, frame=TRUE, xlab="", ylab="") 
  }
  par = opar
}

my_nonconstant_variance_plots(10)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_nonconstant_variance_plots(100)


## ----echo=FALSE, fig.width=8, out.width='0.8\\textwidth'-----------------
my_nonconstant_variance_plots(1000)


## ----echo=FALSE, out.width='0.8\\textwidth'------------------------------

par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)
n = 1000
ub = 1
x = runif(n, -1, 1)
e = rnorm(n,0, 1-abs(x))
plot(x, e, axes=FALSE, frame=TRUE, xlab="Predicted mean", ylab="Residual")


## ----echo=FALSE, out.width='0.7\\textwidth'------------------------------
my_lack_of_independence_plots = function(d) {
  m = lm(y~x, d)
  d$r = residuals(m)
  opar = par(mfrow=c(2,2), mar=c(5,4,0,2)+.1)
  plot(y~x, d, xlab="Explanatory variable", ylab="Response")
  plot(y~i, d, xlab="Observation number", ylab="Response")
  plot(x~i, d, xlab="Observation number", ylab="Explanatory variable")
  plot(r~i, d, xlab="Observation number", ylab="Residual")
  par(opar)
}

n = 100
d = data.frame(i = 1:n, 
               x = rnorm(n))
d$y = with(d, rnorm(n,3*x))
my_lack_of_independence_plots(d)


## ----echo=FALSE, out.width='0.7\\textwidth'------------------------------
d$y = with(d, rnorm(n, 3*x+i/20))
my_lack_of_independence_plots(d)


## ----echo=FALSE----------------------------------------------------------
n = 100
set.seed(1) 
x = runif(n,0,10)
e = rnorm(n)
y = x+e

myplot = function(x,y,main="") {
  plot(x,y,axes=FALSE, frame=TRUE, main=main)
}

par(mfrow=c(2,4), mar=c(0,0,4,0)+.5)
myplot(x, y)
myplot(x, exp(y))
myplot(exp(x), y)
myplot(exp(x), exp(y))
myplot(x, y)
myplot(x, y, "log(y)")
myplot(x, y, "log(x)")
myplot(x, y, "log(x), log(y)")


## ----echo=FALSE----------------------------------------------------------
ggplot(Telomeres, aes(factor(years), telomere.length))+
  geom_boxplot()+
  geom_jitter()+
  labs(x="Years", y="Telomere length", 
       title="Telomere length vs years since diagnosis")


## ----echo=FALSE----------------------------------------------------------
ggplot(Telomeres, aes(years, telomere.length))+
  geom_jitter()+
  geom_smooth(method=lm, se=FALSE)+
  labs(x="Years", y="Telomere length", 
       title="Telomere length vs years since diagnosis")


## ------------------------------------------------------------------------
# Use as.factor to turn a continuous variable into a categorical variable
m_anova = lm(telomere.length ~ as.factor(years), Telomeres) 
m_reg   = lm(telomere.length ~           years , Telomeres)
anova(m_reg, m_anova)


## ----echo=FALSE, fig.width=8, fig.height=7, out.width='0.75\\textwidth'----
m = lm(sqrt(Time)~Voltage, case0802)
opar = par(mfrow=c(2,3))
plot(m, which=1:6)
par(opar)


