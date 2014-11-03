setwd("U:\\401A\\sleuth3csv") # or wherever your data are

#######################################################
# Chapter 13                                         
#######################################################


case1301 = read.csv("case1301.csv")
names(case1301) = tolower(names(case1301))
case1301$regratio = log(case1301$cover/(100-case1301$cover))
summary(case1301)

m = lm(regratio ~ block*treat, case1301)
anova(m) # Compare to Display 13.10

# Remove interaction
m2 = lm(regratio ~ block+treat, case1301)
anova(m2) # Compare to Display 13.11


# Get order of levels in the categorical variables
levels(case1301$block)
levels(case1301$treat)

library(multcomp) 
#                               C   f  fF   L  Lf  LfF
K <- rbind('large fish'    = c( 0, -1,  1,  0, -1,  1)/2,     
           'small fish'    = c(-1,  1,  0, -1,  1,  0)/2,
           'limpits'       = c(-1, -1, -1,  1,  1,  1)/3,
           'limpitsXsmall' = c( 2, -1, -1, -2,  1,  1)/4,
           'limpitsXlarge' = c( 0,  1, -1,  0, -1,  1)/2)
contrasts2 = glht(m2, linfct = mcp(treat=K))
summary(contrasts2) # Compare to Display 13.13


# This doesn't recover the same results...I'm not sure what is going on yet
contrasts = glht(m, linfct = mcp(treat=K))
summary(contrasts)


# Use of LSMEANS even in a model with the interaction */
library(lsmeans)
lsmeans(m, specs=pairwise~treat)       # marginal    treatment differences 
lsmeans(m, specs=pairwise~treat*block) # conditional treatment differences 




############################ Case 13.02 #############################
case1302 = read.csv("case1302.csv")
names(case1302) = tolower(names(case1302))
summary(case1302) 
case1302$company = factor(case1302$company, paste("C",1:10, sep=""))

plotting.character=1+18*(as.numeric(case1302$treat)-1)
plot(score~as.numeric(company), case1302, pch=plotting.character,
     xlab="Company", ylab="Platoon score", main="Compare to Display 13.14")
abline(v=1:10, lty=2, col="gray")
legend("topright", c("Control","Pygmalion"), pch=1:2, bg="white")

# Compare to Display 13.16
mod = lm(score~company*treat, case1302)
anova(mod) 

# Compare to Display 13.18
mod = lm(score~company+treat, case1302)
summary(mod)

# Compare to Display 13.17
plot(mod,1)



