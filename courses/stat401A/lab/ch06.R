setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 6                                         
#######################################################

case0601 = read.csv("case0601.csv")
names(case0601) = tolower(names(case0601))

# Compare to Display 6.4
# install.packages("multcomp")
library(multcomp)
levels(case0601$handicap)
K = rbind("Diff: C+W - A+H"=c(-1,1,-1,0,1)/2)
mod = lm(score~handicap-1, case0601) # No intercept
cont = glht(mod, linfct=K)
summary(cont)
confint(cont)

# Compare to Display 6.6
pairwise.t.test(case0601$score, case0601$handicap, 
                p.adjust="none") # LSD, i.e. no adjustment
pairwise.t.test(case0601$score, case0601$handicap, 
                p.adjust="bonferroni")

# The other options are available in the multcomp package
t = glht(mod, linfct=mcp(handicap="Dunnett"))
# t = glht(mod, linfct=mcp(handicap="Tukey"))
summary(t)
confint(t)

# Alternatively, for Tukey, use 
TukeyHSD(aov(score~handicap, case0601), "handicap")





case0602 = read.csv("case0602.csv")
names(case0602) = tolower(names(case0602))
case0602$percentage = case0602$proportion*100

# Compare to Display 6.3
# Slightly different due to rounding
# install.packages("plyr")
library(plyr)
ddply(case0602, .(pair), summarize,
      n = length(percentage),
      mean = mean(percentage),
      sd = sd(percentage))


# Compare to Display 6.5
levels(case0602$pair)
K = rbind("Linear trend:" = c(5,-3,1,3,-9,3))
mod= lm(percentage~pair-1, case0602)
cont = glht(mod, linfct=K)
summary(cont)
confint(cont)



# Try Kruskal-Wallis due to concerns about normality based on histograms 
case0501 = read.csv("case0501.csv")
names(case0501) = tolower(names(case0501))
kruskal.test(lifetime~diet, case0501)


