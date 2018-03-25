## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("Sleuth3")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mar=c(5,5,0,0)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), 
     case0501 %>% filter(Diet %in% c("NP","N/R50")), 
     xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

# yy = with(case0501 %>% filter(Diet %in% c("NP","N/R50")), 
#           by(Lifetime, Diet, mean))
# segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
par(opar)

## ------------------------------------------------------------------------
case0501$X <- ifelse(case0501$Diet == "N/R50", 1, 0)
unique(case0501$X)
(m <- lm(Lifetime ~ X, data = case0501, subset = Diet %in% c("NP","N/R50")))
confint(m)
predict(m, data.frame(X=1), interval = "confidence") # Expected lifetime on N/R50

## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mar=c(5,5,0,0)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), 
     case0501 %>% filter(Diet %in% c("NP","N/R50")), 
     xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

yy = with(case0501 %>% filter(Diet %in% c("NP","N/R50")),
          by(Lifetime, Diet, mean))
segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
par(opar)

## ------------------------------------------------------------------------
summary(m)$coefficients[2,4] # p-value
confint(m)
t.test(Lifetime ~ Diet, data = case0501, subset = Diet %in% c("NP","N/R50"), var.equal=TRUE)

## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
opar = par(mar=c(5,5,0,0)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), 
     case0501, 
     xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

# yy = with(case0501, 
#           by(Lifetime, Diet, mean))
# segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
par(opar)

## ------------------------------------------------------------------------
case0501 <- case0501 %>% 
  mutate(X1 = Diet == "N/R40",
         X2 = Diet == "N/R50",
         X3 = Diet == "NP",
         X4 = Diet == "R/R50",
         X5 = Diet == "lopro")

m <- lm(Lifetime ~ X1 + X2 + X3 + X4 + X5, data= case0501)
m
confint(m)

## ----echo=FALSE, fig.width=8, out.width='0.9\\textwidth'-----------------
case0501 <- Sleuth3::case0501
opar = par(mar=c(5,5,0,4)+.1)
plot(Lifetime~jitter(I(as.numeric(Diet)-1)), case0501, 
     xaxt='n', pch=19, cex.lab=1.5, 
     xlab="Diet", col='gray')
axis(1, seq(0,nlevels(case0501$Diet)-1), levels(case0501$Diet), cex=1.5)

yy = with(case0501, by(Lifetime, Diet, mean))
axis(4, yy[1], expression(beta[0]), las=1, cex.axis=1.5)
abline(h=yy[1], lwd=2)
segments((0:5)-.3, yy, (0:5)+.3, yy, col='red', lwd=2)
arrows(1:5,yy[1],1:5,yy[-1],col='red', lwd=4)
text(1:5, (yy[2:6]+yy[1])/2, 
     expression(beta[1],beta[2],beta[3],beta[4],beta[5]), 
     pos=4, col='red', cex=1.5, offset=1)
par(opar)

