## ----load_packages-------------------------------------------------------
library("dplyr")
library("ggplot2")
library("Sleuth3")

## ------------------------------------------------------------------------
m <- lm(Lifetime ~ Diet, data = case0501)
anova(m)

## ------------------------------------------------------------------------
summary(m)

## ------------------------------------------------------------------------
m0 <- lm(Lifetime ~ 1, data = case0501) # 1 indicates intercept 
anova(m0, m)

## ------------------------------------------------------------------------
m0  <- lm(Speed ~ 1,                data = ex0920)
mS  <- lm(Speed ~ Starters,         data = ex0920)
mT  <- lm(Speed ~            Track, data = ex0920)
mST <- lm(Speed ~ Starters + Track, data = ex0920)

## ------------------------------------------------------------------------
anova(mST)

## ------------------------------------------------------------------------
anova(m0, mS ) # we are looking to add (S)tarters to the model
anova(mS, mST) # we are looking to add (T)rack    to the model

## ------------------------------------------------------------------------
anova(m0, mS, mST)

## ------------------------------------------------------------------------
m  <- lm(Speed ~ Track*Starters, data = Sleuth3::ex0920)
anova(m)

## ------------------------------------------------------------------------
m <- lm(Speed ~ Track + Starters, data = Sleuth3::ex0920)
drop1(m, test="F")

## ------------------------------------------------------------------------
mT  <- lm(Speed ~ Track,            data = Sleuth3::ex0920)
mS  <- lm(Speed ~         Starters, data = Sleuth3::ex0920)
mST <- lm(Speed ~ Track + Starters, data = Sleuth3::ex0920)
anova(mS,mST) # Consider adding Track into the model that already has Starters
anova(mT,mST) # Consider adding Starters into the model that already has Track

## ------------------------------------------------------------------------
m <- lm(Ingestion ~ Weight + Organic, data = Sleuth3::ex0921)
drop1(m, test='F')

## ------------------------------------------------------------------------
m <- lm(Ingestion ~ Weight * Organic, data = Sleuth3::ex0921)
drop1(m, test = 'F')

