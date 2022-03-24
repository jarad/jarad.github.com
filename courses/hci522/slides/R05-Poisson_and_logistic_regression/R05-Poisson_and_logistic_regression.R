## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")


## ----set_seed, echo=FALSE------------------------------------------------------------------------
set.seed(20220215)


## ------------------------------------------------------------------------------------------------
rate <- 4.5
d <- data.frame(y = 0:(3*rate)) %>%
  mutate(pmf = dpois(y, lambda = rate))

ggplot(d, aes(x=y, y=pmf)) +
  geom_point() +
  geom_line() +
  labs(title = paste0("Poisson probability mass function with rate ", rate),
       y = "P(Y=y)")


## ------------------------------------------------------------------------------------------------
ggplot(ex2223, aes(x = Temp, y = Incidents)) +
  geom_jitter(height = 0) +
  labs(title = "Shuttle O-ring failures")


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(Incidents ~ Temp, data = ex2223, family = poisson)
summary(m)


## ----echo=TRUE-----------------------------------------------------------------------------------
ci <- 100*(exp(confint(m)[2,])-1)
ci


## ------------------------------------------------------------------------------------------------
ggplot(ex2223, aes(x = Temp, y = Incidents)) +
  geom_point() +
  geom_line(aes(y=fitted(m)), color = "magenta") +
  labs(title = "Shuttle O-ring failures")


## ------------------------------------------------------------------------------------------------
theta <- 0.3
d <- data.frame(y = c(0,1)) %>%
  mutate(pmf = dbinom(y, 1, prob = theta))

ggplot(d, aes(x=y, y=pmf)) +
  geom_col(width = 0.1) +
  labs(title = paste0("Bernoulli pmf with probability of success ", theta),
       y = "P(Y=y)")


## ------------------------------------------------------------------------------------------------
g_vitc <- ggplot(ex2113, aes(x=Dose, y=ProportionWithout)) +
  geom_point(aes(size=Number)) +
  labs(title="Randomized Experiment",
       x = "Dose (g) of Vitamin C",
       y = "Proportion Healthy") +
  scale_size_area()

g_vitc


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(cbind(WithoutIllness, Number-WithoutIllness) ~ Dose,
         data = ex2113, family = binomial)
summary(m)


## ------------------------------------------------------------------------------------------------
ci <- 100*(exp(confint(m)[2,])-1)
ci


## ------------------------------------------------------------------------------------------------
g_vitc +
  geom_line(aes(y=fitted(m)), color = "magenta")

