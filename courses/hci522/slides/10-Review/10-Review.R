## ----libraries, message=FALSE, warning=FALSE, cache=FALSE--------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())


## ----set_seed, echo=FALSE----------------------------------------------------------------------------------------------
set.seed(20220222)


## ----------------------------------------------------------------------------------------------------------------------
n <- 20
emergency <- data.frame(individual = 1:n,
                        audio_guide = sample(rep(c("Yes","No"), times = n/2))) %>%
  mutate(success = rbinom(n(), size = 1, prob = ifelse(audio_guide == "Yes", 0.7, 0.3)),
         success = ifelse(success, "Yes","No"),
         cortisol_baseline = rnorm(n(), 100, sd = 5),
         cortisol_stress   = rnorm(n(), ifelse(audio_guide == "Yes", 120, 130)))

write_csv(emergency, "emergency.csv")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
emergency <- read_csv("emergency.csv")

emergency


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(emergency, aes(x = individual, y = success, color = audio_guide)) +
  geom_point()


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
s_emergency <- emergency %>%
  group_by(audio_guide) %>%
  summarize(n = n(),
            y = sum(success == "Yes"))
s_emergency


## ----posterior-probabilities, echo=TRUE, eval=FALSE--------------------------------------------------------------------
## d <- data.frame(theta = seq(from=0, to=1, length=1001)) %>%
##   mutate(yes = dbeta(theta, shape1 = 1+7, shape2 = 1+10-7),
##          no  = dbeta(theta, shape1 = 1+4, shape2 = 1+10-4)) %>%
##   pivot_longer(cols = -theta, names_to = "audio_guide", values_to = "density")
## 
## ggplot(d, aes(x = theta, y = density, color = audio_guide, linetype = audio_guide)) +
##   geom_line() +
##   labs(x = "Probability of successful navigation",
##        y = "Posterior belief",
##        title = "Audio guide effect on emergency navigation")


## ----------------------------------------------------------------------------------------------------------------------
d <- data.frame(theta = seq(from=0, to=1, length=1001)) %>%
  mutate(yes = dbeta(theta, shape1 = 1+7, shape2 = 1+10-7),
         no  = dbeta(theta, shape1 = 1+4, shape2 = 1+10-4)) %>%
  pivot_longer(cols = -theta, names_to = "audio_guide", values_to = "density")

ggplot(d, aes(x = theta, y = density, color = audio_guide, linetype = audio_guide)) +
  geom_line() +
  labs(x = "Probability of successful navigation",
       y = "Posterior belief",
       title = "Audio guide effect on emergency navigation")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
n_reps <- 100000
prob_yes <- rbeta(n_reps, shape1 = 1+7, shape2 = 1+10-7)
prob_no  <- rbeta(n_reps, shape1 = 1+4, shape2 = 1+10-4)
mean(prob_yes > prob_no)

# Credible interval for the difference
a <- 1-0.95
quantile(prob_yes - prob_no, probs = c(a/2, 1-a/2))


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
emergency <- emergency %>%
  mutate(ratio = cortisol_stress / cortisol_baseline)

emergency


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
summary(emergency)


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(emergency, aes(x = individual, y = ratio, color = audio_guide)) +
  geom_point()


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(emergency, aes(x = audio_guide, y = ratio)) +
  geom_jitter(width=0.1)


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(emergency, aes(x = ratio, fill = audio_guide)) +
  geom_histogram()


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
s_emergency <- emergency %>%
  group_by(audio_guide) %>%
  summarize(n = n(),
            mean = mean(ratio),
            sd = sd(ratio)) %>%
  mutate(se = sd/sqrt(n))

s_emergency


## ----posterior-means, echo=TRUE, eval=FALSE----------------------------------------------------------------------------
## dlst <- function(x, df, location, scale) {
##   dt((x-location)/scale, df = df)/scale
## }
## 
## d <- data.frame(mu = seq(from=1.1, to=1.35, length=1001)) %>%
##   mutate(yes = dlst(mu, df = 10-1, location = 1.21, scale = 0.0208),
##          no  = dlst(mu, df = 10-1, location = 1.27, scale = 0.0177)) %>%
##   pivot_longer(cols = -mu, names_to = "audio_guide", values_to = "density")
## 
## ggplot(d, aes(x = mu, y = density, color = audio_guide, linetype = audio_guide)) +
##   geom_line() +
##   labs(x = "Probability of successful navigation",
##        y = "Posterior belief",
##        title = "Audio guide effect on cortisol ratio (stress/baseline)")


## ----------------------------------------------------------------------------------------------------------------------
dlst <- function(x, df, location, scale) {
  dt((x-location)/scale, df = df)/scale
}

