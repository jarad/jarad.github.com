# Author: Jarad Niemi
# Date:   2024-11-22
# Purpose: Using character and factors in regression models in R
#-------------------------------------------------------------------------------


## install.packages("Sleuth3")

library("tidyverse")
library("Sleuth3")

set.seed(20210413) # for reproducibility

is.character("a")
is.character(1)
is.character(pi)
is.character("a123")

unique(c("a","a","A","A"))

sort(c(letters,LETTERS))

write.csv(Sleuth3::case0501, file = "case0501.csv",
          row.names = FALSE)

d = read.csv("case0501.csv")
str(d)

sort(unique(d$Diet))

summary(d$Diet) # really uninformative
table(d$Diet)   # number of observations of each type



d = read.csv(file = "case0501.csv") # Making sure we are all on the same page

d$Diet = factor(d$Diet)
is.character(d$Diet)
is.factor(d$Diet)

d$Diet

as.numeric(d$Diet)

nlevels(d$Diet)
levels(d$Diet)

summary(case0501$Diet)
table(  case0501$Diet)

d$Diet_char <- as.character(d$Diet)
str(d)

d$Diet_fact <- factor(d$Diet_char)
str(d)
all.equal(d$Diet, d$Diet_fact)

d$Diet_fact <- factor(d$Diet_char, 
                      levels = c("N/N85", "lopro", "N/R40", 
                                 "N/R50", "NP",    "R/R50"))
str(d)
all.equal(d$Diet, d$Diet_fact) # no longer equal

d$Diet_fact = relevel(d$Diet_fact, ref = "NP")
levels(d$Diet_fact)



d <- Sleuth3::case0501 %>%
  mutate(Diet_char = as.character(Diet),
         Diet_fact = as.factor(Diet_char))

d = d %>%
  mutate(X1 = Diet == "N/R40",
         X2 = Diet == "N/R50",
         X3 = Diet == "NP",
         X4 = Diet == "R/R50",
         X5 = Diet == "lopro")

m = lm(Lifetime ~ X1 + X2 + X3 + X4 + X5, data = d)
summary(m)

m <- lm(Lifetime ~ Diet_char, data = d)
summary(m)

m <- lm(Lifetime ~ Diet_fact, data = d)
summary(m)

d$Diet_fact <- relevel(d$Diet_fact, ref = "N/N85")
table(d$Diet_fact)

m <- lm(Lifetime ~ Diet_fact, data = d)
summary(m)

m <- lm(Lifetime ~ Diet, data = Sleuth3::case0501)
summary(m)













if (file.exists("case0501.csv")) file.remove("case0501.csv")
if (file.exists("ex0518.csv"))   file.remove("ex0518.csv")
