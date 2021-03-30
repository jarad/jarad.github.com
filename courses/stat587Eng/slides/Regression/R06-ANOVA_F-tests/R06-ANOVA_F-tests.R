## ----options, echo=FALSE, warning=FALSE, message=FALSE----------------------------------------------------------------
options(width=120)
opts_chunk$set(comment=NA, 
               fig.width=6, 
               fig.height=4.4, 
               size='tiny', 
               out.width='\\textwidth', 
               fig.align='center', 
               echo=FALSE,
               message=FALSE)


## ----libraries, message=FALSE, warning=FALSE, echo=FALSE--------------------------------------------------------------
library("tidyverse")
library("Sleuth3")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
set.seed(20190410)
d <- expand.grid(x = seq(-5, 5, length=101),
                 mean = round(sort(rnorm(6)),2)) %>%
  mutate(density = dnorm(x, mean),
         mean = paste0("mean = ", mean))

ggplot(d, aes(x, density, color=mean, linetype=mean)) + 
  geom_line() + 
  theme_bw()


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::case0501, aes(x=Diet, y=Lifetime)) + 
  geom_jitter() + 
  # geom_hline(data=sm2, aes(yintercept=mean[7]), 
  #            col='red', size=2) + 
  # geom_errorbar(data=sm, aes(y=mean, ymin=mean, ymax=mean), 
  #               col='blue', size=2) +
  theme_bw()


## ----F-distribution, echo=FALSE, fig.height = 3.5---------------------------------------------------------------------
df = c(5,300)
ggplot(data.frame(x = c(0,4)), aes(x=x)) + 
  stat_function(fun = "df", args = list(df1 = df[1], df2 = df[2]), 
                xlim = c(2,4), geom = "area", fill = "magenta") +
  stat_function(fun = "df", args = list(df1 = df[1], df2 = df[2])) +
  labs(title = paste0("F(",df[1],", ",df[2],")"),
       x = "F", y = "density") +
  theme_bw()


## ----echo=FALSE, warning=FALSE----------------------------------------------------------------------------------------
sm <- Sleuth3::case0501 %>%
  group_by(Diet) %>%
  summarize(n = n(),
            mean = mean(Lifetime),
            sd = sd(Lifetime))
total <- Sleuth3::case0501 %>% 
  summarize(n = n(), 
            mean = mean(Lifetime),
            sd = sd(Lifetime)) %>%
  mutate(Diet = "Total")
(sm2 <- bind_rows(sm,total))


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::case0501, aes(x = Diet)) + 
  geom_jitter(aes(y=Lifetime), size=3) + 
  geom_hline(data=sm2, aes(yintercept=mean[7]), 
             col='red', size=2) + 
  geom_errorbar(data=sm, aes(x=Diet, ymin=mean, ymax=mean), 
                col='blue', size=2) +
  theme_bw()


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
m <- lm(Lifetime~Diet, case0501)
anova(m)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
sm3 = sm 
sm3$mean[-which(sm3$Diet=="NP")] = mean(case0501$Lifetime[case0501$Diet!="NP"])
ggplot(case0501, aes(x=Diet)) + 
  geom_jitter(aes(y=Lifetime), size=3) + 
  geom_errorbar(data=sm, aes(ymin=mean, ymax=mean), 
                col='blue', size=2) + 
  geom_errorbar(data=sm3, aes(ymin=mean, ymax=mean), 
                col='red', size=2) +
  theme_bw()


## ----echo = TRUE------------------------------------------------------------------------------------------------------
case0501$NP = factor(case0501$Diet == "NP")

modR = lm(Lifetime~NP,   case0501) # (R)educed model
modF = lm(Lifetime~Diet, case0501) # (F)ull    model
anova(modR,modF)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::ex0816, aes(factor(Time), pH))+
  geom_boxplot(color="gray")+
  geom_point()+
  labs(x="Time", y="pH", 
       title="pH vs Time in Steer Carcasses") +
  theme_bw()


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::ex0816, aes(Time, pH))+
  geom_point() +
  stat_smooth(method="lm") +
  labs(x="Time", y="pH", 
       title="pH vs Time in Steer Carcasses") +
  theme_bw() 


## ----echo = TRUE------------------------------------------------------------------------------------------------------
# Use as.factor to turn a continuous variable into a categorical variable
m_anova = lm(pH ~ as.factor(Time), Sleuth3::ex0816) 
m_reg   = lm(pH ~           Time , Sleuth3::ex0816)
anova(m_reg, m_anova)

