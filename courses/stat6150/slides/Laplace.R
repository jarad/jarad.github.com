#' Laplace (double exponential distribution)
#' 
#' Density, distribution function, quantile function, and random generation for the Laplace 
#' (double exponential) distribution with mean equal to mean and scale equal to sd.
#' 
#' @usage dlaplace(x, mean = 0, scale = 1, rate = 1/scale, log = FALSE)
#' @usage plaplace(q, mean = 0, scale = 1, rate = 1/scale, lower.tail = TRUE, log.p = FALSE)
#' @usage qlaplace(p, mean = 0, scale = 1, rate = 1/scale, lower.tail = TRUE, log.p = FALSE)
#' @usage rlaplace(n, mean = 0, scale = 1, rate = 1/scale)
#' 
#' @param x vector of quantiles.
#' @param n number of observations. If length(x) > 1, the length is taken to be the number required.
#' @param mean vector of means.
#' @param scale vector of scales.
#' 
#' @details The Laplace distribution has density ...
#' 
#' @return dlaplace gives the density, plaplace gives the distribution function, 
#'   qlaplace gives the quantile function, and rlaplace generates random deviates. 
#'   
#'   The length of the result is determined by n for rlaplace, and is the maximum 
#'   of the lengths of the numerical arguments for the other functions.
#'   
#'   The numerical arguments other than n are recycled to the length of the result. 
#'   Only the first elements of the logical arguments are used.
#'   
#' @examples dlaplace(0)
#' 
dlaplace = function(x, mean = 0, scale = 1, rate = 1/scale, log = FALSE) {
  if (log) dexp(x=abs(x-mean), rate=rate, log=TRUE)-log(2)
  dexp(x=abs(x-mean), rate=rate, log=FALSE)/2
}

rlaplace = function(n, mean = 0, scale = 1, rate = 1/scale) {
  # sample(c(-1,1), n, replace=TRUE) * rexp(n, rate=rate) + mean
  u = runif(n=n)-.5
  mean - sign(x=u)*log(1-2*abs(x=u)) / rate
}

plaplace = function(q, mean = 0, scale = 1, rate = 1/scale, lower.tail = TRUE, log.p = FALSE) {
  x = (q-mean)*rate
  cdf = ifelse(x<0, exp(x)/2, 1-exp(-x)/2)
  if (!lower.tail) cdf = 1-cdf
  if (log.p) return(log(cdf)) # Placeholder
  return(cdf)
}

qlaplace = function(p, mean = 0, scale = 1, rate = 1/scale, lower.tail = TRUE, log.p = FALSE) {
  mean - sign(p-0.5) * log(1-2*abs(p-0.5)) / rate
}