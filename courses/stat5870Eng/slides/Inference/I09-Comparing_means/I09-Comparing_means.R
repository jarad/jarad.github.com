## ----libraries, warning=FALSE-----------------------------------------------------------------------------------------
library("tidyverse")


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----data-------------------------------------------------------------------------------------------------------------
set.seed(20170301)

# Using the unknown population means and standard deviations
d <- bind_rows(
  tibble(process = "P1", sensitivity = rnorm(22,  7.8, 2.3)),
  tibble(process = "P2", sensitivity = rnorm(34,  9.3, 2.3)),
  tibble(process = "P3", sensitivity = rnorm( 7, 10.0, 2.3)))

# readr::write_csv(d, path="sensitivity.csv")


## ----d2, dependson="data"---------------------------------------------------------------------------------------------
# d <- readr::read_csv("sensitivity.csv")
d2 <- d %>% filter(process %in% c("P1","P2"))


## ----sm, dependson="d2"-----------------------------------------------------------------------------------------------
sm <- d2 %>%
  group_by(process) %>%
  summarize(
    n    = n(),
    mean = mean(sensitivity),
    sd   = sd(sensitivity)
  )
sm


## ----two-means-frequentist-by-hand, dependson="d2", echo=TRUE---------------------------------------------------------
v    <- sm$n[1] + sm$n[2] - 2
diff <- sm$mean[1] - sm$mean[2]

# Calculate standard error
sp2  <- ( (sm$n[1]-1)*sm$sd[1]^2 + (sm$n[2]-1)*sm$sd[2]^2 ) / v # Pooled variance
sp   <- sqrt(sp2)
se   <- sp * sqrt(1/sm$n[1] + 1/sm$n[2])

# Two-sided p-value
2 * pt(-abs(diff / se), df = v)

# Equal-tail confidence interval
diff + c(-1,1) * qt(.975, df = v) * se


## ----two-means-frequentist-t-test, dependson="d2",echo=TRUE-----------------------------------------------------------
(tt <- t.test(sensitivity ~ process, data = d2, var.equal = TRUE))

# Since estimate of the difference is negative
# the following is P(mu_1 - mu_2 > 0)
tt$p.value / 2


## ----two-means-frequentist-t-test-unequal-variance, dependson="d2",echo=TRUE------------------------------------------
t.test(sensitivity ~ process, 
       data = d2, 
       var.equal = FALSE)     # this was the default


## ----mu_draws, dependson="sm", echo=TRUE------------------------------------------------------------------------------
nr = 1e5
sims <- bind_rows(
  tibble(           # tibble is just a special data.frame
    rep     = 1:nr,
    process = "P1",
    mu      = sm$mean[1] + rt(nr, df = sm$n[1]-1) * sm$sd[1] / sqrt(sm$n[1])),
  tibble(
    rep     = 1:nr,
    process = "P2",
    mu      = sm$mean[2] + rt(nr, df = sm$n[2]-1) * sm$sd[2] / sqrt(sm$n[2]))
)


## ----mu_posteriors, dependson="mu_draws"------------------------------------------------------------------------------
ggplot(sims, aes(x=mu, y=after_stat(density), fill=process, group=process)) +
  geom_histogram(position = "identity", alpha=0.5, binwidth=0.1) +
  theme_bw()


## ----mu_difference, dependson="mu_draws", echo=TRUE-------------------------------------------------------------------
d3 <- sims %>%
  spread(process, mu) %>%
  mutate(diff = P1-P2)

# Bayes estimate for the difference
mean(d3$diff)

# Estimated 95% equal-tail credible interval
quantile(d3$diff, c(.025,.975))

# Estimate of the probability that mu1 is smaller than mu2
mean(d3$diff < 0)


## ----summary2, dependson="data"---------------------------------------------------------------------------------------
sm <- d %>%
  group_by(process) %>%
  summarize(
    n    = n(),
    mean = mean(sensitivity),
    sd   = sd(sensitivity)
  )
sm


## ----ftest, dependson="data", echo=TRUE-------------------------------------------------------------------------------
oneway.test(sensitivity ~ process, data = d)


