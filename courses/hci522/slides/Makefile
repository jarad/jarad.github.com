CMD := gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=

PROBABILITY := \
  Probability/P1-Probability/P1-Probability.pdf \
  Probability/P2-Discrete_distributions/P2-Discrete_distributions.pdf \
  Probability/P3-Continuous_distributions/P3-Continuous_distributions.pdf \
  Probability/P4-Central_limit_theorem/P4-Central_Limit_Theorem.pdf \
  Probability/P5-Multiple_random_variables/P5-Multiple_random_variables.pdf 

INFERENCE := \
  Inference/I01-Statistics/I01-Statistics.pdf \
  Inference/I02-Likelihood/I02-Likelihood.pdf \
  Inference/I03-Bayesian_statistics/I03-Bayesian_parameter_estimation.pdf \
  Probability/Distributions/Exponential/Exponential.pdf \
  Probability/Distributions/Gamma/Gamma.pdf \
  Probability/Distributions/Inverse_gamma/Inverse_gamma.pdf \
  Probability/Distributions/Students_t/Students_t.pdf \
  Inference/I04-Normal_model/I04-Normal_model.pdf \
  Inference/I05-Confidence_intervals/Sampling_distribution.pdf \
  Inference/I05-Confidence_intervals/I05-Confidence_intervals.pdf \
  Inference/I06-Pvalues/Statistical_hypotheses.pdf \
  Inference/I06-Pvalues/I06-Pvalues.pdf \
  Inference/I06-Pvalues/Hypothesis_tests.pdf \
  Inference/I06-Pvalues/Correspondence_between_pvalues_and_confidence_intervals.pdf \
  Inference/I06-Pvalues/t-tests.pdf \
  Inference/I07-Posterior_model_probability/I07-Posterior_model_probability.pdf \
  Inference/I08-Comparing_probabilities/I08-Comparing_probabilities.pdf \
  Inference/I09-Comparing_means/I09-Comparing_means.pdf \
  Inference/I10-Multiple_comparisons/I10-Multiple_comparisons.pdf
  
REGRESSION := \
  Regression/R01-Simple_linear_regression/R01-Simple_linear_regression.pdf \
  Regression/R01-Simple_linear_regression/R01-Regression_choosing_explanatory_variables.pdf \
  Regression/R01-Simple_linear_regression/R01-Regression_prediction_intervals.pdf \
  Regression/R02-Regression_diagnostics/R02-Regression_diagnostics.pdf \
  Regression/R03-Logarithms/R03-Logarithms.pdf \
  Regression/R04-Categorical_explanatory_variables/R04-Categorical_explanatory_variables.pdf \
  Regression/R05-Multiple_regression/R05-Multiple_regression.pdf \
  Regression/R06-ANOVA_F-tests/R06-ANOVA_F-tests.pdf \
  Regression/R06-ANOVA_F-tests/R06-pvalue_interpretation.pdf \
  Regression/R07-Contrasts/R07-Contrasts.pdf \
  Regression/R08-Experimental_design/R08-Experimental_design.pdf \
  Regression/R09-Two-way_ANOVA/R09-Two-way_ANOVA.pdf
  
all: probability.pdf inference.pdf regression.pdf
  


probability.pdf: $(PROBABILITY)
	$(CMD)probability.pdf $(PROBABILITY)
	
inference.pdf: $(INFERENCE)
	$(CMD)inference.pdf $(INFERENCE)
	
regression.pdf: $(REGRESSION)
	$(CMD)regression.pdf $(REGRESSION)


%.pdf: %.Rnw commands.tex frontmatter.tex
	Rscript --vanilla makeslides.R $<

