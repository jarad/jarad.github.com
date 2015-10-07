setwd("figs/")

xrng = c(-0.4,1.1)
yrng = c(0,2)


pdf("MonteCarlo1a.pdf")
hist(lMonteCarloSamples$adDraws,100,freq=F,main='',xlab='',ylab='',ylim=yrng,xlim=xrng,border='blue')
dev.off()


pdf("MonteCarlo1b.pdf")
hist(lMonteCarloSamples$adDraws,100,freq=F,main='',xlab='',ylab='',ylim=yrng,xlim=xrng,border='blue')
lines(xx<-seq(min(xrng),max(xrng),by=.01),yy<-dnorm(xx,dM1,sqrt(dC1)),lwd=2)
dev.off()

pdf("MonteCarlo1c.pdf")
hist(lMonteCarloSamples$adDraws,100,freq=F,main='',xlab='',ylab='',ylim=yrng,xlim=xrng,border='blue')
lines(lMonteCarloDensity,lwd=2,col='blue')   
lines(xx,yy,lwd=2)
dev.off()

pdf("MonteCarlo1d.pdf")
plot(xx,yy,type='l',lwd=2,main='',xlab='',ylab='',ylim=yrng,xlim=xrng)   
lines(lMonteCarloDensity,lwd=2,col='blue')
dev.off()

pdf("ImportanceSampling1a.pdf")
plot(xx,yy,type='l',lwd=2,main='',xlab='',ylab='',ylim=yrng,xlim=xrng)   
lines(lMonteCarloDensity,lwd=2,col='blue')
dev.off()

pdf("ImportanceSampling1b.pdf")
plot(xx,yy,type='l',lwd=2,main='',xlab='',ylab='',ylim=yrng,xlim=xrng)   
lines(lMonteCarloDensity,lwd=2,col='blue')
lines(lImportanceSamplingDensity,col='red',lwd=2)
dev.off()

pdf("ImportanceSamplingWeights.pdf",height=240)
anOrderDraws = order(lImportanceSamplingSamples$adDraws)[floor(seq(1,nSamples,length.out=200))]
plot(lImportanceSamplingSamples$adDraws[anOrderDraws],
     lImportanceSamplingSamples$adWeights[anOrderDraws],xlab='',ylab='',main='',
     xlim=xrng)
dev.off()


nParticles <- 20
dResolutionMultiple = 1.5
#par(bg="white")
plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
  ylim=range(lSequentialImportanceSampling$mdParticles[1:10,]))
points(rep(1,nParticles),lSequentialImportanceSampling$mdParticles[1,],pch=19,
         cex=(lSequentialImportanceSampling$mdWeights[1,])^.5*2)
points(1-.25,adY[1],pch=23,bg='green',col=NA)
points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
legend("topright",inset=0.01, c("Data","Truth","Particles"), pch=c(23,23,19), pt.bg=c("green","red","black"), col=c("green","red","black"))
dev.copy2pdf(file="sis-0.pdf")
dev.off()      
#readline("Hit enter:")    
for (i in 2:10) {
  plot(0,0,type='n',main='',xlab='',ylab='',xlim=c(0,10), axes=F,
       ylim=range(lSequentialImportanceSampling$mdParticles[1:10,]))
  points(rep(i,nParticles),lSequentialImportanceSampling$mdParticles[i,],pch=19,
         cex=(lSequentialImportanceSampling$mdWeights[i,])^.5*2)
  for (j in 1:nParticles) {
    segments(i-1,lSequentialImportanceSampling$mdParticles[i-1,j],
             i  ,lSequentialImportanceSampling$mdParticles[i  ,j],
             lwd=(lSequentialImportanceSampling$mdWeights[i,j])^.3*2)
  }
  points(i-.25,adY[i],pch=23,bg='green',col=NA)  
  points(i-.2,lKalmanFilter$vdPosteriorMean[i],pch=23,bg='red',col=NA)
  dev.copy2pdf(file=paste("sis-",i-1,".pdf",sep=''))
  dev.off() 
  #readline("Hit enter:") 
}


