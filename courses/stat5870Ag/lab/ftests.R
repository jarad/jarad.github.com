 
# The main purpose of this lab is 3-fold:
# 1 - Discuss the F-tests that SAS automatically generates
# 2 - Construct contrasts
# 3 - Construct contrasts at a specific level of an explanatory variable

d = read.csv("ex1031.csv")
names(d) = tolower(names(d))
d$x = log(d$bodymass)
d$y = log(d$clutchvolume)
d$group = relevel(d$group, ref="Mani")



#### 10.3 Extra sums of squres F-tests
full = lm(y~group+x,d)
reduced = lm(y~x,d)

anova(full)
anova(reduced)


# Conduct F-tests by hand
#  F-test for above reduced vs full models 
#  Full: SSE=129.37, df=436
#  Red : SSE=156.08, df=441

#  Extra Sum of Squares = ESS = 156.08-129.37 = 26.71
#  Extra deg of freedom = Edf = 441-436 = 5
#  MSE_full = 129.37/436 = 0.2967202
#  F = (ESS/Edf)/MSE_full = 18.00 ~ F_{5,436}

anova(reduced,full)

# anova computes type I sums of squares
# for type III sums of squares use the car package
library(car) # install.packages("car")
Anova(full, type=3)


#### 10.2.3 Contrasts
# What if we wanted to know 
#  1) the difference between Maternal and Paternal,
#  2) the Maternal mean, 
#  3) the Maternal mean at x=1, or
#  4) the difference between Maternal and Paternal at x=1? 


## Parallel lines model
library(lsmeans) # install.packages("lsmeans")
lsmeans(full, specs=pairwise~group, at=list(x=0))
lsmeans(full, specs=pairwise~group, at=list(x=1))

interaction = lm(y~group*x, d)
lsmeans(interaction, specs=pairwise~group, at=list(x=0))
lsmeans(interaction, specs=pairwise~group, at=list(x=1))

# The Warning message produced here is important. 
# We are safe here because we have specified a value for x, but
# the code below does not and is probably not what we wanted.
lsmeans(interaction, specs=pairwise~group)


