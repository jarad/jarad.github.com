setwd("U:\\401A\\sleuth3csv") # or wherever your data are

#######################################################
# Chapter 3                                         
#######################################################

case0301 = read.csv('case0301.csv')
names(case0301) = tolower(names(case0301))
case0301$lrainfall = log(case0301$rainfall)

# Display 3.1 
by(case0301$rainfall, case0301$treatment, function(x) x) 

# Display 3.2
boxplot( rainfall ~ treatment, case0301)
boxplot( rainfall ~ treatment, case0301, log='y')
boxplot(lrainfall ~ treatment, case0301) # notice the y-axis


# Results on the bottom of page 59 
t = t.test(lrainfall ~ treatment, case0301, var.equal=TRUE)
t = t.test(log(rainfall) ~ treatment, case0301, var.equal=TRUE) # This is equivalent
t
exp(t$conf.int)


# Histograms with overlayed density plots by hand
# install.packages("ggplot2") # Run this once if you don't have the ggplot2 package installed on your computer
library(ggplot2) # Load the library for this session of R
ggplot(case0301, aes(x=lrainfall)) + 
  geom_histogram(aes(y=..density..), binwidth=0.5, alpha=0.4) + 
  geom_density(col="red") + facet_wrap(~treatment) 
# Overlaying the best fitting normal curve is harder
# see http://stackoverflow.com/questions/1376967/using-stat-function-and-facet-wrap-together-in-ggplot2-in-r




case0302 = read.csv('case0302.csv')
names(case0302) = tolower(names(case0302))

# Display 3.3
boxplot(dioxin~veteran,case0302)

# Results on the top of page 62
(t = t.test(dioxin~veteran, case0302, var.equal=TRUE))
# Pvalue can be obtained by dividing the two-sided pvalue by 2
# the confidence interval in the book is the negative of the one 
# seen here. 
