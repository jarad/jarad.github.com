

# system
n = 3:6 # number of 
d = data.frame(x = sum(n),
               y = runif(sum(n))
               


n <- 3:6
clrs <- c("black","red","blue","seagreen")
set.seed(1)
par(mar=rep(0,4)+.01)
plot(0,0, type='n', axes=F, frame=T, xlab='', ylab='', xlim=c(0,1), ylim=c(0,1))
for (i in 1:length(n))
  points(runif(n[i]), runif(n[i]), pch=19, col=clrs[i], cex=3)

pdf("rxns.pdf", width=5, height=5)
par(mar=rep(0,4)+.01)
plot(0,0, type='n', axes=F, frame=T, xlab='', ylab='', 
     xlim=c(0,1), ylim=c(0,1))
arrows(0.4,c(.25,.5,.75), .6, c(.25,.5,.75), lwd=3)
points(c(.1,.3,.7), rep(.75,3), col=clrs[1:3], pch=19, cex=3)
points(c(.3,.7,.9), rep(.5 ,3), col=clrs[3:1], pch=19, cex=3)
points(c(.3,.7,.9), rep(.25,3), col=clrs[c(3,1,4)], pch=19, cex=3)
text(c(.2,.8,.8), c(.75,.5,.25), "+", cex=3)
dev.off()


# constitutive production
set.seed(1)
tau <- tau.true <- rexp(20, 1)
pdf("production.pdf", width=10, height=5)
par(mar=c(5,5,0,0)+.1)
plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10), ylim=c(0,12), lwd=2, cex.lab=2, cex.axis=2)
dev.off()

ij <- 10
nj <- sum(cumsum(tau)<ij)
pdf("inference.pdf")
par(mar=c(5,5,5,2)+.1,mfrow=c(2,2))
plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     ylim=c(0,12), lwd=2, cex.lab=2, cex.axis=2, cex.main=2, main='Data')
curve(dgamma(x, nj, ij), 0, 2.5, xlab=expression(theta), lwd=2,
      ylab=expression(paste("p(",theta,"|y)")), cex.lab=2, cex.axis=2, cex.main=2,
      main='Estimation')
abline(v=nj/ij, pch=19, col="red", lwd=2)
legend("topright", .01, c("MLE"), lwd=2, col="red")
dev.off()

t <- 0:10
y <- c()
for (tt in t) y[tt+1] <- sum(cumsum(tau)<tt)
pdf("discrete.pdf")
par(mar=c(5,5,5,2)+.1,mfrow=c(2,2))
plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     ylim=c(0,12), lwd=2, cex.lab=2, cex.axis=2, cex.main=2, main='Complete')
segments(t,0,t,y,col='blue')
plot(t,y, pch=19, cex=1, xlab='Time', ylab='# molecules', xlim=c(0,10),
     ylim=c(0,12), lwd=2, cex.lab=2, cex.axis=2, cex.main=2, main='Discrete')
dev.off()

pdf("parameters.pdf", width=10,height=5)
par(mar=c(5,5,5,2)+.1)
plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, col='blue',
     main='Simulations')
points(t,y, pch=19, cex=1)
lines(cumsum(c(0,tau*2)),0:20, type='s', col='red', lwd=2)
lines(cumsum(c(0,tau/2)),0:20, type='s', col='red', lwd=2)
dev.off()


# Rejection sampling
a <- b <- 100
set.seed(1)
n.reps <- 1e1
theta <- c()
for (i in 1:n.reps) {
	th <- rgamma(1,a,b)
	tau <- rexp(20, th)
	yy <- c()
	for (tt in t) yy[tt+1] <- sum(cumsum(tau)<tt)
	if (isTRUE(all.equal(y,yy))) cat(i,"\n")
	pdf(paste("rej-",i-1,".pdf",sep=''))
	par(mar=c(5,5,5,2)+.1)
	plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     	ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, col='red',
    	 main='Simulations')
	points(t,y, pch=19, cex=1)
	legend("topleft", legend=round(th,2))
	dev.off()
}
pdf(paste("rej-10.pdf",sep=''))
par(mar=c(5,5,5,2)+.1)
plot(cumsum(c(0,tau.true)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     	ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, col='blue',
    	 main='Simulations')
points(t,y, pch=19, cex=1)
legend("topleft", legend="1.00")
dev.off()

# Gibbs sampling - this is faked
set.seed(1)
n.reps <- 1e1
for (i in 1:n.reps) {
	cat(i,"\n")
	yy <- y*0 
	while (!isTRUE(all.equal(y,yy))) {
		tau <- tau.true +rnorm(length(tau.true), 0, .1) # this is faked Gibbs sampling
		for (tt in t) yy[tt+1] <- sum(cumsum(tau)<tt)
	}
	th <- rgamma(1,11,10)
	pdf(paste("gibbs-",i-1,".pdf",sep=''))
	par(mar=c(5,5,5,2)+.1)
	plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     	ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, col='blue',
    	 main='Simulations')
	points(t,y, pch=19, cex=1)
	legend("topleft", legend=round(th,2))
	dev.off()
}

# posteriors
tit <- c("Rejection sampling", "Gibbs sampling")
pdf("posterior.pdf", height=5, width=10)
set.seed(2)
par(mfrow=c(1,2))
for (i in 1:2) {
	hist(rgamma(1e3, 11, 10), 50, main=tit[i], freq=F, xlab=expression(theta),
    	 ylab=expression(paste("p(",theta,"|y)")))
	curve(dgamma(x,11,10), add=T, col='red', lwd=2)
	legend("topright", "Truth", lwd=2, col='red')
}
dev.off()


