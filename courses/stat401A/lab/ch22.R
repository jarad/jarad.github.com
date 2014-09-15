setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 22                                         
#######################################################

######################## Case 22.01 ##############################

case2201 = read.csv("case2201.csv")
names(case2201) = tolower(names(case2201))
case2201 # Compare to Display 22.1

plot(matings~age, case2201, main="Compare to Display 22.2")


modf = glm(matings~age+I(age^2), poisson, case2201)
summary(modf) # Compare to Display 22.6

modr = glm(matings~age         , poisson, case2201)
summary(modr) # Compare to Display 22.8

# Drop-in-deviance test for squared term
anova(modr, modf, test="Chi") 

# Lack-of-fit test
1-pchisq(modr$deviance, modr$df.residual)

######################## Case 22.02 ##############################

case2202 = read.csv("case2202.csv")
names(case2202) = tolower(names(case2202))
case2202 # Compare to Display 22.3

plot(salamanders~pctcover, case2202, main="Compare to Display 22.4")

case2202$closure = case2202$pctcover>70

mod = glm(salamanders~forestage*pctcover*closure+I(forestage^2)+I(pctcover^2)+
                 closure*I(forestage^2)+closure*I(pctcover^2), poisson, case2202)
summary(mod) # Compare to Display 22.7 and Display 22.10 (full model)

plot(residuals(mod)~fitted(mod), main="Compare to Display 22.7")

par(mfrow=c(2,2))
plot(forestage~pctcover, case2202, main="Compare to Display 22.9")
plot(0,0,type="n", xlab="", ylab="", axes=F)
plot(salamanders~pctcover, case2202)
plot(salamanders~forestage, case2202)

mod = glm(salamanders~pctcover*closure+closure*I(pctcover^2), poisson, case2202)
summary(mod) # Compare to Display 22.10 (reduced model)


                 



