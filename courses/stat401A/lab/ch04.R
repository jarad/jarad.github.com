setwd("U:\401A\sleuth3csv") # or whever your data are


#######################################################
# Chapter 4                                         
#######################################################

# case0401
case0401 = read.csv('case0401.csv')
names(case0401) = tolower(names(case0401))

# Display 4.1
by(case0401$incidents, case0401$launch, print)

# Statistical Conclusion on page 86
if ( !("perm" %in% installed.packages()) ) install.packages("perm")
library(perm)
permTS(incidents~launch, case0401, exact=TRUE, alternative="greater")


# case0402
case0402 = read.csv('case0402.csv')
names(case0402) = tolower(names(case0402))

# Statistical Conclusions on page 88
wilcox.test(time~treatment, case0402, alternative="greater", conf.int=TRUE)
wilcox.test(time~treatment, case0402, conf.int=TRUE)



# results on page 101 
case0202 = read.csv(''U:401A/sleuth3csv/case0202.csv')
names(case0202) = tolower(names(case0202))
wilcox.test(case0202$diff, alternative="greater")

