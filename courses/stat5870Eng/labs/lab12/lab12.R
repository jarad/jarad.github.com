# Author: Jarad Niemi
# Date:   2024-11-22
# Purpose: Generalized linear mixed effect models using lme4
#-------------------------------------------------------------------------------


## install.packages("lme4")

library("dplyr")
library("ggplot2")
library("Sleuth3")
library("lme4")

#-------------------------------------------------------------------------------
# Linear regression
#-------------------------------------------------------------------------------

m_lm  <- lm( Velocity ~ Distance, data = case0701)
m_glm <- glm(Velocity ~ Distance, data = case0701)

summary(m_lm)
summary(m_glm)

#-------------------------------------------------------------------------------
# Logistic regression
#-------------------------------------------------------------------------------

levels(case2002$LC)
m <- glm(LC ~ CD, 
         data   = case2002, 
         family = binomial)

m

m <- glm(LC == "LungCancer" ~ CD, 
         data   = case2002, 
         family = binomial)

m

d <- case2002 |>
  mutate(lung_cancer = 1 * (LC == "LungCancer"))

m <- glm(LC == "LungCancer" ~ CD, 
         data   = d, 
         family = binomial)

m

summary(m)



# Create grouped data
lung_grouped <- case2002 |>
  group_by(CD) |>
  summarize(n = n(),
            y = sum(LC == "LungCancer"))

lung_grouped

# Use cbind(successes, failures)
m <- glm(cbind(y, n-y) ~ CD, 
         data   = lung_grouped, 
         family = binomial)

summary(m)



#-------------------------------------------------------------------------------
# Poisson regression
#-------------------------------------------------------------------------------

# Poisson regression
m <- glm(Matings ~ Age,
         data   = case2201,
         family = poisson)

summary(m)



#-------------------------------------------------------------------------------
# Chi-square tests (compare to F-tests)
#-------------------------------------------------------------------------------

mA <- glm(LC ~ BK + CD, data = case2002, family = binomial)
mI <- glm(LC ~ BK * CD, data = case2002, family = binomial)
anova(mA, mI, test = "Chi")



#-------------------------------------------------------------------------------
# Linear mixed effect models
#-------------------------------------------------------------------------------

library("lme4")
m <- lmer(Reaction ~ Days + (1| Subject), data = sleepstudy)
summary(m)

m <- lmer(Reaction ~ Days + (Days| Subject), data = sleepstudy)
summary(m)

#-------------------------------------------------------------------------------
# Generalized linear mixed effect models
#-------------------------------------------------------------------------------

m <- glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
           data = cbpp, 
           family = binomial)

summary(m)
