setwd("U:\\401A\\sleuth3csv") # or whever your data are

library(ggplot2)

#######################################################
# Chapter 7                                         
#######################################################

case0701 = read.csv("case0701.csv")
names(case0701) = tolower(names(case0701))
summary(case0701) 
pairs(case0701)

plot(distance~velocity, case0701, main='Compare to Display 7.1')

mod = lm(distance~velocity, case0701)
summary(mod) # Compare to Display 7.9
case0701$fit = predict(mod)
case0701$res = residual(mod)
case0701 # Compare to Display 7.8

plot(distance~velocity, case0701)
abline(mod, col="red")

# centered explanatory variable regression
case0701$centered = with(case0701, velocity-mean(velocity)) # Automatically subtract the mean
case0701
mod2 = lm(distance~centered, case0701)
summary(mod2)

# Compare to Display 7.10 and 7.12
predict(mod2, interval="confidence")      # confidence interval for the mean
predict(mod2, interval="prediction")      # prediction interval for new data points

plot(residuals(mod2)~fitted(mod2))        # manual diagnostic plot
par(mfrow=c(2,3))
plot(mod2, 1:6, ask=F)                    # automatic diagnostic plots

# Sample correlation coefficient
cor.test(case0701$velocity,case0701$distance)






case0702 = read.csv("case0702.csv")
names(case0702) = tolower(names(case0702))
names(case0702)[1] = "hours" # To match the SAS code and book results

case0702 # Compare to Display 7.3

# Fit the simple linear regression model
mod = lm(ph ~ log(hours), case0702)

# This gets confidence band
ggplot(case0702, aes(x=ph, y=log(hours))) + geom_point() + geom_smooth(method='lm',formula=y~x)

# This gets prediction band
plot(ph~hours, case0702, log='x', main="Compare to Display 7.4", pch=19)
pred = predict(mod, interval="prediction")
lines(case0702$hours,pred[,1])
lines(case0702$hours,pred[,2], lty=2)
lines(case0702$hours,pred[,3], lty=2)




