---
layout: page
title: STAT 401 (Engineering)
tagline: slides
---
{% include JB/setup %}

Below are source (Rnw) and handouts for all course lectures. 
Instructions for compiling the Rnw files can be found below.

## Chapter slide source files

### Probability

|Topic|Source|Handouts|
|---|---|---|
|Data Management|[Set01.Rnw](Set01/Set01_data_management.Rnw)|[Set01.pdf](Set01/Set01_data_management.pdf)|
|Data|[Set02.Rnw](Set02/Set02_data.Rnw)|[Set02.pdf](Set02/Set02_data.pdf)|
|Probability|[Set03.Rnw](Set03/Set03_probability.Rnw)|[Set03.pdf](Set03/Set03_probability.pdf)|
|Discrete distributions|[Set04.Rnw](Set04/Set04_discrete_distributions.Rnw)|[Set04.pdf](Set04/Set04_discrete_distributions.pdf)|
|Continuous distributions|[Set05.Rnw](Set05/Set05_continuous_distributions.Rnw)|[Set05.pdf](Set05/Set05_continuous_distributions.pdf)|
|Central limit theorem|[Set06.Rnw](Set06/Set06_central_limit_theorem.Rnw)|[Set06.pdf](Set06/Set06_central_limit_theorem.pdf)|
|Multiple random variables|[Set07.Rnw](Set07/Set07_multiple_random_variables.Rnw)|[Set07.pdf](Set07/Set07_multiple_random_variables.pdf)|

### Inference

|Topic|Source|Handouts|
|---|---|---|
|Statistics|[Set08.Rnw](Set08/Set08_Statistics.Rnw)|[Set08.pdf](Set08/Set08_Statistics.pdf)|
|Likelihood|[Set09.Rnw](Set09/Set09_likelihood.Rnw)|[Set09.pdf](Set09/Set09_likelihood.pdf)|
|Bayesian statistics|[Set10.Rnw](Set10/Set10_Bayesian_statistics.Rnw)|[Set10.pdf](Set10/Set10_Bayesian_statistics.pdf)|
|Normal model|[Set11.Rnw](Set11.Set11_Normal_model.Rnw)|[Set11.pdf](Set11.Set11_Normal_model.pdf)|

  



## Rnw compilation instructions

From the Rnw files you can construct the pdf slides or extract the R code.
You will need to have the R package `knitr` installed, i.e. 

    install.packages('knitr')

### Slides

To obtain the pdf, you will need to have [LaTeX installed](http://en.wikibooks.org/wiki/LaTeX/Installation) and in the path (etc). Then download the Rnw file (as an example, I will use `Ch01.Rnw`) and run

    knitr::knit2pdf('Set01_data_management.Rnw')

Alternatively, you can install [RStudio](http://www.rstudio.com/) and click on the `Compile PDF` button.

### R Code

To extract the R code, run 

    knitr::knit('Set01_data_management.Rnw', tangle=TRUE)
