## ----libraries, message=FALSE, warning=FALSE, cache=FALSE---------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE-----------------------------------------------------------------------------
set.seed(2)


## -----------------------------------------------------------------------------------------------------
mu0 = 1.5


## ----echo=TRUE----------------------------------------------------------------------------------------
y = rnorm(10, mean = 3, sd = 1.5)
a = 0.05
t = t.test(y, mu = mu0, conf.level = 1-a)
t$p.value
round(as.numeric(t$conf.int),2)


## ----echo=TRUE----------------------------------------------------------------------------------------
a = 0.001
t = t.test(y, mu = mu0, conf.level = 1-a)
t$p.value
round(as.numeric(t$conf.int),2)


## ----echo=TRUE----------------------------------------------------------------------------------------
a = 0.1
ci = t.test(y, conf.level = 1-a)$conf.int; round(as.numeric(ci),2)


## ----fig.height = 3-----------------------------------------------------------------------------------
tfunc = Vectorize(function(mu0) t.test(y, mu = mu0)$p.value, "mu0")
d = data.frame(mu0 = seq(1,6, length = 1001)) %>%
  dplyr::mutate(pvalue = tfunc(mu0),
                significant = pvalue < a)

ggplot(d, aes(x = mu0, y = pvalue, color = significant)) + 
  geom_point(size=1) + 
  geom_hline(yintercept = a, color = "#F8766D") + 
  geom_vline(xintercept = ci, color = "#F8766D") + 
  labs(title = "Hypothesis tests with various null hypothesis values",
       x = expression(mu[0]), y = "p-value") +
  theme_bw() +
  theme(legend.position = "none")

