## ----options, echo=FALSE, warning=FALSE, message=FALSE-------------------
options(width=120)
opts_chunk$set(comment=NA, fig.width=6, fig.height=5, size='tiny', out.width='0.6\\textwidth', fig.align='center', message=FALSE)

## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-----------------
library("dplyr")
library("ggplot2")
library("gridExtra")
# library("xtable")
# library("Sleuth3")

## ----set_seed, echo=FALSE------------------------------------------------
set.seed(2)

## ------------------------------------------------------------------------
d <- expand.grid(b0 = c(-1,0,1), b1 = c(-1,0,1), x = seq(-4,4,by=0.1)) %>%
  mutate(theta = 1/(1+exp(-(b0+b1*x))),
         beta0 = as.factor(b0),
         beta1 = as.factor(b1)) 

ggplot(d, aes(x,theta,color=beta0,linetype=beta1,group=interaction(beta0,beta1))) + 
  geom_line() + 
  theme_bw() +
  labs(x="Explanatory variable (x)", y="Probability of success")

## ----echo=TRUE-----------------------------------------------------------
lung_cancer <- Sleuth3::case2002 %>%
  mutate(`Lung Cancer` = ifelse(LC=="NoCancer", "No","Yes"),
         `Cigarettes Per Day` = CD)

ggplot(lung_cancer, aes(`Cigarettes Per Day`, `Lung Cancer`)) + 
  geom_jitter(height=0.1) +
  theme_bw()

## ------------------------------------------------------------------------
m <- glm(`Lung Cancer`=="Yes" ~ `Cigarettes Per Day`, 
         data = lung_cancer,
         family = "binomial")

summary(m)

## ----echo=TRUE-----------------------------------------------------------
ggplot(lung_cancer, aes(`Cigarettes Per Day`, 1*(`Lung Cancer` == "Yes"))) + 
  geom_jitter(height=0.1) + 
  stat_smooth(method="glm", 
              se=FALSE, 
              method.args = list(family="binomial"))  +
  theme_bw() + 
  scale_y_continuous(breaks=c(0,1), labels=c("No","Yes")) +
  labs(y = "Lung Cancer")

## ------------------------------------------------------------------------
lung_cancer_grouped <- lung_cancer %>%
  group_by(`Cigarettes Per Day`) %>%
  summarize(`Number of individuals` = n(),
            `Number with lung cancer` = sum(`Lung Cancer` == "Yes"),
            `Number without lung cancer` = sum(`Lung Cancer` == "No"),
            `Proportion with lung cancer` = `Number with lung cancer`/`Number of individuals`)

lung_cancer_grouped

## ----fig.width=10--------------------------------------------------------
xx = 0:10
plot(xx, dbinom(xx, 10, .3), main="Probability mass function for Bin(10,.3)", 
     xlab="y", ylab="P(Y=Y)", pch=19)

## ------------------------------------------------------------------------
m = glm(cbind(`Number with lung cancer`, `Number without lung cancer`) ~ `Cigarettes Per Day`, 
        data = lung_cancer_grouped, 
        family="binomial")
summary(m)
confint(m)

## ------------------------------------------------------------------------
lung_cancer_bird <- Sleuth3::case2002 %>%
  group_by(CD, BK) %>%
  summarize(y = sum(LC == "LungCancer"),
            n = n(),
            p = y/n)

lung_cancer_bird

## ------------------------------------------------------------------------
ggplot(lung_cancer_bird, aes(CD, p, size=n, color=BK, shape=BK)) + 
  geom_point() + 
  theme_bw() +
  labs(x="Cigarettes per day", y="Proportion with lung cancer")

## ------------------------------------------------------------------------
# LC is binary
summary(m <- glm(cbind(y,n-y) ~ CD + BK, data=lung_cancer_bird, family="binomial"))

## ----echo=TRUE-----------------------------------------------------------
nd <- expand.grid(CD = 0:45, BK=c("Bird","NoBird"))
pd <- cbind(nd, data.frame(p=predict(m, newdata = nd, type = "response")))

ggplot() + 
  geom_point(data = lung_cancer_bird, aes(CD, p, size=n, color=BK, shape=BK)) + 
  geom_line(data = pd, aes(CD, p, color=BK, linetype=BK)) + 
  theme_bw() + 
  labs(x="Cigarettes per day", y="Proportion with lung cancer")