d <- data.frame(mu = seq(from=1.1, to=1.35, length=1001)) %>%
  mutate(yes = dlst(mu, df = 10-1, location = 1.21, scale = 0.0208),
         no  = dlst(mu, df = 10-1, location = 1.27, scale = 0.0177)) %>%
  pivot_longer(cols = -mu, names_to = "audio_guide", values_to = "density")

ggplot(d, aes(x = mu, y = density, color = audio_guide, linetype = audio_guide)) +
  geom_line() +
  labs(x = "Probability of successful navigation",
       y = "Posterior belief",
       title = "Audio guide effect on cortisol ratio (stress/baseline)")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
n_reps <- 100000
mean_yes <- rt(n_reps, df = 10-1)*0.0208 + 1.21
mean_no  <- rt(n_reps, df = 10-1)*0.0177 + 1.27
mean(mean_no > mean_yes)

# Credible interval for the difference
a <- 1-0.95
quantile(mean_no - mean_yes, probs = c(a/2, 1-a/2))


## ----------------------------------------------------------------------------------------------------------------------
n <- 1000
nielsen <- data.frame(individual = 1:n) %>%
  mutate(satisfaction = rbinom(n(), 10, prob = 7/10))

write_csv(nielsen, file = "nielsen.csv")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
nielsen <- read_csv("nielsen.csv")

nielsen


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
summary(nielsen)


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(nielsen, aes(x = individual, y = satisfaction)) +
  geom_point()


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
ggplot(nielsen, aes(x = satisfaction)) +
  geom_bar() +
  scale_x_continuous(breaks = 0:10) +
  labs(x = "Satisfaction rating",
       y = "Number of respondents",
       title = "Nielsen working from home satisfaction rating")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
nielsen %>%
  summarize(n = n(),
            mean = mean(satisfaction),
            sd = sd(satisfaction)) %>%
  mutate(se = sd/sqrt(n))


## ----posterior-mean, echo=TRUE, eval=FALSE-----------------------------------------------------------------------------
## d <- data.frame(mu = seq(from=6.75, to=7.25, length=1001)) %>%
##   mutate(satisfaction = dlst(mu, df = 1000-1, location = 6.95, scale = 0.0468))
## 
## ggplot(d, aes(x = mu, y = satisfaction)) +
##   geom_line() +
##   labs(x = "Mean satisfaction",
##        y = "Posterior belief",
##        title = "Nielsen working from home mean satisfaction")


## ----------------------------------------------------------------------------------------------------------------------
d <- data.frame(mu = seq(from=6.75, to=7.25, length=1001)) %>%
  mutate(satisfaction = dlst(mu, df = 1000-1, location = 6.95, scale = 0.0468))

ggplot(d, aes(x = mu, y = satisfaction)) +
  geom_line() +
  labs(x = "Mean satisfaction",
       y = "Posterior belief",
       title = "Nielsen working from home mean satisfaction")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
# Credible interval for the difference
a <- 1-0.95
qt(c(a/2, 1-a/2), df = 1000-1)*0.0468 + 6.95

# Probability less than 7.0
pt( (7-6.95)/0.0468, df = 1000-1 )


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
nielsen %>%
  summarize(n = n(),
            y = sum(satisfaction >= 7),
            p = y/n)


## ----posterior-probability, echo=TRUE, eval=FALSE----------------------------------------------------------------------
## d <- data.frame(theta = seq(from=0.55, to=.7, length=1001)) %>%
##   mutate(satisfaction = dbeta(theta, shape1 = 1+621, shape2 = 1+1000-621))
## 
## ggplot(d, aes(x = theta, y = satisfaction)) +
##   geom_line() +
##   labs(x = "Probability 'satisfied or higher'",
##        y = "Posterior belief",
##        title = "Nielsen working from home satisfaction")


## ----------------------------------------------------------------------------------------------------------------------
d <- data.frame(theta = seq(from=0.55, to=.7, length=1001)) %>%
  mutate(satisfaction = dbeta(theta, shape1 = 1+621, shape2 = 1+1000-621))

ggplot(d, aes(x = theta, y = satisfaction)) +
  geom_line() +
  labs(x = "Probability 'satisfied or higher'",
       y = "Posterior belief",
       title = "Nielsen working from home satisfaction")


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
# Credible interval for the difference
a <- 1-0.95
qt(c(a/2, 1-a/2), df = 1000-1)*0.0468 + 6.95

# Probability less than 7.0
pt( (7-6.95)/0.0468, df = 1000-1 )


## ----echo=TRUE---------------------------------------------------------------------------------------------------------
# Credible interval for the difference
a <- 1-0.95
qbeta(c(a/2, 1-a/2), shape1 = 1+621, shape2 = 1+1000-621)

# Probability greater than 0.6
1-pbeta(0.6, shape1 = 1+621, shape2 = 1+1000-621)

