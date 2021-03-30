## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ----data, echo=TRUE--------------------------------------------------------------------------------------------------
library("Sleuth3")
# head(case0501)
summary(case0501)
case0501 <- case0501 %>% 
  mutate(Diet = factor(Diet, c("NP","N/N85","N/R50","R/R50","lopro","N/R40")),
         Diet = recode(Diet, lopro = "N/R50 lopro"))
case0501 %>% group_by(Diet) %>% summarize(n=n(), mean = mean(Lifetime), sd = sd(Lifetime))


## ----data_plot, dependson="data", fig.height=4, echo=TRUE-------------------------------------------------------------
ggplot(case0501, aes(x=Diet, y=Lifetime)) +
  geom_jitter(width=0.2, height=0) +
  geom_boxplot(fill=NA, color='blue', outlier.color = NA) + 
  coord_flip() +
  theme_bw()


## ----tests, dependson="data", echo=TRUE-------------------------------------------------------------------------------
bartlett.test(Lifetime ~ Diet, data = case0501)
oneway.test(Lifetime ~ Diet, data = case0501, var.equal = TRUE)
oneway.test(Lifetime ~ Diet, data = case0501, var.equal = FALSE)


## ----echo=FALSE, fig.height=3.5---------------------------------------------------------------------------------------
m = 1:20
plot(m, 1-(1-.05/m)^m, ylim=c(0,0.05), type="l", lwd=2,
     xlab="Number of tests", ylab="Familywise error rate", 
     main="Bonferroni familywise error rate")
lines(m, 1-(1-.01/m)^m, lty=2, col=2, lwd=2)
legend("right", paste("alpha=",c(.05,.01)), lwd=2, lty=1:2, col=1:2)


## ----pairwise, dependson="data", echo=TRUE----------------------------------------------------------------------------
pairwise.t.test(case0501$Lifetime, case0501$Diet, p.adjust.method = "none")


## ----pairwise_bonferroni, dependson="data", echo=TRUE-----------------------------------------------------------------
pairwise.t.test(case0501$Lifetime, case0501$Diet, p.adjust.method = "bonferroni")


## ----pairwise_tukey, dependson="data", echo=TRUE----------------------------------------------------------------------
TukeyHSD(aov(Lifetime ~ Diet, data = case0501))