## ----pairwise, dependson="ftest", echo=TRUE---------------------------------------------------------------------------
pairwise.t.test(d$sensitivity,
                d$process,
                pool.sd = FALSE,
                p.adjust.method = "none")


## ----mu3_draws, dependson="summary2"----------------------------------------------------------------------------------
sims <- bind_rows(
  sims, # groups 1 and 2
  tibble(
    rep = 1:nr,
    process = "P3",
    mu = sm$mean[3] + rt(nr, df = sm$n[3]-1) * sm$sd[3] / sqrt(sm$n[3]))
)


## ----mu3_posteriors, dependson="mu3_draws"----------------------------------------------------------------------------
ggplot(sims, aes(x=mu, y=after_stat(density), fill=process, group=process)) +
  geom_histogram(position = "identity", alpha=0.5, binwidth=0.1) +
  theme_bw()


## ----mu3_comparison, dependson="mu3_draws", echo=TRUE-----------------------------------------------------------------
# Estimate of the probability that one mean is larger than another
sims %>%
  spread(process, mu) %>%
  mutate(`mu1-mu2` = P1-P2,
            `mu1-mu3` = P1-P3,
            `mu2-mu3` = P2-P3) %>%
  select(`mu1-mu2`,`mu1-mu3`,`mu2-mu3`) %>%
  gather(comparison, diff) %>%
  group_by(comparison) %>%
  summarize(probability = mean(diff>0) %>% round(4),
            lower = quantile(diff, .025) %>% round(2),
            upper = quantile(diff, .975) %>% round(2)) %>%
  mutate(credible_interval = paste("(",lower,",",upper,")", sep="")) %>%
  select(comparison, probability, credible_interval)


## ----bartlett, dependson="data", echo=TRUE----------------------------------------------------------------------------
bartlett.test(sensitivity ~ process, data = d)


## ----ftest2, dependson="data", echo=TRUE------------------------------------------------------------------------------
oneway.test(sensitivity ~ process, data = d, var.equal = TRUE)


## ----pairwise2, dependson="ftest", echo=TRUE--------------------------------------------------------------------------
pairwise.t.test(d$sensitivity, d$process, p.adjust.method = "none")


## ----mu2_draws, dependson="summary2"----------------------------------------------------------------------------------
nr = 1e5
sims <- data.frame(rep = 1:nr,
  sigma = 1/sqrt( rgamma(nr,
                         shape = sum(sm$n-1)/2,
                         rate = sum((sm$n-1)*sm$sd^2)/2
                         )
                  )
  ) %>%
  mutate(
    mu1 = rnorm(nr, mean = sm$mean[1], sd = sigma / sqrt(sm$n[1])),
    mu2 = rnorm(nr, mean = sm$mean[2], sd = sigma / sqrt(sm$n[2])),
    mu3 = rnorm(nr, mean = sm$mean[3], sd = sigma / sqrt(sm$n[3])))


## ----mu2_posteriors, dependson="mu2_draws"----------------------------------------------------------------------------
d_plot <- sims %>% gather(parameter, draw, -rep, -sigma)
ggplot(d_plot, aes(draw, fill=parameter, group=parameter)) +
  geom_histogram(position = "identity", alpha = 0.5, binwidth=0.1) +
  theme_bw()


## ----mu2_comparison, dependson="mu2_draws", echo=TRUE-----------------------------------------------------------------
sims %>%
  mutate(`mu1-mu2` = mu1-mu2,
         `mu1-mu3` = mu1-mu3,
         `mu2-mu3` = mu2-mu3) %>%
  select(`mu1-mu2`,`mu1-mu3`,`mu2-mu3`) %>%
  gather(comparison, diff) %>%
  group_by(comparison) %>%
  summarize(probability = mean(diff>0) %>% round(4),
            lower = quantile(diff, .025) %>% round(2),
            upper = quantile(diff, .975) %>% round(2)) %>%
  mutate(credible_interval = paste("(",lower,",",upper,")", sep="")) %>%
  select(comparison, probability, credible_interval)

