## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(20220119)


## ----echo=TRUE,size="normalsize"--------------------------------------------------------------------------------------
registration <- data.frame(subjectID = 1:30,
                           system = sample(rep(c("A","B"), times = 15)))
registration


## ----echo=TRUE,size="normalsize"--------------------------------------------------------------------------------------
table(registration$system)


## ---------------------------------------------------------------------------------------------------------------------
# Simulate data
registration <- registration %>%
  mutate(time = rnorm(n(), mean = 3 + 0.2*(registration$system == "B"), sd = 1))

registration$time[23] <- NA # create missing data


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
summary(registration)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
registration %>%
  group_by(system) %>%
  summarize(n = sum(!is.na(time)),
            mean = mean(time, na.rm = TRUE),
            sd = sd(time, na.rm = TRUE))


## ----warning=FALSE, fig.height=2.8------------------------------------------------------------------------------------
ggplot(registration, aes(system, time)) +
  geom_jitter(width = 0.1, color = "gray") +
  geom_boxplot(outlier.shape = NA, fill = NA) +
  labs(x = "Registration system",
       y = "Time (minutes)",
       title = "Registration system comparison") +
  theme_bw()


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
t.test(time ~ system, data = registration)


## ----echo=TRUE,size='scriptsize'--------------------------------------------------------------------------------------
summary(lm(time ~ system, data = registration))

