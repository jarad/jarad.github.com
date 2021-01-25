## ----options, echo=FALSE, warning=FALSE, message=FALSE---------------------------------------------------------
options(width=120)
opts_chunk$set(comment=NA, 
               fig.width=6, 
               fig.height=4.5, 
               size='tiny', 
               out.width='\\textwidth', 
               fig.align='center', 
               echo=FALSE,
               message=FALSE)


## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-------------------------------------------------------
library("tidyverse")
library("xtable")
library("Sleuth3")
library("emmeans")
library("ggResidpanel")
my_plots = c("resid","qq","cookd","index","ls","lev")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## ----echo=FALSE------------------------------------------------------------------------------------------------
d <- data.frame(woodID = paste0("wood",1:8),
                woodtype = factor(rep(c("Spruce","Maple"), each=4), 
                                  levels = c("Spruce","Maple"))) %>%
  group_by(woodtype) %>%
  mutate(glue = sample(rep(c("Gorilla","Titebond"), each=2))) %>%
  ungroup() %>%
  mutate(pounds = rnorm(n(), 250, 20) +
           ifelse(glue == "Titebond", 40, 0) +
           ifelse(woodtype == "Maple", 20, 0))


## ----echo=FALSE------------------------------------------------------------------------------------------------
d %>% select(-woodtype, -pounds)


## --------------------------------------------------------------------------------------------------------------
ggplot(d, aes(glue, pounds)) + geom_point() + theme_bw()


## --------------------------------------------------------------------------------------------------------------
m = lm(pounds ~ glue, data = d)
ggResidpanel::resid_panel(m, plots = my_plots[-6], qqbands = TRUE)


## ----echo=TRUE-------------------------------------------------------------------------------------------------
coefficients(m)
summary(m)$r.squared
confint(m)
emmeans(m, ~glue)


## ----echo = FALSE----------------------------------------------------------------------------------------------
ci_m = confint(m)
em = emmeans(m, ~glue)
ci = confint(em)


## ----echo=FALSE------------------------------------------------------------------------------------------------
d %>% select(-pounds)


## --------------------------------------------------------------------------------------------------------------
ggplot(d, aes(glue, pounds, color=woodtype, shape=woodtype)) + geom_point() + theme_bw()


## --------------------------------------------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + geom_point() + theme_bw()


## --------------------------------------------------------------------------------------------------------------
m <- lm(pounds ~ glue + woodtype, data = d)
summary(m)
confint(m)


## ----echo = TRUE-----------------------------------------------------------------------------------------------
d %>% group_by(woodtype, glue) %>% summarize(n = n())


## --------------------------------------------------------------------------------------------------------------
m <- lm(pounds ~ glue * woodtype, data = d)
summary(m)


## ----echo = TRUE-----------------------------------------------------------------------------------------------
anova(m)
drop1(m, test='F')


## ----echo=FALSE------------------------------------------------------------------------------------------------
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


## --------------------------------------------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + geom_point() + theme_bw()


## --------------------------------------------------------------------------------------------------------------
m <- lm(pounds ~ glue * woodtype, data = d)
summary(m)


## ----echo=FALSE------------------------------------------------------------------------------------------------
d <- data.frame(woodID = paste0("wood",1:20),
                woodtype = rep(c("Spruce","Maple","Oak","Cedar"), each=5)) %>%
  group_by(woodtype) %>%
  mutate(glue = sample(c("Gorilla","Titebond","Hot glue","Carpenter's","Weldbond"))) %>%
  ungroup() %>%
  mutate(pounds = rnorm(n(), 250, 20))


## --------------------------------------------------------------------------------------------------------------
ggplot(d, aes(woodtype, pounds, color=glue, shape=glue)) + 
  geom_point() + theme_bw()


## ----echo = TRUE-----------------------------------------------------------------------------------------------
m <- lm(pounds ~ glue + woodtype, data = d)
anova(m)


## --------------------------------------------------------------------------------------------------------------
summary(m)


## --------------------------------------------------------------------------------------------------------------
m <- lm(pounds ~ glue * woodtype, data = d)
anova(m)


## --------------------------------------------------------------------------------------------------------------
summary(m)

