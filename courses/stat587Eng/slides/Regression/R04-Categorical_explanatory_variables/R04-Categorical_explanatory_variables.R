## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-------------------------------------------------------
library("tidyverse")
library("Sleuth3")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## ----eval=FALSE------------------------------------------------------------------------------------------------
## Sleuth3::case0501


## ----echo=FALSE, fig.height = 4--------------------------------------------------------------------------------
g_two_diets = 
ggplot(case0501 %>% filter(Diet %in% c("R/R50","N/R50")),
      aes(x = Diet, y = Lifetime)) + 
  geom_jitter() +
  labs(y = "Lifetime (months)") +
  theme_bw()

g_two_diets


## --------------------------------------------------------------------------------------------------------------
case0501$X <- ifelse(case0501$Diet == "N/R50", 1, 0)
(m <- lm(Lifetime ~ X, data = case0501, subset = Diet %in% c("R/R50","N/R50")))
confint(m)
predict(m, data.frame(X=1), interval = "confidence") # Expected lifetime on N/R50


## ----echo=FALSE------------------------------------------------------------------------------------------------
case0501_means = case0501 %>%
  group_by(Diet) %>%
  summarize(Lifetime = mean(Lifetime), .groups = "drop")

g_two_diets + 
  geom_crossbar(data = case0501_means %>% filter(Diet %in% c("R/R50","N/R50")),
                aes(ymin = Lifetime, ymax = Lifetime), color = "magenta")


## --------------------------------------------------------------------------------------------------------------
summary(m)$coefficients[2,4] # p-value
confint(m)
t.test(Lifetime ~ Diet, data = case0501, subset = Diet %in% c("R/R50","N/R50"), var.equal=TRUE)


## ----echo=FALSE------------------------------------------------------------------------------------------------
g_all_diets = 
ggplot(case0501,
      aes(x = Diet, y = Lifetime)) +
  labs(y = "Lifetime (months)") +
  theme_bw()

g_all_diets + 
  geom_jitter()


## --------------------------------------------------------------------------------------------------------------
case0501 <- case0501 %>% 
  mutate(X1 = Diet == "N/R40",
         X2 = Diet == "N/R50",
         X3 = Diet == "NP",
         X4 = Diet == "R/R50",
         X5 = Diet == "lopro")

m <- lm(Lifetime ~ X1 + X2 + X3 + X4 + X5, data = case0501)
m
confint(m)


## --------------------------------------------------------------------------------------------------------------
summary(m)


## ----echo=FALSE------------------------------------------------------------------------------------------------
case0501_labels = case0501_means %>%
  dplyr::mutate(midpoints = (Lifetime + coef(m)[1])/2,
                label = paste0("beta[",0:5,"]")) %>% 
  filter(Diet != "N/N85")

g_all_diets + 
  geom_jitter(color = "gray") +
  geom_crossbar(data = case0501_means,
                aes(ymin = Lifetime, ymax = Lifetime), color = "magenta") +
  geom_segment(data = case0501_means %>% filter(Diet != "N/N85"),
                aes(xend = Diet, y = coef(m)[1], yend = coef(m)[1] + coef(m)[-1]),
               color = "magenta", 
               arrow = arrow(length = unit(0.03, "npc"))) +
  geom_hline(yintercept = coef(m)[1], linetype = "dashed", color = "magenta") +
  geom_label(data = case0501_labels, nudge_x = 0.2,
             aes(y = midpoints, label = label),
             parse = TRUE) + 
  geom_label(aes(x = "N/N85", y = coef(m)[1], label = "beta[0]"),
             parse = TRUE)

