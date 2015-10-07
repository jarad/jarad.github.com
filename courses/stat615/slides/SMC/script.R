source("functions.R")

set.seed(2)

# Parameters
dBeta = 0.95
dAlpha = 0.05
dV = 0.05
dW = 0.05
dM0 = dAlpha/(1-dBeta)
dC0 = dW/(1-dBeta^2)
nSamples = 1e5

# Data
nT = 1000
adY = rep(NA,nT)
adX = rep(NA,nT)
adX[1] = rnorm(1,dM0,sqrt(dC0))
adY[1] = rnorm(1,adX[1],sqrt(dV))
for (i in 2:nT) {
  adX[i] = rnorm(1,dAlpha+dBeta*adX[i-1],sqrt(dW))
  adY[i] = rnorm(1,adX[i],sqrt(dV))
}

# Monte Carlo sampling
dC1 = 1/(1/dC0+1/dV)
dM1 = (dM0/dC0+adY[1]/dV)*dC1
lMonteCarloSamples = fMonteCarlo(nSamples,function(x) rnorm(x,dM1,sqrt(dC1)))
lMonteCarloDensity = density(lMonteCarloSamples$adDraws)

dMCmean = mean(lMonteCarloSamples$adDraws)
dMCvar = sum((lMonteCarloSamples$adDraws-dMCmean)^2)/nSamples^2
var(lMonteCarloSamples$adDraws)

# Importance sampling
lImportanceSamplingSamples = fImportanceSampling(nSamples,
  function(x) dnorm(adY[1],x,sqrt(dV),log=T),
  function(x) 0,
  function(x) rnorm(x,dM0,sqrt(dC0)))
lImportanceSamplingDensity = density(lImportanceSamplingSamples$adDraws,
  weights = lImportanceSamplingSamples$adWeights)

dISmean = weighted.mean(lImportanceSamplingSamples$adDraws,lImportanceSamplingSamples$adWeights)
lImportanceSamplingSamples$adWeights%*%(lImportanceSamplingSamples$adDraws-dISmean)^2

# Kalman filter
lKalmanFilter = fKalmanFilter1(adY-dAlpha,dM0,dC0,1,dBeta,dV,dW)
lKalmanFilter$vdPosteriorMean = lKalmanFilter$vdPosteriorMean + dAlpha
#lKalmanFilter$vdPriorMean = lKalmanFilter$vdPriorMean + dAlpha


# Sequential importance sampling
nParticles = 20
lSequentialImportanceSampling = fSequentialImportanceSampling(
  adY, 
  function(y,x) dnorm(y,x,sqrt(dV),log=T), 
  function(x) dAlpha+dBeta*x+rnorm(length(x),0,sqrt(dW)), 
  rnorm(nParticles,dM0,sqrt(dC0)), 
  rep(1,nParticles,nParticles))
  
# Sequential Importance Sampling with Resampling (bootstrap filter)
lBootstrapFilter = fBootstrapFilter(
  adY, 
  function(y,x) dnorm(y,x,sqrt(dV),log=T), 
  function(x) dAlpha+dBeta*x+rnorm(length(x),0,sqrt(dW)), 
  rnorm(nParticles,dM0,sqrt(dC0)), 
  rep(1/nParticles,nParticles)
)

# Auxiliary Particle Filter with no resampling
lAuxiliaryParticleFilter = fAuxiliaryParticleFilter(
  adY, 
  function(y,x) dnorm(y,x,sqrt(dV),log=T), 
  function(x) dAlpha+dBeta*x+rnorm(length(x),0,sqrt(dW)),
  function(x) dAlpha+dBeta*x, 
  rnorm(nParticles,dM0,sqrt(dC0)), 
  rep(1/nParticles,nParticles)
)

# Sequential Importance Sampling with Resampling (bootstrap filter)
nParticles = 30    
adInitialX = rnorm(nParticles,dM0,sqrt(dC0))
adInitialW = 1/rgamma(nParticles,shape=11,rate=0.5)
adInitialV = 1/rgamma(nParticles,shape=11,rate=0.5)
adInitialA = rnorm(nParticles,0.05,sqrt(adInitialW))
adInitialB = rnorm(nParticles,0.95,sqrt(adInitialW))

lMultivariateBootstrapFilter = fMultivariateBootstrapFilter(
  adY[1:100], 
  function(y,x) dnorm(y,x[,1],sqrt(x[,5]),log=T), 
  function(x) cbind(x[,2]+x[,3]*x[,1]+rnorm(length(x[,1]),0,sqrt(x[,4])),x[,2:5]), 
  cbind(adInitialX,adInitialA,adInitialB,adInitialW,adInitialV), 
  rep(1/nParticles,nParticles)
)
