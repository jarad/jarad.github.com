## --------------------------------------------------------------------------------------------------------
library("tidyverse")
theme_set(theme_bw()) # set a figure theme


## --------------------------------------------------------------------------------------------------------
n  <- 33
mn <- 13
s  <- 2
se <- s/sqrt(n) # standard error (used often below)


## --------------------------------------------------------------------------------------------------------
# Probability density function for a location-scale t-distribution
dlst <- function(x, df, location, scale) {
  dt((x-location)/scale, df = df)/scale
}

d <- data.frame(mu = seq(from = mn - 4*se, to = mn + 4*se, length = 1001)) %>%
  mutate(density = dlst(mu, df = n-1, location = mn, scale = se))

ggplot(d, aes(x = mu, y = density)) + 
  geom_line() + 
  labs(x = expression(mu),
       y = "Posterior belief",
       title = "Posterior belief about population mean")


## --------------------------------------------------------------------------------------------------------
pt( (13.5-mn)/se, df = n-1) - pt( (12-mn)/se, df = n-1)


## --------------------------------------------------------------------------------------------------------
ggplot(d, aes(x = mu, y = density)) + 
  stat_function(fun = dlst, xlim = c(12,13.5), geom="area", fill = "red",
                args = list(df = n-1, location = mn, scale = se)) + 
  geom_line() + 
  labs(x = expression(mu),
       y = "Posterior belief",
       title = "Belief that the mean is between 12 and 13.5")


## --------------------------------------------------------------------------------------------------------
a <- 1-0.95
qt(c(a/2, 1-a/2), df = n-1) * se + mn




## --------------------------------------------------------------------------------------------------------
d <- read_csv("normal-data.csv")

head(d)


## --------------------------------------------------------------------------------------------------------
sm <- d %>% 
  group_by(group) %>%
  summarize(n = n(),
            mn = mean(y),
            s = sd(y)) %>%
  mutate(se = s/sqrt(n))

sm


## --------------------------------------------------------------------------------------------------------
# Function to create the posterior
create_posterior <- function(sm) {
  
  data.frame(mu = seq(sm$mn-4*sm$se, sm$mn+4*sm$se, length=1001)) %>%
    mutate(posterior = dlst(mu, df = sm$n-1, location = sm$mn, scale = sm$se))
}

# Construct the curves
curves <- sm %>%
  group_by(group) %>%
  do(create_posterior(.)) %>%
  mutate(group = factor(group)) # so that we can use it as a linetype

# Plot curves
ggplot(curves, aes(x = mu, y = posterior, color = group, linetype = group)) +
  geom_line() + 
  labs(x = expression(mu),
       y = "Posterior belief",
       title = "Posterior beliefs for the mean in two groups.") 


## --------------------------------------------------------------------------------------------------------
n_reps <- 100000
mu1 <- rt(n_reps, df = sm$n[1]-1) * sm$se[1] + sm$mn[1]
mu2 <- rt(n_reps, df = sm$n[2]-1) * sm$se[2] + sm$mn[2]


## --------------------------------------------------------------------------------------------------------
mean(mu1 > mu2)


## --------------------------------------------------------------------------------------------------------
a <- 1-0.95
quantile(mu1 - mu2, probs = c(a/2, 1-a/2))

