## ----libraries, message=FALSE, warning=FALSE, echo=FALSE------------------------------------------------------
library("tidyverse")
library("emmeans") # install.packages("Sleuth3")


## ----set_seed, echo=FALSE-------------------------------------------------------------------------------------
set.seed(2)




## -------------------------------------------------------------------------------------------------------------
mouse <- read_csv("mouse.csv", show_col_types = FALSE) %>% mutate(Mouse = factor(Mouse))
head(mouse)
summary(mouse)


## ----echo=FALSE, fig.height = 4-------------------------------------------------------------------------------
g_two_Mouses =
ggplot(mouse %>% filter(Mouse %in% c("Viper (Wired)","Mamba (Wired)")),
      aes(x = Mouse, y = Skill)) +
  geom_jitter() +
  labs(y = "Skill (higher is better)") +
  theme_bw()

g_two_Mouses


## -------------------------------------------------------------------------------------------------------------
two_mice <- mouse %>% filter(Mouse %in% c("Viper (Wired)","Mamba (Wired)"))
two_mice$X <- ifelse(two_mice$Mouse == "Viper (Wired)", 1, 0)
m <- lm(Skill ~ X, data = two_mice)
summary(m)


## -------------------------------------------------------------------------------------------------------------
m <- lm(Skill ~ Mouse, data = two_mice)
summary(m)
emmeans(m, "Mouse")


## ----echo=FALSE-----------------------------------------------------------------------------------------------
d_means = mouse %>%
  group_by(Mouse) %>%
  summarize(Skill = mean(Skill), .groups = "drop")

g_two_Mouses +
  geom_crossbar(data = d_means %>% filter(Mouse %in% c("Viper (Wired)","Mamba (Wired)")),
                aes(ymin = Skill, ymax = Skill), color = "magenta")


## ----echo=FALSE-----------------------------------------------------------------------------------------------
g_all_Mouses =
ggplot(mouse,
      aes(x = Mouse, y = Skill)) +
  labs(y = "Skill (higher is better)") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=45, hjust=1))

g_all_Mouses +
  geom_jitter()


## -------------------------------------------------------------------------------------------------------------
m <- lm(Skill ~ Mouse, data = mouse)
m
confint(m)


## -------------------------------------------------------------------------------------------------------------
summary(m)


## ----echo=FALSE-----------------------------------------------------------------------------------------------
co <- coef(m) %>%round(1)
cf <- confint(m) %>% round(1)


## ----echo=FALSE-----------------------------------------------------------------------------------------------
d_labels = d_means %>%
  dplyr::mutate(midpoints = (Skill + coef(m)[1])/2,
                label = paste0("beta[",0:5,"]")) %>%
  filter(Mouse != "Basilisk (Wired)")

g_all_Mouses +
  geom_jitter(color = "gray") +
  geom_crossbar(data = d_means,
                aes(ymin = Skill, ymax = Skill), color = "magenta") +
  geom_segment(data = d_means %>% filter(Mouse != "Basilisk (Wired)"),
                aes(xend = Mouse, y = coef(m)[1], yend = coef(m)[1] + coef(m)[-1]),
               color = "magenta",
               arrow = arrow(length = unit(0.03, "npc"))) +
  geom_hline(yintercept = coef(m)[1], linetype = "dashed", color = "magenta") +
  geom_label(data = d_labels, nudge_x = 0.2,
             aes(y = midpoints, label = label),
             parse = TRUE) +
  geom_label(aes(x = "Basilisk (Wired)", y = coef(m)[1], label = "beta[0]"),
             parse = TRUE) +
  theme(axis.text.x=element_text(angle=45, hjust=1))


## -------------------------------------------------------------------------------------------------------------
em <- emmeans(m, pairwise ~ Mouse)
em$emmeans


## -------------------------------------------------------------------------------------------------------------
confint(em$contrasts)


## -------------------------------------------------------------------------------------------------------------
mouse <- mouse %>%
  mutate(Mouse = relevel(Mouse, ref = "Dell"))

m <- lm(Skill ~ Mouse, data = mouse)
summary(m)

