## ---------------------------------------------------------------------------------------
library("tidyverse")


## ---------------------------------------------------------------------------------------
data()


## ---- eval=FALSE------------------------------------------------------------------------
## ?ToothGrowth


## ---------------------------------------------------------------------------------------
dim(ToothGrowth)
head(ToothGrowth)
tail(ToothGrowth)
summary(ToothGrowth)


## ---- eval=FALSE------------------------------------------------------------------------
## ggplot(data = <DATA>) +
##   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))


## ---- eval=FALSE------------------------------------------------------------------------
## ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +
##   <GEOM_FUNCTION>()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len)) + 
  geom_histogram()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len)) + 
  geom_histogram(bins = 20)


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len)) + 
  geom_histogram(binwidth = 1)


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len)) + 
  geom_boxplot()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len)) + 
  geom_density()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len, y = 1)) + # note the y = 1
  geom_violin()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len, y = supp)) + 
  geom_violin()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len, y = supp)) + 
  geom_violin(trim = FALSE)


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len, y = supp)) + 
  geom_violin(trim = FALSE) + 
  geom_point()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = len, y = supp)) + 
  geom_violin(trim = FALSE) + 
  geom_jitter()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_violin(trim = FALSE) + 
  geom_jitter()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(y = supp, x = len)) + 
  geom_violin(trim = FALSE) + 
  geom_jitter() + 
  coord_flip()


## ---------------------------------------------------------------------------------------
ggplot(chickwts, aes(x = feed, y = weight)) + 
  geom_violin(trim = TRUE) + 
  geom_jitter() 


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = dose, y = len)) + 
  geom_point()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = dose, y = len)) + 
  geom_jitter(width=0.1)


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = dose, y = len)) + 
  geom_jitter(width=0.01) +
  scale_x_log10()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = dose, y = len, color = supp, shape = supp)) + 
  geom_jitter(width=0.01) +
  scale_x_log10()


## ---------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = dose, y = len, color = supp, shape = supp)) + 
  geom_jitter(width=0.01) +
  scale_x_log10() +
  geom_smooth(method = "lm")


## ---------------------------------------------------------------------------------------
m <- lm(len ~ dose*supp, data = ToothGrowth)
anova(m)


## ---------------------------------------------------------------------------------------
d <- ToothGrowth %>%
  rename(
    Length = len,
    Delivery = supp,
    Dose = dose) %>%
  mutate(Delivery = fct_recode(Delivery, 
                               "Orange Juice" = "OJ",
                               "Ascorbic Acid" = "VC"))


## ---------------------------------------------------------------------------------------
ggplot(d,                       # Note the new data.frame
       aes(
         x = Dose, 
         y = Length, 
         color = Delivery, 
         shape = Delivery)) + 
  geom_point(position = position_jitterdodge(
    jitter.width = 0.005,
    dodge.width = 0.01           # moves Delivery method left and right of Dose
  )) +
  scale_x_log10() +
  scale_color_manual(
    values = c("Orange Juice" = "orange",
               "Ascorbic Acid" = "blue")
  ) +
  geom_smooth(method = "lm") + 
  labs(
    x = "Dose (mg/day)", 
    y = "Length (\u00b5m)", # unicode \u005b is the Greek letter mu
    title = "Odontoblast length vs Vitamin C in Guinea Pigs",
    color = "Delivery Method",
    shape = "Delivery Method") +
  theme_bw() +
  theme(legend.position = c(0.8, 0.2),
        legend.background = element_rect(fill = "white",
                                        color = "black"))


## ---------------------------------------------------------------------------------------
# Save to an object
g <- ggplot(d,                       # Note the new data.frame
       aes(
         x = Dose, 
         y = Length, 
         color = Delivery, 
         shape = Delivery)) + 
  geom_point(position = position_jitterdodge(
    jitter.width = 0.005,
    dodge.width = 0.01
  )) +
  scale_x_log10() +
  scale_color_manual(
    values = c("Orange Juice" = "orange",
               "Ascorbic Acid" = "blue")
  ) +
  geom_smooth(method = "lm") + 
  labs(
    x = "Dose (mg/day)", 
    y = "Length (\u00b5m)", # unicode \u005b is the Greek letter mu
    title = "Odontoblast length vs Vitamin C in Guinea Pigs",
    color = "Delivery Method",
    shape = "Delivery Method") +
  theme_bw() +
  theme(legend.position = c(0.8, 0.2),
        legend.background = element_rect(fill = "white",
                                        color = "black"))

# Write to a file
fn <- "toothgrowth.png"
ggsave(fn, plot = g, width = 6, height = 4)

# Clean up
unlink(fn) # remove the file


## ---- eval=FALSE------------------------------------------------------------------------
## ?diamonds


## ---------------------------------------------------------------------------------------
ggplot(diamonds, 
       aes(
         x = carat,
         y = price,
         color = depth)) +
  scale_color_gradientn(colors = rainbow(5)) +
  geom_point(alpha = 0.2) +
  facet_grid(color ~ cut) + 
  scale_y_log10() + 
  scale_x_log10() + 
  theme_bw()


## ---------------------------------------------------------------------------------------
m <- lm(log(price) ~ log(carat) * depth * cut * color, data = diamonds)
drop1(m, test = "F")

