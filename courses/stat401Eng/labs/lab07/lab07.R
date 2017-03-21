## ----install_packages, eval=FALSE----------------------------------------
## install.packages(c("dplyr","ggplot2","tidyr"))

## ----load_packages-------------------------------------------------------
library("dplyr")
library("ggplot2")
library("tidyr")

## ----set_seed------------------------------------------------------------
set.seed(20170320)

## ----simulating_data-----------------------------------------------------
n <- 100 
x <- rnorm(n)
b0 <- 1
b1 <- 2
sigma <- 0.1
error <- rnorm(n,0,sigma)
y <- b0+b1*x+error

d <- data.frame(x=x,y=y)

## ----visualize_data------------------------------------------------------
plot(y ~ x, data = d)

## ----visualize_using_ggplot----------------------------------------------
library("ggplot2")
ggplot(d, aes(x=x, y=y)) +
  geom_point() +
  theme_bw()

## ----running_regression--------------------------------------------------
m <- lm(y ~ x, data = d)

## ------------------------------------------------------------------------
m
summary(m)

## ------------------------------------------------------------------------
plot(y ~ x, data = d)
abline(m, col='blue')

## ------------------------------------------------------------------------
ggplot(d, aes(x=x, y=y)) +
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE) +
  theme_bw()

## ------------------------------------------------------------------------
opar = par(mfrow=c(2,3))  # Create a 2x3 grid of plots and save the original settings
plot(m, 1:6, ask=FALSE)   # Plot all 6 diagnostics plots
par(opar)                 # Return to original graphics settings

## ----errors--------------------------------------------------------------
n <- 100
errors <- data.frame(rep = 1:n,
                     normal       = rnorm(n),
                     heavy_tailed = rt(n, df=3),
                     right_skewed = exp(rnorm(n))) %>%
  
  mutate(right_skewed = right_skewed - exp(1/2),  # make sure errors have expectation of 0
         left_skewed  = 1-right_skewed) 

errors_long <- errors %>%
  tidyr::gather(distribution,value,-rep) %>%
  mutate(distribution = factor(distribution, 
                               levels = c("normal",
                                          "heavy_tailed",
                                          "right_skewed",
                                          "left_skewed")))

## ----histograms----------------------------------------------------------
ggplot(errors_long, aes(x=value)) + 
  geom_histogram() + 
  facet_grid(. ~ distribution) + 
  theme_bw()

## ----qqplot--------------------------------------------------------------
ggplot(errors_long, aes(sample=value)) + 
  stat_qq() + 
  facet_grid(. ~ distribution) + 
  theme_bw()

## ----baser_qqplot--------------------------------------------------------
opar = par(mfrow=c(1,4))
qqnorm(errors$normal, main="Normal")
qqline(errors$normal)
qqnorm(errors$heavy_tailed, main="Heavy-tailed")
qqline(errors$heavy_tailed)
qqnorm(errors$right_skewed, main="Right-skewed")
qqline(errors$right_skewed)
qqnorm(errors$left_skewed, main="Left-skewed")
qqline(errors$left_skewed)
par(opar)

## ------------------------------------------------------------------------
y <- errors %>%
  mutate(x = rnorm(n))

models <- list()
models[[1]] <- lm(normal       ~ x, data=y)
models[[2]] <- lm(heavy_tailed ~ x, data=y)
models[[3]] <- lm(right_skewed ~ x, data=y)
models[[4]] <- lm(left_skewed  ~ x, data=y)
names(models) <- c("normal","heavy_tailed","right_skewed","left_skewed")

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(models$normal, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(models$heavy_tailed, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(models$right_skewed, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(models$left_skewed, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
opar = par(mfrow=c(1,4))
for (i in 1:4) plot(models[[i]], 2, main=names(models)[i])
par(opar)

## ------------------------------------------------------------------------
n  <- 100
b0 <- 0
b1 <- 1
d  <- data.frame(x = runif(n)) %>%
  mutate(error = rnorm(n,0,x),
         y = b0+b1*x+error)
  
m <- lm(y~x, data=d)
opar <- par(mfrow=c(2,3))
plot(m, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
plot(m, 1)

## ------------------------------------------------------------------------
plot(m,3)

## ------------------------------------------------------------------------
n <- 100
b0 <-1 
b1 <- 2
d <- data.frame(x = rnorm(n)) %>%
  mutate(
    error =rnorm(n),
    y = b0+b1*x + error)

m <- lm(y ~ x, data = d)

## ------------------------------------------------------------------------
names(m)

## ------------------------------------------------------------------------
plot(m$residuals)

## ------------------------------------------------------------------------
d <- d %>% 
  mutate(error = sin(2*pi*(1:n)/n)+rnorm(n),
         y = b0+b1*x+error)

m <- lm(y ~ x, data = d)
plot(m$residuals)

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(m, 1:6, ask=FALSE)
par(opar)

## ------------------------------------------------------------------------
n <- 100
b0 <- 1
b1 <- 2
d <- data.frame(x = rnorm(n)) %>%
  mutate(y = b0+b1*x + rnorm(n))
                
m <- lm(y ~ x, data = d)

d$residuals <- m$residuals
plot(residuals ~ x, data = d)

## ------------------------------------------------------------------------
n <- 100
b0 <- 1
b1 <- 2
d <- data.frame(x = rnorm(n)) %>%
  mutate(y = b0+b1*x+x^2 + rnorm(n))
                
m <- lm(y ~ x, data = d)

d$residuals <- m$residuals
plot(residuals ~ x, data = d)

## ------------------------------------------------------------------------
opar <- par(mfrow=c(2,3))
plot(m, 1:6, ask=FALSE)
par(opar)

