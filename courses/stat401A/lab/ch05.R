setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 5                                         
#######################################################

################### Displays from Chapter 5 ######################
mice = read.csv("case0501.csv")
names(mice) = tolower(names(mice)) # makes variable names lower case

head(mice,10)

boxplot(lifetime~diet,mice, main="Compare to Display 5.1")

# Compare to Display 5.2
library(plyr)
sm = ddply(mice, .(diet), summarise,
           n = length(lifetime),
           min = min(lifetime),
           max = max(lifetime),
           mean = mean(lifetime),
           sd = sd(lifetime))
sm$ciL = sm$mean - qt(.025, sm$n)*sm$sd/sqrt(sm$n)
sm$ciU = sm$mean + qt(.025, sm$n)*sm$sd/sqrt(sm$n)


spock = read.csv("case0502.csv")
names(spock) = tolower(names(spock))
head(spock,10)

boxplot(percent~judge, spock, main="Compare to Display 5.5")

# Compare to Display 5.10
anova(lm(percent~judge, spock))

spock$others = spock$judge == "Spock's"
head(spock,15)

# Compare to Display 5.12
mod0 = lm(percent~1, spock)
mod1 = lm(percent~others, spock)
mod2 = lm(percent~judge, spock)
anova(mod0,mod2)
anova(mod0,mod1,mod2)


# For homework
plot(mod2)
plot(predict(mod2), residuals(mod2))

