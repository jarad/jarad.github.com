case0201 = read.csv('case0201.csv')
names(case0201) = tolower(names(case0201))

# Something like Display 2.1, see the boxplots 
by(case0201$depth, case0201$year, stem)

# but this is better 
plot(depth~year, case0201) 
boxplot(depth~year, case0201)

# Statistical Conclusion on page 30
t.test(depth~year, case0201, var.equal=TRUE)


case0202 = read.csv('case0202.csv')
names(case0202) = tolower(names(case0202)) 
case0202$diff = case0202$unaffected-case0202$affected

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
