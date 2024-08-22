
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(abd)


## ----echo=FALSE----------------------------------------------------------
data(Telomeres)
ggplot(Telomeres, aes(x=years, y=telomere.length))+geom_point()+geom_smooth(method='lm', se=FALSE)


## ----echo=FALSE----------------------------------------------------------
Telomeres$jyears = jitter(Telomeres$years)
plot(telomere.length~jyears, Telomeres,
     main="Telomere length vs years post diagnosis",
     xlab="Years post diagnosis (jittered)",
     ylab="Telomere length")

m = lm(telomere.length~years, Telomeres)
abline(m, col="red", lwd=2)

segments(Telomeres$jyears, predict(m), 
         Telomeres$jyears, predict(m)+residuals(m), 
         lty=2, col="red")


## ----echo=FALSE----------------------------------------------------------
ddply(Telomeres, .(), summarize,
      n = length(years),
      Xbar = mean(years),
      Ybar = mean(telomere.length),
      s_X = sd(years),
      s_Y = sd(telomere.length),
      r_XY = cor(telomere.length,years)
      )[,-1]


## ------------------------------------------------------------------------
m = lm(telomere.length~years, Telomeres)
with(Telomeres, cor(telomere.length,years))
anova(m)


## ------------------------------------------------------------------------
m = lm(telomere.length~years, Telomeres)
summary(m)
confint(m)


## ------------------------------------------------------------------------
m = lm(telomere.length~years, Telomeres)
new = data.frame(years=4)
predict(m, new, interval="confidence")  
predict(m, new, interval="prediction") 


## ----echo=FALSE, fig.height=6, fig.width=7, out.width='0.8\\textwidth'----
plot(telomere.length~years, Telomeres, pch=19)
abline(m)
d = data.frame(years=seq(0,13,by=.1))
tmp = predict(m, d, interval="confidence")  
lines(d$years, tmp[,2], lwd=2, lty=2, col=2)
lines(d$years, tmp[,3], lwd=2, lty=2, col=2)
tmp = predict(m, d, interval="prediction")  
lines(d$years, tmp[,2], lwd=2, lty=3, col=3)
lines(d$years, tmp[,3], lwd=2, lty=3, col=3)
legend("topright", c("Regression line","Confidence bands","Prediction bands"), lty=1:3, lwd=2, col=1:3,
       bg="white")


## ------------------------------------------------------------------------
m0 = lm(telomere.length ~   years   , Telomeres) 
m4 = lm(telomere.length ~ I(years-4), Telomeres) 

coef(m0)
coef(m4)

confint(m0)
confint(m4)


