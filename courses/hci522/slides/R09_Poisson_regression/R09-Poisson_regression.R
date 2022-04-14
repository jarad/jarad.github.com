## ----libraries, message=FALSE, warning=FALSE, cache=FALSE, echo=FALSE------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("emmeans")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------------
set.seed(20220215)


## --------------------------------------------------------------------------------------------------------------------
warpbreaks


## --------------------------------------------------------------------------------------------------------------------
summary(warpbreaks)


## ----echo=FALSE------------------------------------------------------------------------------------------------------
ggplot(warpbreaks, aes(tension, breaks, color = wool, shape = wool)) +
  geom_jitter(height = 0, width = 0.1)


## ----echo=FALSE------------------------------------------------------------------------------------------------------
ggplot(warpbreaks, aes(tension, breaks, color = wool, shape = wool)) +
  geom_jitter(height = 0, width = 0.1) + scale_y_log10()


## ----echo=FALSE------------------------------------------------------------------------------------------------------
ggplot(warpbreaks %>% filter(wool == "A"), aes(tension, breaks)) +
  geom_jitter(height = 0, width = 0.1) + scale_y_log10() +
  labs(title = "Wool Type A")


## ----echo=FALSE------------------------------------------------------------------------------------------------------
m <- lm(log(breaks) ~ tension, warpbreaks %>% filter(wool == "A"))
summary(m)


## --------------------------------------------------------------------------------------------------------------------
em <- emmeans(m, pairwise ~ tension)
ci <- confint(em, type = "response", adjust = "none")
ci


## ----echo=FALSE------------------------------------------------------------------------------------------------------
ggplot(warpbreaks, aes(tension, breaks, color = wool, shape = wool)) +
  geom_jitter(height = 0, width = 0.1) + scale_y_log10()


## ----echo=FALSE------------------------------------------------------------------------------------------------------
m <- lm(log(breaks) ~ tension + wool, warpbreaks)
summary(m)


## --------------------------------------------------------------------------------------------------------------------
em_tension <- emmeans(m, pairwise ~ tension)
ci_tension <- confint(em_tension, type = "response", adjust = "none")
ci_tension


## --------------------------------------------------------------------------------------------------------------------
em_wool <- emmeans(m, pairwise ~ wool)
ci_wool <- confint(em_wool, type = "response", adjust = "none")
ci_wool


## --------------------------------------------------------------------------------------------------------------------
em_tension_by_wool <- emmeans(m, pairwise ~ tension | wool)
ci_tension_by_wool <- confint(em_tension_by_wool, type = "response", adjust = "none")
ci_tension_by_wool$emmeans


## --------------------------------------------------------------------------------------------------------------------
ci_tension_by_wool$contrasts


## --------------------------------------------------------------------------------------------------------------------
em_wool_by_tension <- emmeans(m, pairwise ~ wool | tension)
ci_wool_by_tension <- confint(em_wool_by_tension, type = "response", adjust = "none")
ci_wool_by_tension$emmeans


## --------------------------------------------------------------------------------------------------------------------
ci_wool_by_tension$contrasts


## --------------------------------------------------------------------------------------------------------------------
pm <- ci_tension_by_wool$emmeans %>%
  as.data.frame() %>%
  mutate(mean_with_ci = paste0(
    round(response), " (", round(lower.CL), ", ", round(upper.CL), ")")
  ) %>%
  tidyr::pivot_wider(id_cols = tension, names_from = wool, values_from = mean_with_ci)
pm


## --------------------------------------------------------------------------------------------------------------------
ci_tension$contrasts %>% as.data.frame %>%
  mutate(
    change = 100*(ratio-1),
    lower  = 100*(lower.CL-1),
    upper  = 100*(upper.CL-1),

    change_with_ci = paste0(
      round(change), " (", round(lower), ", ", round(upper), ")"
    )) %>%
  select(contrast, change_with_ci)


## ----echo=FALSE------------------------------------------------------------------------------------------------------
m <- glm(breaks ~ tension, warpbreaks %>% filter(wool == "A"), family=poisson)
summary(m)


## --------------------------------------------------------------------------------------------------------------------
em <- emmeans(m, pairwise ~ tension)
ci <- confint(em, type = "response", adjust = "none")
ci


## ----echo=FALSE------------------------------------------------------------------------------------------------------
ggplot(warpbreaks, aes(tension, breaks, color = wool, shape = wool)) +
  geom_jitter(height = 0, width = 0.1) + scale_y_log10()


## ----echo=FALSE------------------------------------------------------------------------------------------------------
m <- glm(breaks ~ tension + wool, warpbreaks, family = poisson)
summary(m)


## --------------------------------------------------------------------------------------------------------------------
em_tension <- emmeans(m, pairwise ~ tension)
ci_tension <- confint(em_tension, type = "response", adjust = "none")
ci_tension


## --------------------------------------------------------------------------------------------------------------------
em_wool <- emmeans(m, pairwise ~ wool)
ci_wool <- confint(em_wool, type = "response", adjust = "none")
ci_wool


## --------------------------------------------------------------------------------------------------------------------
em_tension_by_wool <- emmeans(m, pairwise ~ tension | wool)
ci_tension_by_wool <- confint(em_tension_by_wool, type = "response", adjust = "none")
ci_tension_by_wool$emmeans


## --------------------------------------------------------------------------------------------------------------------
ci_tension_by_wool$contrasts


## --------------------------------------------------------------------------------------------------------------------
em_wool_by_tension <- emmeans(m, pairwise ~ wool | tension)
ci_wool_by_tension <- confint(em_wool_by_tension, type = "response", adjust = "none")
ci_wool_by_tension$emmeans


## --------------------------------------------------------------------------------------------------------------------
ci_wool_by_tension$contrasts


## --------------------------------------------------------------------------------------------------------------------
pm <- ci_tension_by_wool$emmeans %>%
  as.data.frame() %>%
  mutate(mean_with_ci = paste0(
    round(rate), " (", round(asymp.LCL), ", ", round(asymp.UCL), ")")
  ) %>%
  tidyr::pivot_wider(id_cols = tension, names_from = wool, values_from = mean_with_ci)
pm


## --------------------------------------------------------------------------------------------------------------------
ci_tension$contrasts %>% as.data.frame %>%
  mutate(
    change = 100*(ratio-1),
    lower  = 100*(asymp.LCL-1),
    upper  = 100*(asymp.UCL-1),

    change_with_ci = paste0(
      round(change), " (", round(lower), ", ", round(upper), ")"
    )) %>%
  select(contrast, change_with_ci)

