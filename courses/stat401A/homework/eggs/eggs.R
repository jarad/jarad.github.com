d = read.table("eggs.txt", header=TRUE, check.names=FALSE)

library(plyr)
library(reshape2)
library(xtable)

m = melt(d)
sm = ddply(melt(d), .(variable), summarize,
      n = length(value),
      mean = mean(value),
      sd = sd(value))
cor(d)

tab = xtable(sm)
print(tab, file="table.html", type="html", include.rownames=FALSE)
