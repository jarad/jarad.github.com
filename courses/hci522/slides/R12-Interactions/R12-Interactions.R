## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-----------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("lme4")


## ----set_seed, echo=FALSE-------------------------------------------------------------------
set.seed(20220215)


## -------------------------------------------------------------------------------------------
longnosedace <- read_csv("longnosedace.csv")


## ----echo=TRUE------------------------------------------------------------------------------
longnosedace <- read_csv("longnosedace.csv")
lm_dace <- lm(log(count) ~ do2 + no3 + do2:no3, data = longnosedace)
summary(lm_dace)$coef

lm_dace2 <- lm(log(count) ~ do2 * no3, data = longnosedace)
summary(lm_dace2)$coef


## ----echo=TRUE------------------------------------------------------------------------------
glm_dace <- glm(count ~ do2 + no3 + do2:no3, data = longnosedace, family = poisson)
summary(glm_dace)$coef

glm_dace2 <- glm(count ~ do2 * no3, data = longnosedace, family = poisson)
summary(glm_dace2)$coef


## ----echo=TRUE, size="tiny"-----------------------------------------------------------------
lm_dace <- lm(log(count) ~ do2 * no3, data = longnosedace)
drop1(lm_dace, test="F")

glm_dace <- glm(count ~ do2 * no3, data = longnosedace, family = poisson)
drop1(glm_dace, test="Chi")


## ----echo=TRUE, size="tiny"-----------------------------------------------------------------
glm_breaks <- glm(breaks ~ wool*tension, data = warpbreaks, family = poisson)
summary(glm_breaks)$coef
drop1(glm_breaks, test="Chi")


## ----echo=TRUE, size="tiny"-----------------------------------------------------------------
glm_breaks <- glm(breaks ~ wool*tension, data = warpbreaks, family = poisson)
summary(glm_breaks)$coef
drop1(glm_breaks, test="Chi")


## ----echo=FALSE-----------------------------------------------------------------------------
n <- 20
d <- data.frame(mode = c("in-class","virtual"),
           engagement = runif(n*2, 1, 5)) %>%
  mutate(performance = engagement + (mode == "in-class") + rnorm(n*2, 0, 0.2))

ggplot(d, aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point()


## ----echo=FALSE-----------------------------------------------------------------------------

ggplot(d %>%
         mutate(performance = ifelse(mode == "in-class", -performance+8, performance)), 
       aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point() 


## ----echo=FALSE-----------------------------------------------------------------------------

ggplot(d %>%
         mutate(performance = ifelse(mode == "in-class", performance-engagement+2, performance)), 
       aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point() 


## ----echo=FALSE-----------------------------------------------------------------------------
n <- 20
d <- data.frame(mode = c("in-class","virtual"),
           engagement = sample(c("L","M","H"), n*2, replace = TRUE)) %>%
  mutate(performance = -2^(engagement == "L") + (mode == "in-class") + rnorm(n*2, 3, 0.2),
         engagement = factor(engagement, levels = c("L","M", "H")))

ggplot(d, aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point()


## ----echo=FALSE-----------------------------------------------------------------------------
ggplot(d %>%
         mutate(performance = ifelse(mode == "in-class", -performance+8, performance)), 
       aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point() 


## ----echo=FALSE-----------------------------------------------------------------------------
ggplot(d %>%
         mutate(performance = ifelse(mode == "in-class", performance+0.5*(engagement=="L"), performance)), 
       aes(x = engagement, y = performance, color = mode, shape = mode)) + 
  geom_point() 

