## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("gridExtra")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220119)


## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(y = seq(-4,4,length = 1001)) %>%
  mutate(pdf = dnorm(y), cdf = pnorm(y))

g1 <- ggplot(d, aes(y, pdf)) +
  geom_line() +
  labs(title = "Y~N(0,1)",
       y = "Probability density function")

g2 <- ggplot(d, aes(y, cdf)) +
  geom_line() +
  labs(title = "Y~N(0,1)",
       y = "Cumulative distribution function")

grid.arrange(g1, g2, nrow = 1)


## ---------------------------------------------------------------------------------------------------------------------
ggplot(data.frame(x = seq(-3, 5, length=1001)), aes(x)) +
  stat_function(fun = dnorm, args = list(mean = -1, sd = 0.3), col = "red") +
  stat_function(fun = dnorm, args = list(mean = 2, sd = 2), col = "blue", linetype = 2) +
  labs(title = "Two bell-shaped curves",
       x = "y", y = "Probability density function")


## ---------------------------------------------------------------------------------------------------------------------
d <- tribble(
  ~group, ~mean, ~sd,
  "male", 69.2, 2.5,
  "female", 63.6, 2.2,
)

ggplot(data.frame(x = seq(55, 80, length = 1001)), aes(x=x)) +
  stat_function(fun = dnorm, args = list(mean = 69.2, sd = 2.5), color = "blue") +
  stat_function(fun = dnorm, args = list(mean = 63.6, sd = 2.2), color = "pink") +
  labs(title = "Heights", x = "Height (inches)",
       y = "Probability density function") +
  annotate("text", x = 61, y = 0.17, label = "Female", color = "pink") +
  annotate("text", x = 72, y = 0.15, label = "Male", color = "blue")


## ---------------------------------------------------------------------------------------------------------------------
d <- data.frame(x = seq(-3, 3, length=1001))

g1 <- ggplot(d, aes(x)) +
  stat_function(fun = dnorm, fill = "red", xlim = c(-3, 1), geom="area") +
  stat_function(fun = dnorm) +
  labs(title = "Areas under pdf",
       x = "y", y = "Probability density function")

g2 <- ggplot(d, aes(x)) +
  stat_function(fun = pnorm) +
  geom_segment(data = data.frame(x = 1, y = 0, xend = 1, yend = pnorm(1)),
               aes(x=x, xend=xend, y=y, yend=yend),
               color = "red") +
  labs(title = "Evaluations of cdf",
       x = "y", y = "Cumulative distribution function")

grid.arrange(g1, g2, ncol=2)


## ---------------------------------------------------------------------------------------------------------------------
mn <- 2
s  <- 3

d <- data.frame(x = seq(mn-3*s, mn+3*s, length=1001))

g1 <- ggplot(d, aes(x)) +
  stat_function(fun = dnorm, fill = "red", xlim = c(1, 4), geom="area",
                args = list(mean = mn, sd = s)) +
  stat_function(fun = dnorm, args = list(mean = mn, sd = s)) +
  labs(title = "Areas under pdf",
       x = "y", y = "Probability density function")

g2 <- ggplot(d, aes(x)) +
  stat_function(fun = pnorm,
                args = list(mean = mn, sd = s)) +
  geom_segment(data = data.frame(x = c(1,4), y = 0, xend = c(1,4),
                                 yend = pnorm(c(1,4), mean = mn, sd = s)),
               aes(x=x, xend=xend, y=y, yend=yend),
               color = "red") +
  labs(title = "Evaluations of the cdf",
       x = "y", y = "Cumulative distribution function")

grid.arrange(g1, g2, ncol=2)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
mn <- -3
s  <- 4


## ----echo = TRUE------------------------------------------------------------------------------------------------------
pnorm(0, mean = -3, sd = 4)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
1-pnorm(1, mean = -3, sd = 4)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
mn <- -3
s  <- 4


## ----echo = TRUE------------------------------------------------------------------------------------------------------
pnorm(1, mean = -3, sd = 4) - pnorm(0, mean = -3, sd = 4)


