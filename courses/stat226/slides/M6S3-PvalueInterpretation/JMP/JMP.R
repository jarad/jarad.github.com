set.seed(20181030)

# Sim 1
readr::write_csv(data.frame(y = rnorm(36)), path="sim1.csv")



# Sim 2 - ACT scores
y <- rnorm(51)
s <- sd(y)
m <- mean(y)

y <- (y-mean(y))/sd(y) * 4.38 + 26
readr::write_csv(data.frame(ACT=y), path="ACT.csv")
