
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, 
               fig.width=6, fig.height=5, 
               size='tiny', 
               out.width='0.8\\textwidth', 
               fig.align='center', 
               message=FALSE,
               echo=FALSE)
library(plyr)
library(ggplot2)
library(gridExtra)
library(xtable)
library(Sleuth3)
library(reshape2)


## ----fig.width=10--------------------------------------------------------
xx = 0:10
plot(xx, dbinom(xx, 10, .3), main="Probability mass function for Bin(10,.3)", xlab="x", ylab="P(X=x)", pch=19)


## ----fig.width=10--------------------------------------------------------
xx = 0:15
plot(xx, dpois(xx,3), main="Probability mass function for Po(3)", xlab="x", ylab="P(X=x)", pch=19)


## ------------------------------------------------------------------------
case2101


## ----out.width='0.7\\textwidth'------------------------------------------
ggplot(case2101, aes(x=Area, y=Extinct/AtRisk)) + geom_point()


## ----out.width='0.7\\textwidth'------------------------------------------
logit = function(p) log(p/(1-p))
ggplot(case2101, aes(x=log(Area), y=logit(Extinct/AtRisk))) + geom_point()


## ------------------------------------------------------------------------
m = glm(cbind(Extinct, AtRisk-Extinct) ~ log(Area), data=case2101, family="binomial")
summary(m)
confint(m)


## ------------------------------------------------------------------------
# LC is binary
summary(m <- glm(LC~FM+SS+BK+AG+YR+CD, data=case2002, family="binomial"))


## ----echo=TRUE-----------------------------------------------------------
head(case2201,10)


## ------------------------------------------------------------------------
ggplot(case2201, aes(x=Age, y=Matings)) + geom_point()


## ------------------------------------------------------------------------
ggplot(case2201, aes(x=Age, y=log(Matings+1))) + geom_point()


## ----echo=TRUE-----------------------------------------------------------
m = glm(Matings~Age, data=case2201, family="poisson")
summary(m)


## ----echo=TRUE-----------------------------------------------------------
mAge = median(case2201$Age)
m = glm(Matings~I(Age-mAge), data=case2201, family="poisson")
summary(m)


## ----echo=TRUE-----------------------------------------------------------
confint(m)


## ----echo=TRUE-----------------------------------------------------------
anova(glm(Matings~Age, data=case2201, family="poisson"),
      glm(Matings~Age + I(Age^2), data=case2201, family="poisson"),
      test="Chi")


## ----echo=TRUE-----------------------------------------------------------
summary(m <- glm(Salamanders~PctCover+ForestAge, data=case2202, family="poisson"))


## ----echo=TRUE-----------------------------------------------------------
# Perform all the drop-in-deviance tests
drop1(m, test="Chi")


