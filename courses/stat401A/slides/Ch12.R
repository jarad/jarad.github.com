
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
library(xtable)
library(Sleuth3)
library(reshape2)


## ----echo=TRUE-----------------------------------------------------------
m = step(lm(log(Bsal)~Sex+Senior+Age+Educ+Exper, case1202), direction="both", k=log(nrow(case1202)))


## ----echo=TRUE-----------------------------------------------------------
summary(m)
exp(confint(m))


