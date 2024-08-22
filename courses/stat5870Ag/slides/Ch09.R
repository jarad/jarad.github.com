
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(reshape2)


## ----echo=FALSE----------------------------------------------------------
source("multiplot.R")
g = ggplot(case1001, aes(x=Height, y=Distance)) + geom_point(size=3)
multiplot(
  g,
  g+stat_smooth(method="lm"),
  g+stat_smooth(method="lm", formula=y~x+I(x^2)),
  g+stat_smooth(method="lm", formula=y~x+I(x^2)+I(x^3)),
  layout = matrix(1:4,2,byrow=TRUE)
)


## ----tidy=FALSE----------------------------------------------------------
# Construct the variables by hand
case1001$Height2 = case1001$Height^2
case1001$Height3 = case1001$Height^3

m1 = lm(Distance~Height,                 case1001)
m2 = lm(Distance~Height+Height2,         case1001)
m3 = lm(Distance~Height+Height2+Height3, case1001)

coefficients(m1)
coefficients(m2)
coefficients(m3)


## ----tidy=FALSE----------------------------------------------------------
# Let R construct the variables for you
m = lm(Distance~poly(Height, 3, raw=TRUE), case1001)
summary(m)


## ----echo=FALSE----------------------------------------------------------
d = read.csv("longnosedace.csv")
m = melt(d[,c("stream","count","acreage","no3","maxdepth")], 
         id.vars=c("stream","count","acreage"))
ggplot(m, aes(x=value,y=count))+geom_point(size=2)+facet_wrap(~variable, scales="free")


## ------------------------------------------------------------------------
d = read.csv("longnosedace.csv")
m = lm(count~no3+maxdepth,d)
summary(m)


## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mar=c(5,5,0,0)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), case0501, xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

yy = with(case0501, by(Lifetime, Diet, mean))
segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
par(opar)


## ------------------------------------------------------------------------
# by default, R uses the alphabetically first group as the reference level
case0501$Diet = relevel(case0501$Diet, ref='N/N85') 

m = lm(Lifetime~Diet, case0501)
summary(m)


## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mar=c(5,5,0,4)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), case0501, xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

axis(4, yy[1], expression(beta[0]), las=1, cex.axis=1.5)
yy = with(case0501, by(Lifetime, Diet, mean))
abline(h=yy[1], lwd=2)
segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
arrows(1:5,yy[1],1:5,yy[-1],col='red', lwd=4)
text(1:5, (yy[2:6]+yy[1])/2, expression(beta[1],beta[2],beta[3],beta[4],beta[5]), pos=4, col='red', cex=1.5, offset=1)
par(opar)


## ----echo=FALSE, fig.width=10, out.width='\\textwidth'-------------------
opar = par(mfrow=c(1,2))
b = c(1,1,10,1)
xx = seq(0,1,length=101)*10
plot(0,0,type='n', xlim=range(xx), ylim=c(0,50), xlab=expression(x[1]), ylab=expression(mu), las=2,
     main="Main effects only")
x2s = 0:2
for (i in seq_along(x2s)) abline(b[1]+b[3]*x2s[i], b[2], col=i, lty=i, lwd=2)
lgnd = c(bquote(x[2]==.(x2s[1])),
         bquote(x[2]==.(x2s[2])),
         bquote(x[2]==.(x2s[3])))
legend("topleft", as.expression(lgnd), col=1:length(x2s), lty=1:length(x2s))

plot(0,0,type='n', xlim=range(xx), ylim=c(0,50), xlab=expression(x[1]), ylab=expression(mu), las=2,
     main="with an interaction")
for (i in seq_along(x2s)) abline(b[1]+b[3]*x2s[i], b[2]+b[4]*x2s[i], col=i, lty=i, lwd=2)
par(opar)


## ------------------------------------------------------------------------
d = read.csv("longnosedace.csv")
mM = lm(count ~ no3+maxdepth, d)
summary(mM)


