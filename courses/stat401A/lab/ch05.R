setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 5                                         
#######################################################

################### Displays from Chapter 5 ######################
mice = read.csv("case0501.csv")
names(mice) = tolower(names(mice)) # makes variable names lower case

head(mice,10)

boxplot(lifetime~diet, mice, main="Compare to Display 5.1")

# Compare to Display 5.2
library(plyr)
sm = ddply(mice, .(diet), summarise,
           n = length(lifetime),
           min = min(lifetime),
           max = max(lifetime),
           mean = mean(lifetime),
           sd = sd(lifetime))
sm$ciL = sm$mean - qt(.975, sm$n-1)*sm$sd/sqrt(sm$n)
sm$ciU = sm$mean + qt(.975, sm$n-1)*sm$sd/sqrt(sm$n)
sm

# ANOVA
m = lm(lifetime~diet, mice)
anova(m) # R doesn't give you the bottom line

pairwise.t.test(mice$lifetime, mice$diet, pool.sd = TRUE, p.adjust.method="none")

# pairwise.t.test doesn't provide confidence intervals, but the following will
TukeyHSD(aov(m)) # but this uses the Tukey adjustment (discussed in chapter 6)



spock = read.csv("case0502.csv")
names(spock) = tolower(names(spock))
head(spock,10)

boxplot(percent~judge, spock, main="Compare to Display 5.5")

# Compare to Display 5.10
anova(lm(percent~judge, spock))

# Create a new factor variable distinguishing
# the Spock judge from the rest
spock$others = factor(spock$judge != "Spock's")
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

