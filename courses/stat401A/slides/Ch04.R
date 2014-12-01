
## ----options, echo=FALSE-------------------------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)


## ----bernoulli, echo=FALSE-----------------------------------------------
p = .5
res = ddply(data.frame(n=10^(2:4)), .(n), 
            function(x) rdply(1000, { y = rbinom(x$n, 1, p); data.frame(x = (mean(y)-p)/(sd(y)/sqrt(x$n)))  }))
ggplot(res, aes(x=x)) + geom_histogram(aes(y=..density..), alpha=0.4) + stat_function(fun=dnorm, col="red") + facet_wrap(~n)


## ----rustyd_leaves_data, results='asis', echo=FALSE----------------------
d = data.frame(year1=c(38,10,84,36,50,35,73,48), 
              year2=c(32,16,57,28,55,12,61,29))
d$diff = with(d, year1-year2)
d$"diff>0" = (d$diff>0)*1

print(xtable(d, digits=0), include.rownames=FALSE)


## ----sign_test-----------------------------------------------------------
K = sum(d[,4]) 
n = nrow(d)
sum(dbinom(K:8,8,.5))


## ----pvalue_visualization, echo=FALSE------------------------------------
base_plot <- function(...) {
  xx = -1:10
  plot(xx-.5,dbinom(xx,8,.5), type="s", ylab="Bin(8,.5) probability mass function",...)
  segments(xx+.5, 0, xx+.5, dbinom(xx[-6],8,.5))
  abline(h=0)
}

fill_plot <- function(x,...) {
  rect(x-.5, 0, x+.5, dbinom(x,8,.5), col="red",...)
}

par(mfrow=c(1,3))
base_plot(main="H1: p<0.5")
fill_plot(0:K)

base_plot(main="H1: p!=0.5")
fill_plot(K:n)
fill_plot(0:(n-K))

base_plot(main="H1: p>0.5")
fill_plot(K:n)


## ----sign_test_approximation---------------------------------------------
Z = (K-n/2)/(sqrt(n/4))
1-pnorm(Z)


## ----sign_test_approximation_with_continuity correction------------------
Z = (K-n/2-1/2)/(sqrt(n/4))
1-pnorm(Z)


## ----continuity_correction, echo=FALSE-----------------------------------
par(mfrow=c(1,1))
base_plot(main="Continuity correction")
fill_plot(6:8)
curve(dnorm(x, n/2, sqrt(n/4)), add=TRUE)
abline(v=6)


## ----ranked_data, echo=FALSE, results='asis'-----------------------------
#Signed rank test
d$absdiff = abs(d$diff)
ordr = order(d$absdiff)
d = d[ordr,]
d$rank = rank(d$absdiff)

#d$rank = as.character(d$rank)
tab = xtable(d, digits=c(NA,0,0,0,0,0,1))
print(tab, include.rownames=FALSE)


## ----signed_rank_test----------------------------------------------------
# By hand
S = sum(d$rank[d$"diff>0"==1])
n = nrow(d)
ES = n*(n+1)/4
SDS = sqrt(n*(n+1)*(2*n+1)/24)
z = (S-ES-0.5)/SDS
1-pnorm(z)

# Using a function
wilcox.test(d$year1, d$year2, paired=T)


## ----mpg, echo=FALSE-----------------------------------------------------
mpg = read.csv("mpg.csv")

ss = ddply(mpg, .(country), summarize, mn=mean(mpg), sd=sd(mpg))
attach(ss)

ggplot(mpg, aes(x=mpg))+
  geom_histogram(aes(y=..density..), data=subset(mpg,country=="Japan"), fill="red", alpha=0.5)+
  geom_histogram(aes(y=..density..), data=subset(mpg,country=="US"), fill="blue", alpha=0.5)+
  stat_function(fun=function(x) dnorm(x,mn[1],sd[1]), colour="red")+
  stat_function(fun=function(x) dnorm(x,mn[2],sd[2]), colour="blue")


## ----mpg_small, echo=FALSE, results='asis'-------------------------------
set.seed(2)
id = sample(nrow(mpg),9)
sm = mpg[id,]

ordr = order(sm$mpg)
sm = sm[ordr,]
sm$mpg[5] = 26 # make tie
sm$rank = rank(sm$mpg)
rownames(sm) = 1:nrow(sm)

tab = xtable(sm, digits=c(NA,0,NA,1))
print(tab, include.rownames=FALSE)


## ----mpg_small_by_hand---------------------------------------------------
n1 = sum(sm$country=="Japan")
n2 = sum(sm$country=="US")
U = sum(sm$rank[sm$country=="Japan"])
EU = n1*mean(sm$rank)
SDU = sd(sm$rank) * sqrt(n1*n2/(n1+n2))
Z = (U-.5-EU)/SDU
2*pnorm(-Z)

wilcox.test(mpg~country, sm)


## ----visual_representation, echo=FALSE-----------------------------------
ordr = order(mpg$mpg)
mpg.ordered = mpg[ordr,]

par(mar=c(5,4,0,0)+.1)
plot(mpg.ordered$mpg, 1:nrow(mpg), col=mpg.ordered$country, pch=19, xlab="MPG", cex=0.7, ylab="Rank")
legend("topleft", c("Japan","US"), col=1:2, pch=19)


## ----wilcoxon_rank_sum_test----------------------------------------------
wilcox.test(mpg~country,mpg)