## ------------------------------------------------------------------------
mI = lm(count ~ no3*maxdepth, d)
summary(mI)


## ----echo=FALSE, fig.width=10, out.width='\\textwidth'-------------------
opar = par(mfrow=c(1,2))
b = coef(mM)
xx = d$no3
x2s = c(26,63,160) # values to evaluate
plot(0,0,type='n', xlim=range(d$no3), ylim=range(d$count), 
     xlab='Nitrate (mg/L)', ylab="Expected longnose dace count", las=2,
     main="Main effects only")
for (i in seq_along(x2s)) abline(b[1]+b[3]*x2s[i], b[2], col=i, lty=i, lwd=2)
legend("topleft", paste("Maxdepth=",x2s,"(cm)"), col=1:length(x2s), lty=1:length(x2s))

b = coef(mI)
plot(0,0,type='n', xlim=range(d$no3), ylim=range(d$count), 
     xlab='Nitrate (mg/L)', ylab="Expected longnose dace count", las=2,
     main="with an interaction")
for (i in seq_along(x2s)) abline(b[1]+b[3]*x2s[i], b[2]+b[4]*x2s[i], col=i, lty=i, lwd=2)
par(opar)


## ----echo=FALSE, fig.width=10, out.width='\\textwidth'-------------------
b = c(0,3,7)
opar = par(mar=c(5,5,4,2)+.1, mfrow=c(1,2))

plot(0, 0, type='n', xlim=c(0,10), ylim=c(0,15), axes=F, frame=TRUE, 
     xlab="Continuous explanatory variable", ylab="Expected response",
     main="Main effects only", xaxs='i')
for (i in 1:length(b)) abline(b[i],1, col=i, lty=i, lwd=2)
axis(2, b, expression(beta[0],beta[0]+beta[2],beta[0]+beta[3]), las=1)
loc=c(1,3,6)
arrows(loc[1],b[1]+loc[1], loc[1], b[2]+loc[1], code=3, length=0.1)
text(loc[1], b[2]/2+loc[1], expression(beta[2]), pos=4)
arrows(loc[2], b[1]+loc[2], loc[2], b[3]+loc[2], code=3, length=0.1)
text(loc[2], mean(b[c(1,3)])+loc[2]+1, expression(beta[3]), pos=4)
arrows(loc[3], b[2]+loc[3], loc[3], b[3]+loc[3], code=3, length=0.1)
text(loc[3], mean(b[2:3])+loc[3], expression(beta[3]-beta[2]), pos=4)

segments(5, 5, 8, 5)
segments(8, 5, 8, 8)
text(8, 6.5, expression(beta[1]), pos=4)

b0 = c(0, 10, 13)
b1 = c(1, .5, -0.3)
plot(0, 0, type='n', xlim=c(0,10), ylim=c(0,15), axes=F, frame=TRUE, 
     xlab="Continuous explanatory variable", ylab="",
     main="with an interaction", xaxs='i')

x1 = 5
x2 = 8
i = 1
for (i in 1:length(b)) {
  abline(b0[i],b1[i], col=i, lty=i, lwd=2)
  segments(x1, b0[i]+b1[i]*x1, x2, b0[i]+b1[i]*x1, col=i, lty=i)
  segments(x2, b0[i]+b1[i]*x1, x2, b0[i]+b1[i]*x2, col=i, lty=i)
}
axis(2, b0, expression(beta[0],beta[0]+beta[2],beta[0]+beta[3]), las=1)
text(8, b0+b1*(x1+x2)/2, expression(beta[1], beta[1]+beta[4], beta[1]+beta[5]), pos=4)
par(opar)


## ------------------------------------------------------------------------
case1002$Type = relevel(case1002$Type, ref='non-echolocating bats') # match SAS
summary(mM <- lm(log(Energy)~log(Mass)+Type, case1002))


