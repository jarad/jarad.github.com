## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ----telomere_data, echo=FALSE-------------------------------------------
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

## ----telomere_plot, dependson="telomere_data", echo=FALSE----------------
ggplot(Telomeres, aes(x=years, y=telomere.length)) + 
  geom_point() + 
  geom_smooth(method='lm', se=FALSE) + 
  labs(x = "Years", y = "Telomere length (ratio)") + 
  theme_bw()

## ----residual_plot, dependson="telomere_data", echo=FALSE----------------
m <- lm(telomere.length ~ years, data = Telomeres)
Telomeres <- Telomeres %>%
  mutate(predict = predict(m),
         residuals = residuals(m),
         jittered_years = jitter(years))

ggplot(Telomeres, 
       aes(x = jittered_years, 
           y = telomere.length)) +
  geom_jitter(height = 0) + 
  geom_segment(aes(xend = jittered_years, yend = predict), color = "red") + 
  stat_smooth(method = "lm", se = FALSE) + 
  labs(main = "Telomere length vs years post diagnosis",
    x    = "Years post diagnosis (jittered)",
    y    = "Telomere length") + 
  theme_bw()

## ----hand_calculations, dependson="telomere_data", echo=TRUE-------------
sm <- Telomeres %>% 
  summarize(n    = n(), 
            Xbar = mean(years), 
            Ybar = mean(telomere.length),
            s_X  = sd(years), 
            s_Y  = sd(telomere.length), 
            r_XY = cor(telomere.length,years)) 
sm

## ----hand_calculations2, dependson="hand_calculations", echo=FALSE-------
SXX <- (sm$n-1)*sm$s_X^2
SYY <- (sm$n-1)*sm$s_Y^2
SXY <- (sm$n-1)*sm$s_X*sm$s_Y*sm$r_XY
beta1 <- SXY/SXX
beta0 <- sm$Ybar - beta1 * sm$Xbar
R2 <- sm$r_XY^2
SSE <- SYY*(1-R2)
sigma2 <- SSE/(sm$n-2)
sigma <- sqrt(sigma2)
SE_beta0 <- sigma*sqrt(1/sm$n + sm$Xbar^2/((sm$n-1)*sm$s_X^2))
SE_beta1 <- sigma*sqrt(                 1/((sm$n-1)*sm$s_X^2))
T0 <- -abs(beta0/SE_beta0)
T1 <- -abs(beta1/SE_beta1)

## ----regression_in_r, dependson="telomere_data", echo=TRUE---------------
m = lm(telomere.length~years, Telomeres)
summary(m)
confint(m)

## ----intervals, dependson="telomere_data", echo=TRUE---------------------
m = lm(telomere.length~years, Telomeres)
new = data.frame(years=4:6)
new %>% bind_cols(predict(m, new, interval="confidence") %>% as.data.frame)
new %>% bind_cols(predict(m, new, interval="prediction") %>% as.data.frame)

## ----echo=FALSE, fig.height=6, fig.width=7, out.width='0.8\\textwidth'----
plot(telomere.length~years, Telomeres, pch=19)
abline(m)
d = data.frame(years=seq(0,13,by=.1))
tmp = predict(m, d, interval="confidence")  
lines(d$years, tmp[,2], lwd=2, lty=2, col=2)
lines(d$years, tmp[,3], lwd=2, lty=2, col=2)
tmp = predict(m, d, interval="prediction")  
lines(d$years, tmp[,2], lwd=2, lty=3, col=3)
lines(d$years, tmp[,3], lwd=2, lty=3, col=3)
legend("topright", c("Regression line","Confidence bands","Prediction bands"), lty=1:3, lwd=2, col=1:3,
       bg="white")

## ----shifting_the_intercept, dependson="telomere_data", echo=TRUE--------
m0 = lm(telomere.length ~   years   , Telomeres) 
m4 = lm(telomere.length ~ I(years-4), Telomeres) 

coef(m0)
coef(m4)

confint(m0)
confint(m4)

