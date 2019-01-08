setwd("U:\\401A\\sleuth3csv") # or wherever your data are

library(plyr)

# Construct variables by hand
case1002 = read.csv("case1002.csv")

# Here we use the mutate function in the plyr package to add new columns
# to the data set
case1002 = mutate(case1002,
                  lMass = log(Mass),
                  
                  ## Higher order terms
                  lMass2 = lMass^2,
                  
                  ## Numeric coding of categorical variable
                  typeNumeric = as.numeric(Type),
                  
                  ## Dummy/indicator variables
                  eBats   = ifelse(Type == "echolocating bats",      1, 0),
                  neBats  = ifelse(Type == "non-echolocating bats",  1, 0),
                  neBirds = ifelse(Type == "non-echolocating birds", 1, 0),
                  
                  ## Interactions
                    eBatsXlMass =   eBats*lMass,
                   neBatsXlMass =  neBats*lMass,
                  neBirdsXlMass = neBirds*lMass
                  )

# Verify columns
case1002
summary(case1002)


## Higher order terms (these are equivalent)
lm( log(Energy) ~ lMass + lMass2,               case1002)
lm( log(Energy) ~ lMass + I(lMass^2),           case1002)
lm( log(Energy) ~ log(Mass) + I(log(Mass)^2),   case1002)
lm( log(Energy) ~ poly(log(Mass), 2, raw=TRUE), case1002)


## Categorical variables (these are equivalent)
lm( log(Energy) ~ neBats + neBirds,       case1002)
lm( log(Energy) ~ Type,                   case1002)
lm( log(Energy) ~ as.factor(typeNumeric), case1002)

### These are not equivalent
lm( log(Energy) ~ Type,        case1002)
lm( log(Energy) ~ typeNumeric, case1002) # treats typeNumeric as a continuous explanatory variable

### Change reference level (these are equivalent)
case1002$Type = relevel(case1002$Type, ref="non-echolocating birds")
lm( log(Energy) ~ eBats + neBats, case1002)
lm( log(Energy) ~ Type,           case1002)


## Additional explanatory variables (these are equivalent)
lm( log(Energy) ~ log(Mass) + eBats + neBats, case1002)
lm( log(Energy) ~ log(Mass) + Type,           case1002)


## Interactions (these are equivalent)
lm( log(Energy) ~ log(Mass) + eBats + neBats + eBatsXlMass + neBatsXlMass, case1002)
lm( log(Energy) ~ log(Mass) + Type + log(Mass):Type,                       case1002)
lm( log(Energy) ~ log(Mass)*Type,                                        case1002)

### but this only includes the interaction and not the main effects
lm( log(Energy) ~ log(Mass):Type, case1002)



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
