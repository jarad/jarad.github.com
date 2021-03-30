## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
# library("plyr")
library("dplyr")
library("tidyr")
library("ggplot2")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n = 10
y = 3
probH0 = pbeta(0.5, 1+y, 1+n-y)
probH0   # p(H_0|y)
1-probH0 # p(H_A|y)


## ----echo=TRUE, size="scriptsize"-------------------------------------------------------------------------------------
y = 0.3
probH0 = 1/(1+dnorm(y, 0, sqrt(2))/dnorm(y, 0, 1))
probH0   # p(H_0|y)
1-probH0 # p(H_A|y)


## ---------------------------------------------------------------------------------------------------------------------
densities = data.frame(y = seq(-5, 5, length = 101)) %>%
  dplyr::mutate(H0 = dnorm(y, 0, 1),
                HA = dnorm(y, 0, sqrt(2))) %>%
  tidyr::gather("Hypothesis","density", H0, HA) 

ggplot(densities, aes(x = y, y = density, 
                      color = Hypothesis, linetype = Hypothesis)) +
  geom_line(size = 2) + 
  geom_vline(xintercept = y, color = "gray",linetype = "dotted", size = 2 ) + 
  geom_point(data = data.frame(y = y, 
                                density = dnorm(y, 0, c(1,sqrt(2))), 
                                Hypothesis = c("H0","HA")),
              aes(x=y, y=density, color = Hypothesis),
             size = 4) + 
  labs(title = "Ratio of predictive densities",
       y = "Prior predictive density") +
  theme_bw()


## ---------------------------------------------------------------------------------------------------------------------
d = data.frame(y = seq(-5, 5, length = 101)) %>%
  dplyr::mutate(H0 = 1/(1+dnorm(y, 0, sqrt(2))/dnorm(y, 0, 1)),
                HA = 1-H0) %>%
  tidyr::gather("Hypothesis", "Probability", H0, HA)

ggplot(d, aes(x=y, y=Probability, color = Hypothesis, linetype = Hypothesis)) + 
  geom_line(size = 2) +
  labs(title = "Posterior probabilities as a function of the data",
    y = "Posterior model probability") +
  theme_bw()


## ----normal_bayes_factor----------------------------------------------------------------------------------------------
d = expand.grid(y=seq(0,5,by=1), C=10^seq(0,4,by=0.1)) %>%
   dplyr::mutate(post_prob_H0 = 1/(1+1/exp(dnorm(y,0,1,log=TRUE)-dnorm(y,0,1+C,log=TRUE))))
  
ggplot(d, aes(sqrt(C), post_prob_H0, color=factor(y))) + 
  geom_line() + 
  labs(x = expression(sqrt(C)), y = expression(paste("p(",H[0],"|y)"))) + 
  scale_color_discrete(name="y") +
  theme_bw()

