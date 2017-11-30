---
layout: post
title: "Meta-analysis with missing standard errors"
description: ""
category: [Consulting]
tags: [modeling]
---
{% include JB/setup %}

The goal here is a meta-analysis to look at the effect of two explanatory
variables on a particular response over a range of studies. 
Each observation is a study with a single response, the values of two
explanatory variables, and and estimate of a standard error of the estimated
effect.

Consider a mixed effects model with fixed effects X1 and X2 and study
specific random effects with a variance equal to the square of the 
standard error for the estimated effect in that study for each study. 
But many of these standard errors are missing.

The client suggested an approach based on bootstrapping. 





## Advice

### Questions

- How many observations do we have?
- What proportion have missing estimated standard errors? Approximately half?
- Do we have multiple response and explanatory variables per study? Yes.
- Do these responses have the same standard error in the same study? 
- What kind of bootstrapping are we talking about?

### Consulting solution

Try the following:

- impute missing standard errors with the average of observed values
- use only the studies with reported standard errors

If these two analyses agree, 
this might give you confidence that the analyses is robust.

The main problem will be if the missing standard errors are small and 
therefore these studies are extremely informative about the regression 
coefficients. 

In these two analyses, you may want to understand the relationship between 
the squared standard errors and the new variance. 
If the squared standard errors are sufficiently small relative to the new
variance, then the squared standard errors can be ignored

### Modeling the missing standard errors

A model could be constructed to model the standard errors and their missingness
mechanism. 
A Bayesian (or other) approach could be used to account for  the uncertainty
in the missing values.
These approaches will be highly dependent on the missingness model.

### Related

- R package [metafor](https://cran.r-project.org/web/packages/metafor/index.html)
- [Cross-validated metafor question](https://stats.stackexchange.com/questions/114468/oddly-large-r-squared-values-in-meta-regression-metafor)