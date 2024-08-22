## ----libraries, message=FALSE, warning=FALSE, echo=FALSE--------------------------------------------------------------
library("tidyverse")
library("scales")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----telomere_data, echo=FALSE----------------------------------------------------------------------------------------
# From `abd` package
Telomeres <- structure(list(years = c(1L, 1L, 1L, 2L, 2L, 2L, 2L, 3L, 2L, 
4L, 4L, 5L, 5L, 3L, 4L, 4L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 6L, 7L, 
6L, 8L, 8L, 8L, 7L, 7L, 8L, 8L, 8L, 10L, 10L, 12L, 12L, 9L), 
    telomere.length = c(1.63, 1.24, 1.33, 1.5, 1.42, 1.36, 1.32, 
    1.47, 1.24, 1.51, 1.31, 1.36, 1.34, 0.99, 1.03, 0.84, 0.94, 
    1.03, 1.14, 1.17, 1.23, 1.25, 1.31, 1.34, 1.36, 1.22, 1.32, 
    1.28, 1.26, 1.18, 1.03, 1.1, 1.13, 0.98, 0.85, 1.05, 1.15, 
    1.14, 1.24)), .Names = c("years", "telomere.length"), class = "data.frame", row.names = c(NA, 
-39L)) %>%
  dplyr::mutate(jittered_years = jitter(years)) # used for plotting


## ----telomere_plot, dependson="telomere_data", echo=FALSE-------------------------------------------------------------
g = ggplot(Telomeres, aes(x=jittered_years, y=telomere.length)) + 
  geom_point() + 
  labs(title = "Telomere length vs years post diagnosis",
       x = "Years since diagnosis (jittered)", y = "Telomere length") + 
  theme_bw()

g


## ----telomere_plot_with_regression_line, dependson="telomere_plot", echo=FALSE----------------------------------------
g = g + geom_smooth(method='lm', se=FALSE)  
g


## ----slr_viz, echo = FALSE--------------------------------------------------------------------------------------------
xx = 0:9
d = expand.grid(mean = xx,
                x = seq(-3, 3, length = 101)) %>%
  dplyr::mutate(y = mean + dnorm(x),
                x = mean + x)

slr_viz = ggplot(d, aes(x=x, y=y, group = mean)) + 
  geom_hline(yintercept = xx, color = "gray") +
  geom_abline(intercept = 0, slope = 1, color = "blue") + 
  geom_line(color = "magenta", size = 2) + 
  coord_flip() +
  labs(title = "Simple linear regression model",
       x = "Response variable",
       y = "Explanatory variable") +
  theme_bw() 

slr_viz +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


## ----echo=FALSE, dependson = "slr_viz"--------------------------------------------------------------------------------
slr_viz + 
  scale_y_continuous(breaks = scales::pretty_breaks())


## ----dependson="telomere_plot_with_regression_line", echo=FALSE-------------------------------------------------------
g


## ----residual_plot, dependson="telomere_plot_with_regression_line", echo=FALSE----------------------------------------
m <- lm(telomere.length ~ years, data = Telomeres)
residuals =  Telomeres %>%
  mutate(predict = predict(m),
         residuals = residuals(m))

g +  geom_segment(aes(xend = jittered_years, yend = predict), 
                  data = residuals, color = "red") 


## ----hand_calculations, dependson="telomere_data", echo=TRUE----------------------------------------------------------
n    = nrow(Telomeres)
Xbar = mean(Telomeres$years)
Ybar = mean(Telomeres$telomere.length)
s_X  = sd(Telomeres$years)
s_Y  = sd(Telomeres$telomere.length)
r_XY = cor(Telomeres$telomere.length, Telomeres$years)

SXX = (n-1)*s_X^2
SYY = (n-1)*s_Y^2
SXY = (n-1)*s_X*s_Y*r_XY

beta1 = SXY/SXX
beta0 = Ybar - beta1 * Xbar

R2  = r_XY^2
SSE = SYY*(1-R2)

sigma2 = SSE/(n-2)
sigma  = sqrt(sigma2)

SE_beta0 = sigma*sqrt(1/n + Xbar^2/((n-1)*s_X^2))
SE_beta1 = sigma*sqrt(           1/((n-1)*s_X^2))


## ----pvalues_and_CIs, dependson="hand_calculations", echo=TRUE--------------------------------------------------------
# 95% CI for beta0
beta0 + c(-1,1)*qt(.975, df = n-2) * SE_beta0

# 95% CI for beta1
beta1 + c(-1,1)*qt(.975, df = n-2) * SE_beta1

# pvalue for H0: beta0 >= 0 and P(beta0<0|y)
pt(beta0/SE_beta0, df = n-2)

# pvalue for H1: beta1 >= 0 and P(beta1<0|y)
pt(beta1/SE_beta1, df = n-2)


## ----regression_in_r, dependson="telomere_data", echo=TRUE------------------------------------------------------------
m = lm(telomere.length ~ years, Telomeres)
summary(m)
confint(m)

