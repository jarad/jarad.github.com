
## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)
library(plyr)
library(ggplot2)
library(xtable)
library(Sleuth3)
library(reshape2)


## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
case1002$Species =      ifelse(grepl("bats", case1002$Type), "Bats", "Birds")
case1002$Echolocating = ifelse(grepl("non-", case1002$Type), "No", "Yes")
ggplot(case1002, aes(x=Mass, y=Energy, color=Species, shape=Echolocating)) +
  geom_point() + 
  scale_x_log10() + 
  scale_y_log10()


## ------------------------------------------------------------------------
m0 = lm(log(Energy)~1, case1002)
m1 = lm(log(Energy)~log(Mass)+Type, case1002)
anova(m0,m1)


## ------------------------------------------------------------------------
summary(m1)
confint(m1)


## ------------------------------------------------------------------------
library(lsmeans)
lsmeans(m1, 'Type', contr='pairwise')


## ------------------------------------------------------------------------
drop1(m1, test='F')


## ----tidy=FALSE----------------------------------------------------------
anova(lm(log(Energy)~Type, case1002),      m1)
anova(lm(log(Energy)~log(Mass), case1002), m1)


## ----tidy=FALSE----------------------------------------------------------
new = data.frame(Mass=50, Type='echolocating bats')
exp(predict(m1, new, interval='confidence'))
exp(predict(m1, new, interval='prediction'))


