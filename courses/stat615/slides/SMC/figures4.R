setwd("figs/")

library(plotrix)
pdf("stateSpaceModel-0.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { draw.circle(xs[i],ys[i], 0.3,lwd=4) }
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()

pdf("stateSpaceModel-1.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { draw.circle(xs[i],ys[i], 0.3,lwd=4) }
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2, col='red')
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2, col='red')
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()

pdf("stateSpaceModel-2.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { draw.circle(xs[i],ys[i], 0.3,lwd=4) }
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2, col='red')
dev.off()

#########################################################

pdf("ssm-0.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { 
  draw.circle(xs[i],ys[i], 0.3,lwd=4, 
  border=ifelse(any(i==c(4,5)), "blue","black" ))
}
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()

pdf("ssm-1.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { 
  draw.circle(xs[i],ys[i], 0.3,lwd=4, 
  border=ifelse(any(i==c(4,5)), "blue","black" ))
}
draw.circle(2,1, 0.3, lwd=4, border="red")
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()

pdf("ssm-2.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { 
  draw.circle(xs[i],ys[i], 0.3,lwd=4, 
  border=ifelse(any(i==c(4,5)), "blue","black" ))
}
draw.circle(1,1, 0.3, lwd=4, border="red")
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()


pdf("ssm-3.pdf")
par(mar=rep(0,4))
plot(0,0, axes=F, xlim=c(0,4), ylim=c(-1,3), type='n', xlab='', ylab='')
xs <- c(1,2,3,1,2,3)
ys <- c(1,1,1,2,2,2)
lbls <- expression(theta[t-1],theta[t],theta[t+1],y[t-1],y[t],y[t+1])
for (i in 1:6) { 
  draw.circle(xs[i],ys[i], 0.3,lwd=4, 
  border=ifelse(any(i==c(4,5)), "blue","black" ))
}
draw.circle(3,1, 0.3, lwd=4, border="red")
text(1, 1, expression(x[t-1]), cex=2)
text(2, 1, expression(x[t]), cex=2)
text(3, 1, expression(x[t+1]), cex=2)
text(1, 2, expression(y[t-1]), cex=2)
text(2, 2, expression(y[t]), cex=2)
text(3, 2, expression(y[t+1]), cex=2)
arrows(xs-0.15-.5,1,xs+0.15-.5,1, lwd=2)
arrows(xs-0.15+.5,1,xs+0.15+.5,1, lwd=2)
arrows(xs,1+0.35,xs,2-0.35, lwd=2)
dev.off()

###################### Kalman filter ##############################3

mn <- lKalmanFilter$vdPosteriorMean
sd <- sqrt(lKalmanFilter$vdPosteriorVariance)

plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
  ylim=range(adY))
points(0,mn[1],pch=23,bg='red',col=NA)
points(0,mn[1]-2*sd[1],pch=23,bg='red',col=NA)
points(0,mn[1]+2*sd[1],pch=23,bg='red',col=NA)
legend("topright",inset=0.01, c("Data","Mean","95% Interval"), 
       pch=c(23,NA,NA), lty=c(NA,2,1),pt.bg=c("green","red","red"), 
       col=c("green","red","red"), lwd=2)
dev.copy2pdf(file="kf-0.pdf")   
for (i in 1:10) {
  points(i,adY[i+1],pch=23,bg='green',col=NA) 
  segments(i-1,mn[i],i,mn[i+1],col='red', lty=2, lwd=2)
  segments(i-1,mn[i]-2*sd[i],i,mn[i+1]-2*sd[i+1],col='red', lwd=2)
  segments(i-1,mn[i]+2*sd[i],i,mn[i+1]+2*sd[i+1],col='red', lwd=2)
  dev.copy2pdf(file=paste("kf-",i,".pdf",sep=''))
}


########################## MC #####################################
set.seed(1)
xs <- rnorm(1e4)
bks <- seq(min(xs), max(xs), length.out=100)
pdf("mc.pdf",width=10)
par(mfrow=c(1,3))
hist(xs[1:100], bks, freq=F, main='n=100', xlab='', ylab='',
     xlim=c(-3,3), ylim=c(0,0.5), col='blue', border=NA, cex.main=1.5)
