setwd("U:\\401A\\sleuth3csv") # or wherever your data are

library(plyr)

# Construct variables by hand
case1002 = read.csv("case1002.csv")

# Here we use the mutate function in the plyr package to add new columns
# to the data set
case1002 = mutate(case1002,
                  ## Higher order terms
                  Energy2 = Energy^2,
                  
                  ## Numeric coding of categorical variable
                  typeNumeric = as.numeric(Type),
                  
                  ## Dummy/indicator variables
                  eBats   = ifelse(Type == "echolocating bats",      1, 0),
                  neBats  = ifelse(Type == "non-echolocating bats",  1, 0),
                  neBirds = ifelse(Type == "non-echolocating birds", 1, 0),
                  
                  ## Interactions
                    eBatsXenergy =   eBats*Energy,
                   neBatsXenergy =  neBats*Energy,
                  neBirdsXenergy = neBirds*Energy
                  )

# Verify columns
case1002
summary(case1002)


## Higher order terms (these are equivalent)
lm(log(Mass) ~ Energy + Energy2,               case1002)
lm(log(Mass) ~ Energy + I(Energy^2),           case1002)
lm(log(Mass) ~ poly(Energy,2, raw=TRUE),       case1002)


## Categorical variables (these are equivalent)
lm( log(Mass) ~ neBats + neBirds,       case1002)
lm( log(Mass) ~ Type,                   case1002)
lm( log(Mass) ~ as.factor(typeNumeric), case1002)

### These are not equivalent
lm( log(Mass) ~ Type,        case1002)
lm( log(Mass) ~ typeNumeric, case1002) # treats typeNumeric as a continuous explanatory variable

### Change reference level (these are equivalent)
case1002$Type = relevel(case1002$Type, ref="non-echolocating birds")
lm( log(Mass) ~ eBats + neBats, case1002)
lm( log(Mass) ~ Type,           case1002)


## Additional explanatory variables (these are equivalent)
lm( log(Mass) ~ Energy + eBats + neBats, case1002)
lm( log(Mass) ~ Energy + Type,           case1002)


## Interactions (these are equivalent)
lm( log(Mass) ~ Energy + eBats + neBats + eBatsXenergy + neBatsXenergy, case1002)
lm( log(Mass) ~ Energy + Type + Energy:Type,                             case1002)
lm( log(Mass) ~ Energy*Type,                                             case1002)

### but this only includes the interaction and not the main effects
lm( log(Mass) ~ Energy:Type, case1002)



#######################################################
# Chapter 9                                        
#######################################################

case0901 = read.csv("case0901.csv")
names(case0901) = tolower(names(case0901))
names(case0901)[3] = "light"
case0901$early = case0901$time-1 # time=1 is late, time=2 is early 
case0901$lightXearly = case0901$light*case0901$early

plot(flowers~light,case0901, pch=1+18*early)
legend("bottomleft", legend=c("late","early"), pch=c(1,19))

# Compare to Display 9.14
mod = lm(flowers~light+early+lightXearly, case0901)
summary(mod)

mod = lm(flowers~light+early+light:early, case0901)
summary(mod)

# Include main effects plus the interaction
mod = lm(flowers~light*early, case0901) 
summary(mod)



###############################################
case0902 = read.csv("case0902.csv")
names(case0902)  = tolower(names(case0902))
case0902$lbrain  = log(case0902$brain)
case0902$lbody   = log(case0902$body)
case0902$lgest   = log(case0902$gestation)
case0902$llitter = log(case0902$litter)

# Compare to Display 9.15
mod = lm(lbrain~lbody+lgest+llitter, case0902)
summary(mod)

# Alternatively
mod = lm(log(brain) ~ log(body) + log(gestation) + log(litter), case0902)
summary(mod)
