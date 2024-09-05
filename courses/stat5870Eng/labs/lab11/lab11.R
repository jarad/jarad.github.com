## ----eval=FALSE---------------------------------------------------------------
## install.packages("emmeans")


## -----------------------------------------------------------------------------
library("tidyverse")
library("emmeans")


## -----------------------------------------------------------------------------
ggplot(emmeans::fiber, aes(machine, strength)) + 
  geom_jitter() + 
  theme_bw()


## -----------------------------------------------------------------------------
m <- lm(strength ~ machine, data = emmeans::fiber)
nd <- data.frame(machine = c("A","B","C"))
p <- predict(m, 
             newdata = nd, 
             interval = "confidence")
bind_cols(nd, p %>% as.data.frame)


## -----------------------------------------------------------------------------
emmeans(m, ~machine)


## -----------------------------------------------------------------------------
ex0518 <- Sleuth3::ex0518 %>%
  mutate(Treatment = relevel(Treatment, ref="Control"))

ggplot(ex0518, aes(Treatment, Protein)) + 
  geom_jitter() + 
  theme_bw()




## -----------------------------------------------------------------------------
# First let's make C the reference level
fiber <- emmeans::fiber %>% 
  mutate(machine = relevel(machine, ref="C"))
  
m <- lm(strength ~ machine, data = fiber)
em <- emmeans(m, ~ machine)
(co <- contrast(em, method = "pairwise"))


## -----------------------------------------------------------------------------
confint(co)


## -----------------------------------------------------------------------------
(co <- contrast(em, method = "pairwise", adjust="none"))
confint(co)


## -----------------------------------------------------------------------------
(co <- contrast(em, method = "trt.vs.ctrl"))
confint(co)




## -----------------------------------------------------------------------------
wood_glue <- data.frame(weight = c(185,170,210,240,245,190,210,250,
                                  290,280,260,270,200,280,350,350),
                        wood = rep(c("spruce","maple"), each = 8),
                        glue = rep(c("carpenter's","weldbond",
                                     "gorilla","titebond"), 
                                   each=2, times=2))


## -----------------------------------------------------------------------------
ggplot(wood_glue, aes(wood, weight, color=glue, shape=glue)) +
  geom_jitter() +
  theme_bw()


## -----------------------------------------------------------------------------
m <- lm(weight ~ wood*glue, data = wood_glue)
anova(m)


## -----------------------------------------------------------------------------
(em <- emmeans(m, ~ glue))


## -----------------------------------------------------------------------------
(co <- contrast(em, "pairwise"))
confint(co)


## -----------------------------------------------------------------------------
(em <- emmeans(m, ~ glue | wood))


## -----------------------------------------------------------------------------
(co <- contrast(em, "pairwise"))
confint(co)






## -----------------------------------------------------------------------------
ggplot(emmeans::fiber, aes(diameter, strength, color=machine, shape=machine)) + 
  geom_jitter() + 
  theme_bw()


## -----------------------------------------------------------------------------
m <- lm(strength ~ diameter*machine, data=fiber)
em <- emmeans(m, ~ machine)
co <- contrast(em, method = "pairwise")
confint(co)


## -----------------------------------------------------------------------------
em <- emmeans(m, ~ machine | diameter)
co <- contrast(em, method = "pairwise")
confint(co)


## -----------------------------------------------------------------------------
mean(fiber$diameter)


## -----------------------------------------------------------------------------
em <- emmeans(m, ~ machine | diameter, at = list(diameter = c(20,30)))
co <- contrast(em, method = "pairwise")
confint(co)


## -----------------------------------------------------------------------------
( lst <- lstrends(m, "machine", var = "diameter") )
(co <- contrast(lst, method = "pairwise"))
confint(co)








## -----------------------------------------------------------------------------
m <- lm(Lifetime ~ Diet, data = Sleuth3::case0501)
em <- emmeans(m, "Diet")
#                                           N/N85 N/R40 N/R50  NP R/R50 lopro
co <- contrast(em, list(`High - Low`    = c(    4,   -1,   -1,  0,   -1,   -1) /4,
                        `Pre-wean: R-N` = c(    0,    0,   -1,  0,    1,    0) ))
confint(co)