curve(dnorm(x), -3, 3, add=T, col='red', lwd=4)
hist(xs[1:1e3], bks, freq=F, main='n=1,000', xlab='', ylab='',
     xlim=c(-3,3), ylim=c(0,0.5), col='blue', border=NA, cex.main=1.5)
curve(dnorm(x), -3, 3, add=T, col='red', lwd=4)
hist(xs[1:1e4], bks, freq=F, main='n=10,000', xlab='', ylab='',
     xlim=c(-3,3), ylim=c(0,0.5), col='blue', border=NA, cex.main=1.5)
curve(dnorm(x), -3, 3, add=T, col='red', lwd=4)
dev.off()

set.seed(1)
y <- rnorm(1e5)
cs <- (cumsum(y>1)/(1:1e5))[10^(1:5)]
pdf("mc-tail.pdf")
plot(1:5,cs,log='x', type='b', cex=1.5, cex.lab=1.5, cex.axis=1.5,
     xlab='Log_10 of number of samples', ylab='P(Z>1)', lwd=2)
abline(h=1-pnorm(1),col='red', lwd=2)
dev.off()


########################## IS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
set.seed(1)
xs <- rcauchy(1e4)
pdf("is.pdf",width=10)
par(mfrow=c(1,3), mar=c(2,2,0,2)+.1)
curve(dnorm(x), -5, 5, ylim=c(0,2), lwd=2, ylab='', xlab='')
curve(dcauchy(x), -5, 5, col='red', add=T, lwd=2)
curve(dnorm(x)/dcauchy(x), -5, 5, col='blue', add=T, lwd=2)
legend("topright", inset=0.01, lwd=2, col=c("black","red","blue"),cex=1.5,
       c("N(x;0,1) density", "C(x;0,1) density", "N(x;0,1)/C(x;0,1)"))

curve(dunif(x,-1,1), -5, 5, ylim=c(0,2), lwd=2, ylab='', xlab='')
curve(dnorm(x), -5, 5, col='red', add=T, lwd=2)
curve(dunif(x,-1,1)/dnorm(x), -5, 5, col='blue', add=T, lwd=2)
legend("topright", inset=0.01, lwd=2, col=c("black","red","blue"),cex=1.5,
       c("U(x;-1,1) density", "N(x;0,1) density", "U(x;-1,1)/N(x;0,1)"))

curve(dnorm(x), -5, 5, ylim=c(0,2), lwd=2, col='red', ylab='', xlab='')
curve(dcauchy(x), -5, 5, add=T, lwd=2)
curve(dcauchy(x)/dnorm(x), -5, 5, col='blue', add=T, lwd=2)
legend("topright", inset=0.01, lwd=2, col=c("black","red","blue"), cex=1.5,
       c("C(x;0,1) density", "N(x;0,1) density", "C(x;0,1)/N(x;0,1)"))
dev.off()

set.seed(1)
n <- 20
xs <- rnorm(n)
ws <- dt(xs,2)/dnorm(xs,0,0.5)
ex <- numeric(n)
for (i in 1:n) {
  ex[i] <- sum(xs[1:i]*ws[1:i]/sum(ws[1:i]))
}
ws <- ws/sum(ws)

pdf("is-0.pdf")
plot(0,0, xlim=c(0,n), ylim=c(-3,3), xlab='i', ylab='E[X]', type='n')
legend("topright",inset=.01,c(expression(x_i),"E[X]","weights"), pch=c(22,21,19))
dev.off()
for (i in 1:n) {
  pdf(paste("is-",i,".pdf",sep=''))
  plot(0,0, xlim=c(0,n), ylim=c(-3,3), xlab='', ylab='', type='n', axes=F)
  points(i, xs[i], pch=22)
  points(i, ex[i])
  points(i, 6*ws[i]-3,pch=19)
  #segments(i,-3,i,6*ws[i]-3)
  dev.off()
}

set.seed(2)
y <- rexp(1e5)+4.5
pdf.y <- function(y) { dexp(y-4.5) }
cs <- (cumsum(dnorm(y)/pdf.y(y))/(1:1e5))[10^(1:5)]
pdf("is-tail.pdf")
plot(1:5,cs*10^6,log='x', type='b', cex=1.5, cex.lab=1.5, cex.axis=1.5,
     xlab='Log_10 of number of samples', ylab='P(Z>4.5) [x10^-6]', lwd=2)
abline(h=10^6*(1-pnorm(4.5)),col='red', lwd=2)
dev.off()




setwd("../")




