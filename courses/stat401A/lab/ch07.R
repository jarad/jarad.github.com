setwd("U:\\401A\\sleuth3csv") # or whever your data are

#######################################################
# Chapter 7                                         
#######################################################

bigbang = read.csv("case0701.csv")
names(bigbang) = tolower(names(bigbang))
summary(bigbang) 
pairs(bigbang)

plot(distance~velocity, bigbang, main='Compare to Display 7.1')

carcass = read.csv("case0702.csv")
names(carcass) = tolower(names(carcass))
names(carcass)[1] = "hours"

carcass # Compare to Display 7.3

mod = lm(ph~log(hours),carcass)
plot(ph~hours,carcass, log='x', main="Compare to Display 7.4", pch=19)
pred = predict(mod, interval="prediction")
lines(carcass$hours,pred[,1])
lines(carcass$hours,pred[,2], lty=2)
lines(carcass$hours,pred[,3], lty=2)



mod = lm(distance~velocity, bigbang)
summary(mod) # Compare to Display 7.9
bigbang$fit = predict(mod)
bigbang$res = residual(mod)
bigbang # Compare to Display 7.8

plot(distance~velocity, bigbang)
abline(mod, col="red")

# centered explanatory variable regression
bigbang$centered = bigbang$velocity-mean(bigbang$velocity)
bigbang
mod2 = lm(distance~centered, bigbang)
summary(mod2)

# Compare to Display 7.10 and 7.12
predict(mod2, interval="confidence")      # confidence interval for the mean
predict(mod2, interval="prediction")      # prediction interval for new data points

plot(residuals(mod2)~fitted(mod2))        # manual diagnostic plot
par(mfrow=c(2,3))
plot(mod2, 1:6, ask=F)                    # automatic diagnostic plot




cor(bigbang$velocity,bigbang$distance)

