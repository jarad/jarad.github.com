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
library("Sleuth3")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## --------------------------------------------------------------------------------------------------------------
summary(m <- lm(Speed ~ Conditions * log(NetToWinner), data = Sleuth3::ex0920))


## --------------------------------------------------------------------------------------------------------------
df = 20
mn = 2
d = data.frame(x = seq(-5,5,length = 101)) %>%
  dplyr::mutate(negative = dt(x+mn, df),
                positive = dt(x-mn, df)) %>%
  tidyr::gather(estimate, value, negative, positive)

g = ggplot(d, aes(x=x, y = value, color = estimate, linetype = estimate)) +
  geom_line() +
  labs(title = "Two Posterior Distributions Resulting in the Same p-value",
       x = expression(beta[j]), y = "Posterior density") +
  theme_bw() +
  theme(legend.position = "none")

g


## --------------------------------------------------------------------------------------------------------------
g + stat_function(fun = function(x, df) dt(x+mn, df = df),
                  xlim = c(0,5),
                  geom = "area",
                  color = NA,
                  args = list(df = 20))


## --------------------------------------------------------------------------------------------------------------
g + stat_function(fun = function(x, df) dt(x-mn, df = df),
                  xlim = c(-5,0),
                  geom = "area",
                  color = NA,
                  args = list(df = 20))


## --------------------------------------------------------------------------------------------------------------
summary(m)$coefficients %>% round(2)

