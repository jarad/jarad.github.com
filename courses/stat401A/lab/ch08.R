setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 8                                         
#######################################################

# Read in species data
species = read.csv("case0801.csv")
names(species) = tolower(names(species))
species                                   # Compare to display 8.1

plot(area~species, species, log='xy', main='Compare to Display 8.2')    
# You can use log='x' or log='y' to just log x or y axis respectively



fluid = read.csv(paste(data.dir,"case0802.csv",sep=""))
names(fluid) = tolower(names(fluid))


plot(time~voltage, fluid,          main="Compare to Display 8.5")

plot(time~voltage, fluid, log='y', main="Compare to Display 8.4")
mod = lm(log(time)~voltage, fluid)
lines(fluid$voltage, exp(predict(mod)))


 
mod = lm(sqrt(time)~voltage,fluid)
par(mfrow=c(1,2))
plot(sqrt(time)~voltage, fluid, pch=19) 
abline(mod)
plot(fitted(mod),residuals(mod), main="Compare to Display 8.7", pch=19)
abline(0,0)

# Diagnostics plots
par(mfrow=c(2,3))
plot(mod, 1:6)


# Lack of fit ANOVA table compare to Display 8.10
mod.a = lm(log(time)~1, fluid)                  # Intercept only model
mod.b = lm(log(time)~          voltage , fluid) # Regression model
mod.c = lm(log(time)~as.factor(voltage), fluid) # One-way ANOVA model
# as.factor treats voltage as a categorical variable

# Compare with Display 8.10
anova(mod.a,mod.b,mod.c)  


