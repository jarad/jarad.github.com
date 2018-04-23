## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("lme4")
library("emmeans")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(Subject, Reaction)) + geom_point() + theme_bw()

## ------------------------------------------------------------------------
summary(me <- lmer(Reaction ~ (1|Subject), sleepstudy))

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(Days, Reaction, color = Subject)) + 
  geom_point() + theme_bw()

## ------------------------------------------------------------------------
summary(me <- lmer(Reaction ~ Days + (1|Subject), sleepstudy))

## ----echo=FALSE----------------------------------------------------------
m <- lm(Reaction ~ Days + Subject, sleepstudy)
d <- data.frame(fixed_effect = summary(emmeans(m, ~Subject, at=list(Days=0)))$emmean,
                random_effect = ranef(me)$Subject) %>%
  mutate(fixed_effect = fixed_effect - mean(fixed_effect),
         random_effect = X.Intercept.)
ggplot(d, aes(fixed_effect, random_effect)) + theme_bw() + 
  geom_abline(intercept = 0, slope = 1, color='gray') +
  stat_smooth(method="lm", se=FALSE) + geom_point()

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(Days, Reaction, color = Subject)) + 
  geom_point() + theme_bw()

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(Days, Reaction, color = Subject)) + 
  geom_point() + theme_bw()

## ------------------------------------------------------------------------
summary(me <- lmer(Reaction ~ Days + (Days|Subject), sleepstudy))

## ------------------------------------------------------------------------
ggplot(cbpp, aes(period, incidence/size, color=herd, group=herd)) +
  geom_line() + theme_bw()

## ------------------------------------------------------------------------
me <- glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
            data = cbpp, family = binomial)
summary(me)

## ------------------------------------------------------------------------
em <- emmeans(me, ~ period, type="response") # for intrepretability
em

co <- contrast(em, list(`linear trend` = c(-1.5, -0.5, 0.5, 1.5)))
confint(co)

