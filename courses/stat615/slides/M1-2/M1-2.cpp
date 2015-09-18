#include <Rcpp.h>
using namespace Rcpp;


double sample_normal_mean(int n, double ybar, double V, double m, double C) {
  double Cp = 1/(1/C+n/V);
  double mp = Cp*(m/C+n*ybar/V);
  
  return mp + sqrt(Cp) * R::rnorm(0,1);
}


NumericVector sample_theta(IntegerVector n, NumericVector ybars, double sigma2, double mu, NumericVector phi) {
  NumericVector theta(n.length());
  for (int i=0; i<n.length(); i++) 
    theta[i] = sample_normal_mean(n[i], ybars[i], sigma2, mu, phi[i]);
  return theta;
}


double sample_mu(NumericVector psi, NumericVector phi, double m, double C) {
  NumericVector phi2 = phi*phi;
  double Cp = 1/ (1/C + sum(1  /phi2));
  double mp = Cp*(m/C + sum(psi/phi2));
  return mp + sqrt(Cp) * R::rnorm(0,1);
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
    out[i] = 1/R::rgamma(a+n[i]/2, 1/(b+SSE[i]/2)); // temp fix
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



IntegerVector sample_gamma(double pi, int g, IntegerVector n, NumericVector ybar, NumericVector psi, double sigma2) {
  double new_pi, mx, log_pi=log(pi);
  NumericVector log_pH(2);
  IntegerVector gamma(g);
  
  for (int i=0; i<g; i++) {
    // calculate marginal likelihoods
    log_pH[0] =    log_pi  + R::dnorm(ybar[i],    0.0, sqrt(sigma2/n[i]), 1);
    log_pH[1] = (1-log_pi) + R::dnorm(ybar[i], psi[i], sqrt(sigma2/n[i]), 1);
    
    // normalize
    mx = max(log_pH); log_pH[0] = log_pH[0]-mx; log_pH[1] = log_pH[1]-mx;
    new_pi = exp(log_pH[0]) / (exp(log_pH[0]) + exp(log_pH[1]));
    
    gamma[i] = R::rbinom(1, 1-new_pi); // since pi is probability of zero
  }
  
  return gamma;
}

// [[Rcpp::export]]
double sample_pi(IntegerVector gamma, double a, double b) {
  int n = gamma.length(), s = std::accumulate(gamma.begin(), gamma.end(), 0);
  return rbeta(1, a+s, b+n-s)[0];
}


// [[Rcpp::export]]
List mcmc_normal(
  int n_reps, 
  NumericVector y, 
  IntegerVector group, 
  double mu,            // initial values
  NumericVector theta, 
  double sigma2,
  double tau2,
  double m,             // Prior values
  double C,
  double a,
  double b,
  double c
) {
    
    
  int i,j;
  int g = theta.length();
  
  // Allocate storage
  NumericVector keep_mu(   n_reps);
  NumericMatrix keep_theta(n_reps, g);
  NumericVector keep_sigma(n_reps);
  NumericVector keep_tau(  n_reps);
  
  
  
  // Calculate summary statistics
  int N = y.length();            // total number of observations
  IntegerVector n(   g,0);
  NumericVector ybar(g,0.0);
  for (i=0; i<N; i++) {
    n[   group[i]-1]++;          // group size
    ybar[group[i]-1] += y[i];
  }
  for (i=0; i<g; i++) ybar[i] /= n[i];
  double sigma2_b, sigma2_a = a + N/2;  
  double tau_a    = (g-1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(g);     // within group sum of squared errors (relative to theta)
  NumericVector phi(g);
  
  // Run MCMC
  for (i=0; i<n_reps; i++) {
    for (j=0; j<g; j++) phi[j] = tau2;
    
    // sample mu
    mu    = sample_normal_mean(g, std::accumulate(theta.begin(), theta.end(), 0.0)/g, tau2, m, C);
    
    // sample theta
    theta = sample_theta(n, ybar, sigma2, mu, phi);
    
    // for (int j=0; j<g; j++) Rcout << theta[j] << ' '; Rcout << std::endl;
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/rgamma(1,sigma2_a,1/sigma2_b)[0];
    
    // Sample tau
    tau2 = tau_MH(1/rgamma(1, tau_a, 2/calc_SSE(theta,mu))[0], tau2, c);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_sigma[i]   = sqrt(sigma2);
    keep_tau[i]     = sqrt(tau2);
  }
  
  
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("sigma") = keep_sigma,
    Named("tau")   = keep_tau);
}




// [[Rcpp::export]]
List mcmc_pointmass_normal(
  int n_reps, 
  NumericVector y, 
  IntegerVector group, 
  double mu,            // initial values
  NumericVector theta, 
  double sigma2,
  double tau2,
  double m,             // Prior values
  double C,
  double a,
  double b,
  double c,
  double a_pi,
  double b_pi
) {
    
    
  int i, j, g = theta.length();
  
  // other initial values
  double pi = 0.5, log_pi = log(pi);
  IntegerVector gamma(g, 1); // gamma[i] ~ Ber(pi)
  NumericVector psi(g);      // theta[i] = gamma[i]*psi[i]
  for (i=0; i<g; i++) psi[i] = theta[i];
  
  // Allocate storage
  NumericVector keep_mu(   n_reps);
  NumericMatrix keep_theta(n_reps, g);
  NumericVector keep_sigma(n_reps);
  NumericVector keep_tau(  n_reps);
  NumericVector keep_pi(   n_reps);
  
  // Calculate summary statistics
  int N = y.length();            // total number of observations
  IntegerVector n(   g,0);
  NumericVector ybar(g,0.0);
  for (i=0; i<N; i++) {
    n[   group[i]-1]++;          // group size
    ybar[group[i]-1] += y[i];
  }
  for (i=0; i<g; i++) ybar[i] /= n[i];
  double sigma2_b, sigma2_a = a + N/2;  
  double tau_a    = (g-1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(g);     // within group sum of squared errors (relative to theta)
  // NumericVector phi(g);
  
  // Run MCMC
  for (i=0; i<n_reps; i++) {
    // for (j=0; j<g; j++) phi[j] = tau;
    
    // sample mu
    mu    = sample_normal_mean(g, std::accumulate(psi.begin(), psi.end(), 0.0)/g, tau2, m, C);
    
    // sample gamma
    gamma = sample_gamma(pi, g, n, ybar, psi, sigma2);
    
    // sample psi
    for (j=0; j<g; j++) {
      if (gamma[j]==0) {
        psi[j] = rnorm(1, mu, sqrt(tau2))[0]; 
        theta[j] = 0.0;
      } else {
        psi[j] = sample_normal_mean(n[j], ybar[j], sigma2, mu, tau2);
        theta[j] = psi[j];
      }
    }
    
    // sample pi
    pi = sample_pi(gamma, a_pi, b_pi);
    
    // for (int j=0; j<g; j++) Rcout << theta[j] << ' '; Rcout << std::endl;
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/rgamma(1,sigma2_a,1/sigma2_b)[0];
    
    // Sample tau
    tau2 = tau_MH(1/rgamma(1, tau_a, 2/calc_SSE(theta,mu))[0], tau2, c);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_sigma[i]   = sqrt(sigma2);
    keep_tau[i]     = sqrt(tau2);
    keep_pi[i]      = pi;
  }
  
  
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("sigma") = keep_sigma,
    Named("tau")   = keep_tau,
    Named("pi")    = keep_pi);
}




// [[Rcpp::export]]
List mcmc_pointmass_t(
  int n_reps, 
  NumericVector y, 
  IntegerVector group, 
  double mu,            // initial values
  NumericVector theta, 
  double sigma2,
  double tau2,
  double m,             // Prior values
  double C,
  double a,
  double b,
  double c,
  double a_pi,
  double b_pi,
  int df
) {
    
    
  int i, j, g = theta.length();
  
  // other initial values
  double pi = 0.5, log_pi = log(pi);
  IntegerVector gamma(g, 1); // gamma[i] ~ Ber(pi)
  NumericVector psi(g);      // theta[i] = gamma[i]*psi[i]
  for (i=0; i<g; i++) psi[i] = theta[i];
  
  // Allocate storage
  NumericVector keep_mu(   n_reps);
  NumericMatrix keep_theta(n_reps, g);
  NumericVector keep_sigma(n_reps);
  NumericVector keep_tau(  n_reps);
  NumericVector keep_pi(   n_reps);
  
  // Calculate summary statistics
  int N = y.length();            // total number of observations
  IntegerVector n(   g,0);
  NumericVector ybar(g,0.0);
  for (i=0; i<N; i++) {
    n[   group[i]-1]++;          // group size
    ybar[group[i]-1] += y[i];
  }
  for (i=0; i<g; i++) ybar[i] /= n[i];
  double sigma2_b, sigma2_a = a + N/2;  
  double tau_a    = (g*df+1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(g);     // within group sum of squared errors (relative to theta)
  NumericVector phi(g,1.0); // parameters for hierarchical representation of a t distribution
  NumericVector phi_inverse(g);
  
  // Run MCMC
  for (i=0; i<n_reps; i++) {

    
    // sample mu
    mu = sample_mu(psi, phi, m, C);
    
    // sample gamma
    gamma = sample_gamma(pi, g, n, ybar, psi, sigma2);
    
    // sample psi
    for (j=0; j<g; j++) {
      if (gamma[j]==0) {
        psi[j] = R::rnorm(mu, phi[j]); 
        theta[j] = 0.0;
      } else {
        psi[j] = sample_normal_mean(n[j], ybar[j], sigma2, mu, phi[j]*phi[j]);
        theta[j] = psi[j];
      }
    }
    
    // sample pi
    pi = sample_pi(gamma, a_pi, b_pi);
    
    // for (int j=0; j<g; j++) Rcout << theta[j] << ' '; Rcout << std::endl;
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/R::rgamma(sigma2_a,1/sigma2_b);
    
        
//    Rcout << std:: endl << i << std::endl;
//    Rcout << df << std::endl;
//    Rcout << tau2 << std::endl;
//    Rcout << sigma2 << std::endl;
//    Rcout << mu << std::endl;
//    Rcout << pi << std::endl;
//    for (j=0; j<g; j++) Rcout << phi[j] << ' '; Rcout << std::endl;
//    for (j=0; j<g; j++) Rcout << gamma[j] << ' '; Rcout << std::endl;
//    for (j=0; j<g; j++) Rcout << theta[j] << ' '; Rcout << std::endl;
//    for (j=0; j<g; j++) Rcout << psi[j] << ' '; Rcout << std::endl;
    
    
    // Sample phi
    phi = sample_normal_variance(IntegerVector(g,1), (psi-mu)*(psi-mu), df/2.0, df*tau2/2.0);
    
    // Sample tau
    for (j=0; j<g; j++) phi_inverse[j] = 1.0/phi[j];
    tau2 = tau_MH(rgamma(1, tau_a, std::accumulate(phi_inverse.begin(), phi_inverse.end(), 0.0)/2.0)[0], tau2, c);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_sigma[i]   = sqrt(sigma2);
    keep_tau[i]     = sqrt(tau2);
    keep_pi[i]      = pi;
  }
  
  
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("sigma") = keep_sigma,
    Named("tau")   = keep_tau,
    Named("pi")    = keep_pi);
}
