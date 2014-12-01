
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


## ------------------------------------------------------------------------
tomato = read.csv("Ch13-tomato.csv")
ggplot(tomato, aes(x=Density, y=Yield, color=Variety)) + geom_point()


## ------------------------------------------------------------------------
sm = 
ddply(tomato, .(Variety, Density), summarize, 
      n    = length(Yield),
      mean = mean(Yield),
      sd   = sd(Yield))


## ------------------------------------------------------------------------
dcast(sm[,c("Variety","Density","n")], Variety~Density, value.var="n")


## ------------------------------------------------------------------------
dcast(sm[,c("Variety","Density","mean")], Variety~Density, value.var="mean")


## ------------------------------------------------------------------------
dcast(sm[,c("Variety","Density","sd")], Variety~Density, value.var="sd")


## ------------------------------------------------------------------------
ggplot(sm, aes(x=Density, y=mean, col=Variety)) + geom_line() +labs(y="Mean Yield")


## ----echo=TRUE-----------------------------------------------------------
tomato = read.csv("Ch13-tomato.csv")
tomato$Density = factor(tomato$Density)
m = lm(Yield~Variety*Density, tomato)
anova(m)


## ----echo=TRUE-----------------------------------------------------------
library(lsmeans)
lsmeans(m, pairwise~Variety)


## ----echo=TRUE-----------------------------------------------------------
lsmeans(m, pairwise~Density)


## ----echo=TRUE-----------------------------------------------------------
lsmeans(m, pairwise~Variety*Density)


