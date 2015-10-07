# Sequential Monte Carlo methods

fMarkovChainMonteCarlo = function(nReps, adY, dM0, dC0, dAlpha, dBeta, dW, dV) {
  
}

fMonteCarlo = function(nDraws,fProposalDraw) {
  # Take nDraws draws from fProposalDraw
  return(list(adDraws=fProposalDraw(nDraws)))
}

################### Measures of weight variation #########################
fEffectiveSampleSize = function(adWeights) {
  return(1/(sum(adWeights^2)))
}

fCoefficientOfVariation = function(adWeights) {
  nParticles = length(adWeights)
  return(sqrt(sum((nParticles*adWeights-1)^2)/nParticles))
}

fEntropy = function(adWeights) {
  return(-sum(adWeights*og2(adWeights)))
}

######################### Renormalizing functions ######################
fRenormalizeWeights = function(adWeights) {
  return(adWeights/sum(adWeights))
}

fRenormalizeLogWeights = function(adLogWeights) {
  # Takes LogWeights and returns Weights
  adLogWeights = adLogWeights-max(adLogWeights) # for numerical stability
  
  return(fRenormalizeWeights(exp(adLogWeights)))
}

fImportanceSampling = function(nDraws,fLogTargetDensity,fLogProposalDensity,
                               fProposalDraw,adCurrentWeights=rep(1/nDraws,nDraws)) {
                               
  adDraws      = fProposalDraw(nDraws)
  adLogWeights = fLogTargetDensity(adDraws) - fLogProposalDensity(adDraws)+log(adCurrentWeights)
  adWeights    = fRenormalizeLogWeights(adLogWeights)
  
  return(list(adDraws=adDraws,adWeights=adWeights))
}

fSequentialImportanceSampling = function(adY, fLogTargetDensity, fProposalDraw, 
                                         adInitialParticles, adInitialWeights) {
  nT         = length(adY)
  nParticles = length(adInitialParticles)
  
  mdParticles = matrix(NA,nT,nParticles)
  mdWeights   = matrix(NA,nT,nParticles)
  
  mdParticles[1,] = fProposalDraw(adInitialParticles)
  mLogWeights     = fLogTargetDensity(adY[1],mdParticles[1,])+log(adInitialWeights)
  mdWeights[1,]   = fRenormalizeLogWeights(mLogWeights)
  
  for (i in 2:nT) {
    mdParticles[i,] = fProposalDraw(mdParticles[i-1,])
    mLogWeights     = fLogTargetDensity(adY[i],mdParticles[i,])+log(mdWeights[i-1,])
    mdWeights[i,]   = fRenormalizeLogWeights(mLogWeights)    
  }
  
  return(list(mdParticles = mdParticles, mdWeights = mdWeights))
}
               
fKalmanFilter1 = function(vdY,dM0,dC0,dF,dG,dV,dW) {
  # Kalman filter for scalar data and constant scalars F, G, V, and W
  nT              = length(vdY)
  nStateDimension = length(dM0) 
  
  vdPriorMean          = rep(NA,nT)
  vdPriorVariance      = rep(NA,nT)
  vdPredictiveMean     = rep(NA,nT)
  vdPredictiveVariance = rep(NA,nT)  
  vdKalmanGain         = rep(NA,nT)
  vdForecastError      = rep(NA,nT)
  vdPosteriorMean      = rep(NA,nT)
  vdPosteriorVariance  = rep(NA,nT)
  
  vdPriorMean[1]          = dG*dM0
  vdPriorVariance[1]      = dG^2*dC0+dW
  vdPredictiveMean[1]     = dF*vdPriorMean[1]
  vdPredictiveVariance[1] = dF^2*vdPriorVariance[1]*dF+dV
  vdKalmanGain[1]         = vdPriorVariance[1]*dF/vdPredictiveVariance[1]
  vdForecastError[1]      = vdY[1]-vdPredictiveMean[1]
  vdPosteriorMean[1]      = vdPriorMean[1]+vdKalmanGain[1]*vdForecastError[1]
  vdPosteriorVariance[1]  = vdPriorVariance[1]-vdKalmanGain[1]^2*vdPredictiveVariance[1]

  for (i in 2:nT) {
    vdPriorMean[i]          = dG*vdPosteriorMean[i-1]
    vdPriorVariance[i]      = dG^2*vdPosteriorVariance[i-1]+dW
    vdPredictiveMean[i]     = dF*vdPriorMean[i]
    vdPredictiveVariance[i] = dF^2*vdPriorVariance[i]*dF+dV
    vdKalmanGain[i]         = vdPriorVariance[i]*dF/vdPredictiveVariance[i]
    vdForecastError[i]      = vdY[i]-vdPredictiveMean[i]
    vdPosteriorMean[i]      = vdPriorMean[i]+vdKalmanGain[i]*vdForecastError[i]
    vdPosteriorVariance[i]  = vdPriorVariance[i]-vdKalmanGain[i]^2*vdPredictiveVariance[i]
  }
  
  return(list(vdPriorMean=vdPriorMean,vdPriorVariance=vdPriorVariance,
              vdPredictiveMean=vdPredictiveMean,vdPredictiveVariance=vdPredictiveVariance,
              vdKalmanGain=vdKalmanGain,vdForecastError=vdForecastError,
              vdPosteriorMean=vdPosteriorMean,vdPosteriorVariance=vdPosteriorVariance))        
}


