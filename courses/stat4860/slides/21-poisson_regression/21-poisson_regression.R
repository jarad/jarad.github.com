## -----------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## -----------------------------------------------------------------------------------------
summary(ex1509)

## -----------------------------------------------------------------------------------------
ggplot(ex1509, aes(x = Year, y = Sunspots)) + 
  geom_point() + 
  geom_smooth() # smoother, not lm


## -----------------------------------------------------------------------------------------
ggplot(ex1509, aes(x = Year, y = Sunspots)) + 
  geom_point() + 
  scale_y_log10() + 
  geom_smooth()


## -----------------------------------------------------------------------------------------
m <- glm(Sunspots ~ Year, 
         data = ex1509,
         family = poisson)


## -----------------------------------------------------------------------------------------
coef(m)


## -----------------------------------------------------------------------------------------
confint(m)


## -----------------------------------------------------------------------------------------
summary(m)$coefficients


## -----------------------------------------------------------------------------------------
anova(m, test = "LRT")


## -----------------------------------------------------------------------------------------
p <- bind_cols(ex1509, 
               predict(m, newdata = ex1509, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    # convert to expected count
    fit = exp(fit),
    lcl = exp(lcl),
    ucl = exp(ucl)
  ) %>%
  select(-residual.scale)

head(p)


## -----------------------------------------------------------------------------------------
ggplot(p, aes(x = Year, 
              y = Sunspots,
              ymin = lcl,
              ymax = ucl)) + 
  geom_point() + 
  geom_ribbon(fill = "blue", alpha = 0.5) +
  geom_line(aes(y = fit), color = "blue")


## -----------------------------------------------------------------------------------------
emmeans(m, pairwise ~ Year, type = "response", 
        at = list(Year = c(quantile(ex1509$Year, c(0,.5,1)))))


## -----------------------------------------------------------------------------------------
resid_panel(m)
resid_xpanel(m)


## -----------------------------------------------------------------------------------------
case0801


## -----------------------------------------------------------------------------------------
g <- ggplot(case0801, aes(x = Area, y = Species)) + 
  geom_point() +
  scale_x_log10() + 
  scale_y_log10()

g


## -----------------------------------------------------------------------------------------
m <- glm(Species ~ log(Area), 
         data = case0801,
         family = "poisson")


## -----------------------------------------------------------------------------------------
summary(m)
confint(m)


## -----------------------------------------------------------------------------------------
p <- bind_cols(case0801,
               predict(m, se.fit = TRUE)) %>% # defaults to observed data
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    fit = exp(fit),
    lcl = exp(lcl),
    ucl = exp(ucl)
  )


## -----------------------------------------------------------------------------------------
g + geom_ribbon(data = p, 
              aes(
                x = Area,
                ymin = lcl,
                ymax = ucl
              ),
              fill = "blue",
              alpha = 0.5) +
  geom_line(data = p,
            aes(
              x = Area,
              y = fit
            ), color = "blue") +
  labs(
    x = "Island Area (sq. miles)",
    y = "Number of Species",
    title = "Number of Reptile and Amphibian Species v Island Area"
  )


## -----------------------------------------------------------------------------------------
summary(warpbreaks)


## -----------------------------------------------------------------------------------------
g <- ggplot(warpbreaks, 
       aes(x = tension,
           y = breaks,
           color = wool,
           shape = wool)) +
  geom_point(position = position_jitterdodge(dodge.width = 0.1)) +
  scale_y_log10()
g


## -----------------------------------------------------------------------------------------
m <- glm(breaks ~ wool * tension,
         data = warpbreaks,
         family = "poisson")


## -----------------------------------------------------------------------------------------
resid_panel(m, qqbands = TRUE, smoother = TRUE)


## -----------------------------------------------------------------------------------------
anova(m, test = "LRT")

## -----------------------------------------------------------------------------------------
nd <- warpbreaks %>%
  select(wool, tension) %>%
  unique()

p <- bind_cols(nd, 
               predict(m, nd, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    # Convert to expected count scale
    fit = exp(fit),
    lcl = exp(lcl),
    ucl = exp(ucl)
  )

g + 
  geom_pointrange(
    data = p,
    aes(y = fit,
        ymin = lcl,
        ymax = ucl),
    position = position_dodge(width = 0.1)
  ) + 
  geom_line(
    data = p,
    aes(y = fit, group = wool)
  ) +
  labs(
    x = "Tension",
    y = "Number of breaks",
    title = "Number of Breaks vs Tension and Wool Type",
    color = "Wool",
    shape = "Wool"
  )


## -----------------------------------------------------------------------------------------
tension <- emmeans(m, pairwise ~ tension, type = "response")
confint(tension)

wool    <- emmeans(m, pairwise ~ wool,    type = "response")
confint(wool)


## -----------------------------------------------------------------------------------------
tension <- emmeans(m, pairwise ~ tension | wool, type = "response")
confint(tension)


# Compare wool 
wool    <- emmeans(m, pairwise ~ wool | tension, type = "response")
confint(wool)


# Get all the comparisons
both    <- emmeans(m, pairwise ~ wool + tension, type = "response")
confint(both)

