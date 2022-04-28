## ----libraries, message=FALSE, warning=FALSE, cache=FALSE, echo=FALSE--------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## ----set_seed, echo=FALSE----------------------------------------------------------------
set.seed(20220215)


## ----------------------------------------------------------------------------------------
case0901 <- Sleuth3::case0901 %>% 
  mutate(Start = recode(Time, `1` = "Late", `2` = "Early"),
         Start = factor(Start, levels = c("Early","Late")))
head(case0901)
summary(case0901)


## ----------------------------------------------------------------------------------------
g <- ggplot(case0901, aes(x = Intensity, y = Flowers, color = Start, shape = Start)) +
  geom_point() 
g + geom_smooth(method="lm", se = FALSE)


## ----------------------------------------------------------------------------------------
mM <- lm(Flowers ~ Start + Intensity, data = case0901) # Main effects model
mI <- lm(Flowers ~ Start * Intensity, data = case0901) # Interaction model

drop1(mI, test="F")


## ----------------------------------------------------------------------------------------
resid_panel(mM, plots = c("qq", "resid", "index", "cookd"), qqbands = TRUE)


## ----------------------------------------------------------------------------------------
summary(mM)


## ----------------------------------------------------------------------------------------
em <- emmeans(mM, pairwise ~ Start | Intensity, at = list(Intensity = c(150,500,900)))
(cm <- confint(em, type = "response"))


## ----------------------------------------------------------------------------------------
et <- emtrends(mM, pairwise ~ Start, var = "Intensity")
(ct <- confint(et, type = "response"))


## ----------------------------------------------------------------------------------------
g + geom_smooth(method = "lm", mapping=aes(y=predict(mM, case0901)))


## ----------------------------------------------------------------------------------------
summary(mI)


## ----------------------------------------------------------------------------------------
em <- emmeans(mI, pairwise ~ Start | Intensity, at = list(Intensity = c(150,500,900)))
(cm <- confint(em, type = "response"))


## ----------------------------------------------------------------------------------------
et <- emtrends(mI, pairwise ~ Start, var = "Intensity")
(ct <- confint(et, type = "response"))


## ----------------------------------------------------------------------------------------
g + geom_smooth(method = "lm", se=FALSE)


## ----------------------------------------------------------------------------------------
case1301 <- Sleuth3::case1301 %>% 
  filter(Treat %in% c("C","L","f","Lf"), Block %in% c("B1","B2","B3"))
head(case1301)
summary(case1301)


## ----------------------------------------------------------------------------------------
g <- ggplot(case1301, aes(x = Block, y = Cover, color = Treat, shape = Treat)) +
  geom_point() + scale_y_log10()
g 


## ----------------------------------------------------------------------------------------
mM <- lm(log(Cover) ~ Treat + Block, data = case1301) # Main effects model
mI <- lm(log(Cover) ~ Treat * Block, data = case1301) # Interaction model

drop1(mI, test="F")


## ----------------------------------------------------------------------------------------
resid_panel(mM, plots = c("qq", "resid", "index", "cookd"), qqbands = TRUE)


## ----------------------------------------------------------------------------------------
summary(mM)


## ----------------------------------------------------------------------------------------
em <- emmeans(mM, trt.vs.ctrl ~ Treat)
(cm <- confint(em, type = "response"))


## ----------------------------------------------------------------------------------------
et <- emmeans(mM, pairwise ~ Block)
(ct <- confint(et, type = "response"))


## ----------------------------------------------------------------------------------------
g + geom_smooth(method = "lm", mapping=aes(y=predict(mM, case1301)))


## ----------------------------------------------------------------------------------------
summary(mI)


## ----------------------------------------------------------------------------------------
em <- emmeans(mI, pairwise ~ Treat | Block)
(cm <- confint(em, type = "response"))


## ----------------------------------------------------------------------------------------
et <- emtrends(mI, pairwise ~ Treat, var = "Block")
(ct <- confint(et, type = "response"))


## ----------------------------------------------------------------------------------------
g

