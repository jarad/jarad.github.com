## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20200915)


## ---------------------------------------------------------------------------------------------------------------------
d <- expand.grid(nu = c(1,10,100),
                 x = seq(-4, 4, length = 1001)) %>%
  dplyr::mutate(pdf = dt(x, df = nu),
                cdf = pt(x, df = nu),
                `Degrees of freedom` = as.character(nu))

ggplot(d, aes(x=x, y = pdf, 
              color = `Degrees of freedom`, linetype = `Degrees of freedom`)) +
  geom_line() + 
  labs(y = "Probablity density function, p(x)",
       title = "Student's t random variables") + 
  theme_bw()


## ---------------------------------------------------------------------------------------------------------------------
ggplot(d, aes(x=x, y = cdf, 
              color = `Degrees of freedom`, linetype = `Degrees of freedom`)) +
  geom_line() + 
  labs(y = "Cumulative distribution function, F(x)",
       title = "Student's t random variables") +
  theme_bw()


## ---------------------------------------------------------------------------------------------------------------------
d <- expand.grid(nu = 10,
                 mu = c(0, 2),
                 sigma = c(1, 2),
                 x = seq(-4, 4, length = 1001)) %>%
  dplyr::mutate(pdf = dt((x-mu)/sigma, df = nu)/sigma,
                musigma = paste0(mu,sigma),
                mu = as.character(mu),
                sigma = as.character(sigma))

ggplot(d, aes(x=x, y = pdf, group = musigma, color = mu, linetype = sigma)) +
  geom_line() + 
  labs(y = "Probablity density function, p(x)",
       title = expression(paste("Student's ",t[10]," random variables")),
       linetype = expression(paste("Scale, ", sigma)),
       color = expression(paste("Location, ", mu))) +
  theme_bw()

