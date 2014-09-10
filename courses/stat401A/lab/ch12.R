#####################################################################
# Chapter 12                                                        #
#####################################################################

############################ Case 12.01 #############################
case1201 = read.csv("case1201.csv")
names(case1201) = tolower(names(case1201))
case1201 = case1201[case1201$state!="Alaska",] # Delete Alaska
pairs(case1201)


# Manual variable selection using F-test
add1(lm(sat~1, case1201), scope=~takers+income+years+public+expend+rank, test="F")
add1(lm(sat~rank, case1201), scope=~takers+income+years+public+expend+rank, test="F")
add1(lm(sat~rank+expend, case1201), scope=~takers+income+years+public+expend+rank, test="F")
add1(lm(sat~rank+expend+years, case1201), scope=~takers+income+years+public+expend+rank, test="F")
add1(lm(sat~rank+expend+years+income, case1201), scope=~takers+income+years+public+expend+rank, test="F")

# Automatic variable selection using AIC and BIC
mod = lm(sat~., case1201[,-1])
mod.aic = step(mod)
mod.bic = step(mod, k=log(nrow(case1201)))



