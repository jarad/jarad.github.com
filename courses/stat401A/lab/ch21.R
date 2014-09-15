setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 21                                         
#######################################################

######################## Case 21.01 ##############################

case2101 = read.csv("case2101.csv")
names(case2101) = tolower(names(case2101))

case2101 # Compare to Display 21.1
case2101$larea = log(case2101$area)
case2101$proportion = case2101$extinct/case2101$atrisk
case2101$logit = log(case2101$proportion/(1-case2101$proportion))

par(mar=c(5,4,4,4)+.1)
plot(logit~area, case2101, pch=19, main="Compare to Display 21.2", log='x')
pp = c(.01,.05,.1,.2,.3,.4,.5,.6)
logit = function(x) log(x/(1-x))
axis(4,logit(pp), pp)


# Notice the syntax
mod = glm(cbind(extinct,atrisk-extinct) ~ larea, binomial, case2101)
summary(mod)



######################## Case 21.02 ##############################

case2102 = read.csv("case2102.csv")
names(case2102) = tolower(names(case2102))

case2102 # Compare to Display 21.3
case2102$proportion = case2102$removed/case2102$placed
case2102$logit = log(case2102$proportion/(1-case2102$proportion))

ch = rep(NA,nrow(case2102))
ch[case2102$morph=="dark"] = 19
ch[case2102$morph=="light"] = 1

cl = rep(NA,nrow(case2102))
cl[case2102$morph=="dark"] = "black"
cl[case2102$morph=="light"] = "gray"


plot(logit~distance, case2102[case2102$morph=="dark",], type='p', pch=19,
     ylim=range(case2102$logit))
lines(case2102$distance[case2102$morph=="dark"], case2102$logit[case2102$morph=="dark"])
points(case2102$distance[case2102$morph=="light"], case2102$logit[case2102$morph=="light"], pch=21, bg="gray")
lines(case2102$distance[case2102$morph=="light"], case2102$logit[case2102$morph=="light"], col="gray")




modf = glm(cbind(removed,placed-removed) ~ morph*distance, binomial, case2102)
summary(modf) # Compare to Display 21.8 (full model)

modr = glm(cbind(removed,placed-removed) ~ morph*distance, binomial, case2102)
summary(modr) # Compare to Display 21.8 (full model)

# Drop-in-deviance test for interaction
anova(modr, modf, test="Chi")


case2102$proportion = case2102$removed/case2102$placed

cbind(case2102, residuals(mod), predict(mod))


