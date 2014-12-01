
## ----options, echo=FALSE-------------------------------------------------
opts_chunk$set(comment=NA, fig.width=6, fig.height=6, size='tiny', out.width='0.6\\textwidth')


## ----experiments, echo=FALSE, warning=FALSE, out.width='0.6\\textwidth', fig.align='center'----
library(plotrix)

set.seed(1)
n = 20
x = runif(n,0,1)
y = runif(n,0,1)

ox = c(0,0,1,1)
oy = c(0,1,0,1)

par(mar=rep(0,4))
plot(0,0,type="n",axes=F,xlim=c(0,2), ylim=c(0,2), xlab="", ylab="")

points(x+rep(ox,each=n),y+rep(oy,each=n), pch=19)

xr = .08
yr = .08
of = .8
rect(xr+ox,yr+oy,xr+ox+of,yr+oy+of)

points(x,y+1, pch=19, col=c(rep(2,5), rep(4,5)))
text(0.5,yr+of+1.05,"Observational Study",pos=3)
text(0.04,1.8,"Non-random selection",pos=2,srt=90)
draw.ellipse(.60,1.7,a=.05,b=.25,angle=-55)


points(x,y, pch=19, col=c(rep(2,5), rep(4,5)))
text(0.04,0.7,"Random selection",pos=2,srt=90)
id = c(2,3,8,9)
points(x[id], y[id], cex=2)


points(x[c(3,15,16,17)]+1,y[c(3,15,16,17)]+1, 
       pch=19,, col=c(2,4))
text(1.5,yr+of+1.05,"Randomized Experiment",pos=3)
draw.ellipse(1.6,1.7,a=.05,b=.25,angle=-55)

wh = which(x>xr & x<xr+of & y>yr & y<yr+of)
id = sample(wh,4)
points(x[id]+1,y[id], pch=19, col=c(2,2,4,4))
points(x[id]+1, y[id], cex=2)



# ## ggplot2 attempt below
# library(ggplot2)
# library(plyr)
# 
# set.seed(1)
# n = 30
# x = runif(n,0,1)
# y = runif(n,0,1)
# trt = c("A","B")
# 
# d = ddply(expand.grid(type = factor(c("Observational Study","Randomized Experiment"),ordered=T),
#                 sam = factor(c("Non-random Sample","Random Sample"),ordered=T)), 
#           .(type,sam), 
#           data.frame,x=x,y=y,Treatment=trt)
# d$Treatment[d$sam=="Random Sample"     & d$type=="Randomized Experiment"][sample(n,20)] = NA
# d$Treatment[d$sam=="Non-random Sample" & d$type=="Randomized Experiment" & (d$x<.5 | d$y<.5)] = NA
# 
# p = ggplot(d, aes(x=x,y=y,color=Treatment))+facet_grid(type~sam)+geom_point()+geom_rect(data=data.frame(variable=1:3), aes(xmin=.5,xmax=1,ymin=.5,ymax=1), fill=NA)
#            
# print(p)


## ----randomization, message=FALSE----------------------------------------
library(combinat)
fertilizer = c("A","A","A","B","B")
yield = c(136,146,140,145,139)
rands = as.data.frame(matrix(unlist(unique(permn(fertilizer))),ncol=5,byrow=TRUE))
names(rands) = yield
rands$meanA = apply(rands, 1, function(x) mean(yield[x=='A']))
rands$meanB = apply(rands, 1, function(x) mean(yield[x=='B']))
rands$diffs = with(rands, meanA-meanB)
rands


## ----randomization_pvalue------------------------------------------------
truediff = mean(yield[fertilizer=="A"])-mean(yield[fertilizer=="B"])
mean(rands$diffs <= -abs(truediff) | rands$diffs >= abs(truediff))


## ----permutation_pvalue--------------------------------------------------
side = c("W","W","W","E","E")
perms = as.data.frame(matrix(unlist(permn(yield)), ncol=5))
names(perms) = side
perms$meanW = rowSums(perms[,1:3])/3
perms$meanE = rowSums(perms[,4:5])/2
perms$diffs = with(perms, meanW-meanE)
head(perms,10)
pvalue = mean(perms$diffs<=-1.33 | perms$diffs>=1.33)
pvalue


## ----permutation_distribution, fig.align='center'------------------------
hist(perms$diffs,20, main="Permutation distribution", xlab="Theoretical differences (W-E)")
abline(v=c(-1.33,1.33), col="red", lwd=2)


