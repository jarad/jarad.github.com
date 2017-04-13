## ----install_packages, eval=FALSE----------------------------------------
## install.packages("lsmeans")

## ----load_packages-------------------------------------------------------
library("dplyr")
library("ggplot2")
# library("Sleuth3")
library("lsmeans")

## ------------------------------------------------------------------------
ggplot(lsmeans::fiber, aes(machine, strength)) + 
  geom_point() + 
  theme_bw()

## ------------------------------------------------------------------------
m <- lm(strength ~ machine, data = lsmeans::fiber)
nd <- data.frame(machine = c("A","B","C"))
p <- predict(m, 
             newdata = nd, 
             interval = "confidence")
bind_cols(nd, p %>% as.data.frame)

## ------------------------------------------------------------------------
lsmeans(m, ~machine)

## ------------------------------------------------------------------------
ex0518 <- Sleuth3::ex0518 %>%
  mutate(Treatment = relevel(Treatment, ref="Control"))

ggplot(ex0518, aes(Treatment, Protein)) + 
  geom_point() + 
  theme_bw()

## ------------------------------------------------------------------------
# First let's make C the reference level
fiber <- lsmeans::fiber %>% 
  mutate(machine = relevel(machine, ref="C"))
  
m <- lm(strength ~ machine, data = fiber)
ls <- lsmeans(m, ~ machine)
(co <- contrast(ls, method = "pairwise"))

## ------------------------------------------------------------------------
confint(co)

## ------------------------------------------------------------------------
(co <- contrast(ls, method = "pairwise", adjust="none"))
confint(co)

## ------------------------------------------------------------------------
(co <- contrast(ls, method = "trt.vs.ctrl"))
confint(co)

## ------------------------------------------------------------------------
wood_glue <- data.frame(force = c(185,170,210,240,245,190,210,250,
                                  290,280,260,270,200,280,350,350),
                        wood = rep(c("spruce","maple"),each = 8),
                        glue = rep(c("carpenter's", "weldbond","gorilla","titebond"), each=2, times=2))

## ------------------------------------------------------------------------
ggplot(wood_glue, aes(wood, force, color=glue, shape=glue)) +
  geom_point() +
  theme_bw()

## ------------------------------------------------------------------------
m <- lm(force ~ wood*glue, data = wood_glue)
anova(m)

## ------------------------------------------------------------------------
(ls <- lsmeans(m, ~ glue))

## ------------------------------------------------------------------------
(co <- contrast(ls, "pairwise"))
confint(co)

## ------------------------------------------------------------------------
(ls <- lsmeans(m, ~ glue | wood))

## ------------------------------------------------------------------------
(co <- contrast(ls, "pairwise"))
confint(co)

## ------------------------------------------------------------------------
ggplot(lsmeans::fiber, aes(diameter, strength, color=machine, shape=machine)) + 
  geom_point() + 
  theme_bw()

## ------------------------------------------------------------------------
m <- lm(strength ~ diameter*machine, data=fiber)
ls <- lsmeans(m, ~ machine)
co <- contrast(ls, method = "pairwise")
confint(co)

## ------------------------------------------------------------------------
ls <- lsmeans(m, ~ machine | diameter)
co <- contrast(ls, method = "pairwise")
confint(co)

## ------------------------------------------------------------------------
mean(fiber$diameter)

## ------------------------------------------------------------------------
ls <- lsmeans(m, ~ machine | diameter, at = list(diameter = c(20,30)))
co <- contrast(ls, method = "pairwise")
confint(co)

## ------------------------------------------------------------------------
( lst <- lstrends(m, "machine", var = "diameter") )
(co <- contrast(lst, method = "pairwise"))
confint(co)

## ------------------------------------------------------------------------
m <- lm(Lifetime ~ Diet, data = Sleuth3::case0501)
ls <- lsmeans(m, "Diet")
#                                           N/N85 N/R40 N/R50  NP R/R50 lopro
co <- contrast(ls, list(`High - Low`    = c(    4,   -1,   -1,  0,   -1,   -1) /4,
                        `Pre-wean: R-N` = c(    0,    0,   -1,  0,    1,    0) ))
confint(co)

