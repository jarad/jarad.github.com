---
layout: page
title: STAT 401 (Engineering)
tagline: slides
---
{% include JB/setup %}

Below are source (Rnw) and handouts for all course lectures. 
Instructions for compiling the Rnw files can be found below.

## Chapter slide set files

If the files are ever not available here or if you are interested in the source
files, 
you can find them [here](https://github.com/jarad/jarad.github.com/tree/master/courses/stat401Eng/slides).

### Probability

- [Probability](Probability/P1-Probability/P1-Probability.pdf)|
- [Discrete distributions](Probability/P2-Discrete_distributions/P2-Discrete_distributions.pdf)|
- [Continuous distributions](Probability/P3-Continuous_distributions/P3-Continuous_distributions.pdf)|
- [Central Limit Theorem](Probability/P4-Central_limit_theorem/P4-Central_limit_theorem.pdf)|
- [Multiple random variables](Probability/P5-Multiple_random_variables/P5-Multiple_random_variables.pdf)|

 ============ updated to here =================

|---|---|---|
|Multiple random variables|[Set07.Rnw](Set07/Set07_multiple_random_variables.Rnw)|[Set07.pdf](Set07/Set07_multiple_random_variables.pdf)|

### Inference

|Topic|Source|Handouts|
|---|---|---|
|Statistics|[Set08.Rnw](Set08/Set08_Statistics.Rnw)|[Set08.pdf](Set08/Set08_Statistics.pdf)|
|Likelihood|[Set09.Rnw](Set09/Set09_likelihood.Rnw)|[Set09.pdf](Set09/Set09_likelihood.pdf)|
|Bayesian statistics|[Set10.Rnw](Set10/Set10_Bayesian_statistics.Rnw)|[Set10.pdf](Set10/Set10_Bayesian_statistics.pdf)|
|Normal model|[Set11.Rnw](Set11/Set11_Normal_model.Rnw)|[Set11.pdf](Set11/Set11_Normal_model.pdf)|
|Confidence intervals|[Set12.Rnw](Set12/Set12_Confidence_intervals.Rnw)|[Set12.pdf](Set12/Set12_Confidence_intervals.pdf)|
|Pvalues|[Set13.Rnw](Set13/Set13_Pvalues.Rnw)|[Set13.pdf](Set13/Set13_Pvalues.pdf)|
|Posterior model probability|[Set14.Rnw](Set14/Set14_Posterior_model_probability.Rnw)|[Set14.pdf](Set14/Set14_Posterior_model_probability.pdf)|
|Comparing probabilities|[Set15.Rnw](Set15/Set15_Comparing_probabilities.Rnw)|[Set15.pdf](Set15/Set15_Comparing_probabilities.pdf)|
|Comparing means|[Set16.Rnw](Set16/Set16_Comparing_means.Rnw)|[Set16.pdf](Set16/Set16_Comparing_means.pdf)|
|Multiple comparisons|[Set17.Rnw](Set17/Set17_Multiple_comparisons.Rnw)|[Set17.pdf](Set17/Set17_Multiple_comparisons.pdf)|

### Regression

|Topic|Source|Handouts|
|---|---|---|
|Simple linear regression|[SetR01.Rnw](SetR01/SetR01_Simple_linear_regression.Rnw)|[SetR01.pdf](SetR01/SetR01_Simple_linear_regression.pdf)|  
|Regression diagnostics|[SetR02.Rnw](SetR02/SetR02_Regression_diagnostics.Rnw)|[SetR02.pdf](SetR02/SetR02_Regression_diagnostics.pdf)|  
|Logarithms|[SetR03.Rnw](SetR03/SetR03_Logarithms.Rnw)|[SetR03.pdf](SetR03/SetR03_Logarithms.pdf)|  
|Categorical explanatory variables |[SetR04.Rnw](SetR04/SetR04_Categorical_explanatory_variables.Rnw)|[SetR04.pdf](SetR04/SetR04_Categorical_explanatory_variables.pdf)|  
|Multiple regression|[SetR05.Rnw](SetR05/SetR05_Multiple_regression.Rnw)|[SetR05.pdf](SetR05/SetR05_Multiple_regression.pdf)| 
|ANOVA/F-tests|[SetR06.Rnw](SetR06/SetR06_ANOVA_F-tests.Rnw)|[SetR06.pdf](SetR06/SetR06_ANOVA_F-tests.pdf)|  
|Contrasts|[SetR07.Rnw](SetR07/SetR07_Contrasts.Rnw)|[SetR07.pdf](SetR07/SetR07_Contrasts.pdf)|  
|Experimental design|[SetR08.Rnw](SetR08/SetR08_Experimental_design.Rnw)|[SetR08.pdf](SetR08/SetR08_Experimental_design.pdf)|  
|Two-way ANOVA|[SetR09.Rnw](SetR09/SetR09_Two-way_ANOVA.Rnw)|[SetR09.pdf](SetR09/SetR09_Two-way_ANOVA.pdf)|  

### Supplementary topics

|Topic|Source|Handouts|
|---|---|---|
|Data Management|[Set01.Rnw](Set01/Set01_data_management.Rnw)|[Set01.pdf](Set01/Set01_data_management.pdf)|
|Data|[Set02.Rnw](Set02/Set02_data.Rnw)|[Set02.pdf](Set02/Set02_data.pdf)|
|Logistic regression|[SetS01.Rnw](SetS01/SetS01_Logistic_Regression.Rnw)|[SetS01.pdf](SetS01/SetS01_Logistic_Regression.pdf)|
|Poisson regression|[SetS02.Rnw](SetS02/SetS02_Poisson_Regression.Rnw)|[SetS02.pdf](SetS02/SetS02_Poisson_Regression.pdf)|
|Random effects|[SetS03.Rnw](SetS03/SetS03_Random_effects.Rnw)|[SetS03.pdf](SetS03/SetS03_Random_effects.pdf)|
|Model comparison|[SetS04.Rnw](SetS04/SetS04_Model_comparison.Rnw)|[SetS04.pdf](SetS04/SetS04_Model_comparison.pdf)|
|Random forests|[SetS05.Rnw](SetS05/SetS05_Random_forests.Rnw)|[SetS05.pdf](SetS05/SetS05_Random_forests.pdf)|


## Rnw compilation instructions

From the Rnw files you can construct the pdf slides or extract the R code.
You will need to have the R package `knitr` installed, i.e. 

    install.packages('knitr')

### R Code

To extract the R code, run 

    knitr::knit('Set01_data_management.Rnw', tangle=TRUE)


### Slides

To obtain the pdf, 
you will need to have [LaTeX installed](http://en.wikibooks.org/wiki/LaTeX/Installation) and in the path (etc). Then download the Rnw file (as an example, I will use `Set01_data_management.Rnw`) and run

    knitr::knit2pdf('Set01_data_management.Rnw')

Alternatively, you can install [RStudio](http://www.rstudio.com/) and click on the `Compile PDF` button.
