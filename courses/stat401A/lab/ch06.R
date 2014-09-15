setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 6                                         
#######################################################

################### Displays from Chapter 6 ######################
discrimination = read.csv("case0601.csv")
names(discrimination) = tolower(names(discrimination))

fish = read.csv("case0602.csv")
names(fish) = tolower(names(fish))
fish$percentage = fish$proportion*100

# Compare to Display 6.3
# Slightly different due to rounding
my.fun = function(x) {
	return(round(c(length(x), mean(x), sd(x)),1))
}
by(fish$percentage, fish$pair, my.fun)

# Compare to Display 6.4
# install.packages("multcomp")
library(multcomp)
levels(discrimination$handicap)
K = cbind("Diff: C+W - A+H"=c(-1,1,-1,0,1)/2)
mod = lm(score~handicap-1, discrimination) # No intercept
cont = glht(mod, linfct=t(K))
summary(cont)
confint(cont)

# Compare to Display 6.5
levels(fish$pair)
K = cbind("Linear trend:" = c(5,-3,1,3,-9,3))
mod= lm(percentage~pair-1, fish)
cont = glht(mod, linfct=t(K))
summary(cont)
confint(cont)

# Compare to Display 6.6
pairwise.t.test(discrimination$score, discrimination$handicap, 
                p.adjust="bonferroni")

# In pairwise.t.test there is no p.adjust="tukey", instead use 
TukeyHSD(aov(score~handicap, discrimination), "handicap")

kruskal.test(lifetime~diet, mice)


