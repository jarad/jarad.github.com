sample_mu = function(theta, varsigma, prior) {
  Cp = 1/(1/prior$C+sum(1/varsigma))
  mp = Cp*(prior$m/prior$C+sum(theta/varsigma))
  return(rnorm(1, mp, Cp))
}

sample_sigma2 = function(y, group, theta, prior) {
  ap = prior$a + length(y)/2
  bp = prior$b + sum((y[group]-theta[group])^2)/2
  return(1/rgamma(1,ap,bp))
}

sample_theta = function(ybar, n, sigma2, mu, varsigma, model, prior) {
  zero = rep(FALSE, length(ybar))
  if (model %in% c('point-normal','point-t')) {
    log_py0 = log(  prior$p) + dnorm(ybar, 0, sqrt(sigma2/n), log=TRUE)
    log_py1 = log(1-prior$p) + dnorm(ybar, mu, sqrt((sigma2+varsigma)/2), log=TRUE)
    mx = pmax(log_py0, log_py1)
    pp = exp(log_py0-mx)/(exp(log_py0-mx)+exp(logpy1-mx))
    zero[which(rbinom(length(pp), 1, pp)==1)] = TRUE
  }
  
  Cp = 1/(1/varsigma + n/sigma2)
  mp = Cp*(mu/varsigma + ybar*n/sigma2)
  theta = rnorm(length(Cp), mp, sqrt(Cp))
  theta[zero] = 0
  return(theta)
}

sample_pi = function(theta, model, prior) {
  if (model %in% c('point-normal','point-t')) {
    n = length(theta)
    n_zero = sum(which(theta==0))
    rbeta(1, prior$s+n_zero, prior$f+n-n_zero)
  } else {
    return(NA)
  }
}

sample_varsigma = function(theta, mu, tau, model, prior) {
  I = length(theta)
  tau2 = tau^2
  zero = theta==0
  
  require(mgcv)
  switch(model,
         normal = {
           return(tau)
         },
         laplace = {
           # inverse gaussian
           mn = 1/(tau*sqrt((theta-mu)^2))
           return(ifelse(zero, rexp(1/(2*tau2)),1/rig(I, mn, tau^2)))
         }, 
         t = {
           # inverse gamma
           ap = (prior$v+1)/2
           bp = (tau2 + sum((theta-mu)^2))/2
           return(ifelse(zero, 1/rgamma(prior$v/2, tau2/2), 1/rgamma(I, ap, bp)))
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




mcmc = function(n_reps, d, prior, model, initial=NULL) {
  require(plyr) 
  require(mgcv)
  
  I = length(initial$theta)
  ss = ddply(d, .(group), summarize, n = length(y), mean=mean(y))
  
  # Saving structures
  keep = list(sigma    = rep(NA, n_reps),
              mu       = rep(NA, n_reps),
              tau      = rep(NA, n_reps),
              theta    = matrix(NA, nrow=n_reps, ncol=I),
              varsigma = matrix(NA, nrow=n_reps, ncol=I))
  
  # Initialize
  sigma2   = ifelse(is.null(initial$sigma)   , 1          , initial$sigma)^2
  theta    = ifelse(is.null(initial$theta)   , ss$mean    , initial$theta)
  pi       = ifelse(is.null(initial$pi)      , 0.5        , initial$pi)
  varsigma = ifelse(is.null(initial$varsigma), rep(1, I)  , initial$varsigma)
  mu       = ifelse(is.null(initial$mu)      , mean(theta), initial$mu)
  tau      = ifelse(is.null(initial$tau)     , sd(theta)  , initial$tau)
  zero = theta==0
  
  # Run MCMC
  for (i in 1:n_reps) {
    
    sigma2   = sample_sigma2(d$y, d$group, theta, prior)
    theta    = sample_theta(ss$mean, ss$n, sigma2, mu, varsigma, model, prior)
    zero     = theta==0
    pi       = sample_pi(theta, model, prior)
    varsigma = sample_varsigma(theta, mu, tau, model)
    mu       = sample_mu(theta, varsigma, prior)
    tau      = sample_tau(varsigma, theta, mu, tau, model, prior)
    
    # Save values
    keep$sigma[i]     = sqrt(sigma2)
    keep$theta[i,]    = theta
    keep$pi           = pi
    keep$varsigma[i,] = varsigma
    keep$mu[i]        = mu
    keep$tau[i]       = tau
  }
  
  return(keep)
}


I = 10
theta = rnorm(I)
theta[1:3] = 0
n_per_group = 5
group = rep(1:I, each=n_per_group)
d = data.frame(y = rnorm(I*n_per_group), group=group)

prior = list(a = 1, b = 1, m = 0, C = 1, s = 1, f = 1, c = 1)

r = mcmc(1000, d, prior, 'normal')


