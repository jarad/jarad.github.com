## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("gridExtra")
# library("xtable")
# library("Sleuth3")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=FALSE----------------------------------------------------------
tomato = structure(list(Variety = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
2L, 2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L), .Label = c("A", 
"B", "C"), class = "factor"), Density = c(10L, 10L, 10L, 20L, 
20L, 20L, 30L, 30L, 30L, 40L, 40L, 40L, 10L, 10L, 10L, 20L, 20L, 
20L, 30L, 30L, 30L, 40L, 40L, 40L, 10L, 10L, 10L, 20L, 20L, 20L, 
30L, 30L, 30L, 40L, 40L, 40L), Yield = c(7.9, 9.2, 10.5, 11.2, 
12.8, 13.3, 12.1, 12.6, 14, 9.1, 10.8, 12.5, 8.1, 8.6, 10.1, 
11.5, 12.7, 13.7, 13.7, 14.4, 15.4, 11.3, 12.5, 14.5, 15.3, 16.1, 
17.5, 16.6, 18.5, 19.2, 18, 20.8, 21, 17.2, 18.4, 18.9)), .Names = c("Variety", 
"Density", "Yield"), class = "data.frame", row.names = c(NA, 
-36L))
tomato$Variety = relevel(tomato$Variety, ref="C")
ggplot(tomato, aes(x=Density, y=Yield, color=Variety)) + geom_jitter(height=0, width=0.1) + theme_bw()

## ------------------------------------------------------------------------
sm = tomato %>% 
  group_by(Variety, Density) %>% 
  summarize(n    = n(),
            mean = mean(Yield),
            sd   = sd(Yield))
sm

## ------------------------------------------------------------------------
ggplot(sm, aes(x=Density, y=mean, col=Variety)) + geom_line() + labs(y="Mean Yield") + theme_bw()

## ----echo=TRUE-----------------------------------------------------------
tomato$Density = factor(tomato$Density)
m = lm(Yield~Variety*Density, tomato)
anova(m)

## ----echo=TRUE-----------------------------------------------------------
library(emmeans)
emmeans(m, pairwise~Variety)

## ----echo=TRUE-----------------------------------------------------------
emmeans(m, pairwise~Density)

## ----echo=TRUE-----------------------------------------------------------
emmeans(m, pairwise~Variety*Density)

## ------------------------------------------------------------------------
tomato_unbalanced = tomato[-19,]
ggplot(tomato_unbalanced, aes(x=Density, y=Yield, color=Variety)) +  geom_jitter(height=0, width=0.1) + theme_bw()

## ------------------------------------------------------------------------
sm_unbalanced = tomato_unbalanced %>% 
  group_by(Variety, Density) %>% 
  summarize(n    = n(),
            mean = mean(Yield),
            sd   = sd(Yield))
sm_unbalanced

## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety*Density, tomato_unbalanced)
anova(m)

## ----echo=TRUE-----------------------------------------------------------
emmeans(m, pairwise~Variety)

## ----echo=TRUE-----------------------------------------------------------
emmeans(m, pairwise~Density)

## ----echo=TRUE-----------------------------------------------------------
emmeans(m, pairwise~Variety*Density)

## ------------------------------------------------------------------------
tomato_incomplete = tomato %>%
  filter(!(Variety == "B" & Density == 30)) %>%
  mutate(VarietyDensity = paste0(Variety,Density))
ggplot(tomato_incomplete, aes(x=Density, y=Yield, color=Variety)) + geom_jitter(height=0, width=0.1) + theme_bw()

## ------------------------------------------------------------------------
sm_incomplete = tomato_incomplete %>% 
  group_by(Variety, Density) %>% 
  summarize(n    = n(),
            mean = mean(Yield),
            sd   = sd(Yield))
sm_incomplete

## ----echo=TRUE-----------------------------------------------------------
m <- lm(Yield ~ Variety*Density, data=tomato_incomplete)
anova(m)

## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety:Density, tomato_incomplete)
anova(m)

## ----echo=TRUE-----------------------------------------------------------
# Note the -1 in order to construct the contrast
m = lm(Yield ~ VarietyDensity, tomato_incomplete)
em <- emmeans(m, ~ VarietyDensity) 
contrast(em, method = list(
#         A10 A20 A30 A40 B10 B20 B40 C10 C20 C30 C40  
"C-B" = c(  0,  0,  0,  0, -1, -1, -1,  1,  1,  0,  1)/3,
"C-A" = c( -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1)/4,
"B-A" = c( -1, -1,  0, -1,  1,  1,  1,  0,  0,  0,  0)/3)) %>%
  confint

## ----echo=TRUE-----------------------------------------------------------
m = lm(Yield~Variety:Density, tomato_incomplete)
emmeans(m, pairwise~Variety:Density)
# We could have used the VarietyDensity model, but this looks nicer

## ----echo=FALSE----------------------------------------------------------
ggplot(tomato, aes(x=Density, y=Yield, color=Variety)) + geom_jitter(height=0, width=0.1) + theme_bw()

