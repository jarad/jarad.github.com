## ----setup, include=FALSE, perl=FALSE----------------------
knitr::opts_chunk$set(echo = TRUE)


## ----load_ggplot2------------------------------------------
library("ggplot2")  # you may need to install it first using install.packages("ggplot2")


## ----load_Sleuth3------------------------------------------
library("Sleuth3")  # you may need to install it first using install.packages("Sleuth3")


## ----case0801----------------------------------------------
ggplot(Sleuth3::case0801, 
       aes(x = Area, y = Species)) + 
  geom_point() +  
  labs(title = "Number of reptile and amphibian species for West Indies islands") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----case0801_log_x----------------------------------------
ggplot(Sleuth3::case0801, 
       aes(x = Area, y = Species)) + 
  geom_point() + 
  scale_x_log10() + 
  labs(title = "Number of reptile and amphibian species for West Indies islands") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----case0801_log_y----------------------------------------
ggplot(Sleuth3::case0801, 
       aes(x = Area, y = Species)) + 
  geom_point() + 
  scale_y_log10() + 
  labs(title = "Number of reptile and amphibian species for West Indies islands") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----case0801_log_xy---------------------------------------
ggplot(Sleuth3::case0801, 
       aes(x = Area, y = Species)) + 
  geom_point() + 
  scale_x_log10() + 
  scale_y_log10() + 
  labs(title = "Number of reptile and amphibian species for West Indies islands") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----case0801_regression-----------------------------------
m <- lm(log(Species) ~ log(Area), data = Sleuth3::case0801)
summary(m)


## ----case0801_poisson_regression---------------------------
m <- glm(Species ~ log(Area),      
         data = Sleuth3::case0801,
         family = poisson)
summary(m)


## ----case0801_binary_x-------------------------------------
ggplot(Sleuth3::case0801, 
       aes(x = 1*I(Area>100), y = Species)) + 
  geom_point() + 
  scale_y_log10() + 
  labs(title = "Number of reptile and amphibian species for West Indies islands") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----fix_case0901------------------------------------------
library("dplyr") # may need to install.packages("dplyr")
case0901 <- Sleuth3::case0901 %>%
  mutate(Time = ifelse(Time == 1, "Late", "Early"))


## ----explore_case0901--------------------------------------
dim(case0901)
summary(case0901)
head(case0901)


## ----case0901_plot_only_flowers----------------------------
ggplot(case0901, 
       aes(x = Intensity, y = Flowers)) + 
  geom_point() + 
  labs(title = "Effects of Light on Meadowfoam Flowering") +
  geom_smooth(method = "lm", formula = y ~ x)


## ----case0901_slr_reg--------------------------------------
m <- lm(Flowers ~ Intensity, data = case0901)
summary(m)


## ----case0901_plot_with_time-------------------------------
ggplot(case0901, 
       aes(x = Intensity, y = Flowers, color = Time, shape = Time)) + 
  geom_point() + 
  labs(title = "Effects of Light on Meadowfoam Flowering") +
  geom_smooth(method = "lm")


## ----case0901_reg_with_interaction-------------------------
m <- lm(Flowers ~ Intensity*Time, data = case0901)
anova(m)


## ----case0901_reg------------------------------------------
m <- lm(Flowers ~ Intensity+Time, data = case0901)
anova(m)
summary(m)

