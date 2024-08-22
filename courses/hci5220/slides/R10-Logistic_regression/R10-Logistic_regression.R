## ----libraries, message=FALSE, warning=FALSE, cache=FALSE------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("emmeans")
library("GGally")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------------
set.seed(20220215)


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
admission <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv") %>% select(-rank)
head(admission)
summary(admission)


## --------------------------------------------------------------------------------------------------------------------
ggpairs(admission)


## ----eval=FALSE, echo=TRUE-------------------------------------------------------------------------------------------
## plot_ly(admission, x = ~gre, y = ~gpa, z = ~admit, color = ~rank)


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
m <- glm(admit ~ I(gre-580) + I(gpa-3.4), data = admission, family = binomial)
summary(m)


## ----echo=TRUE, size='tiny'------------------------------------------------------------------------------------------
1/(1+exp(-coef(m)[1]))     # probability of acceptance with GRE 580 and GPA 3.4
1/(1+exp(-confint(m)[1,]))

100*(exp(coef(m)[-1])-1)
100*(exp(confint(m)[-1,])-1)


## ----probability-plot, echo=TRUE, eval=FALSE-------------------------------------------------------------------------
## nd <- expand.grid(gre = seq(220,800,length=101), gpa = 2:4)
## nd$p <- predict(m, newdata = nd, type="response")
## ggplot(nd, aes(x = gre, y = p, color = gpa, group = gpa)) +
##   geom_line() +
##   labs(x = "GRE score", y = "Probability of acceptance", color = "GPA")


## ----echo=FALSE------------------------------------------------------------------------------------------------------
nd <- expand.grid(gre = seq(220,800,length=101), gpa = 2:4)
nd$p <- predict(m, newdata = nd, type="response")
ggplot(nd, aes(x = gre, y = p, color = gpa, group = gpa)) +
  geom_line() +
  labs(x = "GRE score", y = "Probability of acceptance", color = "GPA")


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
Sleuth3::case2102


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
Sleuth3::case2102


## --------------------------------------------------------------------------------------------------------------------
g_moths <- ggplot(case2102, aes(x=Distance, y=Removed/Placed, color = Morph)) +
  geom_point(aes(size=Placed)) +
  labs(title="Randomized Experiment",
       x = "Distance from Liverpool (km)",
       y = "Proportion removed") +
  scale_color_manual(values = c("dark" = "black","light"="gray")) +
  scale_size_area()

g_moths


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
m <- glm(cbind(Removed, Placed - Removed) ~ Distance + Morph,
         data = case2102, family = binomial)
summary(m)


## --------------------------------------------------------------------------------------------------------------------
nd <- expand.grid(Distance = seq(0,60,length=101), Morph = c("dark","light"))
nd$p <- predict(m, newdata = nd, type = "response")

g_moths + geom_line(data = nd, aes(y=p))


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
m <- glm(cbind(Removed, Placed - Removed) ~ Distance + Morph + Distance:Morph,
         data = case2102, family = binomial)
summary(m)


## --------------------------------------------------------------------------------------------------------------------
nd$p <- predict(m, newdata = nd, type = "response")

g_moths + geom_line(data = nd, aes(y=p))


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
em <- emmeans(m, ~ Morph, at = list(Distance = 15))
em_ci <- confint(em, type = "response")
em_ci


## ----echo=TRUE-------------------------------------------------------------------------------------------------------
et <- emtrends(m, ~ Morph, var = "Distance")
et_ci <- confint(et)
et_ci