########################### Resampling functions ################################
# All take particle weights and return resampled indices
fMultinomialResampling = function(adWeights,nSamples=length(adWeights)) {
  nBins = length(adWeights)
  return(sample(1:nBins,nSamples,replace=T,prob=adWeights))
}

fResidualResampling = function(adWeights) {
  nParticles = length(adWeights)
  adExpectedSamples = nParticles*adWeights
  adFloor = floor(adExpectedSamples)
  
  adIndices = NULL
  for (i in 1:nParticles) {
    adIndices = c(adIndices,rep(i,adFloor[i]))
  }
  adResidualIndices = fMultinomialResampling((adExpectedSamples-adFloor)/(nParticles-sum(adFloor)),nParticles-sum(adFloor))
  
  return(c(adIndices,adResidualIndices))
}

fInverseCDF = function(adWeights,adUniforms) {
  nParticles             = length(adWeights)
  adIndices              = rep(NA,nParticles)
  adWeightsCumulativeSum = cumsum(adWeights)
  
  for (i in 1:nParticles) {
    dIndex = 1
    bFound = FALSE
    while (!bFound) {
      if (adUniforms[i]>adWeightsCumulativeSum[dIndex]) {
        dIndex = dIndex+1
      } else {
        bFound = TRUE
      }
    }
    adIndices[i] = dIndex
  }
  return(adIndices)  
}

fStratifiedResampling = function(adWeights) {
  nParticles   = length(adWeights)
  adLowerBound = (1:nParticles-1)/nParticles
  adUs         = runif(nParticles,adLowerBound,adLowerBound+1/nParticles)
  
  return(fInverseCDF(adWeights,adUs))
}

fSystematicResampling = function(adWeights) {
  nParticles        = length(adWeights)
  adUs               = rep(NA,nParticles)
  adUs[1]            = runif(1,0,1/nParticles)
  adUs[2:nParticles] = adUs[1]+(1:(nParticles-1))/nParticles
  
  return(fInverseCDF(adWeights,adUs))
}

##########################################################################
# Sequential importance sampling with resampling
fBootstrapFilter = function(adY, fLogTargetDensity, fProposalDraw, 
                            adInitialParticles, adInitialWeights, 
                            fResampling=fMultinomialResampling) {
  nT         = length(adY)
  nParticles = length(adInitialParticles)
  
  mdParticles        = matrix(NA,nT,nParticles)
  mdWeights          = matrix(NA,nT,nParticles)
  mnResampledIndices = matrix(NA,nT,nParticles)
  
  mnResampledIndices[1,] = 1:nParticles
  mdParticles[1,]        = fProposalDraw(adInitialParticles[mnResampledIndices[1,]])
  mLogWeights            = fLogTargetDensity(adY[1],mdParticles[1,])
  mdWeights[1,]          = fRenormalizeLogWeights(mLogWeights)
  
  for (i in 2:nT) { 
    mnResampledIndices[i,] = fResampling(mdWeights[i-1,])
    mdParticles[i,]        = fProposalDraw(mdParticles[i-1,mnResampledIndices[i,]])
    mLogWeights            = fLogTargetDensity(adY[i],mdParticles[i,])
    mdWeights[i,]          = fRenormalizeLogWeights(mLogWeights)    
  }
  
  return(list(mdParticles = mdParticles, mdWeights = mdWeights, 
              mnResampledIndices = mnResampledIndices))
}
            
