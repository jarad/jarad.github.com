## ------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## ------------------------------------------------------------------------------------------
d <- case1002 %>%
  filter(grepl("bats", Type)) %>%
  mutate(echolocating = Type == "echolocating bats")

d %>% 
  group_by(echolocating) %>%
  summarize(
    n = n(),
    mean = mean(Energy),
    sd = sd(Energy))

t.test(Energy ~ echolocating, data = d, var.equal = FALSE)


## ------------------------------------------------------------------------------------------
# Maybe should use logarithms
d %>% 
  group_by(echolocating) %>%
  summarize(
    n = n(),
    mean = mean(log(Energy)),
    sd = sd(log(Energy)))

t.test(log(Energy) ~ echolocating, data = d, var.equal = FALSE)


## ------------------------------------------------------------------------------------------
case1002 %>% 
  group_by(Type) %>%
  summarize(
    n = n(),
    mean = mean(log(Energy)),
    sd = sd(log(Energy)))

m <- lm(log(Energy) ~ Type, data = case1002)
anova(m)
summary(m)


## ------------------------------------------------------------------------------------------
ggplot(case1002, aes(x = Mass, y = Energy, color = Type, shape = Type)) +
  geom_point() + 
  scale_y_log10() + 
  scale_x_log10()


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass) + Type, data = case1002)
anova(m)


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass) * Type, data = case1002)
s <- summary(m)

# Coefficient estimates and confidence/credible intervals
coef(m)            # or m$coefficients
confint(m)

# SD estimate
s$sigma

# Coefficint of determination
s$r.squared

# Fitted and residuals
head(fitted(m))    # or head(m$fitted.values)
head(residuals(m)) # or head(m$residuals)

# A reasonable display of most of this
summary(m)


## ------------------------------------------------------------------------------------------
opar = par(mfrow = c(2,3))
plot(m, 1:6, ask = FALSE)
par(opar)


## ------------------------------------------------------------------------------------------
d <- case1002 %>%
  mutate(residuals = residuals(m))

plot(d$residuals) # residuals v index
plot(residuals ~ Type, data = d, type = "p")
plot(residuals ~ log(Mass), data = d)


## ------------------------------------------------------------------------------------------
resid_panel(m, plots = "all")

resid_panel(m, plots = "all", 
            qqbands = TRUE, smoother = TRUE)

resid_panel(m, plots = c("resid","index","qq","cookd"), 
            qqbands = TRUE, smoother = TRUE)

resid_xpanel(m, smoother = TRUE)


## ------------------------------------------------------------------------------------------
coef(s) # or s$coefficients


## ------------------------------------------------------------------------------------------
summary(m)


## ------------------------------------------------------------------------------------------
m  <- lm(log(Energy) ~ log(Mass) * Type, data = case1002)
m0 <- lm(log(Energy) ~ 1, data = case1002)
anova(m0, m)


## ------------------------------------------------------------------------------------------
anova(m)


## ------------------------------------------------------------------------------------------
drop1(m, test = "F")


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ Type, data = case1002)
e <- emmeans(m, pairwise~Type)
e


## ------------------------------------------------------------------------------------------
contrast(e, list("echo v non-echo" = c(-1,.5,.5)))


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass)*Type, data = case1002)
emtrends(m, pairwise ~ Type, var = "log(Mass)")


## ------------------------------------------------------------------------------------------
ggplot(case1002, aes(x = Mass, y = Energy, 
       color = Type, linetype = Type, shape = Type)) +
  geom_point() + 
  geom_smooth(method = "lm") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_vline(xintercept = 400)


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass)*Type, data = case1002)
em <- emmeans(m, pairwise ~ Type, at = list(Mass = 400))
em
co <- contrast(em, type = "response")
confint(co)


## ------------------------------------------------------------------------------------------
lm(Energy ~ Mass + Type, data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ sqrt(Mass) + Type, data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ Mass + I(Mass^2) + Type, data = case1002)


## ------------------------------------------------------------------------------------------
meanMass <- mean(case1002$Mass)
lm(Energy ~ I(Mass - meanMass), data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ log(Mass) + Type + log(Mass):Type, data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ log(Mass) * Type, data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ ., data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ .^2, data = case1002)


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ log(Mass) + Type - 1, data = case1002) # remove intercept


