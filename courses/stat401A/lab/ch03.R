setwd("U:\401A\sleuth3csv") # or whever your data are

#######################################################
# Chapter 3                                         
#######################################################

case0301 = read.csv('case0301.csv')
names(case0301) = tolower(names(case0301))
case0301$lrainfall = log(case0301$rainfall)

# Display 3.1 
by(case0301$rainfall, case0301$treatment, print)

# Display 3.2
boxplot( rainfall ~ treatment, case0301)
boxplot( rainfall ~ treatment, case0301, log='y')
boxplot(lrainfall ~ treatment, case0301) # notice the y-axis


# Results on the bottom of page 59 
t = t.test(lrainfall ~ treatment, case0301, var.equal=TRUE)
t
exp(t$conf.int)


case0302 = read.csv('case0302.csv')
names(case0302) = tolower(names(case0302))

# Display 3.3
boxplot(dioxin~veteran,case0302)

# Results on the top of page 62
t.test(dioxin~veteran, case0302, var.equal=TRUE, alternative="less")
-t.test(dioxin~veteran, case0302, var.equal=TRUE)$conf.int


