#include <Rcpp.h>
using namespace Rcpp;

// Below is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar)

// For more on using Rcpp click the Help button on the editor toolbar


double sample_normal_mean(double sum, double var, double m, double C) {
  // sum= n*ybar
  // var= sigma2/n
  double Cp = 1/(1/C+1/var);
  double mp = Cp*(m/C+sum/var);
  
  return mp + sqrt(Cp) * R::rnorm(0,1);
}


NumericVector sample_theta(NumericVector sums, IntegerVector n, double sigma2, double mu, NumericVector phi) {
  NumericVector theta(n.length());
  for (int i=0; i<n.length(); i++) 
    theta[i] = sample_normal_mean(sums[i], sigma2/n[i], mu, phi[i]);
  return theta;
}


// [[Rcpp::export]]
NumericVector sample_normal_variance(IntegerVector n, NumericVector SSE, double a, double b) {
  // y ~ N(theta, sigma2) 
  // sigma2 ~ IG(a,b)
  // sample sigma2|y ~ IG(a',b')
  // a' = a+n/2
  // b' = b+(y-theta)^2/2
  int g = SSE.length();
  NumericVector out(g);
  for (int i=0; i<g; i++) {
    out[i] = 1/rgamma(1, a+n[i]/2, 1/(b+SSE[i]/2))[0]; // temp fix
  }
  
  return out;
}


double calc_SSE(NumericVector y, double theta) {
  double SSE = 0.0;
  double e;
  for (int i=0; i<y.length(); i++) {
    e = y[i]-theta;
    SSE += e*e;
  }
  return SSE;
}

// [[Rcpp::export]]
NumericVector calc_all_SSE(NumericVector y, IntegerVector group, NumericVector theta) {
  int g = theta.length();
  NumericVector SSE(g);
  LogicalVector x(y.length());
  for (int i=0; i<g; i++) {
    x = group == (i+1); 
    SSE[i] = calc_SSE(y[x], theta[i]);
  }
  return(SSE);
}


double tau_MH(double tau_proposed, double tau_current, double c) {
  double log_rho = log(1+tau_current/c) - log(1+tau_proposed/c);
  return ifelse( log(runif(1)) < log_rho, tau_proposed, tau_current)[0];
}


// [[Rcpp::export]]
List mcmc_normal(
  int n_reps, 
  NumericVector y, 
  IntegerVector group, 
  double mu,            // initial values
  NumericVector theta, 
  double sigma2,
  double tau,
  double m,             // Prior values
  double C,
  double a,
  double b,
  double c
) {
    
    
  int i;
  int g = theta.length();
  
  // Allocate storage
  NumericVector keep_mu(   n_reps);
  NumericMatrix keep_theta(n_reps, g);
  NumericVector keep_sigma(n_reps);
  NumericVector keep_tau(  n_reps);
  
  
  
  // Calculate summary statistics
  int N = y.length();            // total number of observations
  IntegerVector n(   g,0);
  NumericVector ysum(g,0.0);
  for (i=0; i<N; i++) {
    n[   group[i]-1]++;          // group size
    ysum[group[i]-1] += y[i];
  }
  double sigma2_b, sigma2_a = a + N/2;  
  double tau_a    = (g-1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(g);     // within group sum of squared errors (relative to theta)
  
  
  
  // Run MCMC
  for (i=0; i<n_reps; i++) {
    // sample mu
    mu    = sample_normal_mean(std::accumulate(theta.begin(), theta.end(), 0.0), sigma2/g, m, C);
    
    // sample theta
    theta = sample_theta(ysum, n, sigma2, mu, tau);
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/rgamma(1,sigma2_a,1/sigma2_b)[0];
    
    // Sample tau
    tau = tau_MH(1/rgamma(1, tau_a, 2/calc_SSE(theta,mu))[0], tau, c);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_sigma[i]   = sqrt(sigma2);
    keep_tau[i]     = tau;
  }
  
  
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("sigma") = keep_sigma,
    Named("tau")   = keep_tau);
}
