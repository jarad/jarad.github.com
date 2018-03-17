---
layout: page
title: STAT 401 (Engineering)
tagline: slides
---
{% include JB/setup %}

Below are source (Rnw) and handouts for all course lectures. 
Instructions for compiling the Rnw files can be found below.

## Chapter slide set files

If the files are ever not available here, 
you can find them 
[here](https://github.com/jarad/jarad.github.com/tree/master/courses/stat401Eng/slides).

### Probability

|Topic|slides|code|
|---|---|---|
|Probability|[pdf](Probability/P1-Probability/P1-Probability.pdf)|[R](Probability/P1-Probability/P1-Probability.R)|
|Discrete distributions|[pdf](Probability/P2-Discrete_distributions/P2-Discrete_distributions.pdf)|[R](Probability/P2-Discrete_distributions/P2-Discrete_distributions.R)|
|Continuous distributions|[pdf](Probability/P3-Continuous_distributions/P3-Continuous_distributions.pdf)|[R](Probability/P3-Continuous_distributions/P3-Continuous_distributions.R)|
|Central limit theorem|[pdf](Probability/P4-Central_limit_theorem/P4-Central_Limit_Theorem.pdf)|[R](Probability/P4-Central_limit_theorem/P4-Central_Limit_Theorem.R)|
|Multiple random variables|[pdf](Probability/P5-Multiple_random_variables/P5-Multiple_random_variables.pdf)|[R](Probability/P5-Multiple_random_variables/P5-Multiple_random_variables.R)|


### Inference

|Topic|slides|code|
|---|---|---|
|Statistics|[pdf](Inference/I01-Statistics/I01-Statistics.pdf)|[R](Inference/I01-Statistics/I01-Statistics.R)|
|Likelihood|[pdf](Inference/I02-Likelihood/I02-Likelihood.pdf)|[R](Inference/I02-Likelihood/I02-Likelihood.R)|
|Bayesian statistics|[pdf](Inference/I03-Bayesian_statistics/I03-Bayesian_statistics.pdf)|[R](Inference/I03-Bayesian_statistics/I03-Bayesian_statistics.R)|
|Normal model|[pdf](Inference/I04-Normal_model/I04-Normal_model.pdf)|[R](Inference/I04-Normal_model/I04-Normal_model.R)|
|Confidence intervals|[pdf](Inference/I05-Confidence_intervals/I05-Confidence_intervals.pdf)|[R](Inference/I05-Confidence_intervals/I05-Confidence_intervals.R)|
|P values|[pdf](Inference/I06-Pvalues/I06-Pvalues.pdf)|[R](Inference/I06-Pvalues/I06-Pvalues.R)|
|Posterior model probability|[pdf](Inference/I07-Posterior_model_probability/I07-Posterior_model_probability.pdf)|[R](Inference/I07-Posterior_model_probability/I07-Posterior_model_probability.R)|
|Comparing probabilities|[pdf](Inference/I08-Comparing_probabilities/I08-Comparing_probabilities.pdf)|[R](Inference/I08-Comparing_probabilities/I08-Comparing_probabilities.R)|
|Comparing means|[pdf](Inference/I09-Comparing_means/I09-Comparing_means.pdf)|[R](Inference/I09-Comparing_means/I09-Comparing_means.R)|
|Multiple comparisons|[pdf](Inference/I10-Multiple_comparisons/I10-Multiple_comparisons.pdf)|[R](Inference/I10-Multiple_comparisons/I10-Multiple_comparisons.R)|


### Regression

|Topic|slides|code|
|---|---|---|
|Simple linear regression|[pdf](Regression/R01-Simple_linear_regression/R01-Simple_linear_regression.pdf)|[R](Regression/R01-Simple_linear_regression/R01-Simple_linear_regression.R)|
|Regression diagnostics|[pdf](Regression/R02-Regression_diagnostics/R02-Regression_diagnostics.pdf)|[R](Regression/R02-Regression_diagnostics/R02-Regression_diagnostics.R)|

 ============ updated to here =================


|Topic|Source|Handouts|
|---|---|---| 
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
