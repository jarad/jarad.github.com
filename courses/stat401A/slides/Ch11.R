
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, 
               fig.width=6, fig.height=5, 
               size='tiny', 
               out.width='0.8\\textwidth', 
               fig.align='center', 
               message=FALSE,
               echo=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(reshape2)


## ------------------------------------------------------------------------
set.seed(2)
n = 20
x = runif(n)
y = rnorm(n,x,0.1)
x[n] = y[n] = 0.5

pcc = c(rep(19,n-1),1)
clr = ifelse(pcc==1, "red","black")

lm = c(-0.5,1.5)
plot.f = function(x,y,xlb,ylb, xlm=lm, ylm=lm) {
  plot(y~x, pch=pcc, ylab="", xlab="", axes=F, 
         frame=T, xlim=xlm, ylim=ylm)
	title(xlab=xlb, ylab=ylb, line=1, cex.lab=2)
	mod <- lm(y~x)
	abline(mod, col="black", lwd=2)
	tmp = round(influence.measures(mod)$infmat[,5:6],2)
	legend("bottomright",
           c(paste("Leverage=",tmp[n,2]),
             paste("Cook's D=",tmp[n,1])))
	
	mod <- lm(y[-n]~x[-n])
	abline(mod, col="red", lwd=2, lty=2)
}

par(mfcol=c(2,2), mar=c(4,3,0,0))
plot.f(x,y,"","Low influence")
y.old = y[n]; y[n] = y[n]+1
plot.f(x,y,"Low leverage","High influence")
x[n] = x[n]-1; y[n] = x[n]
plot.f(x,y,"","")
y[n] = y.old
plot.f(x,y,"High leverage","")


## ----fig.width=8, out.width='\\textwidth'--------------------------------
mod = lm(SAT~log(Takers)+Rank, case1201)
case1201m = mutate(case1201, 
                   "Case number" = 1:nrow(case1201),
                   Residuals=residuals(mod),
                   "Studentized residuals" = rstandard(mod),
                   "Externally studentized residuals" = rstudent(mod))

m = melt(case1201m[,9:12], 
         variable.name="residual", 
         id.vars="Case number")

ggplot(m, aes(x=`Case number`, y=`value`)) +
  geom_point() + 
  facet_wrap(~residual, scales='free')


## ----echo=TRUE-----------------------------------------------------------
mod = lm(SAT~log(Takers)+Rank, case1201)
opar = par(mfrow=c(2,3)); plot(mod, 1:6, ask=FALSE); par(opar)


