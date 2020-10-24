## ----libraries, message=FALSE, warning=FALSE, echo=FALSE, cache=FALSE------------------------------------------
library("tidyverse")
library("ggResidpanel")
library("scales")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## --------------------------------------------------------------------------------------------------------------
d = expand.grid(slope = c(-1,1),
                x = seq(0.1,2,length=101)) %>%
  dplyr::mutate(intercept = ifelse(slope > 0, -1, 1),
                `y,x` = intercept + slope*x,
                `y,log(x)` = intercept + slope*log(x),
                `log(y),x` = exp(intercept+slope*x),
                `log(y),log(x)` = exp(intercept+slope*log(x))) %>%
  tidyr::gather("model","y", `y,x`, `y,log(x)`, `log(y),x`, `log(y),log(x)`) %>%
  dplyr::mutate(model = factor(model, levels = c("y,x","log(y),x","y,log(x)","log(y),log(x)")),
                slope = ifelse(slope > 0, "positive", "negative"))

ggplot(d, aes(x, y, color = slope, linetype = slope)) +
  geom_line() + 
  facet_wrap(~model, scales = "free") + 
  labs(title = "Regression models using logarithms",
       x = "Explanatory variable", y = "Expected response") + 
  theme_bw()


## ----echo=FALSE------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(0, 2, length=101)) %>%
  mutate(negative = exp(1-2*x),
         positive = exp(-2+1.5*x)) %>%
  gather(slope, `Response Median`, negative, positive) %>%
  mutate(slope = paste(slope, "slope"))

ggplot(d, aes(x, `Response Median`)) +
  geom_line() +
  facet_wrap(~slope) +
  labs(x = "Explanatory variable") +  
  theme_bw()


## ----echo=FALSE------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(0.1, 2, length=101)) %>%
  mutate(negative = -1-log(x),
         positive = 1+log(x)) %>%
  gather(slope, `Expected response`, negative, positive) %>%
  mutate(slope = paste(slope, "slope"))

ggplot(d, aes(x, `Expected response`)) +
  geom_line() +
  facet_wrap(~slope) +
  labs(x = "Explanatory variable") +  
  theme_bw()


## ----echo=FALSE------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(1, 2.3, length=101)) %>%
  mutate(negative = exp(1-2*log(x)),
         positive = exp(-0.5+2*log(x))) %>%
  gather(slope, `Response Median`, negative, positive) %>%
  mutate(slope = paste(slope, "slope"))

ggplot(d, aes(x, `Response Median`)) +
  geom_line() +
  facet_wrap(~slope) +
  labs(x = "Explanatory variable") +  
  theme_bw()


## ----summary, echo = TRUE--------------------------------------------------------------------------------------
summary(Sleuth3::case0802)


## ----data, echo=FALSE------------------------------------------------------------------------------------------
# insulating <- structure(list(Time = c(5.79, 1579.52, 2323.7, 68.85, 108.29,
# 110.29, 426.07, 1067.6, 7.74, 17.05, 20.46, 21.02, 22.66, 43.4,
# 47.3, 139.07, 144.12, 175.88, 194.9, 0.27, 0.4, 0.69, 0.79, 2.75,
# 3.91, 9.88, 13.95, 15.93, 27.8, 53.24, 82.85, 89.29, 100.59,
# 215.1, 0.19, 0.78, 0.96, 1.31, 2.78, 3.16, 4.15, 4.67, 4.85,
# 6.5, 7.35, 8.01, 8.27, 12.06, 31.75, 32.52, 33.91, 36.71, 72.89,
# 0.35, 0.59, 0.96, 0.99, 1.69, 1.97, 2.07, 2.58, 2.71, 2.9, 3.67,
# 3.99, 5.35, 13.77, 25.5, 0.09, 0.39, 0.47, 0.73, 0.74, 1.13,
# 1.4, 2.38), Voltage = c(26L, 26L, 26L, 28L, 28L, 28L, 28L, 28L,
# 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 30L, 32L, 32L,
# 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L,
# 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L,
# 34L, 34L, 34L, 34L, 34L, 34L, 36L, 36L, 36L, 36L, 36L, 36L, 36L,
# 36L, 36L, 36L, 36L, 36L, 36L, 36L, 36L, 38L, 38L, 38L, 38L, 38L,
# 38L, 38L, 38L), Group = structure(c(1L, 1L, 1L, 2L, 2L, 2L, 2L,
# 2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L,
# 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 5L, 5L, 5L, 5L, 5L,
# 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L,
# 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 7L, 7L, 7L,
# 7L, 7L, 7L, 7L, 7L), .Label = c("Group1", "Group2", "Group3",
# "Group4", "Group5", "Group6", "Group7"), class = "factor")), .Names = c("Time",
# "Voltage", "Group"), class = "data.frame", row.names = c(NA,
# -76L))


g = ggplot(Sleuth3::case0802, aes(Voltage, Time)) +
  geom_point() +
  labs(y = "Time until breakdown (min)",
       x = "Voltage (kV)",
       title = "Insulating fluid breakdown") +
  theme_bw()
g


## ----dependson="data", echo=FALSE------------------------------------------------------------------------------
g + stat_smooth(method="lm")


## ----model, dependson="data"-----------------------------------------------------------------------------------
m <- lm(Time ~ Voltage, Sleuth3::case0802)


## ----diagnostics, dependson="model", fig.height=4, echo=FALSE--------------------------------------------------
# opar = par(mfrow=c(2,2)); plot(m, ask=FALSE); par(opar)
ggResidpanel::resid_panel(m, plots = c("resid","qq","cookd","index"),
                          smoother = TRUE, qqbands = TRUE)


## ----plot_logy, dependson="plot"-------------------------------------------------------------------------------
ggplot(Sleuth3::case0802, aes(Voltage, Time)) + 
  geom_point() + 
  stat_smooth(method="lm") + 
  labs(y = "Time until breakdown (min)",
       x = "Voltage (kV)",
       title = "Insulating fluid breakdown") +
  scale_y_log10(labels = comma) +
  theme_bw()


## ----logy_model, dependson="data"------------------------------------------------------------------------------
m <- lm(log(Time) ~ Voltage, Sleuth3::case0802)
ggResidpanel::resid_panel(m, plots = c("resid","qq","cookd","index"),
                          smoother = TRUE)


## ----logy_summary, dependson="logy_model", echo = TRUE---------------------------------------------------------
m <- lm(log(Time) ~ I(Voltage-30), Sleuth3::case0802)
exp(m$coefficients)
exp(confint(m))


## ----logy_estimates, dependson="logy_model", echo=FALSE--------------------------------------------------------
b <- m$coefficients
ci <- confint(m)

