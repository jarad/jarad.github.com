#################################
# Example
#################################
bigbang = read.csv("case0701.csv",sep="")
names(bigbang) = tolower(names(bigbang)
summary(bigbang)
pairs(bigbang)

plot(distance~velocity, bigbang, main='Compare to Display 7.1')

mod = lm(distance~velocity, bigbang)
mod

summary(mod) # Compare to Display 7.9
bigbang$fit = predict(mod)
bigbang$res = residual(mod)
bigbang # Compare to Display 7.8

plot(mod,1:6)

plot(distance~velocity, bigbang)
abline(mod, col="red")

