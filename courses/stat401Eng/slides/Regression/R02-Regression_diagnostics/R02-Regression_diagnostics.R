## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----data, echo=FALSE, warning=FALSE-------------------------------------
# From `abd` package
Telomeres <- structure(list(years = c(1L, 1L, 1L, 2L, 2L, 2L, 2L, 3L, 2L, 
4L, 4L, 5L, 5L, 3L, 4L, 4L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 6L, 7L, 
6L, 8L, 8L, 8L, 7L, 7L, 8L, 8L, 8L, 10L, 10L, 12L, 12L, 9L), 
    telomere.length = c(1.63, 1.24, 1.33, 1.5, 1.42, 1.36, 1.32, 
    1.47, 1.24, 1.51, 1.31, 1.36, 1.34, 0.99, 1.03, 0.84, 0.94, 
    1.03, 1.14, 1.17, 1.23, 1.25, 1.31, 1.34, 1.36, 1.22, 1.32, 
    1.28, 1.26, 1.18, 1.03, 1.1, 1.13, 0.98, 0.85, 1.05, 1.15, 
    1.14, 1.24)), .Names = c("years", "telomere.length"), class = "data.frame", row.names = c(NA, 
-39L))

ggplot(Telomeres, aes(years, telomere.length)) + 
  geom_point() + 
  stat_smooth(method = "lm") + 
  theme_bw()

## ----default_diagnostics, dependson = "data"-----------------------------
m <- lm(telomere.length ~ years, Telomeres)
opar = par(mfrow=c(2,3)); plot(m, 1:6, ask = FALSE); par(opar)

## ----leverage, dependson="data"------------------------------------------
m <- lm(telomere.length~years, Telomeres)

cbind(Telomeres, leverage = hatvalues(m)) %>%
  select(years, leverage) %>% 
  unique() %>% 
  arrange(-years)

## ----residuals, dependson="data"-----------------------------------------
m <- lm(telomere.length~years, Telomeres)

Telomeres %>%
  mutate(leverage     = hatvalues(m), 
         residual     = residuals(m), 
         standardized = rstandard(m),
         studentized  = rstudent(m)) 

## ----residual_vs_fitted, dependson="residuals"---------------------------
plot(m, 1)

## ----qqplot, dependson="residuals"---------------------------------------
plot(m, 2)

## ----absolute_residuals, dependson="residuals", echo=FALSE---------------
plot(m, 3)

## ----cooks_distance, dependson="residuals"-------------------------------
plot(m, 4)

## ----residuals_vs_leverage, dependson="residuals"------------------------
plot(m, 5)

## ----cooks_distance_vs_leverage, dependson="residuals"-------------------
plot(m, 6)

## ----residuals_vs_index, dependson="residuals", fig.height=3.5, echo=TRUE----
plot(residuals(m))

## ----residual_vs_explanatory, dependson="residuals", fig.height=3.5, echo=TRUE----
plot(Telomeres$years, residuals(m))