# Bootstrap filter plot
plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
    ylim=range(lAuxiliaryParticleFilter$mdParticles[1:10,]))
points(rep(1,nParticles),lAuxiliaryParticleFilter$mdParticles[1,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[1,])^.5*2)
points(1-.25,adY[1],pch=23,bg='green',col=NA)  
points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
legend("bottomright",inset=0.01, c("Data","Truth","Particles"), pch=c(23,23,19), 
       pt.bg=c("green","red","black"), col=c("green","red","black"))
dev.copy2pdf(file="sir-0.pdf")
dev.off()      
#readline("Hit enter:")

adParticleIndices = 1:nParticles  
  
for (i in 2:10) {
  plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
    ylim=range(lAuxiliaryParticleFilter$mdParticles[1:10,]))
  points(rep(1,nParticles),lAuxiliaryParticleFilter$mdParticles[1,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[1,])^.5*2)
  points(1-.25,adY[1],pch=23,bg='green',col=NA)  
  points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
  adParticleIndices = 1:nParticles     
  for (ii in i:2) {
    points(rep(ii,nParticles),lAuxiliaryParticleFilter$mdParticles[ii,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[ii,])^.5*2)
    for (j in adParticleIndices) {
      segments(ii-1,lAuxiliaryParticleFilter$mdParticles[ii-1,lAuxiliaryParticleFilter$mnResampledIndices[ii,j]],
               ii  ,lAuxiliaryParticleFilter$mdParticles[ii  ,j],
               lwd=(lAuxiliaryParticleFilter$mdWeights[i,j])^.3*2)
    }
    points(ii-.25,adY[ii],pch=23,bg='green',col=NA)     
  points(ii-.2,lKalmanFilter$vdPosteriorMean[ii],pch=23,bg='red',col=NA)
    adParticleIndices = unique(lAuxiliaryParticleFilter$mnResampledIndices[ii,adParticleIndices])
  }
  legend("bottomright",inset=0.01, c("Data","Truth","Particles"), pch=c(23,23,19), 
       pt.bg=c("green","red","black"), col=c("green","red","black"))
  dev.copy2pdf(file=paste("sir-",i-1,".pdf",sep=''))
  dev.off()      
  #readline("Hit enter:")
  # dev.copy2pdf
}


# APF plot
plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
    ylim=range(lAuxiliaryParticleFilter$mdParticles[1:10,]))
points(rep(1,nParticles),lAuxiliaryParticleFilter$mdParticles[1,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[1,])^.5*2)
points(1-.25,adY[1],pch=23,bg='green',col=NA)  
points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
legend("bottomright",inset=0.01, c("Data","Truth","Particles"), pch=c(23,23,19), 
       pt.bg=c("green","red","black"), col=c("green","red","black"))
dev.copy2pdf(file="apf-0.pdf")
dev.off()      
#readline("Hit enter:")

adParticleIndices = 1:nParticles  
  
for (i in 2:10) {
  plot(0,0,type='n',main='',xlab='t',ylab=expression(x[t]),xlim=c(0,10),
    ylim=range(lAuxiliaryParticleFilter$mdParticles[1:10,]))
  points(rep(1,nParticles),lAuxiliaryParticleFilter$mdParticles[1,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[1,])^.5*2)
  points(1-.25,adY[1],pch=23,bg='green',col=NA)  
  points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
  adParticleIndices = 1:nParticles     
  for (ii in i:2) {
    points(rep(ii,nParticles),lAuxiliaryParticleFilter$mdParticles[ii,],pch=19,
           cex=(lAuxiliaryParticleFilter$mdWeights[ii,])^.5*2)
    for (j in adParticleIndices) {
      segments(ii-1,lAuxiliaryParticleFilter$mdParticles[ii-1,lAuxiliaryParticleFilter$mnResampledIndices[ii,j]],
               ii  ,lAuxiliaryParticleFilter$mdParticles[ii  ,j],
               lwd=(lAuxiliaryParticleFilter$mdWeights[i,j])^.3*2)
    }
    points(ii-.25,adY[ii],pch=23,bg='green',col=NA)     
  points(ii-.2,lKalmanFilter$vdPosteriorMean[ii],pch=23,bg='red',col=NA)
    adParticleIndices = unique(lAuxiliaryParticleFilter$mnResampledIndices[ii,adParticleIndices])
  }
  legend("bottomright",inset=0.01, c("Data","Truth","Particles"), pch=c(23,23,19), 
       pt.bg=c("green","red","black"), col=c("green","red","black"))
  dev.copy2pdf(file=paste("apf-",i-1,".pdf",sep=''))
  dev.off()      
  #readline("Hit enter:")
  # dev.copy2pdf
}


