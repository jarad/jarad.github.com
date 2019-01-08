
## ----options, echo=FALSE-------------------------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center')
library(plyr)
library(ggplot2)
library(xtable)


## ----visualize, echo=FALSE, out.width='\\textwidth'----------------------
par(mfrow=c(2,2))
curve(dnorm(x,1), -4, 4, main="Paired t-test", xlab="Difference", ylab="Distribution", 
      lwd=2, axes=F, frame=T)
axis(1,0)
abline(v=0, col="gray", lty=2)
points(.8,0, pch=19)
segments(.8-1.3,0,.8+1.3,0, lwd=2)

curve(dnorm(x,-1), -4, 4, main="Two-sample t-test", xlab="", ylab="", lwd=2, axes=F, frame=T, col=2, lty=1)
curve(dnorm(x,1), add=TRUE, col=3, lwd=2, lty=2)
legend("bottomright", paste("Pop",1:2),col=2:3, lwd=2, lty=1:2)


## ----normal_distribution, echo=FALSE-------------------------------------
curve(dnorm, -3.1, 3.1, main='Probability density function', xlab='y', ylab='Probability density function, f(y)', lwd=2, axes=F, frame=TRUE)
abline(v=-3:3, lty=2, col='gray')
axis(1,-3:3,expression(mu-3*sigma, mu-2*sigma, mu-sigma, mu,mu+sigma,mu+2*sigma,mu+3*sigma))
arrows(-1:-3, dnorm(1:3), 1:3, dnorm(1:3), code=3)
text(0, dnorm(1:3), round(1-2*pnorm(-1:-3),3), pos=3)


## ----kurtosis, echo=FALSE------------------------------------------------
v = c(Inf,30,15,5)
sigma = v/(v-2); sigma[1] = 1
mykurtosis = paste("Kurtosis=", round(6/(v-4),2))
curve(dnorm, -3, 3, main="t distribution", ylab='Probability density function, f(y)', xlab='y', lwd=2, axes=F, frame=TRUE)
for (i in 2:4) curve(dt(x/sigma[i],v[i])/sigma[i], add=TRUE, col=i, lty=i, lwd=2)
abline(v=-3:3, lty=2, col='gray')
legend("topright", mykurtosis, lwd=2, lty=1:4, col=1:4)


## ----outliers, echo=FALSE------------------------------------------------
v = 5
sigma = sqrt(v/(v-2))

curve(dnorm, -4, 4, main='Probability density function', xlab='y', ylab='Probability density function, f(y)', lwd=2, axes=F, frame=TRUE, col='gray')
curve(dt(x/sigma,v)/sigma, lwd=2, add=TRUE)
curve(dnorm, col="gray", add=TRUE)
abline(v=-3:3, lty=2, col='gray')
axis(1,-3:3,expression(mu-3*sigma, mu-2*sigma, mu-sigma, mu,mu+sigma,mu+2*sigma,mu+3*sigma))
arrows(-1:-3, dt(1:3/sigma,v)/sigma, 1:3, dt(1:3/sigma,v)/sigma, code=3)
text(0, dt(3:1/sigma,v)/sigma, round(1-2*pt(-3:-1,v),3), pos=3)
legend("topright", c("Normal", "Scaled t_5"), lwd=2, col=c("gray","black"))


## ----kurtosis_samples, echo=FALSE----------------------------------------
v = c(Inf,30,15,5)
sigma = v/(v-2); sigma[1] = 1
d = data.frame(v=v, sigma=sigma, kurtosis=mykurtosis)
samps = ddply(d, .(v,kurtosis), function(x) data.frame(samples = x$sigma*rt(100,x$v))) 
qplot(samples, data=samps, facets=~kurtosis, binwidth=8/30)


## ----kurtosis_samples_boxplot, echo=FALSE--------------------------------
v = c(Inf,30,15,5)
sigma = v/(v-2); sigma[1] = 1
d = data.frame(v=v, sigma=sigma, kurtosis=mykurtosis)
samps = ddply(d, .(v,kurtosis), function(x) data.frame(samples = x$sigma*rt(100,x$v))) 
ggplot(samps, aes(factor(kurtosis), samples))+geom_boxplot()


## ----skewness, echo=FALSE------------------------------------------------
skewness = function(mu,sigma) (exp(sigma^2)+2)*sqrt(exp(sigma^2)-1)
mydlnorm = function(x,sigma) dlnorm(x, -sigma^2/2, sigma) 
sigma = c(.5,1,1.5)
myskewness = paste("Skewness=", round(skewness(-sigma^2/2,sigma),2))
curve(mydlnorm(x,sigma[1]), 0, 4, main="Log-normal distribution", ylab='Probability density function, f(y)', xlab='y', lwd=2, axes=F, frame=TRUE, ylim=c(0,1.5))
curve(mydlnorm(x,sigma[2]), add=TRUE, col=2, lty=2, lwd=2)
curve(mydlnorm(x,sigma[3]), add=TRUE, col=3, lty=3, lwd=2)
legend("topright", myskewness, lwd=2, lty=1:3, col=1:3)
abline(v=1, lty=4, col='gray')
text(1,1,"Mean", pos=4, col="gray")


## ----skewness_samples, echo=FALSE----------------------------------------
d = data.frame(sigma=sigma, skewness=myskewness)
samps = ddply(d, .(sigma,skewness), function(x) data.frame(samples = rlnorm(100,-x$sigma^2/2, x$sigma))) 
qplot(samples, data=samps, facets=~sigma, binwidth=15/30)


