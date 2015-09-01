---
layout: page
title: STAT 615
tagline: Assignments
---
{% include JB/setup %}

I will post lecture slides here. 

# Article summary

- [Horseshoe prior](http://machinelearning.wustl.edu/mlpapers/paper_files/AISTATS09_CarvalhoPS.pdf) due 17 Sep

# Homework

### Homework 1 (due 24 Sep)

1. For the regularized regression problems, we assume the data are of the form y=Xb+e where e~N(0,s^2 ).
  a. Show that independent normal priors on regression components lead to the ridge estimator on page 5 of [Ridge Regression in Practice](http://www.tandfonline.com/doi/abs/10.1080/00031305.1975.10479105).
  b. Show that independent [Laplace](http://en.wikipedia.org/wiki/Laplace_distribution) priors on regression coefficients lead to the LASSO estimator on page 1 of [Bayesian LASSO](http://www.stat.ufl.edu/~casella/Papers/Lasso.pdf).
  c. Derive the form of the prior distribution for the [elastic net estimator](http://en.wikipedia.org/wiki/Elastic_net_regularization). 
  
2. For the following problems, we asume the data are of the form y_{ij} ~ N(\mu_i,\sigma^2).
  a. Construct an MCMC algorithm for the Horseshoe prior for $\mu_i$.
  b. Construct a simulation study to compare the Horseshoe prior to the point-mass prior. The terms of the simulation study are up to you, but be clear about what you have done and how you are evaluating the two priors.

