## ----libraries, message=FALSE, warning=FALSE, echo=FALSE, cache=FALSE----
library("dplyr")
library("ggplot2")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----data, echo=FALSE----------------------------------------------------
# Sleuth3::case0802
insulating <- structure(list(Time = c(5.79, 1579.52, 2323.7, 68.85, 108.29, 
110.29, 426.07, 1067.6, 7.74, 17.05, 20.46, 21.02, 22.66, 43.4, 
47.3, 139.07, 144.12, 175.88, 194.9, 0.27, 0.4, 0.69, 0.79, 2.75, 
3.91, 9.88, 13.95, 15.93, 27.8, 53.24, 82.85, 89.29, 100.59, 
215.1, 0.19, 0.78, 0.96, 1.31, 2.78, 3.16, 4.15, 4.67, 4.85, 
6.5, 7.35, 8.01, 8.27, 12.06, 31.75, 32.52, 33.91, 36.71, 72.89, 
0.35, 0.59, 0.96, 0.99, 1.69, 1.97, 2.07, 2.58, 2.71, 2.9, 3.67, 
3.99, 5.35, 13.77, 25.5, 0.09, 0.39, 0.47, 0.73, 0.74, 1.13, 
1.4, 2.38), Voltage = c(26L, 26L, 26L, 28L, 28L, 28L, 28L, 28L, 
30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 32L, 32L, 
32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 
34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 
34L, 34L, 34L, 34L, 34L, 34L, 36L, 36L, 36L, 36L, 36L, 36L, 36L, 
36L, 36L, 36L, 36L, 36L, 36L, 36L, 36L, 38L, 38L, 38L, 38L, 38L, 
38L, 38L, 38L), Group = structure(c(1L, 1L, 1L, 2L, 2L, 2L, 2L, 
2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L, 
4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 5L, 5L, 5L, 5L, 5L, 
5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 
6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 7L, 7L, 7L, 
7L, 7L, 7L, 7L, 7L), .Label = c("Group1", "Group2", "Group3", 
"Group4", "Group5", "Group6", "Group7"), class = "factor")), .Names = c("Time", 
"Voltage", "Group"), class = "data.frame", row.names = c(NA, 
-76L))

ggplot(insulating, aes(Voltage, Time)) + 
  geom_point() +
  stat_smooth(method="lm") + 
  theme_bw()

## ----model, dependson="data"---------------------------------------------
m <- lm(Time ~ Voltage, insulating)

## ----diagnostics, dependson="model"--------------------------------------
opar = par(mfrow=c(2,3)); plot(m, 1:6, ask=FALSE); par(opar)

## ----summary, dependson="data"-------------------------------------------
summary(insulating)

## ----plot, dependson="data"----------------------------------------------
g <- ggplot(insulating, aes(Voltage, Time)) + geom_point() + theme_bw(); g

## ----plot_logy, dependson="plot"-----------------------------------------
g + stat_smooth(method="lm") + scale_y_log10()

## ----logy_model, dependson="data"----------------------------------------
m <- lm(log(Time) ~ Voltage, insulating)
opar = par(mfrow=c(2,3)); plot(m, 1:6, ask=FALSE); par(opar)

## ----logy_summary, dependson="logy_model"--------------------------------
m$coefficients %>% exp
confint(m) %>% exp()
lm(log(Time) ~ Voltage, insulating, subset= Time != 5.79) %>% confint() %>% exp() # remove first observation

## ----logy_estimates, dependson="logy_model", echo=FALSE------------------
b <- m$coefficients
ci <- confint(m)

