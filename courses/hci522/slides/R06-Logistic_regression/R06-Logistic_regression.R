## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")


## ----set_seed, echo=FALSE------------------------------------------------------------------------
set.seed(20220215)


## ------------------------------------------------------------------------------------------------
theta <- 0.3
d <- data.frame(y = c(0,1)) %>%
  mutate(pmf = dbinom(y, 1, prob = theta))

ggplot(d, aes(x=y, y=pmf)) +
  geom_col(width = 0.1) +
  labs(title = paste0("Bernoulli pmf with probability of success ", theta),
       y = "P(Y=y)")


## ----echo=TRUE-----------------------------------------------------------------------------------
admission <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
head(admission)
summary(admission)


## ------------------------------------------------------------------------------------------------
g_admit <- ggplot(admission, aes(x = gre, y = admit)) +
  geom_jitter(height=0.1)

g_admit


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(admit ~ gre, data = admission)
summary(m)


## ----echo=TRUE, size='tiny'----------------------------------------------------------------------
ci <- 100*(exp(confint(m)[2,])-1)
ci


## ----echo=TRUE, size='tiny'----------------------------------------------------------------------
ci <- 100*(exp(10*confint(m)[2,])-1)
ci


## ------------------------------------------------------------------------------------------------
g_admit +
  geom_smooth(method = "glm",
    method.args = list(family = "binomial"),
    se = FALSE)


## ------------------------------------------------------------------------------------------------
Sleuth3::ex2113


## ------------------------------------------------------------------------------------------------
n <- 14
theta <- 0.3
d <- data.frame(y = 0:n) %>%
  mutate(pmf = dbinom(y, n, prob = theta))

ggplot(d, aes(x=y, y=pmf)) +
  geom_col(width = 0.1) +
  labs(title = paste("Binomial pmf with", n, "attempts and probability of success ", theta),
       y = "P(Y=y)")


## ------------------------------------------------------------------------------------------------
Sleuth3::ex2113


## ------------------------------------------------------------------------------------------------
g_vitc <- ggplot(ex2113, aes(x=Dose, y=ProportionWithout)) +
  geom_point(aes(size=Number)) +
  labs(title="Randomized Experiment",
       x = "Dose (g) of Vitamin C",
       y = "Proportion Healthy") +
  scale_size_area()

g_vitc


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(cbind(WithoutIllness, Number - WithoutIllness) ~ Dose,
         data = ex2113, family = binomial)
summary(m)


## ----echo=TRUE-----------------------------------------------------------------------------------
ci <- 100*(exp(confint(m)[2,])-1)
ci


## ------------------------------------------------------------------------------------------------
g_vitc +
  geom_smooth(method = "glm",
    method.args = list(family = "binomial"),
    se = FALSE)


## ----echo=TRUE-----------------------------------------------------------------------------------
Sleuth3::case2101


## ------------------------------------------------------------------------------------------------
ggplot(Sleuth3::case2101, aes(x = Area, y = Extinct/AtRisk)) +
  geom_point(aes(size = AtRisk))


## ------------------------------------------------------------------------------------------------
g_island <- ggplot(Sleuth3::case2101, aes(x = Area, y = Extinct/AtRisk)) +
  geom_point(aes(size = AtRisk)) +
  scale_x_log10()

g_island


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(cbind(Extinct, AtRisk - Extinct) ~ Area,
        data = Sleuth3::case2101, family = binomial)
summary(m)


## ------------------------------------------------------------------------------------------------
g_island +
  geom_smooth(method = "glm",
    method.args = list(family = "binomial"),
    se = FALSE)


## ----echo=TRUE-----------------------------------------------------------------------------------
Sleuth3::ex2119 %>%
  filter(Study == 5) %>%
  mutate(p <- Cancer / (Cancer + NoCancer))


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(cbind(Cancer, NoCancer) ~ Lactate,
         data = Sleuth3::ex2119 %>% filter(Study == 5),
         family = binomial)
summary(m)


## ------------------------------------------------------------------------------------------------
ggplot(ex2119, aes(x = Lactate, y = Cancer / (Cancer + NoCancer),
                   group = Study, color = Study)) +
  geom_line() +
  geom_point(aes(size = Cancer + NoCancer))


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(cbind(Cancer, NoCancer) ~ Lactate + factor(Study),
         data = Sleuth3::ex2119,
         family = binomial)
summary(m)


## ----echo=TRUE-----------------------------------------------------------------------------------
library("lme4")
m <- glmer(cbind(Cancer, NoCancer) ~ Lactate + (1|Study),
         data = Sleuth3::ex2119,
         family = binomial)
summary(m)


## ----echo=TRUE-----------------------------------------------------------------------------------
m <- glm(admit ~ gre + gpa + factor(rank),
        data = admission, family = binomial)
summary(m)

