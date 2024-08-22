## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----data, echo=TRUE--------------------------------------------------------------------------------------------------
successes = c(135,216)
attempts  = c(140,230)


## ----data_data_frame, dependson="data", echo=TRUE---------------------------------------------------------------------
d = data.frame(process   = factor(1:2),
               successes = successes,
               attempts  = attempts)


## ----frequentist_analysis, dependson="data_data_frame", echo=TRUE-----------------------------------------------------
prop.test(d$successes, d$attempts)


## ----posteriors, dependson="data_data_frame", echo=FALSE--------------------------------------------------------------
posterior <- function(d) {
  data.frame(theta = seq(.85,1,length=101)) %>%
       mutate(density = dbeta(theta, 1+d$successes, 1+d$attempts-d$successes))
}

dp <- d %>% group_by(process) %>% do(posterior(.))
  
ggplot(dp, aes(x=theta, y=density, color=process, linetype=process, group=process)) + 
  geom_line() + 
  labs(x = expression(theta),
       y = "Posterior densities") +
  theme_bw()


## ----bayesian_analysis, dependson="data_data_frame", echo=TRUE--------------------------------------------------------
n      <- 1e5
theta1 <- rbeta(n, 1+d$success[1], 1+d$attempts[1] - d$success[1])
theta2 <- rbeta(n, 1+d$success[2], 1+d$attempts[2] - d$success[2])
diff   <- theta1 - theta2

# Bayes estimate for the difference
mean(diff)

# Estimated 95% equal-tail credible interval
quantile(diff, c(.025,.975))

# Estimate of the probability that theta1 is less than theta2
mean(diff < 0)


## ----data2, echo=TRUE-------------------------------------------------------------------------------------------------
successes = c(135,216,10)
attempts  = c(140,230,10)


## ----data2_data_frame, dependson="data2", echo=TRUE-------------------------------------------------------------------
d = data.frame(process   = factor(1:3),
               successes = successes,
               attempts  = attempts)


## ----data2_frequentist_analysis, dependson="data2_data_frame", echo=TRUE----------------------------------------------
prop.test(d$successes, d$attempts)


## ----data2_frequentist_analysis2, dependson="data2_data_frame", echo=TRUE---------------------------------------------
# Need to specify a comparison to get confidence intervals of the difference
prop.test(d$successes[c(1,3)], d$attempts[c(1,3)])$conf.int


## ----data2_chi_square, dependson="data2_data_frame", echo=TRUE--------------------------------------------------------
d$failures <- d$attempts - d$successes
chisq.test(d[c("successes","failures")])


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
chisq.test(d[c("successes","failures")], simulate.p.value = TRUE)


## ----data2_bayesian, dependson="data2_data_frame"---------------------------------------------------------------------
posterior <- function(d) {
  data.frame(theta = seq(.85,1,length=101)) %>%
       mutate(density = dbeta(theta, 1+d$successes, 1+d$attempts-d$successes))
}

dp <- d %>% group_by(process) %>% do(posterior(.))
  
ggplot(dp, aes(x=theta, y=density, color=process, linetype=process, group=process)) + 
  geom_line() + 
  labs(x = expression(theta),
       y = "Posterior densities") +
  theme_bw()


## ----data2_posterior_simulation, dependson="data2_data_frame", echo=TRUE----------------------------------------------
posterior_samples <- function(d) {
  data.frame(
    rep = 1:1e5,
    name = paste0("theta", d$process),
    theta = rbeta(1e5, 1+d$successes, 1+d$attempts-d$successes),
    stringsAsFactors = FALSE) 
}

draws <- d %>% group_by(process) %>% do(posterior_samples(.)) %>% ungroup() %>%
  select(-process) %>% tidyr::spread(name, theta)

# Estimate of the comparison probabilities
draws %>% 
  summarize(`P(theta1>theta2|y)` = mean(draws$theta1 > draws$theta2),
            `P(theta1>theta3|y)` = mean(draws$theta1 > draws$theta3),
            `P(theta2>theta3|y)` = mean(draws$theta2 > draws$theta3)) %>%
  gather(comparison, probability)

