## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("gridExtra")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220119)


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


## ----echo=TRUE, size="scriptsize"-------------------------------------------------------------------------------------
1-pt((60-mean(heights))/(sd(heights)/sqrt(length(heights))), df = length(heights)-1)


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