## ------------------------------------------------------------------------
summary(mI <- lm(log(Energy)~log(Mass)*Type, case1002))


## ----echo=FALSE, fig.width=10, out.width='\\textwidth'-------------------
opar = par(mar=c(5,5,4,2)+.1, mfrow=c(1,2))

plot(Energy~Mass, case1002, log='xy', 
     pch=as.numeric(Type), col=as.numeric(Type), 
     xlab="Mass (grams)", ylab="Energy (W)",
     main="Main effects only")
with(case1002, legend("topleft", legend=levels(Type), pch=1:nlevels(Type), col=1:nlevels(Type)))
xrng = range(case1002$Mass)
for (i in 1:3) {
  yy = predict(mM, data.frame(Type=levels(case1002$Type)[i], Mass=xrng))
  lines(xrng, exp(yy), col=i, lty=i, lwd=2)
}


b = coef(mI)
plot(Energy~Mass, case1002, log='xy', 
     pch=as.numeric(Type), col=as.numeric(Type), 
     xlab="Mass (grams)", ylab="Energy (W)",
     main="with an interaction")
for (i in 1:3) {
  yy = predict(mI, data.frame(Type=levels(case1002$Type)[i], Mass=xrng))
  lines(xrng, exp(yy), col=i, lty=i, lwd=2)
}
par(opar)


## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
mus = function(b, cats=c("A","B","C"), types=c(0,1)) {
  d = data.frame(type=rep(types, each=3),
                 category = rep(cats, 2))
  if (length(b) == 4) {
  d$mu = c(b[1],      b[1]     +b[3], b[1]     +b[4],
           b[1]+b[2], b[1]+b[2]+b[3], b[1]+b[2]+b[4])
  } else {
  d$mu = c(b[1],      b[1]     +b[3],      b[1]     +b[4],
           b[1]+b[2], b[1]+b[2]+b[3]+b[5], b[1]+b[2]+b[4]+b[6])
  }
  d
}
opar = par(mfrow=c(1,2))
d = mus(c(4,2,-5,-3))
interaction.plot(d$category, d$type, d$mu, type='b', pch=1:2, lty=1:2, legend=FALSE,
     xlab="Category", ylab=expression(mu), main="Main effect only", trace.label="Type")
legend("topright",paste("Type=",0:1), lty=1:2, pch=1:2)
d = mus(c(4,2,-1,-3, 2, -3))
interaction.plot(d$category, d$type, d$mu, type='b', pch=1:2, lty=1:2, legend=FALSE,
     xlab="Category", ylab=expression(mu), main="with interaction", trace.label="Type")
par(opar)


## ------------------------------------------------------------------------
# Set the reference levels
case1301$Block = relevel(case1301$Block, ref='B1')
case1301$Treat = relevel(case1301$Treat, ref='L' )
summary(mM <- lm(Cover~Block+Treat, case1301, subset=Block %in% c("B1","B2") & Treat %in% c("L","Lf","LfF")))


## ------------------------------------------------------------------------
summary(mI <- lm(Cover~Block*Treat, case1301, subset=Block %in% c("B1","B2") & Treat %in% c("L","Lf","LfF")))


## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mfrow=c(1,2))
d = mus(coef(mM), cats=c("L","Lf","LfF"), types=c("B1","B2"))
interaction.plot(d$category, d$type, d$mu, type='b', pch=1:2, lty=1:2, legend=FALSE,
     xlab="Treatment", ylab=expression(mu), main="Main effect only", trace.label="Block")
legend("topright",paste("Block=",levels(d$type)), lty=1:2, pch=1:2)
d = mus(coef(mI), cats=c("L","Lf","LfF"), types=c("B1","B2"))
interaction.plot(d$category, d$type, d$mu, type='b', pch=1:2, lty=1:2, legend=FALSE,
     xlab="Treatment", ylab=expression(mu), main="with interaction", trace.label="Block")
par(opar)


