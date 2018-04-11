## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("xtable")
library("Sleuth3")
library("emmeans")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=FALSE----------------------------------------------------------
d <- data.frame(woodID = paste0("wood",1:8),
                woodtype = factor(rep(c("Spruce","Maple"), each=4), 
                                  levels = c("Spruce","Maple"))) %>%
  group_by(woodtype) %>%
  mutate(glue = sample(rep(c("Gorilla","Titebond"), each=2))) %>%
  ungroup() %>%
  mutate(pounds = rnorm(n(), 250, 20) +
           ifelse(glue == "Titebond", 40, 0) +
           ifelse(woodtype == "Maple", 20, 0))

## ----echo=FALSE----------------------------------------------------------
d %>% select(-woodtype, -pounds)

## ------------------------------------------------------------------------
ggplot(d, aes(glue, pounds)) + geom_point() + theme_bw()

## ----message=TRUE--------------------------------------------------------
m <- lm(pounds ~ glue, data = d)
opar = par(mfrow=c(2,3)); plot(m, 1:6, ask=FALSE); par(opar)

## ------------------------------------------------------------------------
coefficients(m)
summary(m)$r.squared
confint(m)
emmeans(m, ~glue)

## ----echo=FALSE----------------------------------------------------------
d %>% select(-pounds)

## ------------------------------------------------------------------------
ggplot(d, aes(glue, pounds, color=woodtype, shape=woodtype)) + geom_point() + theme_bw()

## ------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + geom_point() + theme_bw()

## ------------------------------------------------------------------------
m <- lm(pounds ~ woodtype + glue, data = d)
summary(m)
confint(m)

## ------------------------------------------------------------------------
d %>% group_by(woodtype, glue) %>% summarize(n = n())

## ------------------------------------------------------------------------
m <- lm(pounds ~ woodtype * glue, data = d)
summary(m)

## ------------------------------------------------------------------------
anova(m)
drop1(m, test='F')

## ----echo=FALSE----------------------------------------------------------
set.seed(3)
d <- data.frame(woodID = paste0("wood",1:8),
                woodtype = factor(rep(c("Spruce","Maple"), each=4), 
                                  levels = c("Spruce","Maple"))) %>%
  group_by(woodtype) %>%
  mutate(glue = sample(rep(c("Gorilla","Titebond"), each=2))) %>%
  ungroup() %>%
  mutate(pounds = rnorm(n(), 250, 20) +
           ifelse(glue == "Titebond", 40, 0) +
           ifelse(woodtype == "Maple", 20, 0) + 
           ifelse(glue == "Titebond" & woodtype == "Maple", -50, 0))

## ------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + geom_point() + theme_bw()

## ------------------------------------------------------------------------
m <- lm(pounds ~ woodtype * glue, data = d)
summary(m)

## ----echo=FALSE----------------------------------------------------------
d <- data.frame(woodID = paste0("wood",1:20),
                woodtype = rep(c("Spruce","Maple","Oak","Cedar"), each=5)) %>%
  group_by(woodtype) %>%
  mutate(glue = sample(c("Gorilla","Titebond","Hot glue","Carpenter's","Weldbond"))) %>%
  ungroup() %>%
  mutate(pounds = rnorm(n(), 250, 20))

## ------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + 
  geom_point() + theme_bw()

## ------------------------------------------------------------------------
m <- lm(pounds ~ woodtype + glue, data = d)
anova(m)

## ------------------------------------------------------------------------
summary(m)

## ------------------------------------------------------------------------
m <- lm(pounds ~ woodtype * glue, data = d)
anova(m)

## ------------------------------------------------------------------------
summary(m)

