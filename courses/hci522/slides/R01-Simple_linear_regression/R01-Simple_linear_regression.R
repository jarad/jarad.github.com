## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("ggResidpanel")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220215)


## ----gpm-plot---------------------------------------------------------------------------------------------------------
mouse <- data.frame(sensitivity = rep(c(800,1200,1600,2000), times = 5)) %>%
  mutate(gpm = rnorm(n(), 650-sensitivity/10, 10))

g <- ggplot(mouse, aes(x = sensitivity, y = gpm)) +
  geom_point() +
  labs(x = "Mouse sensitivity (DPI)",
       y = "Gold per minute",
       title = "League of Legends")


## ---------------------------------------------------------------------------------------------------------------------
g + stat_smooth(method = "lm", se = FALSE)


## ---------------------------------------------------------------------------------------------------------------------
g + stat_smooth(method = "lm")


## ---------------------------------------------------------------------------------------------------------------------
dat <- data.frame(x = mouse$sensitivity,
                  y = mouse$gpm)

## breaks: where you want to compute densities
breaks <- seq(800, max(dat$x), len=4)
dat$section <- cut(dat$x, breaks)

## Get the residuals
dat$res <- residuals(lm(y ~ x, data=dat))

## Compute densities for each section, and flip the axes, and add means of sections
## Note: the densities need to be scaled in relation to the section size (2000 here)
dens <- do.call(rbind, lapply(split(dat, dat$section), function(x) {
    d <- density(x$res, n=50)
    res <- data.frame(x=max(x$x)- d$y*2000, y=d$x+mean(x$y))
    res <- res[order(res$y), ]
    ## Get some data for normal lines as well
    xs <- seq(min(x$res), max(x$res), len=50)
    res <- rbind(res, data.frame(y=xs + mean(x$y),
                                 x=max(x$x) - 2000*dnorm(xs, 0, sd(x$res))))
    res$type <- rep(c("empirical", "normal"), each=50)
    res
}))
dens$section <- rep(levels(dat$section), each=100)

ggplot(dat, aes(x, y)) +
  geom_point() +
  geom_smooth(method="lm", fill=NA, lwd=2) +
  # geom_path(data=dens[dens$type=="normal",], aes(x, y, group=section), color="salmon", lwd=1.1) +
  theme_bw() +
  geom_vline(xintercept=breaks, lty=2)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
m <- lm(gpm ~ sensitivity, data = mouse)
m


## ---------------------------------------------------------------------------------------------------------------------
g + stat_smooth(method = "lm", se = FALSE)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
confint(m)


## ---------------------------------------------------------------------------------------------------------------------
g + stat_smooth(method = "lm")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
summary(m)


## ---------------------------------------------------------------------------------------------------------------------
g


## ---------------------------------------------------------------------------------------------------------------------
g + stat_smooth(method = "lm", se = FALSE)


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = "resid")


## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(x = runif(100)) %>%
  mutate(y = rnorm(n(), (2*x)^2, 0.1))

ggplot(d, aes(x=x,y=y)) +
  geom_point()


## ---------------------------------------------------------------------------------------------------------------------
ggplot(d, aes(x=x,y=y)) +
  geom_point() +
  stat_smooth(method = "lm", se=FALSE)


## ---------------------------------------------------------------------------------------------------------------------
m2 <- lm(y~x, data = d)
resid_panel(m2, plots = "resid")


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = "qq")


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = "qq", qqbands = TRUE)


## ---------------------------------------------------------------------------------------------------------------------
m3 <- lm(y~x,
         data = data.frame(x = runif(200)) %>%
           mutate(y = x + rt(n(), df = 3)/10)
          )

resid_panel(m3, plots = "qq", qqbands = TRUE)


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = "resid")


## ---------------------------------------------------------------------------------------------------------------------
m4 <- lm(y~x,
         data = data.frame(x = runif(200)) %>%
           mutate(y = rnorm(n(), mean = x, sd = x))
          )

resid_panel(m4, plots = "resid")


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = "index")


## ---------------------------------------------------------------------------------------------------------------------
m5 <- lm(y~x, data = data.frame(x = runif(100)) %>%
  mutate(y = x + sin(1:n()/20) + rnorm(n(),0,0.5)))

resid_panel(m5, plots = "index")


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = c("resid","qq","index"), qqbands = TRUE)

