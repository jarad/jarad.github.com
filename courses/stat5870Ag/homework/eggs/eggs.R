d = read.table("eggs.txt", header=TRUE, check.names=FALSE)

library(plyr)
library(reshape2)

m = melt(d)
sm = ddply(melt(d), .(variable), summarize,
      n = length(value),
      mean = mean(value),
      sd = sd(value))
cor(d)

sm
