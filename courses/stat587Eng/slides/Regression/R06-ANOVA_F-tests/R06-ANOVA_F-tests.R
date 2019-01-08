## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("Sleuth3")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=FALSE----------------------------------------------------------
set.seed(1)
mu = rnorm(6)
opar = par(mar=rep(0,4) + 0.1)
curve(dnorm(x,mu[1]),-4,6, axes=F, frame=T, xlab="", ylab="", lwd=2)
for (i in 2:length(mu)) curve(dnorm(x, mu[i]), add=TRUE, lwd=2, col=i, lty=i)
par(opar)

## ----echo=FALSE----------------------------------------------------------
ggplot(Sleuth3::case0501, aes(x=Diet, y=Lifetime)) + 
  geom_jitter() + 
  # geom_hline(data=sm2, aes(yintercept=mean[7]), 
  #            col='red', size=2) + 
  # geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), 
  #               col='blue', size=2) +
  theme_bw()

## ----F-distribution, echo=FALSE------------------------------------------
df = c(5,300)
curve(df(x,df[1], df[2]), 0, 4, main=expression(F[list(5,300)]),
      xlab="x",
      ylab="Probability density function",
      lwd=2)
xx = c(2, seq(2, 4,by=.01), 4)
yy = c(0, df(xx[-c(1,length(xx))], df[1], df[2]), 0)
polygon(xx,yy, col='red', border=NA)

## ----echo=FALSE, warning=FALSE-------------------------------------------
sm <- Sleuth3::case0501 %>%
  group_by(Diet) %>%
  summarize(n = n(),
            mean = mean(Lifetime),
            sd = sd(Lifetime))
total <- Sleuth3::case0501 %>% 
  summarize(n = n(), 
            mean = mean(Lifetime),
            sd = sd(Lifetime)) %>%
  mutate(Diet = "Total")
(sm2 <- bind_rows(sm,total))

## ----echo=FALSE----------------------------------------------------------
ggplot(Sleuth3::case0501, aes(x=Diet, y=Lifetime)) + 
  geom_jitter(size=3) + 
  geom_hline(data=sm2, aes(yintercept=mean[7]), 
             col='red', size=2) + 
  geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), 
                col='blue', size=2) +
  theme_bw()

## ------------------------------------------------------------------------
m <- lm(Lifetime~Diet, case0501)
anova(m)

## ----echo=FALSE----------------------------------------------------------
sm3 = sm 
sm3$mean[-which(sm3$Diet=="NP")] = mean(case0501$Lifetime[case0501$Diet!="NP"])
ggplot(case0501, aes(x=Diet, y=Lifetime)) + 
  geom_jitter(size=3) + 
  geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), 
                col='blue', size=2) + 
  geom_errorbar(data=sm3, aes(y=mean, ymin=mean, ymax=mean), 
                col='red', size=2) +
  theme_bw()

## ------------------------------------------------------------------------
case0501$NP = factor(case0501$Diet == "NP")

modR = lm(Lifetime~NP,   case0501) # (R)educed model
modF = lm(Lifetime~Diet, case0501) # (F)ull    model
anova(modR,modF)

## ----echo=FALSE----------------------------------------------------------
ggplot(Sleuth3::ex0816, aes(factor(Time), pH))+
  geom_boxplot(color="gray")+
  geom_point()+
  labs(x="Time", y="pH", 
       title="pH vs Time in Steer Carcasses") +
  theme_bw()

## ----echo=FALSE----------------------------------------------------------
ggplot(Sleuth3::ex0816, aes(Time, pH))+
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  labs(x="Time", y="pH", 
       title="pH vs Time in Steer Carcasses") +
  theme_bw()

## ------------------------------------------------------------------------
# Use as.factor to turn a continuous variable into a categorical variable
m_anova = lm(pH ~ as.factor(Time), Sleuth3::ex0816) 
m_reg   = lm(pH ~           Time , Sleuth3::ex0816)
anova(m_reg, m_anova)

