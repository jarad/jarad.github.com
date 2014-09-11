setwd("U:\401A\sleuth3csv") # or whever your data are

#######################################################
# Chapter 11                                         
#######################################################

############################ Case 11.01 #############################

case1101 = read.csv("case1101.csv")
names(case1101) = tolower(names(case1101))
case1101$subject = NULL # remove subject column, unnecessary in R


head(case1101,10) # first 10 rows of the dataset

# To match the plot in the book
plotting.character = NA
plotting.character[case1101$sex=="Female" & case1101$alcohol=="Non-alcoholic"] = 17
plotting.character[case1101$sex=="Female" & case1101$alcohol=="Alcoholic"]     = 19
plotting.character[case1101$sex=="Male"   & case1101$alcohol=="Non-alcoholic"] = 2
plotting.character[case1101$sex=="Male"   & case1101$alcohol=="Alcoholic"]     = 1

plot(metabol~gastric, case1101, pch=plotting.character, main="Display 11.2")
legend("topleft", 
       c("NonAlcoholic Females","NonAlcoholic Males","Alcoholic Females","Alcoholic Males"), 
       pch=c(17,19,2,1))

# Regression
mod = lm(metabol~.^3, case1101) # shorthand to get all 3 way interactions
plot(mod,1) # Compare to Display 11.7

mod.subset = lm(metabol~.^3, case1101[-c(31,32),])

# Compare to Display 11.9
round(cbind(coef(summary(mod))[,-3], coef(summary(mod.subset))[,-3]),2)

mod.new = lm(metabol~gastric*sex, case1101) # shorthand to get both main effects and interaction
inf = influence.measures(mod.new)

# Compare to Display 11.12
par(mfrow=c(4,1))
plot(cooks.distance(mod.new))
plot(hatvalues(mod.new)) # Leverage
plot(rstandard(mod.new)) # These are the internally studentized residuals
plot(rstudent(mod.new))  # These are the externally studentized residuals



############################ Case 11.02 #############################
case1102 = read.csv("case1102.csv")
names(case1102)  = tolower(names(case1102))
case1102$treat    = factor(case1102$treat, c("NS","BD"))
case1102$ratio    = case1102$brain/case1102$lliver  # This will be used in the plot
case1102$response = log(case1102$ratio)

case1102$ltime    = log(case1102$time)

head(case1102)

# Compare to Display 11.5
plotting.character = 1+18*(as.numeric(case1102$treat)-1)     # To match the book
par(mar=c(5,5,0,0)+.1)
plot(response~ltime, case1102, pch=plotting.character)       # Compare to the axis on the plot below
plot(ratio~time, case1102, pch=plotting.character, 
     log='xy',                                               # Plots on a log scale
     xlab="Sacrifice Time (hours)", 
     ylab="Tumor-to-liver\nconcentration ratio",
     xaxt='n') 
axis(1,c(0.5,3,24,72))


case1102$timeF = factor(case1102$time)
case1102$daysF = factor(case1102$days)
mod = lm(response~timeF*treat+days+sex+weight+loss+tumor, case1102)
plot(mod,1, main="Compare to Display 11.6")




############################ Case 9.02 #############################
case0902 = read.csv("case0902.csv")
names(case0902) = tolower(names(case0902))
mod = lm(log(brain)~log(gestation)+log(body), case0902)

# Partial residual plot
#install.packages("faraway")
require(faraway) # might need to download this package using the previous line
par(mfrow=c(2,1))
plot(log(brain)~log(gestation), case0902)
prplot(mod, 1)   # 2 is the explanatory variable index


