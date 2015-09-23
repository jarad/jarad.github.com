#include <Rcpp.h>
using namespace Rcpp;




//////////////////////////////////////////////////////////////////////////
// Some functions to restrict range of parameter values to avoid
// numerical problems
//////////////////////////////////////////////////////////////////////////

double check(double value, double min, double max) {
  if (value < min) value = min;
  if (value > max) value = max;
  return value;
}

void check(NumericVector value, double min, double max) {
  for (int i=0; i<value.length(); i++) value[i] = check(value[i], min, max);
}

int check(int value, int min, int max) {
  if (value < min) value = min;
  if (value > max) value = max;
  return value;
}

IntegerVector check(IntegerVector value, int min, int max) {
  for (int i=0; i<value.length(); i++) value[i] = check(value[i], min, max);
}

//////////////////////////////////////////////////////////////////////
// Summary statistics
//////////////////////////////////////////////////////////////////////

IntegerVector calc_group_size(IntegerVector group) {
  int G = max(group); // number of groups
  IntegerVector size(G, 0);
  for (int i=0; i<group.length(); i++) size[group[i]-1]++;
  return size;
}

NumericVector calc_group_sum(NumericVector y, IntegerVector group) {
  int G = max(group);
  NumericVector sum(G, 0.0);
  for (int i=0; i<group.length(); i++) sum[group[i]-1] += y[i];
  return sum;
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


//////////////////////////////////////////////////////////////////////
// Sampling functions
//////////////////////////////////////////////////////////////////////


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
  int g = SSE.length(), count;
  NumericVector out(g);
  for (int i=0; i<g; i++) {
    out[i] = R_PosInf; count = 0;
    while ( (out[i] == R_PosInf) && (count<1000) ) {
      out[i] = 1/R::rgamma(a+n[i]/2, 1/(b+SSE[i]/2)); // temp fix
      count++;
    }
  }
  
  return out;
}




double tau2_MH(double tau2_proposed, double tau2_current, double c) {
  double log_rho = log(1+tau2_current/c) - log(1+tau2_proposed/c);
  return ifelse( log(runif(1)) < log_rho, tau2_proposed, tau2_current)[0];
}

IntegerVector sample_gamma(double pi, int g, IntegerVector n, NumericVector ybar, NumericVector psi, double sigma2) {
  double log_pi=log(pi);
  NumericVector log_pH(2), pH(2);
  IntegerVector gamma(g);
  
  for (int i=0; i<g; i++) {
    // calculate marginal likelihoods
    log_pH[0] =    log_pi  + R::dnorm(ybar[i],    0.0, sqrt(sigma2/n[i]), 1);
    log_pH[1] = (1-log_pi) + R::dnorm(ybar[i], psi[i], sqrt(sigma2/n[i]), 1);
    
    // normalize
    log_pH = log_pH - max(log_pH);
    pH = exp(log_pH);
    
    gamma[i] = R::rbinom(1, pH[1]/sum(pH)); 
  }
  
  return gamma;
}

double sample_pi(IntegerVector gamma, double a, double b) {
  // pi is the probability of gamma==0
  int n = gamma.length(), f = std::accumulate(gamma.begin(), gamma.end(), 0);
  return rbeta(1, a+n-f, b+f)[0];
}


// [[Rcpp::export]]
List mcmc_normal(
  int n_reps, 
  NumericVector y, 
  IntegerVector group, 
  List initial_values,
  List prior,
  int verbose
) {
  
  
  if (verbose) Rcout << "Setting initial values." << std::endl;
  // Set initial values
  double mu     = as<double>(initial_values["mu"]);
  double sigma2 = as<double>(initial_values["sigma2"]);
  double tau2   = as<double>(initial_values["tau2"]);
  NumericVector theta  = clone(as<NumericVector>(initial_values["theta"]));
  
  // Allocate storage
  int G = theta.length(); // number of groups
  NumericVector keep_mu(   n_reps);
  NumericVector keep_sigma2(n_reps);
  NumericVector keep_tau2(  n_reps);
  NumericMatrix keep_theta(n_reps, G);
  
  // Set prior values
  double m = as<double>(prior["m"]); // mu ~ N(m,C)
  double C = as<double>(prior["C"]);
  double a = as<double>(prior["a"]); // sigma2 ~ IG(a,b)
  double b = as<double>(prior["b"]);
  double c = as<double>(prior["c"]); // tau ~ Ca+(0,c)
  
  // Calculate summary statistics
  IntegerVector n(   calc_group_size(  group)  );
  NumericVector ybar(calc_group_sum(y, group)/as<NumericVector>(n));
  double sigma2_b, sigma2_a = a + y.length()/2;  
  double tau2_a    = (G-1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(G);     // within group sum of squared errors (relative to theta)
  NumericVector phi(G);
  
  // Run MCMC
  for (int i=0; i<n_reps; i++) {
    for (int g=0; g<G; g++) phi[g] = tau2;
    
    // sample mu
    mu    = sample_normal_mean(G, std::accumulate(theta.begin(), theta.end(), 0.0)/G, tau2, m, C);
    
    // sample theta
    theta = sample_theta(n, ybar, sigma2, mu, phi);
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/rgamma(1,sigma2_a,1/sigma2_b)[0];
    
    // Sample tau2
    tau2 = tau2_MH(1/rgamma(1, tau2_a, 2/calc_SSE(theta,mu))[0], tau2, c);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_sigma2[i]  = sqrt(sigma2);
    keep_tau2[i]    = sqrt(tau2);
  }
  
  
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("sigma") = keep_sigma2,
    Named("tau")   = keep_tau2);
}




