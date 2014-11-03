setwd("U:\\401A\\sleuth3csv") # or wherever your data are

#######################################################
# Chapter 9                                        
#######################################################

case0901 = read.csv("case0901.csv")
names(case0901) = tolower(names(case0901))
names(case0901)[3] = "light"
case0901$early = case0901$time-1
case0901$lightXearly = case0901$light*case0901$early

plot(flowers~light,case0901, pch=1+18*early)
legend("bottomleft", legend=c("late","early"), pch=c(1,19))

# Compare to Display 9.14
mod = lm(flowers~light+early+lightXearly, case0901)
summary(mod)

mod = lm(flowers~light+early+light:early, case0901)
sumary(mod)

# Include main effects plus the interaction
mod = lm(flowers~light*early, case0901) 
summary(mod)



###############################################
case0902 = read.csv("case0902.csv")
names(case0902)  = tolower(names(case0902))
case0902$lbrain  = log(case0902$brain)
case0902$lbody   = log(case0902$body)
case0902$lgest   = log(case0902$gestation)
case0902$llitter = log(case0902$litter)

# Compare to Display 9.15
mod = lm(lbrain~lbody+lgest+llitter, case0902)
summary(mod)

# Alternatively
mod = lm(log(brain) ~ log(body) + log(gest) + log(litter), case0902)
summary(mod)
