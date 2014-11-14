library(Sleuth3)
library(ggplot2)
library(reshape2) 

#9.13
m = lm(pH~Time, case0702)
ggplot(case0702, aes(x=Time, y=pH)) + 
  geom_point() + 
  stat_smooth(method="lm", formula=y~x)

plot(case0702$Time, residuals(m), pch=19)

m = lm(pH~Time+I(Time^2), case0702)
summary(m)
ggplot(case0702, aes(x=Time, y=pH)) + 
  geom_point() + 
  stat_smooth(method="lm", formula=y~poly(x,2))
plot(case0702$Time, residuals(m), pch=19)

m = lm(pH~log(Time), case0702)
plot(case0702$Time, residuals(m), pch=19)
ggplot(case0702, aes(x=Time, y=pH)) + 
  geom_point() + 
  stat_smooth(method="lm", formula=y~log(x))



m = lm(pH~log(Time)+I(log(Time)^2), case0702)
summary(m)


#9.15
plot(Yield~Rainfall, ex0915)

m = lm(Yield~Rainfall+I(Rainfall^2), ex0915)
summary(m)
plot(ex0915$Year, residuals(m), pch=19)

m = lm(Yield~Rainfall+I(Rainfall^2) + Year, ex0915)
summary(m)

summary(ex0915)
new = expand.grid(Rainfall=c(6.8,7.8,10.5,11.5,15.5,16.5), Year=c(1890,1927))
new$pred = predict(m, new)

plot(pred~Rainfall, new, pch=ifelse(Year==1890,1,2))
legend("bottomright", legend=c(1890,1927), pch=1:2)

m = lm(Yield~Rainfall+I(Rainfall^2) + Rainfall*Year, ex0915)
summary(m)
#9.18
cols = c("Continent","Latitude","Females","Males")
ex0918long = melt(ex0918[,cols], id.vars = cols[1:2], variable.name="Sex", value.name="WingSize")
ex0918long$Sex = relevel(ex0918long$Sex, ref='Males')
ex0918long$Continent = relevel(ex0918long$Continent, ref='NA')

ggplot(ex0918long, aes(x=Latitude, y=WingSize, col=Continent, shape=Sex))+geom_point(size=3)

m = lm(WingSize~Latitude*Sex*Continent, ex0918long)
summary(m)

library(plyr)
ddply(ex0918long, .(Sex,Continent), function(x) {
  m = lm(WingSize~Latitude, x)
  data.frame(Intercept = coef(m)[1],
             Slope     = coef(m)[2])
})


#9.23
m = lm(log(Income2005) ~ Gender + AFQT + Educ, ex0923)
summary(m)

ggplot(ex0923, aes(x=AFQT, y=Income2005, shape=Gender, color=Educ))+
  geom_point()+
  scale_y_log10()

new = expand.grid(Gender=c("female","male"), 
                  AFQT=c(0,100), 
                  Educ=c(6,13,20))
new$pred = exp(predict(m, new))

ggplot(ex0923, aes(x=AFQT, y=Income2005, shape=Gender, color=Educ))+
  geom_point(alpha=.5)+
  scale_y_log10()+
  geom_line(data=new[new$Educ== 6,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)+
  geom_line(data=new[new$Educ==13,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)+
  geom_line(data=new[new$Educ==20,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)



# Interactions
m = lm(log(Income2005) ~ Gender + AFQT*Educ, ex0923)
summary(m)

new = expand.grid(Gender=c("female","male"), 
                  AFQT=c(0,100), 
                  Educ=c(6,13,20))
new$pred = exp(predict(m, new))

ggplot(ex0923, aes(x=AFQT, y=Income2005, shape=Gender, color=Educ))+
  geom_point(alpha=.5)+
  scale_y_log10()+
  geom_line(data=new[new$Educ== 6,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)+
  geom_line(data=new[new$Educ==13,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)+
  geom_line(data=new[new$Educ==20,], aes(x=AFQT, y=pred, group=Gender, color=Educ, linetype=Gender), size=1)


m = lm(log(Income2005) ~ Gender + AFQT*Educ + Gender*AFQT, ex0923)
summary(m)

m = lm(log(Income2005) ~ Gender + AFQT*Educ + Gender*Educ, ex0923)
summary(m)

m = lm(log(Income2005) ~ Gender*AFQT*Educ, ex0923)
summary(m)






