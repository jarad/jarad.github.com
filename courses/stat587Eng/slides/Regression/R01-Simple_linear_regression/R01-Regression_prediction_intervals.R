## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## --------------------------------------------------------------------------------------------------------------
m = lm(telomere.length ~ years, data = abd::Telomeres)
ci = confint(m)

g = ggplot(abd::Telomeres, aes(x=years, y=telomere.length)) + 
  geom_point() +
  geom_segment(aes(x = 0, xend = 0, y = ci[1,1], yend = ci[1,2]), 
                 color = "blue", size = 2) +
  stat_smooth(method = "lm", se = FALSE) + 
  labs(title = "Telomere length vs years post diagnosis",
       x = "Years since diagnosis", y = "Telomere length") + 
  theme_bw()

g


## --------------------------------------------------------------------------------------------------------------
g = g + stat_smooth(method = "lm")
g


## --------------------------------------------------------------------------------------------------------------
p = predict(m, newdata = abd::Telomeres, interval = "prediction")
Telomeres = abd::Telomeres %>%
  dplyr::mutate(piU = p[,2], piL = p[,3])

g + 
  geom_line(aes(x = years, y = piL), 
              color = "red", linetype = "dashed",
              data = Telomeres) + 
  geom_line(aes(x = years, y = piU), 
              color = "red", linetype = "dashed",
              data = Telomeres)

