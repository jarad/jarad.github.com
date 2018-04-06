## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("xtable")
library("Sleuth3")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=FALSE, results='asis'------------------------------------------
K = rbind("early rest - none @ 50kcal"=c( 0, 0,-1, 0, 1, 0),
          "40kcal/week - 50kcal/week" =c( 0, 2,-1, 0,-1, 0) / 2,
          "lo cal - hi cal"           =c(-2, 1, 1,-2, 1, 1) / 4)
colnames(K) = levels(case0501$Diet)
print(xtable(K))

## ----echo=FALSE,results='asis'-------------------------------------------
sm <- Sleuth3::case0501 %>%
  group_by(Diet) %>%
  summarize(n = n(),
            mean = mean(Lifetime),
            sd = sd(Lifetime))

sm %>% xtable %>% print

## ----echo=FALSE, results='asis'------------------------------------------
m = lm(Lifetime ~ Diet, data = Sleuth3::case0501)
sp = summary(m)$sigma

g = rowSums(K%*%sm$mean)
SEg = rowSums(sp*sqrt(K^2%*%(1/sm$n)))

df = sum(sm$n-1)
t = g/SEg
p = 2*pt(-abs(t),df)
L = g-qt(.975,df)*SEg
U = g+qt(.975,df)*SEg

tests = data.frame(g=g,"SE(g)"=SEg,t=t,p=p,L=L,U=U, check.names=FALSE)

print(xtable(tests))

## ----warning=FALSE-------------------------------------------------------
m = lm(Lifetime ~ Diet, data = Sleuth3::case0501) 
summary(m)
K

## ----warning = FALSE-----------------------------------------------------
library("lsmeans")
ls = lsmeans(m, ~ Diet)
ls

co = contrast(ls, 
              #                                   N/N85 N/R40 N/R50  NP R/R50 lopro
              list("early rest - none @ 50kcal"=c(    0,    0,   -1,  0,    1,    0),
                   "40kcal/week - 50kcal/week" =c(    0,    2,   -1,  0,   -1,    0) / 2,
                   "lo cal - hi cal"           =c(   -2,    1,    1, -2,    1,    1) / 4))
confint(co)

## ----echo=FALSE----------------------------------------------------------
d = structure(list(inf = c(9L, 12L, 18L, 10L, 24L, 17L, 30L, 16L, 
10L, 7L, 4L, 10L, 21L, 24L, 29L, 12L, 9L, 7L, 18L, 30L, 18L, 
16L, 16L, 4L, 9L, 18L, 17L, 19L, 32L, 5L, 26L, 4L), trt = structure(c(2L, 
4L, 7L, 1L, 7L, 5L, 6L, 3L, 4L, 6L, 1L, 3L, 6L, 4L, 4L, 7L, 2L, 
5L, 3L, 4L, 3L, 5L, 2L, 1L, 6L, 4L, 5L, 7L, 4L, 1L, 4L, 2L), .Label = c("F12", 
"F3", "F6", "O", "S12", "S3", "S6"), class = "factor"), row = c(4L, 
4L, 4L, 4L, 4L, 4L, 4L, 4L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 2L, 
2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L), 
    col = c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 1L, 2L, 3L, 4L, 5L, 
    6L, 7L, 8L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 1L, 2L, 3L, 4L, 
    5L, 6L, 7L, 8L)), .Names = c("inf", "trt", "row", "col"), class = "data.frame", row.names = c(NA, 
-32L))

d
d$sulfur = as.numeric(gsub("\\D","",d$trt))*100
d$sulfur[is.na(d$sulfur)] = 0
d$application = NA
d$application[grep("F",d$trt)] = "fall"
d$application[grep("S",d$trt)] = "spring"
d$application = factor(d$application)

d$trt = factor(d$trt, levels=c("F12","F6","F3","O","S3","S6","S12"), ordered=TRUE)

## ----echo=FALSE----------------------------------------------------------
plot(0,0, xlab="Sulfur (lbs/acre)", ylab="Application", 
     main="Treatment visualization",
     type="n", axes=F,
     xlim=c(-100,1500), ylim=c(.5,2.5))
axis(1, c(0,300,600,1200), lwd=0)
axis(2, c(1,2), c("spring","fall"), lwd=0)
xc = c(0,300,300,600,600,1200,1200)
yc = c(1.5,1,2,1,2,1,2)
rect(xc-100,yc-.4,xc+100,yc+.4)
text(xc,yc, c(8,rep(4,6)))

## ----echo=FALSE----------------------------------------------------------
plot(0,0, xlab="col", ylab="row", 
     main="Completely randomized design\n potato scab experiment",
     xlim=range(d$col)+c(-.5,.5), ylim=range(d$row)+c(-.5,.5), axes=F, type="n")
text(d$col, d$row, d$trt)
axis(1, 1:8, lwd=0)
axis(2, 1:4, lwd=0)
segments(1:9-.5,0.5,1:9-.5,4.5)
segments(0.5,1:5-.5,8.5,1:5-.5)

## ----echo=FALSE----------------------------------------------------------
ggplot(d, 
       aes(trt, inf)) + 
  geom_boxplot(color="gray") + 
  geom_jitter(height=0) +
  labs(x = "Sulfur", y = "Average scab percent") + 
  theme_bw()

## ----echo=FALSE----------------------------------------------------------
ggplot(d %>% 
         mutate(application = ifelse(is.na(application), "NA", application)), 
       aes(sulfur, inf, shape=application, color=application)) + 
  geom_jitter(height=0, width=10) +
  labs(x = "Sulfur", y = "Average scab percent") + 
  theme_bw()

## ----echo=FALSE----------------------------------------------------------
qplot(col, inf, data=d, color=application, geom="jitter", 
      xlab="Column ID", ylab="Scab percent") + 
  theme_bw()

## ----echo=FALSE----------------------------------------------------------
qplot(row, inf, data=d, color=application, geom="jitter", 
      xlab="Row ID", ylab="Scab percent") + 
  theme_bw()

## ----potato_in_R---------------------------------------------------------
#                               F12 F6 F3  0 S3 S6 S12
K = rbind("sulfur - control" = c( 1, 1, 1,-6, 1, 1,  1)/6,
          "fall - spring"    = c( 1, 1, 1, 0,-1,-1, -1)/3,
          "linear trend"     = c( 6, 0,-3,-6,-3, 0,  6)/1)
m = lm(inf ~ trt, data = d)
anova(m)

## ------------------------------------------------------------------------
par(mfrow=c(2,3))
plot(m,1:6)

## ------------------------------------------------------------------------
ls <- lsmeans(m, ~trt)
ls 

co <- contrast(ls, 
#                                         F12 F6 F3  0 S3 S6 S12           
               list("sulfur - control" = c( 1, 1, 1,-6, 1, 1,  1)/6,
                    "fall - spring"    = c( 1, 1, 1, 0,-1,-1, -1)/3,
                    "linear trend"     = c( 6, 0,-3,-6,-3, 0,  6)/1))
confint(co)

## ------------------------------------------------------------------------
d$residuals <- residuals(m)
ggplot(d, aes(col, residuals)) + geom_point() + stat_smooth(se=FALSE) + theme_bw()

