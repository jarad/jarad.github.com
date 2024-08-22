## ----libraries, message=FALSE, warning=FALSE, echo=FALSE--------------------------------------------------------------
library("tidyverse")
library("gridExtra")
library("abd")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ---------------------------------------------------------------------------------------------------------------------
d = data.frame(x = runif(100, -2, 2)) %>%
  dplyr::mutate(f = x^2,
                y = rnorm(n(), f, 0.1)) 

g1 = ggplot(d, aes(x = f, y = y)) + 
  geom_point() + 
  labs(x = "x^2") + 
  theme_bw()

g2 = ggplot(d, aes(x = x, y)) +
  geom_point() + 
  theme_bw()

gridExtra::grid.arrange(g1, g2)


## ---------------------------------------------------------------------------------------------------------------------
d = data.frame(x = runif(100, 0, 2)) %>%
  dplyr::mutate(f = log(x),
                y = rnorm(n(), f, 0.1)) 

g1 = ggplot(d, aes(x = f, y = y)) + 
  geom_point() + 
  labs(x = "log(x)") + 
  theme_bw()

g2 = ggplot(d, aes(x = x, y)) +
  geom_point() + 
  theme_bw()

gridExtra::grid.arrange(g1, g2)


## ---------------------------------------------------------------------------------------------------------------------
Telomeres = abd::Telomeres %>%
  dplyr::mutate(f = years - 5)

g1 = ggplot(Telomeres, aes(x = f, y = telomere.length)) + 
  geom_point() + 
  labs(x = "years - 5") + 
  stat_smooth(method = "lm", se = FALSE) + 
  theme_bw()

g2 = ggplot(Telomeres, aes(x = years, y = telomere.length)) +
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE) + 
  theme_bw()

gridExtra::grid.arrange(g1, g2)


## ----shifting_the_intercept, dependson="telomere_data", echo=TRUE-----------------------------------------------------
m0 = lm(telomere.length ~   years   , abd::Telomeres) 
m4 = lm(telomere.length ~ I(years-5), abd::Telomeres) 

coef(m0)
coef(m4)

confint(m0)
confint(m4)


## ---------------------------------------------------------------------------------------------------------------------
Telomeres = abd::Telomeres %>%
  dplyr::mutate(f = years/2)

g1 = ggplot(Telomeres, aes(x = f, y = telomere.length)) + 
  geom_point() + 
  labs(x = "years/2") + 
  stat_smooth(method = "lm", se = FALSE) + 
  theme_bw()

g2 = ggplot(Telomeres, aes(x = years, y = telomere.length)) +
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE) + 
  theme_bw()

gridExtra::grid.arrange(g1, g2)


## ----rescaling_the_slope, dependson="telomere_data", echo=TRUE--------------------------------------------------------
m0 = lm(telomere.length ~   years   , abd::Telomeres) 
m4 = lm(telomere.length ~ I(years/2), abd::Telomeres) 

coef(m0)
coef(m4)

confint(m0)
confint(m4)

