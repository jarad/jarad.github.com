# Paired t-test
case0202 = read.csv("case0202.csv")
names(case0202) = tolower(names(case0202))

t.test(case0202$unaffected, case0202$affected, paired=TRUE)


# Mixed effect model with results equivalent to paired t-test
case0202alt = read.csv("case0202_alt.csv")
names(case0202alt) = tolower(names(case0202alt))

# install.packages("lme4")
library(lme4)
m = lmer(volume~schizophrenia+(1|twin), case0202alt)
summary(m)


# Extending to more than 2 observations
case1301 = read.csv("case1301.csv")
names(case1301) = tolower(names(case1301))
case1301$lrr = log(case1301$cover/(100-case1301$cover))

# Fixed effect analysis
mf = lm(lrr ~ treat+block, case1301)
summary(mf)

# Mixed effect analysis
mr = lmer(lrr~treat+(1|block), case1301)
summary(mr)

ranef(mr)