## ---------------------------------------------------------------------------------------------------------------------
ggplot(data.frame(x = seq(55, 75, length = 1001)), aes(x=x)) +
  stat_function(fun = dnorm, args = list(mean = 63.6, sd = 2.2),
                geom = "area", xlim = c(60,75), fill = "pink") +
  stat_function(fun = dnorm, args = list(mean = 63.6, sd = 2.2)) +
  labs(title = "Heights", x = "Height (inches)",
       y = "Probability density function") +
  annotate("text", x = 61, y = 0.17, label = "Female", color = "pink")


## ----echo = TRUE------------------------------------------------------------------------------------------------------
1-pnorm(60, mean = 63.6, sd = 2.2)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
heights <- c(66.9, 63.2, 58.7, 64.2, 65.1)

length(heights) # number of observations
mean(heights) # sample mean
var(heights)  # sample variance
sd(heights)   # sample standard deviation


## ---------------------------------------------------------------------------------------------------------------------
dlst <- function(x, df, location, scale) {
  dt((x-location)/scale, df = df)/scale
}

ggplot(data.frame(x = seq(50, 75, length = 1001)),
       aes(x=x)) +
  stat_function(fun = dlst,
                args = list(df = length(heights)-1,
                            location = mean(heights),
                            scale = sd(heights)/sqrt(length(heights)))) +
  labs(x = "Height (inches)",
        y = "Posterior belief",
        title = "Posterior belief about female mean height")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(heights, conf.level = 0.95)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
1-pt((60-mean(heights))/sd(heights), df = length(heights)-1)


## ----echo=TRUE, size="scriptsize"-------------------------------------------------------------------------------------
plst <- function(q, df, location, scale) { # location-scale t distribution
  pt( (q-location)/scale, df = df)
}
1-plst(60, df = length(heights)-1, location = mean(heights), scale = sd(heights)/sqrt(length(heights)))


## ---------------------------------------------------------------------------------------------------------------------
set.seed(20220208)
heights <- data.frame(sex = rep(c("male","female"), c(7, 11))) %>%
  mutate(height = ifelse(sex == "female", 63.6, 69.2) +
           rnorm(n()) * ifelse(sex == "female", 2.2, 2.5),
         height = round(height,1))

write_csv(heights, file = "heights.csv")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
d <- read_csv("heights.csv")

d %>%
  group_by(sex) %>%
  summarize(n = n(),
            mean = mean(height),
            sd = sd(height))


## ---------------------------------------------------------------------------------------------------------------------
s = d %>%
  group_by(sex) %>%
  summarize(n = n(),
            mean = mean(height),
            sd = sd(height))

ggplot(data.frame(x = seq(55,80, length=1001)), aes(x=x)) +
  stat_function(fun = dlst, args = list(df = s$n[s$sex == "female"],
                                        location = s$mean[s$sex == "female"],
                                        scale = s$sd[s$sex == "female"]/sqrt(s$n[s$sex == "female"])),
                color = "pink") +
  stat_function(fun = dlst, args = list(df = s$n[s$sex == "male"],
                                        location = s$mean[s$sex == "male"],
                                        scale = s$sd[s$sex == "male"]/sqrt(s$n[s$sex == "male"])),
                color = "blue") +
  labs(title = "Posterior beliefs about mean height",
       x = "Height (inches)",
       y = "Posterior")


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
rlst <- function(n, df, location, scale) {
  location+scale*rt(n, df = df)
}
n_reps <- 100000
mu_female <- rlst(n_reps, df = 11-1, location = 64.1, scale = 1.59/sqrt(11))
mu_male   <- rlst(n_reps, df =  7-1, location = 71.6, scale = 2.66/sqrt(7))
mean(mu_male > mu_female)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
a <- 1 - 0.95
quantile(mu_male - mu_female, prob = c(a/2, 1-a/2))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
d <- read_csv("heights.csv")
t.test(height ~ sex, data = d)

