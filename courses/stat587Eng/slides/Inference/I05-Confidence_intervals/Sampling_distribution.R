## ----libraries, message=FALSE, warning=FALSE, cache=FALSE------------------------------------------------------
library("plyr")
library("dplyr")
library("tidyr")
library("ggplot2")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## ----normal_samples, cache = TRUE------------------------------------------------------------------------------
mu = 35
sigma = 5
ns = 10*(2:5)
samples = expand.grid(rep = 1:1000, 
               n = ns,
               mu = mu, 
               sigma = sigma) %>%
  dplyr::group_by(rep, n) %>%
  do(data.frame(samples = rnorm(.$n, mean = mu, sd = sigma))) 


## ----normal_average, dependson = "normal_samples"--------------------------------------------------------------
d = samples %>%
  dplyr::summarize(average = mean(samples),
                   .groups = "keep") %>%
  dplyr::mutate(n = paste("n =", n))

density = expand.grid(x = seq(from = mu-sigma, to = mu+sigma, length = 1001),
                      n = ns) %>%
  dplyr::mutate(density = dnorm(x, mean = mu, sd = sigma/sqrt(n)),
                n = paste("n =", n))
  

ggplot(d, aes(x = average)) + 
  geom_histogram(aes(y=..density..), binwidth = .1) + 
  geom_line(data = density, aes(x=x, y = density), color = "red") + 
  facet_wrap(~n, scales = "free_y") +
  labs(title = paste0("Sampling distribution for N(",mu,", ",sigma^2,") average")) +
  theme_bw()


## ----t_statistic, dependson = "normal_samples", fig.height=3.7-------------------------------------------------
mu = 35
sigma = 5
ns = 10*(2:5)

d = samples %>%
  dplyr::summarize(sample_mean = mean(samples),
                   sample_sd   = sd(samples),
                   t = (sample_mean - mu)/(sample_sd/sqrt(n)),
                   n = paste("n =", n),
                   .groups = "keep")

density = expand.grid(x = seq(from = -4, to = 4, length = 1001),
                      n = ns) %>%
  dplyr::mutate(density = dt(x, df = n-1),
                n = paste("n =", n))
  

ggplot(d, aes(x = t)) + 
  geom_histogram(aes(y=..density..), binwidth = .1) + 
  geom_line(data = density, aes(x=x, y = density), color = "red") + 
  facet_wrap(~n, scales = "free_y") +
  labs(title = paste0("Sampling distribution of the t-statistic")) +
  theme_bw()


## ----binomial_samples, cache = TRUE----------------------------------------------------------------------------
ns = c(10,100)
ps = c(.5,.8)
samples = expand.grid(rep = 1:1000, 
               n = ns,
               p = ps) %>%
  dplyr::group_by(n, p) %>%
  dplyr::mutate(y = rbinom(n(), size = n, prob = p),
                phat = y/n, 
                p = paste("p =", p),
                n = paste("n =", n)) 


## ----binomial_proportion, dependson = "binomial_samples", fig.height=3.7---------------------------------------
pmf = expand.grid(n = ns, p = ps, values = (0:max(ns))/max(ns)) %>%
  dplyr::group_by(n, p) %>%
  do(data.frame(values = (0:max(.$n))/max(.$n))) %>%
  dplyr::mutate(
    pmf = dbinom(values*n, size = n, prob = p),
    p = paste("p =", p),
    n = paste("n =", n)) %>%
  dplyr::filter(pmf > 0)
  

ggplot(samples, aes(x = phat)) + 
  geom_bar(aes(y = ..prop..)) + 
  geom_point(data = pmf, aes(x=values, y = pmf), color = "red") +
  facet_grid(n~p, scales = "free_y") +
  labs(title = paste0("Sampling distribution for binomial proportion"),
       x = "Sample proportion (y/n)", 
       y = "") +
  theme_bw()


## ----dependson = "binomial_samples", fig.height=3.7------------------------------------------------------------
pmf = expand.grid(n = ns, p = ps, 
                  prop = seq(0,1,length=101)) %>%
  dplyr::mutate(
    pmf = dnorm(prop, mean = p, sd = sqrt(p*(1-p)/n)),
    p = paste("p =", p),
    n = paste("n =", n)) %>%
  dplyr::filter(n > 30)
  

ggplot(samples %>%
         dplyr::group_by(n,p,phat) %>%
         dplyr::summarize(count = n(), .groups = "keep") %>%
         dplyr::group_by(n,p) %>%
         dplyr::arrange(phat) %>%
         dplyr::mutate(height = count / sum(count) / min(diff(phat))),
      aes(x = phat, y = height)) + 
  geom_bar(stat = "identity") + 
  geom_line(data = pmf, aes(x=prop, y = pmf), color = "red") +
  facet_grid(n~p, scales = "free_y") +
  labs(title = paste0("Approximate sampling distributions for binomial proportion"),
       x = "Sample proportion (y/n)", 
       y = "") +
  theme_bw()

