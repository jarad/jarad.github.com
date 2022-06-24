## ----libraries, message=FALSE, warning=FALSE, cache=FALSE, echo=FALSE----------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## ----set_seed, echo=FALSE------------------------------------------------------------------
set.seed(20220215)


## ----echo=FALSE,size='LARGE'---------------------------------------------------------------
d <- data.frame(period = c("I","II"),
                sequence = LETTERS[1:2])
d


## ----echo=FALSE,size='LARGE'---------------------------------------------------------------
d <- data.frame(period = c("I","II","III"),
                seq1 = LETTERS[1:3],
                seq2 = LETTERS[c(2,3,1)],
                seq3 = LETTERS[c(3,1,2)],
                seq4 = LETTERS[c(1,3,2)],
                seq5 = LETTERS[c(2,1,3)],
                seq6 = LETTERS[3:1])
d


## ----echo=FALSE,size='Large'---------------------------------------------------------------
d <- data.frame(period = c("I","II"),
                seqAB = LETTERS[1:2],
                seqBA = LETTERS[2:1])
d


## ----echo=FALSE,size='Large'---------------------------------------------------------------
d <- data.frame(period = c("I","II","III"),
                seqABB = LETTERS[c(1:2,2)],
                seqBAA = LETTERS[c(2:1,1)])
d


## ----echo=TRUE, eval=FALSE, size='large'---------------------------------------------------
## library(lme4) # library(lmerTest)?
## m <- lmer(y ~
##             # fixed effects
##             treatment + period + sequence +
##             carryover + # carryover missing in first period
## 
##             # random effect
##             (1|subject),
## 
##           data = d)
## 
## anova(m) # Type III ?
## em <- emmeans(m, pairwise ~ treatment) # ??
## confint(em) # ??

