
## ----options, echo=FALSE, warning=FALSE----------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)


## ----echo=FALSE----------------------------------------------------------
ggplot(case0501, aes(x=Diet, y=Lifetime))+geom_boxplot()


## ----echo=FALSE, results='asis'------------------------------------------
K = rbind("early rest - none @ 50kcal"=c( 0, 0,-1, 0, 1, 0),
          "40kcal/week - 50kcal/week" =c( 0, 2,-1, 0,-1, 0) / 2,
          "lo cal - hi cal"           =c(-2, 1, 1,-2, 1, 1) / 4)
colnames(K) = levels(case0501$Diet)
print(xtable(K))


## ----echo=FALSE,results='asis'-------------------------------------------
sm = ddply(case0501, .(Diet), summarise, 
           n = length(Lifetime),
           mean = mean(Lifetime),
           sd = sd(Lifetime))

print(xtable(sm))


## ----echo=FALSE, results='asis'------------------------------------------
m = lm(Lifetime~Diet, case0501)
sp = summary(m)$sigma

g = rowSums(K%*%sm$mean)
SEg = rowSums(sp*sqrt(K^2%*%(1/sm$n)))

df = sum(sm$n-1)
t = g/SEg
p = 2*pt(-abs(t),df)
L = g-qt(.975,df)*SEg
U = g+qt(.975,df)*SEg

tests = data.frame(g=g,"SE(g)"=SEg,t=t,p=p,L=L,U=U, check.names=FALSE)

print(xtable(tests))


## ----warning=FALSE-------------------------------------------------------
library(multcomp)
m = lm(Lifetime~Diet-1, case0501) # The -1 indicates no intercept (see Ch 7)
summary(m)
K


## ----warning=FALSE-------------------------------------------------------
t = glht(m, linfct=K)
summary(t)
confint(t, calpha=univariate_calpha())


## ----echo=FALSE----------------------------------------------------------
m = 1:20
plot(m, 1-(1-.05/m)^m, ylim=c(0,0.05), type="l", lwd=2,
     xlab="Number of tests", ylab="Familywise error rate", main="Bonferroni familywise error rate")
lines(m, 1-(1-.01/m)^m, lty=2, col=2, lwd=2)
legend("right", paste("alpha=",c(.05,.01)), lwd=2, lty=1:2, col=1:2)


## ----echo=FALSE----------------------------------------------------------
d = read.csv("potato.csv")
d
d$sulfur = as.numeric(gsub("\\D","",d$trt))*100
d$sulfur[is.na(d$sulfur)] = 0
d$application = NA
d$application[grep("F",d$trt)] = "fall"
d$application[grep("S",d$trt)] = "spring"
d$application = factor(d$application)

d$trt = factor(d$trt, levels=c("F12","F6","F3","O","S3","S6","S12"), ordered=TRUE)


## ----echo=FALSE----------------------------------------------------------
plot(0,0, xlab="Sulfur (lbs/acre)", ylab="Application", main="Treatment visualization",
     type="n", axes=F,
     xlim=c(-100,1500), ylim=c(.5,2.5))
axis(1, c(0,300,600,1200), lwd=0)
axis(2, c(1,2), c("spring","fall"), lwd=0)
xc = c(0,300,300,600,600,1200,1200)
yc = c(1.5,1,2,1,2,1,2)
rect(xc-100,yc-.4,xc+100,yc+.4)
text(xc,yc, c(8,rep(4,6)))


## ----echo=FALSE----------------------------------------------------------
plot(0,0, xlab="col", ylab="row", main="Completely randomized design\n potato scab experiment",
     xlim=range(d$col)+c(-.5,.5), ylim=range(d$row)+c(-.5,.5), axes=F, type="n")
text(d$col, d$row, d$trt)
axis(1, 1:8, lwd=0)
axis(2, 1:4, lwd=0)
segments(1:9-.5,0.5,1:9-.5,4.5)
segments(0.5,1:5-.5,8.5,1:5-.5)


## ----echo=FALSE----------------------------------------------------------
qplot(trt, inf, data=d, geom=c("boxplot","jitter"), xlab="Sulfur", ylab="Scab percent")


## ----echo=FALSE----------------------------------------------------------
qplot(sulfur, inf, data=d, color=application, geom="jitter", xlab="Sulfur", ylab="Scab percent")


## ----echo=FALSE----------------------------------------------------------
qplot(col, inf, data=d, color=application, geom="jitter", xlab="Column ID", ylab="Scab percent")


## ----echo=FALSE----------------------------------------------------------
qplot(row, inf, data=d, color=application, geom="jitter", xlab="Row ID", ylab="Scab percent")


## ----potato_in_R---------------------------------------------------------
library(multcomp)
K = rbind("sulfur - control" = c(1, 1, 1, -6, 1, 1, 1)/6,
          "fall - spring"    = c(1,1,1,0,-1,-1,-1)/3,
          "linear trend"     = c(27,3,-9,-42,-9,3,27)/8)
m = lm(inf~trt,d)
anova(m)


## ------------------------------------------------------------------------
par(mfrow=c(2,3))
plot(m,1:6)


## ------------------------------------------------------------------------
g = glht(lm(inf~trt-1,d), linfct=K) # notice the -1 in the model
summary(g, test=adjusted(type="none")) # unadjusted pvalues
confint(g, calpha=univariate_calpha()) # unadjusted confidence intervals


## ------------------------------------------------------------------------
plot(d$col,residuals(m))