## ----"robustness data", echo=FALSE, results='asis'-----------------------
options(width=170)
d = 
data.frame("sample size" = c(5,10,25,50,100),
           "strongly skewed" = c(95.5,95.5,95.3,95.1,94.8),
           "moderately skewed" = c(95.4,95.4,95.3,95.3,95.3),
           "mildly skewed" = c(95.2,95.2,95.1,95.1,95.0),
           "heavy-tailed" = c(98.3, 98.3, 98.2, 98.1, 98.0),
           "short-tailed" = c(94.5, 94.6, 94.9, 95.2, 95.6), 
           check.names=FALSE)
print(xtable(d, digits=c(NA,0,1,1,1,1,1), align='c|r|ccccc|'),
      include.row=FALSE)


## ----different_variances, echo=FALSE-------------------------------------
par(mfrow=c(1,1))
sigma = c(1,2,4)
curve(dnorm, -5, 5, main="Normal distribution", xlab="", ylab="",
      axes=F, frame=T, type="n")
for (i in 1:3) curve(dnorm(x,0,sigma[i]), add=TRUE, lwd=2, col=i, lty=i)
legend("topright", paste("SD=",sigma), lwd=2, col=1:3, lty=1:3)


## ----different_variances_samples, echo=FALSE-----------------------------
d = adply(sigma,1,function(x) data.frame(sigma=x,y=rnorm(100,0,x)))
ggplot(d, aes(factor(sigma), y))+geom_boxplot()


## ----"robustness data2", echo=FALSE, results='asis'----------------------
options(width=170)
d = 
data.frame(n1=c(10,10,10,100,100,100), 
           n2=c(10,20,40,100,200,400), 
           "r=1/4" = c(95.2,83,71,94.8,86.5,71.6),
           "r=1/2" = c(94.2,89.3,82.6,96.2,88.3,81.5),
           "r=1"   = c(94.7,94.4,95.2,95.4,94.8,95.0),
           "r=2"   = c(95.2,98.7,99.5,95.3,98.8,99.5),
           "r=4"   = c(94.5,99.1,99.9,95.1,99.4,99.9),
           check.names=FALSE)
print(xtable(d, digits=c(NA,0,0,1,1,1,1,1), align='c|rr|ccccc|'),
      include.row=FALSE)


## ----echo=FALSE, fig.height=2.5, message=FALSE---------------------------
d = read.csv("mpg.csv")

grid <- with(d, seq(min(mpg), max(mpg), length = 100))
normaldens <- ddply(d, "country", function(df) {
  data.frame( 
    predicted = grid,
    density = dnorm(grid, mean(df$mpg), sd(df$mpg))
  )
})

ggplot(d, aes(x=mpg)) + geom_histogram(aes(y=..density..)) + facet_wrap(~country) + geom_line(data=normaldens, aes(x=predicted, y=density, color='red'), size=2)+guides(color=FALSE)


## ----echo=FALSE, fig.height=2.5, message=FALSE---------------------------
d$lmpg = log(d$mpg)
grid <- with(d, seq(min(lmpg), max(lmpg), length = 100))
normaldens <- ddply(d, "country", function(df) {
  data.frame( 
    predicted = grid,
    density = dnorm(grid, mean(df$lmpg), sd(df$lmpg))
  )
})
ggplot(d, aes(x=lmpg)) + geom_histogram(aes(y=..density..)) + facet_wrap(~country) + geom_line(data=normaldens, aes(x=predicted, y=density, color='red'), size=2)+guides(color=FALSE)


## ----echo=FALSE, fig.height=2.5, message=FALSE---------------------------
ggplot(d, aes(x=country, y=mpg)) + geom_boxplot()


## ----echo=FALSE, fig.height=2.5, message=FALSE---------------------------
ggplot(d, aes(x=country, y=lmpg)) + geom_boxplot() 


## ----echo=FALSE, results='asis'------------------------------------------
print(xtable(ddply(d, .(country), summarise, n=length(mpg), mean=mean(mpg), sd=sd(mpg))), include.rownames=F)


## ----echo=FALSE, results='asis'------------------------------------------
print(xtable(ss<-ddply(d, .(country), summarise, n=length(lmpg), mean=mean(lmpg), sd=sd(lmpg))), include.rownames=F)


## ----echo=FALSE, results='asis'------------------------------------------
print(xtable(ss), include.rownames=F)


## ------------------------------------------------------------------------
t = t.test(log(mpg)~country, d, var.equal=TRUE)
t$estimate # On log scale
exp(t$estimate) # On original scale
exp(t$estimate[1]-t$estimate[2]) # Ratio of medians (Japan/US)
exp(t$conf.int) # Confidence interval for ratio of medians


## ------------------------------------------------------------------------
curve(dnorm, -3, 6, lwd=2)
curve(dnorm(x, 2, 2), lwd=2, col=2, lty=2, add=TRUE)


## ----welch---------------------------------------------------------------
var.test(mpg~country,d) # F-test
(t=t.test(mpg~country, d, var.equal=FALSE))


## ----welch_on_log--------------------------------------------------------
var.test(log(mpg)~country,d)
(t = t.test(log(mpg)~country, d, var.equal=FALSE))
exp(t$conf.int)


