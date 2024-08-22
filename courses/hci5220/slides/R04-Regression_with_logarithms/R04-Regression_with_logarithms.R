## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-----------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("ggResidpanel"); my_plots = c("resid","qq","yvp","index")
library("car")


## ----set_seed, echo=FALSE-------------------------------------------------------------------------
set.seed(20220215)


## ----echo=TRUE------------------------------------------------------------------------------------
head(Salaries)


## ----echo=TRUE------------------------------------------------------------------------------------
summary(Salaries)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex, shape = rank)) +
  geom_point() +
  facet_grid(discipline ~ rank)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries %>% filter(rank == "Prof", sex == "Male", discipline == "B"),
       aes(x = yrs.since.phd, y = salary)) +
  geom_point() +
  stat_smooth(method = "lm")


## ----echo=TRUE, size='tiny'-----------------------------------------------------------------------
summary(m <- lm(salary ~ yrs.since.phd,
                data = Salaries %>% filter(rank == "Prof", sex == "Male", discipline == "B")))


## ----echo=TRUE------------------------------------------------------------------------------------
confint(m)


## -------------------------------------------------------------------------------------------------
resid_panel(m, plots = my_plots)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries %>% filter(rank == "Prof", discipline == "B"),
       aes(x = sex, y = salary)) +
  geom_boxplot(color='gray', outlier.shape = NA) +
  geom_jitter(width=0.1)


## ----echo=TRUE, size='tiny'-----------------------------------------------------------------------
summary(m <- lm(salary ~ sex,
                data = Salaries %>% filter(rank == "Prof", discipline == "B")))


## ----echo=TRUE------------------------------------------------------------------------------------
confint(m)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex, shape = rank)) +
  geom_point() +
  facet_grid(discipline ~ rank, scales = "free") +
  stat_smooth(method="lm", )


## ----reg, echo=TRUE, size='tiny', cache=TRUE------------------------------------------------------
summary(m <- lm(salary ~ sex + rank + discipline + yrs.since.phd,
                data = Salaries))


## ----reg-confint, echo=TRUE, dependson="reg"------------------------------------------------------
confint(m)


## ----reg-resid, cache=TRUE, dependson="reg"-------------------------------------------------------
resid_panel(m, plots = my_plots)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex, shape = rank)) +
  geom_point() +
  facet_grid(discipline ~ rank) +
  scale_y_log10()


## -------------------------------------------------------------------------------------------------
ggplot(Salaries %>% filter(rank == "Prof", sex == "Male", discipline == "B"),
       aes(x = yrs.since.phd, y = salary)) +
  geom_point() +
  stat_smooth(method = "lm") +
  scale_y_log10()


## ----echo=TRUE, size='tiny'-----------------------------------------------------------------------
summary(m <- lm(log(salary) ~ yrs.since.phd,
                data = Salaries %>% filter(rank == "Prof", sex == "Male", discipline == "B")))


## ----echo=TRUE------------------------------------------------------------------------------------
confint(m)
100*(exp(confint(m)[2,])-1)


## -------------------------------------------------------------------------------------------------
resid_panel(m, plots = my_plots)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries %>% filter(rank == "Prof", discipline == "B"),
       aes(x = sex, y = salary)) +
  geom_boxplot(color='gray', outlier.shape = NA) +
  geom_jitter(width=0.1)


## ----echo=TRUE, size='tiny'-----------------------------------------------------------------------
summary(m <- lm(log(salary) ~ sex,
                data = Salaries %>% filter(rank == "Prof", discipline == "B")))


## ----echo=TRUE------------------------------------------------------------------------------------
confint(m)


## -------------------------------------------------------------------------------------------------
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex, shape = rank)) +
  geom_point() +
  facet_grid(discipline ~ rank, scales = "free") +
  stat_smooth(method="lm", )


## ----echo=TRUE, size='tiny'-----------------------------------------------------------------------
summary(m <- lm(log(salary) ~ sex + rank + discipline + yrs.since.phd,
                data = Salaries))


## ----echo=TRUE------------------------------------------------------------------------------------
confint(m)


## -------------------------------------------------------------------------------------------------
resid_panel(m, plots = my_plots)

