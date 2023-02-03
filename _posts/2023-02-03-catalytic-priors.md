---
layout: post
title: "Catalytic priors"
description: ""
category: [Bayesian]
tags: [Bayesian, prior]
---

{% include JB/setup %}

This post was created to aid discussion in the Bayesian Working Group at 
Iowa State University concerning *catalytic priors*. 
The starting point for discussion is the manuscript
[Catalytic prior distributions with application to genearlized linear models]
(https://www.pnas.org/doi/abs/10.1073/pnas.1920913117) by
Huang, Stein, Rubin, and Kou. 
This is really my first foray into this area, so we'll see how well it goes.

# Catalytic priors

The basic idea of catalytic priors is that you construct a prior by 

1. fitting a *simple* model to your data,
1. simulating data from the posterior predictive distribution of this simple model, and
1. use the simulated data with the real data to fit the model you want to fit.

Operationally things work a bit different than this. 
For one thing, how do you decide how much data you simulate?
The more data you simulate, the larger influence that data has
(and therefore the *simple* model used has) on the posterior. 
This issue can be ameliorated by raising the likelihood for the simulated data
to a power in order to reduce the impact of the simulated data. 

## Mathematical formulation

Suppose you are interested in estimating a model whose density is $f(y|\theta)$
where theta is unknown.
