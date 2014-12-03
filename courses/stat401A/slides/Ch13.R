
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
dcast(tomato, Variety~Density, value.var="Yield", fun=length)


## ------------------------------------------------------------------------
dcast(tomato, Variety~Density, value.var="Yield", fun=mean)


## ------------------------------------------------------------------------
dcast(tomato, Variety~Density, value.var="Yield", fun=sd)


## ------------------------------------------------------------------------
sm = ddply(tomato, .(Density, Variety), summarize, mean=mean(Yield))
ggplot(sm, aes(x=Density, y=mean, col=Variety)) + geom_line() +labs(y="Mean Yield")


## ----echo=TRUE-----------------------------------------------------------
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


## ------------------------------------------------------------------------
tomato_unbalanced = tomato[-19,]
ggplot(tomato_unbalanced, aes(x=Density, y=Yield, color=Variety)) + geom_point()


## ------------------------------------------------------------------------
dcast(tomato_unbalanced, Variety~Density, value.var="Yield", fun=length)


## ------------------------------------------------------------------------
dcast(tomato_unbalanced, Variety~Density, value.var="Yield", fun=mean)


## ------------------------------------------------------------------------
dcast(tomato_unbalanced, Variety~Density, value.var="Yield", fun=sd)


## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety*Density, tomato)
anova(m)


## ----echo=TRUE-----------------------------------------------------------
lsmeans(m, pairwise~Variety)


## ----echo=TRUE-----------------------------------------------------------
lsmeans(m, pairwise~Density)


## ----echo=TRUE-----------------------------------------------------------
lsmeans(m, pairwise~Variety*Density)


## ------------------------------------------------------------------------
tomato_incomplete = tomato[-c(19:21),]
ggplot(tomato_incomplete, aes(x=Density, y=Yield, color=Variety)) + geom_point()


## ------------------------------------------------------------------------
dcast(tomato_incomplete, Variety~Density, value.var="Yield", fun=length)


## ------------------------------------------------------------------------
dcast(tomato_incomplete, Variety~Density, value.var="Yield", fun=mean)


## ------------------------------------------------------------------------
dcast(tomato_incomplete, Variety~Density, value.var="Yield", fun=sd)


## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety:Density, tomato, subset=!(Variety=='B' & Density==30))
anova(m)


## ----echo=TRUE-----------------------------------------------------------
tomato$VarietyDensity = factor(paste(tomato$Variety, tomato$Density, sep=""))
# Note the -1 in order to construct the contrast
m = lm(Yield~VarietyDensity-1, tomato, subset=!(Variety=='B' & Density==30))
#                   A10 A20 A30 A40 B10 B20 B40 C10 C20 C30 C40   
K = rbind('C-B' = c(  0,  0,  0,  0, -1, -1, -1,  1,  1,  0,  1)/3,
          'C-A' = c( -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1)/4,
          'B-A' = c( -1, -1,  0, -1,  1,  1,  1,  0,  0,  0,  0)/3)

library(multcomp)
t = glht(m, linfct=K)
#summary(t)
confint(t, calpha=univariate_calpha())


## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety:Density, tomato, subset=!(Variety=='B' & Density==30))
lsmeans(m, pairwise~Variety:Density)
# We could have used the VarietyDensity model, but this looks nicer