## ----fig.width=10,out.width='0.9\\textwidth',echo=FALSE------------------
tomato = structure(list(Variety = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
2L, 2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L), .Label = c("A", 
"B", "C"), class = "factor"), Density = c(10L, 10L, 10L, 20L, 
20L, 20L, 30L, 30L, 30L, 40L, 40L, 40L, 10L, 10L, 10L, 20L, 20L, 
20L, 30L, 30L, 30L, 40L, 40L, 40L, 10L, 10L, 10L, 20L, 20L, 20L, 
30L, 30L, 30L, 40L, 40L, 40L), Yield = c(7.9, 9.2, 10.5, 11.2, 
12.8, 13.3, 12.1, 12.6, 14, 9.1, 10.8, 12.5, 8.1, 8.6, 10.1, 
11.5, 12.7, 13.7, 13.7, 14.4, 15.4, 11.3, 12.5, 14.5, 15.3, 16.1, 
17.5, 16.6, 18.5, 19.2, 18, 20.8, 21, 17.2, 18.4, 18.9)), .Names = c("Variety", 
"Density", "Yield"), class = "data.frame", row.names = c(NA, 
-36L))
tomato$Variety = relevel(tomato$Variety, ref="C")

g1 = ggplot(tomato, aes(x=Density, y=Yield)) + geom_jitter(height=0, width=0.1) + 
  stat_smooth(method="lm", formula=y~x+I(x^2), se=FALSE, color="black") +
  labs(title="No variety") + theme_bw()


# Need to construct the parallel curves 
lines = with(tomato,expand.grid(Density=seq(min(Density),max(Density),length=41),
                               Variety=levels(Variety)))
lines$Yield <- predict(lm(Yield~Density+I(Density^2)+Variety, tomato),lines)

g2 = ggplot(tomato, aes(x=Density, y=Yield, color=Variety)) + geom_jitter(height=0, width=0.1) + 
  geom_line(data=lines) + labs(title="Parallel curves") + theme_bw()

g3 = ggplot(tomato, aes(x=Density, y=Yield, color=Variety)) + geom_jitter(height=0, width=0.1) + 
  stat_smooth(method="lm", formula=y~x+I(x^2), se=FALSE) +
  labs(title="Independent curves") + theme_bw()
grid.arrange(g1,g2,g3, ncol=3)

## ------------------------------------------------------------------------
summary(lm(Yield~Density+I(Density^2), tomato))

## ------------------------------------------------------------------------
summary(lm(Yield~Density+I(Density^2) + Variety, tomato))

## ------------------------------------------------------------------------
summary(lm(Yield~Density*Variety+I(Density^2)*Variety, tomato))

## ----out.width='0.6\\textwidth', echo=FALSE------------------------------
set.seed(20121204)
opar = par(mar=rep(0,4))
plot(0,0, type="n", axes=F, 
     xlab='', ylab='', xlim=c(0.5,6.5), ylim=c(0.5,6.5))
segments(1:7-.5, .5, 1:7-.5, 6.5)
segments(.5, 1:7-.5, 6.5, 1:7-.5)
trts = rep(paste(rep(c("A","B","C"),each=4), rep(seq(10,40,by=10), 3), sep=""),3)
text(rep(1:6, each=6), rep(1:6, 6), sample(trts))
par(opar)

## ----out.width='0.6\\textwidth', echo=FALSE------------------------------
set.seed(20121204)
opar = par(mar=rep(0,4))
plot(0,0, type="n", axes=F, 
     xlab='', ylab='', xlim=c(0,8.5), ylim=c(0,7.5))
segments(1:9-.5, .5, 1:9-.5, 6.5)
for (i in c(.5, 3.5, 6.5)) segments(i, 1:7-.5, i+2, 1:7-.5)
trts = paste(rep(c("A","B","C"),each=4), rep(seq(10,40,by=10), 3), sep="")
for (i in c(1, 4, 7)) text(rep(c(i,i+1), each=2), rep(1:6, 2), sample(trts))
text(c(1.5,4.5,7.5), 0, paste("Block", 1:3))
par(opar)

## ----out.width='0.4\\textwidth', fig.width=4, fig.height=3, echo=FALSE----
set.seed(20121204)
opar = par(mar=rep(0,4))
plot(0,0, type="n", axes=F, 
     xlab='', ylab='', xlim=c(0,5.5), ylim=c(0,4))
segments(1:6-.5, .5, 1:6-.5, 3.5)
for (i in c(.5, 3.5)) segments(i, 1:4-.5, i+2, 1:4-.5)
trts = rep(c("A","B","C"),each=2)
for (i in c(1, 4)) text(rep(c(i,i+1), each=3), rep(1:3, 2), sample(trts))
text(c(1,2,4,5), .3, paste("Block", 1:2))
text(c(1.5,4.5), 3.7, c("Blocked","Unblocked"))
par(opar)

