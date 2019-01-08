
## ----options, echo=FALSE, warning=FALSE----------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)


## ----echo=FALSE----------------------------------------------------------
ggplot(case0501, aes(x=Diet, y=Lifetime))+geom_boxplot()


## ----echo=FALSE----------------------------------------------------------
set.seed(1)
mu = rnorm(4)
curve(dnorm(x,mu[1]),-4,6, axes=F, frame=T, xlab="", ylab="", lwd=2)
for (i in 2:length(mu)) curve(dnorm(x, mu[i]), add=TRUE, lwd=2, col=i, lty=i)


## ----echo=FALSE, results='asis'------------------------------------------
sm = ddply(case0501, .(Diet), summarize,
          n = length(Lifetime),
          mean = mean(Lifetime),
          sd = sd(Lifetime))
tab = xtable(sm, digits=c(NA,NA,0,1,1), caption="Summary statistics for mice lifetime (months) on different diets")
print(tab, caption.placement="top")


## ----F-distribution, echo=FALSE------------------------------------------
df = c(5,300)
curve(df(x,df[1], df[2]), 0, 4, main=expression(F[list(5,300)]),
      xlab="x",
      ylab="Probability density function",
      lwd=2)
xx = c(2, seq(2, 4,by=.01), 4)
yy = c(0, df(xx[-c(1,length(xx))], df[1], df[2]), 0)
polygon(xx,yy, col='red', border=NA)


## ----echo=FALSE, results='asis'------------------------------------------
sm2 = rbind(sm, data.frame(Diet="Total", n=nrow(case0501), mean=mean(case0501$Lifetime), sd=NA))
tab = xtable(sm2, digits=c(NA,NA,0,1,1), caption="Summary statistics for mice lifetime (months) on different diets")
print(tab, caption.placement="top", hline.after=c(-1,0,6,7))


## ----echo=FALSE----------------------------------------------------------
ggplot(case0501, aes(x=Diet, y=Lifetime)) + geom_jitter(size=3) + geom_hline(data=sm2, aes(yintercept=mean[7]), col='red', size=2) + geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), col='blue', size=2)


## ------------------------------------------------------------------------
m = lm(Lifetime~Diet, case0501)
anova(m)


## ----echo=FALSE----------------------------------------------------------
sm3 = sm 
sm3$mean[-which(sm3$Diet=="NP")] = mean(case0501$Lifetime[case0501$Diet!="NP"])
ggplot(case0501, aes(x=Diet, y=Lifetime)) + geom_jitter(size=3) + geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), col='blue', size=2) + geom_errorbar(data=sm3, aes(y=mean, ymin=mean, ymax=mean), col='red', size=2)


## ------------------------------------------------------------------------
case0501$NP = factor(case0501$Diet == "NP")

modR = lm(Lifetime~NP,   case0501)
modF = lm(Lifetime~Diet, case0501)
anova(modR,modF)


## ------------------------------------------------------------------------
case0501$local = ifelse(case0501$Diet=='N/N85', 1, 2) # NP is 2 here 
case0501$local[case0501$Diet=='NP'] = 0               # now NP is 1
case0501$local = factor(case0501$local)
mod1 = lm(Lifetime~1,     case0501)
modR = lm(Lifetime~local, case0501)
modF = lm(Lifetime~Diet,  case0501)
anova(mod1, modR, modF)

anova(modF) # To get the pooled estimate of the variance for the full model


