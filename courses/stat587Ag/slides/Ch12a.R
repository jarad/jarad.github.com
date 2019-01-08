
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
library(reshape2)


## ------------------------------------------------------------------------
t1 <- read.csv("Ch12a-2-Story & 1-1_2-Story Houses 1946 & Newer.csv")
t2 <- read.csv("Ch12a-1-Story Houses 1946 & Newer (Detached).csv")

dat <- merge(t1,t2,all=T)
dat$YrSld = dat$Yr+dat$Mo/12

dim(dat)
summary(dat[,c(5,10,17,24,23)])
summary(dat$Exterior1)


## ------------------------------------------------------------------------
opar = par(mfrow=c(5,5), mar=c(0,0,4,0)+.1)
for (i in 7:ncol(dat)) {
  plot(Price~dat[,i], dat, main=names(dat)[i], xlab="", ylab="", axes=FALSE, frame=TRUE)
}
par(opar)


## ------------------------------------------------------------------------
slim <- dat[dat$Zone=="RL" & 
            dat$FB < 3 & 
            dat$BR > 1 &
            dat$Gar. < 4 & 
            dat$Area < 3000 & 
            dat$HB < 2 & 
            dat$Price>150000 & dat$Price<300000 & 
            dat$C.A =="Yes" &
            dat$GarType=="Attachd" &
            !(dat$Style %in% c("1.5 Fin", "2.5 Unf")) & 
            dat$Land.SF < 50000 &
            !(dat$Exterior1 %in% c("AsbShng", "BrkFace", "WdShing")),
            c(5,7,9,11:16,18:21,23:24,27)]

# eliminate unused factor levels
slim$Style = factor(slim$Style) 
slim$Exterior1 = factor(slim$Exterior1)
#rownames(slim) = 1:nrow(slim)
            
slim$BsmtFin = slim$Bsmt*slim$X.Fin/100
#slim$BsmtUnf = slim$Bsmt-slim$BsmtFin
#slim$Bsmt = NULL
slim$X.Fin = NULL
            
dim(slim)
            
# Exploratory analysis
summary(slim)


## ------------------------------------------------------------------------
opar = par(mfrow=c(4,4), mar=c(2,4,4,2)+.1)
for (i in 2:ncol(slim)) plot(Price~slim[,i], slim, main=names(slim)[i], xlab="", ylab="")
par(opar)


## ----echo=TRUE-----------------------------------------------------------
mod = lm(Price~., slim)
par(mfrow=c(2,3))
plot(mod,1:6, ask=F)


## ----"calculate MSPE", results='hide', warning=FALSE---------------------
set.seed(20141121)
test.id  = sample(nrow(slim), round(nrow(slim)*.25))
train.id = setdiff(1:nrow(slim), test.id)
test  = slim[test.id, ]
train = slim[train.id,]

mod = list()
mod[[1]] = step(lm(    Price ~., train), scope=~.  )
mod[[2]] = step(lm(    Price ~., train), scope=~.^2)
mod[[3]] = step(lm(log(Price)~., train), scope=~.  )
mod[[4]] = step(lm(log(Price)~., train), scope=~.^2)
mod[[5]] = step(lm(    Price ~., train), scope=~.  , k=log(nrow(train)))
mod[[6]] = step(lm(    Price ~., train), scope=~.^2, k=log(nrow(train)))
mod[[7]] = step(lm(log(Price)~., train), scope=~.  , k=log(nrow(train)))
mod[[8]] = step(lm(log(Price)~., train), scope=~.^2, k=log(nrow(train)))


lg = c(F,F,T,T,F,F,T,T) # Keeps track of which model used log(Price)

MSPE = rep(NA,length(mod))
for (i in 1:length(mod)) {
  yhat = predict(mod[[i]],test)
	if (lg[i]) yhat=exp(yhat)
	MSPE[i] = mean((yhat-test$Price)^2, na.rm=TRUE)
}

d_MSPE = data.frame(Response = ifelse(lg, "log(Price)", "Price"),
                   Interactions = c("No","Yes"),
                   Criterion = rep(c("AIC","BIC"), each=4),
                   "sqrt(MSPE)" = sqrt(MSPE), 
                   Ratio = MSPE/min(MSPE), check.names=FALSE)


## ----MSPE, results='asis'------------------------------------------------
print(xtable(d_MSPE, digits=c(NA, NA, NA, NA, 0, 2)), include.names=FALSE)
id = which.min(MSPE)


## ----"diagnostic plots"--------------------------------------------------
mod.final = lm(formula(mod[[id]]), slim)
opar = par(mfrow=c(2,3))
plot(mod.final, 1:6, ask=F)
par(opar)


## ----"quadratic terms?"--------------------------------------------------
opar = par(mfrow=c(2,3))
plot(residuals(mod.final)~slim$Area[-364])
plot(residuals(mod.final)~slim$YrBlt[-364])
plot(residuals(mod.final)~slim$BR[-364])
plot(residuals(mod.final)~slim$Gar.[-364])
plot(residuals(mod.final)~slim$Bsmt[-364])
plot(residuals(mod.final)~slim$BsmtFin[-364])
par(opar)


## ----"final model summary"-----------------------------------------------
summary(mod.final)


## ----prediction, echo=TRUE, size='normalsize'----------------------------
new <- read.csv("Ch12a-new.csv",header=T)
new$YrSld = 2012
exp(predict(mod.final, new, interval="confidence"))
exp(predict(mod.final, new, interval="prediction"))