# # ????????????
# for (i in 2:10) {
#   plot(0,0,type='n',main='',xlab='',ylab='',xlim=c(0,10),
#     ylim=range(lMultivariateBootstrapFilter$adParticles[1:10,]))
#     points(rep(1,nParticles),lMultivariateBootstrapFilter$adParticles[1,],pch=19,
#            cex=(lMultivariateBootstrapFilter$mdWeights[1,])^.5*2)
#     points(1-.2,adY[1],pch=23,bg='green',col=NA)  
#     points(1-.2,lKalmanFilter$vdPosteriorMean[1],pch=23,bg='red',col=NA)
#     adParticleIndices = 1:nParticles 
#     #dev.copy(pdf,filename=paste("MBF",1,".pdf",sep=''),bg="white",
#     #     width=480*dResolutionMultiple,height=480*dResolutionMultiple)
#     #dev.off()    
#   for (ii in i:2) {
#     points(rep(ii,nParticles),lMultivariateBootstrapFilter$mdParticles[ii,],pch=19,
#            cex=(lMultivariateBootstrapFilter$mdWeights[ii,])^.5*2)
#     for (j in adParticleIndices) {
#       segments(ii-1,lMultivariateBootstrapFilter$adParticles[ii-1,lMultivariateBootstrapFilter$mnResampledIndices[ii,j]],
#                ii  ,lMultivariateBootstrapFilter$adParticles[ii  ,j],
#                lwd=(lMultivariateBootstrapFilter$mdWeights[i,j])^.3*2)
#     }
#     points(ii-.2,adY[ii],pch=23,bg='green',col=NA)   
#     points(ii-.2,lKalmanFilter$vdPosteriorMean[ii],pch=23,bg='red',col=NA)
#     adParticleIndices = unique(lMultivariateBootstrapFilter$mnResampledIndices[ii,adParticleIndices])
#   }                   
#   #dev.copy(pdf,filename=paste("MBF",i,".pdf",sep=''),bg="white",
#   #       width=480*dResolutionMultiple,height=480*dResolutionMultiple)
#   #dev.off()    
#   readline("Hit enter:")
#   # dev.copy2pdf
# }


# SIR with fixed parameters
nParticles <- 30
dResolutionMultiple = 1
#par(bg="white")

par(mfrow=c(2,2))
for (nParam in 2:5) {
plot(0,0,type='n',main='',xlab='t',ylab='',xlim=c(0,10),
    ylim=range(lMultivariateBootstrapFilter$adParticles[1:10,,nParam]))
  if (nParam != 3) { abline(h=0.05,col='red') } else { abline(h=0.95,col='red') }
  points(rep(1,nParticles),lMultivariateBootstrapFilter$adParticles[1,,nParam],pch=19,
           cex=(lMultivariateBootstrapFilter$mdWeights[1,])^.5*2)
}
dev.copy2pdf(file="MBF-0.pdf")
dev.off()    