######################################################################
fAuxiliaryParticleFilter = function(adY, fLogTargetDensity, fProposalDraw,
                            fPointEstimate, adInitialParticles, adInitialWeights, 
                            fResampling=fMultinomialResampling) {
                            
  nT         = length(adY)
  nParticles = length(adInitialParticles)
  
  mdParticles        = matrix(NA,nT,nParticles)
  mdWeights          = matrix(NA,nT,nParticles)
  mnResampledIndices = matrix(NA,nT,nParticles)
  
  adPointEstimates       = fPointEstimate(adInitialParticles)
  adPredictedLogDensity  = fLogTargetDensity(adY[1],adPointEstimates)
  adNewWeights           = fRenormalizeLogWeights(adPredictedLogDensity+log(adInitialWeights))
  mnResampledIndices[1,] = sample(1:nParticles,nParticles,prob=adNewWeights,replace=T)
  mdParticles[1,]        = fProposalDraw(adInitialParticles[mnResampledIndices[1,]])
  mLogWeights            = fLogTargetDensity(adY[1],mdParticles[1,])-adPredictedLogDensity[mnResampledIndices[1,]]
  mdWeights[1,]          = fRenormalizeLogWeights(mLogWeights)
  
  for (i in 2:nT) { 
    adPointEstimates       = fPointEstimate(mdParticles[i-1,])
    adPredictedLogDensity  = fLogTargetDensity(adY[i],adPointEstimates)
    adNewWeights           = fRenormalizeLogWeights(adPredictedLogDensity+log(mdWeights[i-1,]))
    mnResampledIndices[i,] = sample(1:nParticles,nParticles,prob=adNewWeights,replace=T)
    mdParticles[i,]        = fProposalDraw(adInitialParticles[mnResampledIndices[i,]])
    mLogWeights            = fLogTargetDensity(adY[i],mdParticles[i,])-adPredictedLogDensity[mnResampledIndices[i,]]
    mdWeights[i,]          = fRenormalizeLogWeights(mLogWeights) 
  }
  
  return(list(mdParticles = mdParticles, mdWeights = mdWeights, 
              mnResampledIndices = mnResampledIndices))
}


# Bootstrap filter for multivariate state
fMultivariateBootstrapFilter = function(adY, fLogTargetDensity, fProposalDraw, 
                            mdInitialParticles, adInitialWeights, 
                            fResampling=fMultinomialResampling) { 
  
  nT          = length(adY)
  nParticles  = nrow(mdInitialParticles)  
  nParameters = ncol(mdInitialParticles)
  
  adParticles        = array(NA,dim=c(nT,nParticles,nParameters))
  mdWeights          = matrix(NA,nT,nParticles)
  mnResampledIndices = matrix(NA,nT,nParticles)
  
  mnResampledIndices[1,] = 1:nParticles    
  adParticles[1,,]       = fProposalDraw(mdInitialParticles[mnResampledIndices[1,],])
  mLogWeights            = fLogTargetDensity(adY[1],adParticles[1,,])
  mdWeights[1,]          = fRenormalizeLogWeights(mLogWeights)
  
  for (i in 2:nT) { 
    mnResampledIndices[i,] = fResampling(mdWeights[i-1,])
    adParticles[i,,]       = fProposalDraw(adParticles[i-1,mnResampledIndices[i,],])
    mLogWeights            = fLogTargetDensity(adY[i],adParticles[i,,])
    mdWeights[i,]          = fRenormalizeLogWeights(mLogWeights)    
  }
  
  return(list(adParticles = adParticles, mdWeights = mdWeights, 
              mnResampledIndices = mnResampledIndices))
}
        

########################################################################
# Kernel density sampling
fKernelDensitySampling = function(mdParticles,adWeights,dDiscountFactor=0.99) {
  library(mvtnorm)
  dA = (3*dDiscountFactor-1)/(2*dDiscountFactor)
  dH2 = 1-dA^2
  
  lWeightedCovariance = cov.wt(mdParticles,adWeights,method="ML")
  nParticles          = lWeightedCovariance$n.obs
  mdMixtureMeans      = dA*mdParticles+(1-dA)*lWeightedCovariance$center   
  mdShrunkCovariance  = dH2*lWeightedCovariance$cov
  anSampledIndices    = sample(1:nParticles,nParticles,prob=adWeights,replace=T)
  
  mdSamples = NA*mdParticles
  for (i in 1:nParticles) {
    mdSamples[i,] = rmvnorm(1,mdMixtureMeans[anSampledIndices[i],],mdShrunkCovariance)
  }
  
  return(mdSamples=mdSamples)
}  
