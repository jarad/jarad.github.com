---
layout: page
title: STAT 544
tagline: Bayesian Statistics
---
{% include JB/setup %}

## Report outline

A general outline for data analysis reports is 

- Introduction
- Data
- Methods 
- Results 
- Discussion

The contents of each section are described below.

### Introduction

This section should provide a brief introduction to the subject matter you are
discussing and should present the scientific question of interest.

### Data

The data section should provide relevant details about the data that you will be 
modeling. 
It should include information like the range of values for each variable 
including units, the relationship between the variables, the number of 
observations, etc. 
This section can provide tables or figures to help the reader understand the 
data. 

### Methods

The methods section should introduce the model that you are fitting to the data
using statistical notation.
The model discussion should include 
how the parameters in this model will be estimated and how this model will
address the scientific question of interests.

Introduced notation, e.g. Y_i, X_i, etc, should be defined. 
Statistical notation does not need to be defined, e.g. ind, N(m,C), etc, 
but conventions used in this class should be followed, e.g. C is the variance
in N(m,C). 
If there is a doubt about the convention, then it is best to be explicit, 
e.g. specify if b in Ga(a,b) is the rate or the scale.

Since the methods in this project will likely depend on MCMC, 
you need to specify how convergence in the MCMC will be assessed.

### Results

The results section should provide summaries of the results of applying methods
from the Methods section on the data in the Data section.
Before discussing the actual estimates of parameters, 
you should provide details of the MCMC, 
e.g. number of burn-in and inferential iterations, 
as well as an assessment of convergence.

After summarizing convergence, summarize the posterior distribution of the 
model parameters. 
This is typically best done by plots of posterior distributions or, 
if there are too many parameters,
plots of credible intervals.
In addition, the answer to the scientific question should be presented.

### Discussion

The discussion section provides an interpretation of the results from the 
results section.
It also provides an opportunity to discuss any shortcomings in the model or the
data.