adParticleIndices = 1:nParticles 
for (i in 2:10) {
  par(mfrow=c(2,2))
  for (nParam in 2:5) {
  plot(0,0,type='n',main='',xlab='t',ylab='',xlim=c(0,10),
         ylim=range(lMultivariateBootstrapFilter$adParticles[1:10,,nParam]))
  if (nParam != 3) { abline(h=0.05,col='red') } else { abline(h=0.95,col='red') }
  for (ii in i:2) {
    points(rep(ii,nParticles),lMultivariateBootstrapFilter$adParticles[ii,,nParam],pch=19,
           cex=(lMultivariateBootstrapFilter$mdWeights[ii,])^.5*2)
    for (j in adParticleIndices) {
      segments(ii-1,lMultivariateBootstrapFilter$adParticles[ii-1,lMultivariateBootstrapFilter$mnResampledIndices[ii,j],nParam],
               ii  ,lMultivariateBootstrapFilter$adParticles[ii  ,j,nParam],
               lwd=(lMultivariateBootstrapFilter$mdWeights[i,j])^.3*2)
    }
    adParticleIndices = unique(lMultivariateBootstrapFilter$mnResampledIndices[ii,adParticleIndices])
  }            
  #readline("Hit enter:")
  }        
  dev.copy2pdf(file=paste("MBF-",i-1,".pdf",sep=''))
  dev.off()   
}



# Kernel density example
adRandomPoints = rnorm(10)
adRandomPointWeights = fRenormalizeWeights(runif(10))
dDelta = 0.99
dH2 = 1-((3*dDelta-1)/(2*dDelta))^2
dA = sqrt(1-dH2)
dMean = weighted.mean(adRandomPoints,adRandomPointWeights)
dVar = 0
for (i in 1:10) dVar= dVar+adRandomPointWeights[i]*(adRandomPoints[i]-dMean)^2
adShrunkMean = dA*adRandomPoints+(1-dA)*dMean

xx = seq(min(adRandomPoints)-0.5,max(adRandomPoints)+0.5,by=0.01)
plot(0,0,type='n',xlim=range(xx),ylim=c(0,max(adRandomPointWeights)+0.1),
     xlab='',ylab='',main='',axes=F,frame.plot=T)       
segments(adRandomPoints,rep(0,10),adRandomPoints,adRandomPointWeights)  
adDensity = rep(0,length(xx))
for (i in 1:10) {
  points(adRandomPoints[i],adRandomPointWeights[i])  
  points(adShrunkMean[i],adRandomPointWeights[i],col='red') 
  adThisDensity = 0.2*adRandomPointWeights[i]*dnorm(xx,adShrunkMean[i],sqrt(dH2*dVar))
  lines(xx,adThisDensity,col='red')
  adDensity = adDensity+adThisDensity
}
lines(xx,adDensity,lwd=2,col='red')
dev.copy2pdf(file="KernelDensity1.pdf"); dev.off()


dDelta = 0.85
dH2 = 1-((3*dDelta-1)/(2*dDelta))^2
dA = sqrt(1-dH2)
dMean = weighted.mean(adRandomPoints,adRandomPointWeights)
dVar = 0
for (i in 1:10) dVar= dVar+adRandomPointWeights[i]*(adRandomPoints[i]-dMean)^2
adShrunkMean = dA*adRandomPoints+(1-dA)*dMean

xx = seq(min(adRandomPoints)-0.5,max(adRandomPoints)+0.5,by=0.01)
plot(0,0,type='n',xlim=range(xx),ylim=c(0,max(adRandomPointWeights)+0.1),
     xlab='',ylab='',main='',axes=F,frame.plot=T)       
segments(adRandomPoints,rep(0,10),adRandomPoints,adRandomPointWeights)  
adDensity = rep(0,length(xx))
for (i in 1:10) {
  points(adRandomPoints[i],adRandomPointWeights[i])  
  points(adShrunkMean[i],adRandomPointWeights[i],col='red') 
  adThisDensity = 0.2*adRandomPointWeights[i]*dnorm(xx,adShrunkMean[i],sqrt(dH2*dVar))
  lines(xx,adThisDensity,col='red')
  adDensity = adDensity+adThisDensity
}
lines(xx,adDensity,lwd=2,col='red')
dev.copy2pdf(file="KernelDensity2.pdf"); dev.off()



setwd("../")
