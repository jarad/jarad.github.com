## ---- eval=FALSE--------------------------------------------------------------
## install.packages("lme4")


## -----------------------------------------------------------------------------
library("dplyr")
library("ggplot2")
# library("Sleuth3")
library("lme4")


## -----------------------------------------------------------------------------
m_lm  <- lm( Velocity ~ Distance, data = Sleuth3::case0701)
m_glm <- glm(Velocity ~ Distance, data = Sleuth3::case0701)


## -----------------------------------------------------------------------------
summary(m_lm)
summary(m_glm)


## -----------------------------------------------------------------------------
levels(Sleuth3::case2002$LC)
m <- glm(LC ~ CD, data = Sleuth3::case2002, family=binomial)
m


## -----------------------------------------------------------------------------
m <- glm(LC == "LungCancer" ~ CD, 
         data = Sleuth3::case2002, 
         family = binomial)
m


## -----------------------------------------------------------------------------
d <- Sleuth3::case2002 %>%
  mutate(lung_cancer = 1*(LC == "LungCancer"))
m <- glm(LC == "LungCancer" ~ CD, 
         data = d, 
         family = binomial)
m


## -----------------------------------------------------------------------------
summary(m)




## -----------------------------------------------------------------------------
lung_grouped <- Sleuth3::case2002 %>%
  group_by(CD) %>%
  summarize(n = n(),
            y = sum(LC == "LungCancer"))

lung_grouped


## -----------------------------------------------------------------------------
m <- glm(cbind(y,n-y) ~ CD, 
         data = lung_grouped, 
         family = binomial)
summary(m)




## -----------------------------------------------------------------------------
m <- glm(Matings ~ Age,
         data = Sleuth3::case2201,
         family = poisson)
summary(m)




## -----------------------------------------------------------------------------
mA <- glm(LC ~ BK + CD, data = Sleuth3::case2002, family = binomial)
mI <- glm(LC ~ BK * CD, data = Sleuth3::case2002, family = binomial)
anova(mA,mI, test="Chi")




## -----------------------------------------------------------------------------
library("lme4")
m <- lmer(Reaction ~ Days + (1| Subject), data = sleepstudy)
summary(m)


## -----------------------------------------------------------------------------
m <- lmer(Reaction ~ Days + (Days| Subject), data = sleepstudy)
summary(m)


## -----------------------------------------------------------------------------
m <- glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
              data = cbpp, family = binomial)
summary(m)

