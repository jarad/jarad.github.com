sample_theta = function(ybar, n, sigma2, mu, varsigma) {
  Cp = 1/(1/varsigma + n/sigma2)
  mp = Cp*(mu/varsigma + ybar*n/sigma2)
  rnorm(length(Cp), mp, sqrt(Cp))
}

sample_sigma2 = function(y, group, theta, prior) {
  ap = prior$a + length(y)/2
  bp = prior$b + sum((y[group]-theta[group])^2)/2
  return(1/rgamma(1,ap,bp))
}

sample_mu = function(theta, varsigma, prior) {
  Cp = 1/(sum(1/varsigma)+1/prior$C)
  mp = Cp*(sum(theta/varsigma)+prior$m/prior$C)
  return(rnorm(1, mp, Cp))
}

sample_varsigma = function(theta, mu, tau, model) {
  require(mgcv)
  switch(model,
         normal = {
           return(tau)
         },
         laplace = {
           # inverse gaussian
           mn = 1/(tau*sqrt((theta-mu)^2))
           return(1/rig(length(theta), mn, tau^2))
         }, 
         t = {
           # inverse gamma
           ap = (v+1)/2
           bp = (tau2 + sum((theta-mu)^2))/2
           return(1/rgamma(1, ap, bp))
         })
}

sample_tau = function(varsigma, theta, mu, tau_current, model, prior) {
  eta_current = tau_current^2
  
  eta_proposed = 
  switch(model,
         normal = {
           ap = length(theta)/2-1
           bp = sum((theta-mu)^2)/2
           1/rgamma(1,ap,bp)
         },
         laplace = {
           ap = length(varsigma)-1
           bp = sum(varsigma)/2
           1/rgamma(1,ap,bp)
         },
         t = {
           ap = length(varsigma)*prior$v/2+1
           bp = sum(1/varsigma)/2
           rgamma(1,ap,bp)
         })
  
  log_rho = 
    log(1+eta_current /prior$c^2) + log(eta_current )/2 -
    log(1+eta_proposed/prior$c^2) - log(eta_proposed)/2 
  return(sqrt(ifelse(log(runif(1)) < log_rho, eta_proposed, eta_current)))
}




mcmc = function(n_reps, d, initial, prior, model) {
  I = length(initial$theta)
  ss = ddply(d, .(group), summarize, n = length(y), mean=mean(y))
  
  # Saving structures
  keep = list(sigma    = rep(NA, n_reps),
              mu       = rep(NA, n_reps),
              tau      = rep(NA, nreps),
              theta    = matrix(NA, nrow=n_reps, ncol=I),
              varsigma = matrix(NA, nrow=n_reps, ncol=I))
  
  # Initialize
  sigma = initial$sigma
  mu = initial$mu
  tau = initial$tau
  theta = initial$theta
  
  # Run MCMC
  for (i in 1:n_reps) {
    
    varsigma = sample_varsigma(theta, mu, tau, model)
    sigma2   = sample_sigma2(d$y, d$group, theta, prior)
    theta    = sample_theta(ss$mean, ss$n, mu, varsigma)
    mu       = sample_mu(theta, varsigma, prior)
    tau      = sample_tau(varsigma, theta, mu, tau, model, prior)
    
    # Save values
    keep$sigma[i] = sqrt(sigma2)
    keep$mu[i] = mu
    keep$tau[i] = tau
    keep$theta[i,] = theta
    keep$varsigma[i,] = varsigma
  }
  
  return(keep)
}
