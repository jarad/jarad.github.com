setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 8                                         
#######################################################

# Read in case0801 data
case0801 = read.csv("case0801.csv")
names(case0801) = tolower(names(case0801))
case0801                                   # Compare to display 8.1

plot(species~area, case0801, log='xy', main='Compare to Display 8.2')    
# You can use log='x' or log='y' to just log x or y axis respectively



case0802 = read.csv("case0802.csv")
names(case0802) = tolower(names(case0802))


plot(time~voltage, case0802,          main="Compare to Display 8.5")

plot(time~voltage, case0802, log='y', main="Compare to Display 8.4")
mod = lm(log(time)~voltage, case0802)
lines(case0802$voltage, exp(predict(mod)), col='red', lwd=2) # Need to use this due to using log


 
mod = lm(sqrt(time)~voltage,case0802)
par(mfrow=c(1,2))
plot(sqrt(time)~voltage, case0802, pch=19) 
abline(mod, col='red', lwd=2)
plot(fitted(mod), residuals(mod), main="Compare to Display 8.7", pch=19)
abline(0,0)

# Diagnostics plots
par(mfrow=c(2,3))
plot(mod, 1:6)


# Lack of fit ANOVA table compare to Display 8.10
mod.a = lm(log(time)~               1  , case0802) # Intercept only model
mod.b = lm(log(time)~          voltage , case0802) # Regression model
mod.c = lm(log(time)~as.factor(voltage), case0802) # One-way ANOVA model
# as.factor treats voltage as a categorical variable

# Compare with Display 8.10
anova(mod.a,mod.b,mod.c)  


