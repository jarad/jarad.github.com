
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(reshape2)


## ----echo=FALSE----------------------------------------------------------
tmp = read.csv("Ch10a-potato_means.csv")
tmp$site = factor(tmp$site, labels=paste("Site",1:4))

# Simulate data
set.seed(1)

sim = function(x) {
  x = x[rep(1,4),]
  x$yield = round(rnorm(4,mean(x$mean.yield)),1)
  x
}
d = ddply(tmp, .(site,year,irrigated,N.rate), sim)
d$site = factor(d$site)


## ----echo=FALSE----------------------------------------------------------
head(d[,c("yield", "N.rate", "irrigated", "site")],25)


## ----echo=FALSE----------------------------------------------------------
p2 <- ggplot(d, aes(x=N.rate, y=yield, shape=irrigated, color=irrigated)) +
     geom_point() +
     facet_wrap(~site)
print(p2)


## ----echo=FALSE----------------------------------------------------------
p2+geom_smooth(method="lm", formula=y~poly(x,2), se=FALSE)


## ------------------------------------------------------------------------
p <- ggplot(d, aes(x=N.rate, y=yield))+
     geom_point(aes(shape=irrigated, color=irrigated))+
     facet_wrap(~site)
m = lm(yield~N.rate, d)
d2 = data.frame(N.rate = 0:250)
d2$yield = predict(m,d2)
p+geom_line(aes(x=N.rate, y=yield), d2)


## ----echo=FALSE----------------------------------------------------------
m = lm(yield~N.rate+irrigated, d)
d2 = expand.grid(N.rate=0:250, irrigated=c("yes","no"))
d2$yield = predict(m,d2)
p+geom_line(aes(x=N.rate, y=yield, color=irrigated), d2)


## ----echo=FALSE----------------------------------------------------------
m = lm(yield~N.rate+irrigated+site, d)
d2 = expand.grid(N.rate=0:250, irrigated=c("yes","no"), site=paste("Site",1:4))
d2$yield = predict(m,d2)
p + geom_line(aes(x=N.rate, y=yield, color=irrigated), d2)


## ----echo=FALSE----------------------------------------------------------
m = lm(yield~N.rate+irrigated*site, d)
d2 = expand.grid(N.rate=0:250, irrigated=c("yes","no"), site=paste("Site",1:4))
d2$yield = predict(m,d2)
p + geom_line(aes(x=N.rate, y=yield, color=irrigated), d2)


## ----echo=FALSE----------------------------------------------------------
p2+geom_smooth(method="lm", se=FALSE)


## ----echo=FALSE----------------------------------------------------------
p2+geom_smooth(method="lm", formula=y~poly(x,2), se=FALSE)


