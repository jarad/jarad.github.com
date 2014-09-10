# To subset your data, you can use the subset command 
# to create a new data set or the subset argument within
# some functions to do an analysis on that subset.
# The case0402 data set is used as an example.

d = read.csv("case0402.csv")
names(d) = tolower(names(d))

# Create a data set with only the uncensored observations
uncensored = subset(d, censored==0)

# Only censored=0 observations are in this dataset
uncensored

# Create a data set with only the Conventional treatment
conventional = subset(d, treatment=="Conventional")

# Only conventional treatment observations are in this dataset
conventional

###############
# T-test
###############

# Use the uncensored data set
t.test(time~treatment, uncensored)

# Alternatively use the subset argument and you get the same results
t.test(time~treatment, uncensored, subset=censored==0)

# This is NOT an appropriate analysis. It is used for 
# demonstration only. 