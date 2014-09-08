
# The first thing is to change your working directory
setwd("U:\401A\sleuth2csv")
# if you are using your own computer, select File -> Change dir...
# and select the location where you put all the datasets. 

getwd() # Check your working directory



# For calculating pvalues
(p1 = 1-pnorm(2))         # P(Z > 2)
(p2 = 1-pt(3,5))          # P(t_5 > 3)
(p3 = 1-pt(3,5)+pt(-3,5)) # P(t_5 > |3|)
(p4 = 1-pf(5,25,26))      # P(F_25,26 > 5)

# Critical values for constructing confidence intervals
(q1 = qnorm(.975))        # 0.975 = P(Z<q1)
(q2 = qt(.975,5))         # 0.975 = P(t_5 > q2)




case0201 = read.csv('case0201.csv')
names(case0201) = tolower(names(case0201))

head(case0201,10) # first 10 rows

# Something like Display 2.1, see the boxplots 
by(case0201$depth, case0201$year, stem)

# but this is better 
plot(depth~year, case0201) 
boxplot(depth~year, case0201)

# Statistical Conclusion on page 30
t.test(depth~year, case0201, var.equal=TRUE)




case0202 = read.csv('case0202.csv')
names(case0202) = tolower(names(case0202)) 
case0202$diff = with(case0202, unaffected-affected)

# Display 2.2 
case0202
summary(case0202)

mean(case0202$diff)
sd(case0202$diff)
length(case0202$diff)

# Results above Display 2.2 and on the next page
t.test(case0202$diff) # or the next one
t.test(case0202$unaffected, case0202$affected, paired=TRUE)

# Displays 2.8, 2.9, 2.10 
stats = function(x) return(c(length(x), mean(x), sd(x)))
by(case0201$depth, case0201$year, stats)

# An alternative is to use the plyr package
# this package needs to be installed prior to use
install.packages("plyr") 
# after installing, comment the line above by putting a '#' at the beginning
require(plyr) # this loads the package for the current R session
ddply(case0201, .(year), summarize, n=length(depth), mean=mean(depth), sd=sd(depth))



# Getting help
?t.test              # function name must match exactly
help.search("ttest")



# When you quit R, it will ask you 'Save workspace image?' 
# get into the habit of clicking 'No'