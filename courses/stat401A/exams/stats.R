library(ggplot2)
library(plyr)
library(reshape2)

d = read.csv("exam2.csv")

names(d)[13] = "hw" # homework subtotal
names(d)[14] = "exam1"
names(d)[15] = "exam2"
names(d)[17] = "exams"
names(d)[18] = "final"

sm = 
ddply(melt(d[,c("exam1","exam2")]),
      .(variable), 
      summarize,
      mean = mean(value, na.rm=TRUE),
      sd   = sd(value, na.rm=TRUE))
sm

# remove student who hasn't taken the exam
d = d[-which(d$exam2==0 | is.na(d$exam2)),]

ggplot(d, aes(x=exam2)) + geom_histogram(binwidth=1, origin=14.5)

ggplot(d, aes(x=exam1, y=exam2)) + geom_point() + stat_smooth(method='lm') +
  geom_abline(intercept=diff(sm$mean), slope=1, col='red')

m = lm(exam2~exam1, d)

summary(m)

ggplot(d, aes(x=hw, y=exam2)) + geom_point()


ggplot(subset(d, hw>.85), aes(x=hw, y=exam2)) + geom_point() + stat_smooth(method='lm')