# abc
pdf("abc1.pdf", width=10,height=5)
set.seed(2)
par(mar=c(5,5,5,2)+.1)
plot(cumsum(c(0,tau.true)),0:20, type='s', xlab='Time', ylab='# molecules', xlim=c(0,10),
     ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, col='blue',
     main='Simulations')
points(t,y, pch=19, cex=1)
lines(sort(cumsum(c(0,tau.true+rnorm(length(tau),0,.3)))),0:20, type='s', col='blue', lwd=2)
lines(sort(cumsum(c(0,tau.true+rnorm(length(tau),0,.3)))),0:20, type='s', col='blue', lwd=2)
lines(cumsum(c(0,tau.true*2)),0:20, type='s', col='red', lwd=2)
lines(cumsum(c(0,tau.true/2)),0:20, type='s', col='red', lwd=2)
dev.off()

# ABC Rejection sampling
a <- b <- 100
d <- 10
set.seed(2)
n.reps <- 1e1
for (i in 1:n.reps) {
	success <- FALSE
	th <- rgamma(1,a,b)
	tau <- rexp(20, th)
	yy <- c()
	for (tt in t) yy[tt+1] <- sum(cumsum(tau)<tt)
	if (sum(abs(y-yy))<=d) success <- TRUE
	pdf(paste("abc-rej-",i-1,".pdf",sep=''))
	par(mar=c(5,5,5,2)+.1)
	plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', 
	     xlim=c(0,10),
     	 ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, 
     	 col=ifelse(success,'blue','red'), main='Simulations')
	points(t,y, pch=19, cex=1)
	legend("topleft", legend=round(th,2), cex=2)
	dev.off()
}

a <- b <- 1
d <- seq(0,50,by=5)
n.reps <- 1e3
success <- rep(0,length(d))
theta <- matrix(NA,n.reps,length(d))
for (j in 1:length(d)) {
	for (i in 1:n.reps) {
		th <- rgamma(1,a,b)
		tau <- rexp(20, th)
		for (tt in t) yy[tt+1] <- sum(cumsum(tau)<tt)
		if (sum(abs(y-yy))<=d[j]) {
			success[j] <- success[j]+1
			theta[i,j] <- th
		}
	}
}
p <- success/n.reps
pdf("abc-rej-acc.pdf")
par(mar=c(5,5,0,0)+.1)
plot(d, p, type='p', pch=19, xlab=expression(epsilon),
     ylab='Acceptance rate', cex.lab=1.5, cex.axis=1.5, ylim=c(0,1))
segments(d,p-2*sqrt(p*(1-p)/n.reps),d,p+2*sqrt(p*(1-p)/n.reps))
dev.off()

pdf("abc-rej-post.pdf")
par(mar=c(5,4,4,0)+.1, mfrow=c(2,2))
for (j in 1:4) {
	hist(theta[,2*j], 50, freq=F, xlab='', ylab='', xlim=c(0,2.5), ylim=c(0,2),   
		 main=paste('e=',d[2*j]))
	curve(dgamma(x, 1, 1), add=T, col='seagreen', lwd=2)
	curve(dgamma(x, 11, 10), add=T, col='blue', lwd=2)
	if(j==2) legend("topright",c("Prior","Posterior (truth)"), lty=1, lwd=2, 
	                col=c("seagreen","blue"))
}
dev.off()


# ABC Gibbs sampling - again this is faked Gibbs sampling
a <- b <- 100
d <- 10
set.seed(2)
n.reps <- 5
th <- rgamma(1,a,b)
for (i in 1:n.reps) {
	th.old <- th
	success <- FALSE
	while (!success) {
		th <- rgamma(1,a,b)
		tau <- rexp(20, th)
		yy <- c()
		for (tt in t) yy[tt+1] <- sum(cumsum(tau)<tt)
		if (sum(abs(y-yy))<=d) success <- TRUE
	}
	pdf(paste("abc-gibbs-",2*i-1,".pdf",sep=''))
	par(mar=c(5,5,5,2)+.1)
	plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', 
	     xlim=c(0,10),
     	 ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, 
     	 col=ifelse(success,'blue','red'), main='Simulations')
	points(t,y, pch=19, cex=1)
	legend("topleft", legend=round(th,2), cex=2)
	dev.off()
	pdf(paste("abc-gibbs-",2*i-2,".pdf",sep=''))
	par(mar=c(5,5,5,2)+.1)
	plot(cumsum(c(0,tau)),0:20, type='s', xlab='Time', ylab='# molecules', 
	     xlim=c(0,10),
     	 ylim=c(0,12), lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, 
     	 col=ifelse(success,'blue','red'), main='Simulations')
	points(t,y, pch=19, cex=1)
	legend("topleft", legend=round(th.old,2), cex=2)
	dev.off()
}


############################ Reversible isomerization ##########################
t <- 0:10
y <- c(5,6,5,4,4,5,6,5,5,6,5)
pdf("rev-isom.pdf", width=10, height=3)
plot(t,y, ylim=c(2,8), pch=19, xlab='Time', ylab='# molecules', 
     lwd=2, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, main='Reversible isomerization')
points(t, 10-y, pch=19, col='red')
legend("topright", c(expression(S[1]), expression(S[2])), pch=19, col=1:2)
dev.off()

