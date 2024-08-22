## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20190222)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
n = 10
a = 0.05 # 95\% CI
qt(1-a/2, df = n-1) 


## ----qinvgamma, echo=TRUE---------------------------------------------------------------------------------------------
qinvgamma <- function(p, shape, scale = 1) 
  1/qgamma(1-p, shape = shape, rate = scale)


## ----dsqrtinvgamma, echo=TRUE-----------------------------------------------------------------------------------------
dinvgamma <- function(x, shape, scale = 1) 
  dgamma(1/x, shape = shape, rate = scale)/x^2

dsqrtinvgamma = function(x, shape, scale) 
  dinvgamma(x^2, shape, scale)*2*x


## ---------------------------------------------------------------------------------------------------------------------
n <- 9
d <- data.frame(farm = paste0("farm",1:n), yield = rnorm(n, 200, 25))
write_csv(d, path="yield.csv")


## ----data, echo=TRUE--------------------------------------------------------------------------------------------------
yield_data <- read.csv("yield.csv")
nrow(yield_data)
yield_data


## ---------------------------------------------------------------------------------------------------------------------
ggplot(yield_data, aes(x = yield)) + 
  geom_histogram() + 
  theme_bw()


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n               = length(yield_data$yield); n
sample_mean     = mean(yield_data$yield);   sample_mean
sample_variance = var(yield_data$yield);    sample_variance


## ---------------------------------------------------------------------------------------------------------------------
my_dt <- function(x, df, mu, sd) {
  dt((x-mu)/sd, df = df)/sd
}
sd = sqrt((n-1)*sample_variance / (n-3) / n)

mean_posterior_density =
  ggplot(data.frame(x = c(sample_mean - 4*sd,
                          sample_mean + 4*sd)),
         aes(x=x)) +
  stat_function(fun = my_dt, 
                args = list(df = n-1, 
                            mu = sample_mean, 
                            sd = sd)) +
  labs(title = "Posterior density for population mean",
       x = "Mean yield (bushels per acre)",
       y = "Posterior probability density function") +
  theme_bw()

mean_posterior_density


## ---------------------------------------------------------------------------------------------------------------------
variance_posterior_density = 
ggplot(data.frame(x = c(0.1,5*sample_variance)),
       aes(x=x)) +
  stat_function(fun = dinvgamma, 
                args = list(shape = (n-1)/2, scale = (n-1)*sample_variance/2)) +
  labs(title = "Posterior density for population variance",
       x = "Variance of yield (bushels per acre)^2",
       y = "Posterior probability density function") +
  theme_bw()

variance_posterior_density 


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
# Posterior mean of population yield mean, E[mu|y]
sample_mean


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
# Posterior mean of population yield variance
post_mean_var = (n-1)*sample_variance / (n-3)
post_mean_var


## ----echo = TRUE------------------------------------------------------------------------------------------------------
# 95% credible interval for the population mean
a = 0.05
mean_ci = sample_mean + c(-1,1) *  qt(1-a/2, df = n-1) * sqrt(sample_variance/n)
mean_ci


## ----echo = TRUE------------------------------------------------------------------------------------------------------
# 95% credible interval for the population variance
var_ci = qinvgamma(c(a/2, 1-a/2), 
                   shape = (n-1)/2, 
                   scale = (n-1)*sample_variance/2)
var_ci


## ---------------------------------------------------------------------------------------------------------------------
mean_posterior_density +
  geom_vline(xintercept = sample_mean, color = "red", linetype = "dashed") +
  geom_vline(xintercept = mean_ci, color = "red")


## ---------------------------------------------------------------------------------------------------------------------
variance_posterior_density +
  geom_vline(xintercept = (n-1)*sample_variance/(n-3), color = "red", linetype = "dashed") +
  geom_vline(xintercept = var_ci, color = "red") 


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
# Posterior median and 95% CI for population yield standard deviation
sd_median = sqrt(qinvgamma(.5, shape = (n-1)/2, scale = (n-1)*sample_variance/2))
sd_median


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
# Posterior 95% CI for the population yield standard deviation
sd_ci = sqrt(var_ci)
sd_ci


## ---------------------------------------------------------------------------------------------------------------------
ggplot(data.frame(x=c(0.1, 1.5*max(sqrt(var_ci)))), aes(x=x)) +
  stat_function(fun = dsqrtinvgamma,
                args = list(shape = (n-1)/2,
                            scale = (n-1)*sample_variance/2)) +
  geom_vline(xintercept = sd_median,
             color = "red", linetype = "dashed") +
  geom_vline(xintercept = sd_ci, color = "red") +
  labs(title = "Posterior density for population standard deviation",
       x = "Standard deviation of yield (bushels per acre)",
       y = "Posterior probability density function") +
  theme_bw()


## ----eval=FALSE, echo=TRUE--------------------------------------------------------------------------------------------
## # Sufficient statistics
## n               = length(y)
## sample_mean     = mean(y)
## sample_variance = var(y)
## 
## # Posterior expectations
## sample_mean                   # mu
## (n-1)*sample_variance / (n-3) # sigma^2
## 
## # Posterior medians
## var_median = qinvgamma(.5, shape = (n-1)/2, scale = (n-1)*sample_variance/2)
## sd_median  = sqrt(median_var)
## 
## # Posterior credible intervals
## sample_mean + c(-1,1) *  qt(1-a/2, df = n-1) * sqrt(sample_variance/n)
## var_ci = qinvgamma(c(a/2,1-a/2), shape = (n-1)/2, scale = (n-1)*sample_variance/2)
## sd_ci  = sqrt(var_ci)