## ------------------------------------------------------------------------------------------
lm(log(Energy) ~ log(Mass) * Type - Type, data = case1002)


## ------------------------------------------------------------------------------------------
ggplot(case0701, aes(x = Velocity, y = Distance)) +
  geom_point() + 
  geom_smooth(method = "lm", formula = y ~ x)


## ------------------------------------------------------------------------------------------
m <- lm(Distance ~ Velocity, data = case0701)

d <- data.frame(Velocity = range(case0701$Velocity)) %>%
  mutate(prediction = predict(m, newdata = .))

ggplot(case0701, aes(x = Velocity)) +
  geom_point(aes(y = Distance)) + 
  geom_line(
    data = d,
    aes(y = prediction), color = "blue")


## ------------------------------------------------------------------------------------------
summary(m)


## ------------------------------------------------------------------------------------------
resid_panel(m, plots = c("resid","index","qq","cookd"))
resid_xpanel(m)


## ------------------------------------------------------------------------------------------
ggplot(case0501, aes(x = Diet, y = Lifetime)) + 
  geom_jitter(width = 0.1)


## ------------------------------------------------------------------------------------------
m <- lm(Lifetime ~ Diet, data = case0501)


## ------------------------------------------------------------------------------------------
resid_panel(m, plots = c("resid","index","qq","cookd"))
resid_xpanel(m)


## ------------------------------------------------------------------------------------------
d <- data.frame(Diet = unique(case0501$Diet)) 
p <- d %>% mutate(prediction = predict(m, d))

ggplot() + 
  geom_jitter(
    data = case0501,
    aes(x = Diet, y = Lifetime),
    width = 0.1) + 
  geom_point(
    data = p,
    aes(x = Diet, y = prediction),
    color = "red",
    size = 3)


## ------------------------------------------------------------------------------------------
ggplot(Sleuth3::case1001, aes(Height, Distance)) +
  geom_point() +
  theme_bw()


## ------------------------------------------------------------------------------------------
m1 <- lm(Distance ~ Height,                             case1001)
m2 <- lm(Distance ~ Height + I(Height^2),               case1001)
m3 <- lm(Distance ~ Height + I(Height^2) + I(Height^3), case1001)


## ------------------------------------------------------------------------------------------
g <- ggplot(case1001, aes(x=Height, y=Distance)) + geom_point(size=3)

g 
g + stat_smooth(method="lm", formula = y ~ x)                                   
g + stat_smooth(method="lm", formula = y ~ x + I(x^2))          
g + stat_smooth(method="lm", formula = y ~ x + I(x^2) + I(x^3)) 


## ------------------------------------------------------------------------------------------
m <- lm(Distance ~ Height + I(Height^2) + I(Height^3) + I(Height^4), case1001)
anova(m)


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass) + Type, data = case1002)

d <- expand.grid(
  Mass = seq(min(case1002$Mass), max(case1002$Mass), length = 1001),
  Type = unique(case1002$Type)
)

p <- d %>%
  mutate(Energy = exp(predict(m, newdata = d))) # note the exp()

g <- ggplot() + 
  geom_point(
    data = case1002, aes(x = Mass, y = Energy, color = Type, shape    = Type)) + 
  geom_line(
    data = p,        aes(x = Mass, y = Energy, color = Type, linetype = Type)) 

g


## ------------------------------------------------------------------------------------------
g + 
  scale_x_log10() + 
  scale_y_log10()


## ------------------------------------------------------------------------------------------
m <- lm(log(Energy) ~ log(Mass) * Type, data = case1002) # note the *

d <- expand.grid(
  Mass = seq(min(case1002$Mass), max(case1002$Mass), length = 1001),
  Type = unique(case1002$Type)
)

p <- d %>%
  mutate(Energy = exp(predict(m, newdata = d))) # note the exp()

g <- ggplot() + 
  geom_point(
    data = case1002, aes(x = Mass, y = Energy, color = Type, shape    = Type)) + 
  geom_line(
    data = p,        aes(x = Mass, y = Energy, color = Type, linetype = Type)) 

g


## ------------------------------------------------------------------------------------------
g + 
  scale_x_log10() + 
  scale_y_log10()

