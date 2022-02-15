## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("gridExtra")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220215)


## ----simple-random-sample, echo=TRUE----------------------------------------------------------------------------------
n <- 10000 # enumerate all n individuals
sample(n, size = 10)


## ----simple-random-sample2, echo=TRUE---------------------------------------------------------------------------------
data.frame(individual = 1:n,
           random_number = runif(n)) %>% # RAND() in Excel
  arrange(random_number) %>%
  head(10) %>%
  pull(individual)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
y <- 6; n <- 20; a <- 1-0.95
qbeta(c(a/2,1-a/2), 1+y, 1+n-y) %>% round(2)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n <- 30; mn <- 73; sd <- 5; se <- sd/sqrt(n); a <- 1-0.95
(qt(c(a/2,1-a/2), df = n-1)*se + mn) %>% round(1)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
data.frame(subject = 1:10) %>%
  mutate(treatment = sample(c("A","B"), size = n(), replace = TRUE))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
data.frame(subject = 1:10) %>%
  mutate(treatment = sample(c("A","B","C"), size = n(), replace = TRUE, prob = c(2,3,5)/10))


## ----echo=TRUE, size="scriptsize"-------------------------------------------------------------------------------------
data.frame(subject = 1:10) %>%
  mutate(treatment = sample(rep(c("A","B"), times = 5), size = n()))


## ----echo=TRUE, size="scriptsize"-------------------------------------------------------------------------------------
data.frame(subject = 1:10) %>%
  mutate(treatment = sample(rep(c("A","B","C"), times = c(2,3,5)), size = n()))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n_reps <- 100000; a <- 1-0.95
theta_chatbot   <- rbeta(n_reps, shape1 = 1+10, shape2 = 1+10-10)
theta_nochatbot <- rbeta(n_reps, shape1 = 1+ 8, shape2 = 1+10- 8)
quantile(theta_chatbot - theta_nochatbot, probs = c(a/2, 1-a/2)) %>% round(2)


## ---------------------------------------------------------------------------------------------------------------------
data.frame(group = c("chatbot","no chatbot"),
           n = c(21,19),
           mean = c(2, 1.5),
           sd = c(1,0.75))


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
n_reps <- 100000; a <- 1-0.95
mu_chatbot   <- rt(n_reps, df = 21-1)*(   1/sqrt(21)) + 2
mu_nochatbot <- rt(n_reps, df = 19-1)*(0.75/sqrt(19)) + 1.5
quantile(mu_chatbot - mu_nochatbot, probs = c(a/2, 1-a/2)) %>% round(2)

