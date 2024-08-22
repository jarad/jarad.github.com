## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----echo=TRUE-----------------------------------------------------------
ggplot(Sleuth3::case2202, aes(ForestAge, Salamanders)) + 
  geom_point() + 
  theme_bw()

## ----echo=TRUE-----------------------------------------------------------
ggplot(Sleuth3::case2202, aes(ForestAge, log(Salamanders+1))) + 
  geom_point() + 
  theme_bw()

## ------------------------------------------------------------------------
m <- glm(Salamanders ~ ForestAge, 
         data = Sleuth3::case2202,
         family = "poisson")

summary(m)

## ----echo=TRUE-----------------------------------------------------------
ggplot(Sleuth3::case2202, aes(ForestAge, Salamanders)) + 
  geom_point() + 
  stat_smooth(method="glm", 
              se=FALSE, 
              method.args = list(family="poisson"))  +
  theme_bw() 

## ------------------------------------------------------------------------
m <- glm(Salamanders ~ ForestAge * PctCover, 
         data = Sleuth3::case2202,
         family = "poisson")

summary(m)

## ------------------------------------------------------------------------
airline = data.frame(year=1976:1985,
                     fatal_accidents = c(24,25,31,31,22,21,26,20,16,22),
                     passenger_deaths = c(734,516,754,877,814,362,764,809,223,1066),
                     death_rate = c(0.19,0.12,0.15,0.16,0.14,0.06,0.13,0.13,0.03,0.15)) %>%
  mutate(miles_flown = passenger_deaths / death_rate)

airline

## ------------------------------------------------------------------------
ggplot(airline, aes(year, fatal_accidents)) + 
  geom_point() + 
  scale_x_continuous(breaks= scales::pretty_breaks()) + 
  theme_bw()

## ------------------------------------------------------------------------
ggplot(airline, aes(year, fatal_accidents/miles_flown)) + 
  geom_point() + 
  scale_x_continuous(breaks= scales::pretty_breaks()) + 
  theme_bw()

## ------------------------------------------------------------------------
m <- glm(fatal_accidents ~ year + offset(log(miles_flown)), 
         data = airline,
         family = "poisson")

summary(m)

## ------------------------------------------------------------------------
m <- glm(fatal_accidents ~ year + log(miles_flown), 
         data = airline,
         family = "poisson")

confint(m) # No evidence coefficient for log(miles_flown) is incompatible with 1

## ----echo=FALSE----------------------------------------------------------
d = expand.grid(df = c(1,2,3,4,6,9),
                x = seq(0,8,by=0.01)) %>%
  mutate(density = dchisq(x, df)) %>%
  mutate(df = factor(df))
  
ggplot(d, aes(x, density, color=df, linetype=df, group=df)) + 
  geom_line() + 
  ylim(0,0.5) +
  theme_bw()

## ------------------------------------------------------------------------
m <- glm(Salamanders ~ ForestAge * PctCover, 
         data = Sleuth3::case2202,
         family = "poisson")

anova(m, test="Chi")

