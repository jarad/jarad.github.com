
## ----options, echo=FALSE-------------------------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center')


## ----normal_distribution, fig.height=5, fig.align='center', echo=FALSE----
curve(dnorm, -3.1, 3.1, main='Probability density function', xlab='y', ylab='f(y)', lwd=2, axes=F, frame=TRUE)
abline(v=-3:3, lty=2, col='gray')
axis(1,-3:3,expression(mu-3*sigma, mu-2*sigma, mu-sigma, mu,mu+sigma,mu+2*sigma,mu+3*sigma))
arrows(-1:-3, dnorm(1:3), 1:3, dnorm(1:3), code=3)
text(0, dnorm(1:3), c("68%","95%","99.7%"), pos=3)


## ----t_distribution, fig.height=5, fig.align='center', echo=FALSE--------
curve(dnorm, -3.1, 3.1, main='Probability density function', xlab='y', ylab='f(y)', lwd=2, axes=F, frame=TRUE, col="gray")
curve(dt(x,3), -3.1, 3.1, add=TRUE, lwd=2)
abline(v=-3:3, lty=2, col='gray')
axis(1,-3:3)
legend("topright",expression(N(0,1),t[3]), lwd=2, col=c("gray","black"))


## ----t30_distribution, fig.height=5, fig.align='center', echo=FALSE------
curve(dnorm, -3.1, 3.1, main='Probability density function', xlab='y', ylab='f(y)', lwd=2, axes=F, frame=TRUE, col="gray")
curve(dt(x,30), -3.1, 3.1, add=TRUE, lwd=2)
abline(v=-3:3, lty=2, col='gray')
axis(1,-3:3)
legend("topright",expression(N(0,1),t[30]), lwd=2, col=c("gray","black"))


## ----t_critical_value, fig.height=5, fig.align='center', echo=FALSE------
curve(dt(x,5), -3.1, 3.1, main=expression(paste('Probability density function ', t[5])), xlab='t', ylab='f(t)', lwd=2, axes=F, frame=T)
t_crit = qt(.9, 5)
axis(1,t_crit)
abline(v=t_crit, col="gray", lty=2)
text(-.5, .1, 0.9, cex=2)
text(2.5, .1, .1, cex=2)
arrows(2.4, .08, 2, 0.03)


## ----paired_data---------------------------------------------------------
library(plyr)
y1 = c(38,10,84,36,50,35,73,48)
y2 = c(32,16,57,28,55,12,61,29)
leaves  = data.frame(year1=y1, year2=y2, diff=y1-y2)
leaves
summarize(leaves, n=length(diff), mean=mean(diff), sd=sd(diff))


## ----paired_t_test-------------------------------------------------------
t.test(leaves$year1, leaves$year2, paired=TRUE, alternative="greater")


## ----mpg_data, message=FALSE---------------------------------------------
mpg = read.csv("mpg.csv")
library(ggplot2)
ggplot(mpg, aes(x=mpg))+
  geom_histogram(data=subset(mpg,country=="Japan"), fill="red", alpha=0.5)+
  geom_histogram(data=subset(mpg,country=="US"), fill="blue", alpha=0.5)


## ----pvalue_figure, echo=FALSE, fig.height=3, fig.align='center'---------
dt326 = function(x) dt(x,df=30)
xx = seq(-3,-1.5,0.1)
yy = dt326(xx)

par(mar=c(2,4,0,0)+.2)
curve(dt326, -3, 3, ylab="Probability density function")
polygon(c(xx,-1.5,-3), c(yy,0,0), col="red", border=NA)
polygon(-c(xx,-1.5,-3), c(yy,0,0), col="red", border=NA)


## ----car_summary_statistics----------------------------------------------
library(plyr)
ddply(mpg, .(country), summarize, n=length(mpg), mean=mean(mpg), sd=sd(mpg))


## ----two_sample_t_test---------------------------------------------------
t.test(mpg~country, data=mpg, var.equal=TRUE)


## ----z, echo=FALSE-------------------------------------------------------
xx = seq(-3,-1.5,by=0.1)
yy = dnorm(xx)
par(mar=c(2,4,0,0)+.1)
curve(dnorm, -3, 3, ylab="Probability density function", 
      axes=F, frame=T, cex.main=1.5)
polygon(c(xx,-1.5,-3), c(yy,0,0), col="red", border=NA)
polygon(-c(xx,-1.5,-3), c(yy,0,0), col="blue", border=NA)
axis(1, c(-1,0,1)*1.5, labels=c("-t","0","t"))


## ----z2, echo=FALSE------------------------------------------------------
par(mar=c(4,4,0,0)+.1)
curve(dnorm, -3, 3, ylab="Probability density function", axes=F, frame=T, cex.main=1.5)
polygon(-c(xx,-1.5,-3), c(yy,0,0), col="red", border="red")
axis(1, 0)
axis(1, 1.5, labels=expression(t[nu](1-alpha/2)))
text(1.8, .02, expression(alpha/2), col="white", pos=3)
text(-.5, .02, expression(1-alpha/2), pos=3)


