## ----------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## ----------------------------------------------------------------------------------
expit <- function(eta) 1/(1+exp(-eta)) # inverse logitistic


## ----------------------------------------------------------------------------------
case1802


## ----------------------------------------------------------------------------------
# NoCold is success here
m_binomial <- glm(cbind(NoCold, Cold) ~ Treatment, 
                  data = case1802,
                  family = "binomial")


## ----------------------------------------------------------------------------------
case1802_individual <- case1802 %>%
  tidyr::pivot_longer(-Treatment, names_to = "Result", values_to = "n") %>%
  tidyr::uncount(n) %>%
  mutate(Result = factor(Result))

table(case1802_individual)


## ----------------------------------------------------------------------------------
m_bernoulli <- glm(Result ~ Treatment,
                   data = case1802_individual,
                   family = "binomial")


## ----------------------------------------------------------------------------------
coef(m_bernoulli)


## ----------------------------------------------------------------------------------
confint(m_bernoulli)


## ----------------------------------------------------------------------------------
summary(m_bernoulli)$coefficients


## ----------------------------------------------------------------------------------
anova(m_bernoulli, test = "LRT")


## ----------------------------------------------------------------------------------
nd <- data.frame(Treatment = unique(case1802_individual$Treatment))

p <- nd %>%
  mutate(prediction = predict(m_bernoulli, newdata = .))
p


## ----------------------------------------------------------------------------------
p %>% mutate(probability = expit(prediction))


## ----------------------------------------------------------------------------------
p %>% mutate(probability = predict(m_bernoulli, newdata = ., type = "response"))


## ----------------------------------------------------------------------------------
cbind(nd, predict(m_bernoulli, newdata = nd, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    # convert to probability
    prob  = expit(fit),
    p.lcl = expit(lcl),
    p.ucl = expit(ucl)
  ) %>%
  select(-residual.scale)


## ----------------------------------------------------------------------------------
emmeans(m_bernoulli, ~ Treatment, type = "response")


## ----------------------------------------------------------------------------------
emmeans(m_bernoulli, pairwise ~ Treatment, type = "response")


## ----------------------------------------------------------------------------------
resid_panel(m_binomial)
resid_panel(m_bernoulli)


## ----------------------------------------------------------------------------------
summary(ex2011)


## ----------------------------------------------------------------------------------
m <- glm(Failure ~ Temperature, 
         data = ex2011,
         family = "binomial")


## ----------------------------------------------------------------------------------
summary(m)


## ----------------------------------------------------------------------------------
p <- bind_cols(ex2011, 
               predict(m, newdata = ex2011, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit
  )


## ----------------------------------------------------------------------------------
ggplot(p, aes(x = Temperature, y = fit, ymin = lcl, ymax = ucl)) + 
  geom_ribbon(alpha = 0.5) +
  geom_line()


## ----------------------------------------------------------------------------------
p <- p %>%
  mutate(
    fit = expit(fit),
    lcl = expit(lcl),
    ucl = expit(ucl)
  )

ggplot(p, aes(x = Temperature, y = fit, ymin = lcl, ymax = ucl)) + 
  geom_ribbon(alpha = 0.5, fill = "gray") +
  geom_line(color = "blue") +
  labs(
    y = "Probability",
    title = "Probability of O-ring Failure vs Temperature"
  ) +
  geom_jitter(aes(y = 1*(Failure == "Yes")),
              height = 0)


## ----------------------------------------------------------------------------------
summary(case2002)


## ----------------------------------------------------------------------------------
d <- case2002 %>%
  mutate(LungCancer   = LC == "LungCancer",
         
         BirdKeeping  = ifelse(BK == "Bird", "Yes", "No"),
         BirdKeeping  = factor(BirdKeeping, levels = c("Yes","No")),
         
         SmokingYears = YR) %>%
  
  select(LungCancer, BirdKeeping, SmokingYears)

summary(d)


## ----------------------------------------------------------------------------------
m <- glm(LungCancer ~ BirdKeeping * SmokingYears, 
         data = d,
         family = "binomial")


## ----------------------------------------------------------------------------------
resid_panel(m)


## ----------------------------------------------------------------------------------
summary(m)
anova(m, test = "Chi")


## ----------------------------------------------------------------------------------
m <- glm(LungCancer ~ BirdKeeping + SmokingYears, 
         data = d,
         family = "binomial")

summary(m)


## ----------------------------------------------------------------------------------
em <- emmeans(m, pairwise ~ BirdKeeping, type = "response")
confint(em)


## ----------------------------------------------------------------------------------
nd <- expand.grid(
  BirdKeeping  = unique(d$BirdKeeping),
  SmokingYears = seq(min(d$SmokingYears), max(d$SmokingYears), length = 1001)
)

p <- bind_cols(nd, predict(m, newdata = nd, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    # Convert to probability scale
    prob = expit(fit),
    lcl  = expit(lcl),
    ucl  = expit(ucl)
  )

ggplot(p, aes(x = SmokingYears, 
              y = prob, ymin = lcl, ymax = ucl,
              fill = BirdKeeping, color = BirdKeeping)) + 
  geom_ribbon(alpha = 0.5) + 
  geom_line() +
  ylim(0,1) +
  labs(y = "Probability of lung lancer",
        x = "Number of years of smoking",
        title = "Effect of Bird Keeping on Lung Cancer",
        subtitle = "Controlling for Years of Smoking",
       color = "Bird keeping",
       fill = "Bird keeping") +
  theme(legend.position = "bottom")


## ----------------------------------------------------------------------------------
m <- glm(LC ~ ., data = case2002, family = "binomial")
drop1(m, test = "LRT")


## ----------------------------------------------------------------------------------
m <- glm(Cause ~ Make*Passengers*VehicleAge, data = ex2018, family = "binomial")
anova(m, test = "LRT")


## ----------------------------------------------------------------------------------
m <- glm(Cause ~ Make * Passengers + VehicleAge, 
         data = ex2018,
         family = "binomial")

nd <- expand.grid(
  Make  = unique(ex2018$Make),
  Passengers = seq(min(ex2018$Passengers), 
                   max(ex2018$Passengers)),
  VehicleAge = seq(min(ex2018$VehicleAge),
                   max(ex2018$VehicleAge))
  )

p <- bind_cols(nd, 
               predict(m, newdata = nd, se.fit = TRUE)) %>%
  mutate(
    lcl = fit - qnorm(.975)*se.fit,
    ucl = fit + qnorm(.975)*se.fit,
    
    fit = expit(fit),
    lcl = expit(lcl),
    ucl = expit(ucl)
  )

ggplot(p, aes(x = Passengers, 
              y = fit, 
              ymin = lcl,
              ymax = ucl,
              fill = Make,
              color = Make,
              linetype = Make)) + 
  geom_ribbon(alpha = 0.5) +
  geom_line() + 
  facet_wrap(~VehicleAge, 
             labeller = label_both) +
  theme(legend.position = "bottom") + 
  labs(
    y = "Probability",
    title = "Probability a Car Accident is Caused by Tire Failure"
  )