// [[Rcpp::export]]
List mcmc_pointmass_normal(
  int n_reps, 
  const NumericVector y, 
  const IntegerVector group, 
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
  IntegerVector gamma(g, 0); // gamma[i] ~ Ber(pi)
  NumericVector psi(g);      // theta[i] = gamma[i]*psi[i]
  for (i=0; i<g; i++) psi[i] = theta[i];
  
  // Allocate storage
  NumericVector keep_mu(   n_reps);
  NumericMatrix keep_theta(n_reps, g);
  IntegerMatrix keep_gamma(n_reps, g);
  NumericMatrix keep_psi(  n_reps, g);
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
  double tau2_a    = (g-1)/2;
  
  // quantities reused during MCMC
  NumericVector SSE(g);     // within group sum of squared errors (relative to theta)
  // NumericVector phi(g);
  
  // Run MCMC
  for (i=0; i<n_reps; i++) {
    // for (j=0; j<g; j++) phi[j] = tau2;
    
    // sample mu
    mu    = sample_normal_mean(g, std::accumulate(psi.begin(), psi.end(), 0.0)/g, tau2, m, C);
    check(mu, -1e5, 1e5);
    
    // sample gamma
    gamma = sample_gamma(pi, g, n, ybar, psi, sigma2);
    check(gamma, 0, 1);
    
    // sample psi
    for (j=0; j<g; j++) {
      if (gamma[j]) {
        psi[j] = sample_normal_mean(n[j], ybar[j], sigma2, mu, tau2);
        theta[j] = psi[j];
      } else {
        psi[j] = rnorm(1, mu, sqrt(tau2))[0]; 
        theta[j] = 0.0;
      }
    }
    check(psi,   -1e5, 1e5);
    check(theta, -1e5, 1e5);
    
    // sample pi
    pi = sample_pi(gamma, a_pi, b_pi);
    pi = check(pi, 0.0, 1.0);
    
    // for (int j=0; j<g; j++) Rcout << theta[j] << ' '; Rcout << std::endl;
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/rgamma(1,sigma2_a,1/sigma2_b)[0];
    sigma2 = check(sigma2, 0.0, 1e5);
    
    // Sample tau2
    tau2 = tau2_MH(1/rgamma(1, tau2_a, 2/calc_SSE(psi,mu))[0], tau2, c);
    tau2 = check(tau2, 0.0, 1e5);
  
    // Update storage
    keep_mu[i]      = mu;
    keep_theta(i,_) = theta;
    keep_psi(  i,_) = psi;
    keep_gamma(i,_) = gamma;
    keep_sigma[i]   = sqrt(sigma2);
    keep_tau[i]     = sqrt(tau2);
    keep_pi[i]      = pi;
  }
  
  return List::create(
    Named("mu")    = keep_mu,
    Named("theta") = keep_theta,
    Named("psi")   = keep_psi,
    Named("gamma") = keep_gamma,
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
  double tau2_a    = (g*df+1)/2;
  
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
    
    // sample sigma2
    SSE      = calc_all_SSE(y, group, theta);
    sigma2_b = b + 0.5*std::accumulate(SSE.begin(), SSE.end(), 0.0);
    sigma2   = 1/R::rgamma(sigma2_a,1/sigma2_b);
    
    // Sample phi
    phi = sample_normal_variance(IntegerVector(g,1), (psi-mu)*(psi-mu), df/2.0, df*tau2/2.0);
    for (j=0; j<g; j++) if (phi[j]>1e5) phi[j] = 1e5;
    
    
    // Sample tau2
    for (j=0; j<g; j++) phi_inverse[j] = 1.0/phi[j];
    tau2 = tau2_MH(rgamma(1, tau2_a, std::accumulate(phi_inverse.begin(), phi_inverse.end(), 0.0)/2.0)[0], tau2, c);
  
    Rcout << std::endl << i << std::endl;
    Rcout << "mu= " << mu << std::endl;
    for (j=0; j<g; j++) Rcout << "gamma= " << gamma[j] << ' '; Rcout << std::endl;
    for (j=0; j<g; j++) Rcout << "theta= " << theta[j] << ' '; Rcout << std::endl;
    for (j=0; j<g; j++) Rcout << "psi= "   << psi[j]   << ' '; Rcout << std::endl;
    Rcout << "pi= " << pi << std::endl;
    Rcout << "sigma2= " << sigma2 << std::endl;
    for (j=0; j<g; j++) Rcout << "phi= " << phi[j]   << ' '; Rcout << std::endl;
    Rcout << "tau2= " << tau2 << std::endl;
    
    if (NumericVector::is_na(mu)) break;
    // if (is_true(any(phi == R_PosInf))) break;
  
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
