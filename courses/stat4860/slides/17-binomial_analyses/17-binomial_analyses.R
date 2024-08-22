## --------------------------------------------------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
set.seed(20230319)


## --------------------------------------------------------------------------------------------------------------------------------------
## Conover (1971), p. 97f.
## Under (the assumption of) simple Mendelian inheritance, a cross
##  between plants of two particular genotypes produces progeny 1/4 of
##  which are "dwarf" and 3/4 of which are "giant", respectively.
##  In an experiment to determine if this assumption is reasonable, a
##  cross results in progeny having 243 dwarf and 682 giant plants.
##  If "giant" is taken as success, the null hypothesis is that p =
##  3/4 and the alternative that p != 3/4.
successes <- 682
failures  <- 243

binom.test(c(successes, failures), p = 3/4)


## --------------------------------------------------------------------------------------------------------------------------------------
y <- successes
n <- successes + failures
binom.test(y, n, p = 3/4)


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(matrix(c(successes, failures), ncol = 2), p = 3/4)


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(y, n, p = 3/4)


## --------------------------------------------------------------------------------------------------------------------------------------
args(prop.test)
prop.test(y, n, p = 3/4, alternative = "greater", conf.level = 0.9, correct = FALSE)


## --------------------------------------------------------------------------------------------------------------------------------------
args(binom.test)
binom.test(y, n, p = 3/4, alternative = "greater", conf.level = 0.9)


## --------------------------------------------------------------------------------------------------------------------------------------
admissions <- UCBAdmissions %>%
  as.data.frame() %>%
  group_by(Admit, Gender) %>%
  summarize(
    n = sum(Freq),
    .groups = "drop"
  ) %>%
  pivot_wider(names_from = "Admit", values_from = "n") %>%
  mutate(
    y = Admitted, 
    n = Admitted + Rejected,
    p = y/n)

admissions


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(admissions$y, admissions$n)


## --------------------------------------------------------------------------------------------------------------------------------------
case1802 %>%
  mutate(p = NoCold / (Cold+NoCold))


## ---- error = TRUE---------------------------------------------------------------------------------------------------------------------
prop.test(case1802[,c("Cold","NoCold")]) # I feel like this should work


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(cbind(case1802$Cold, case1802$NoCold))


## --------------------------------------------------------------------------------------------------------------------------------------
admissions_by_department <- UCBAdmissions %>%
  as.data.frame() %>%
  group_by(Dept, Admit) %>%
  summarize(
    n = sum(Freq),
    .groups = "drop"  
  ) %>%
  pivot_wider(names_from = "Admit", values_from = "n") %>%
  mutate(Total = Admitted + Rejected)


## --------------------------------------------------------------------------------------------------------------------------------------
admissions_by_department %>%
  mutate(p = Admitted / Total)


## --------------------------------------------------------------------------------------------------------------------------------------
ggplot(admissions_by_department,
       aes(x = Dept, y = Admitted / Total, size = Total)) + 
  geom_point() + 
  ylim(0,1)


## --------------------------------------------------------------------------------------------------------------------------------------
prop.test(admissions_by_department$Admitted,
          admissions_by_department$Total)


## --------------------------------------------------------------------------------------------------------------------------------------
admissions_by_dept_and_gender <- UCBAdmissions %>%
  as.data.frame() %>%
  pivot_wider(names_from = "Admit", values_from = "Freq") %>%
  # group_by(Dept, Gender) %>%
  mutate(
    Total = Admitted + Rejected,
    p_hat = Admitted / Total,
    lcl   = p_hat - qnorm(.975)*sqrt(p_hat*(1-p_hat)/Total),
    ucl   = p_hat + qnorm(.975)*sqrt(p_hat*(1-p_hat)/Total)
  )


## --------------------------------------------------------------------------------------------------------------------------------------
admissions_by_dept_and_gender 


## --------------------------------------------------------------------------------------------------------------------------------------
ggplot(admissions_by_dept_and_gender, 
       aes(x = Dept, y = Admitted / Total, ymin = lcl, ymax = ucl,
           color = Gender)) +
  geom_point(aes(size = Total), position = position_dodge(width = 0.1)) +
  geom_linerange(position = position_dodge(width = 0.1))


## --------------------------------------------------------------------------------------------------------------------------------------
m <- glm(cbind(Admitted, Rejected) ~ Dept + Gender, 
        data = admissions_by_dept_and_gender,
        family = "binomial")

summary(m)

