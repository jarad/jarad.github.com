library("ggplot2")

set.seed(20181113)

n <- 30
x <- runif(n)
y <- rnorm(n,x,0.1)

d <- data.frame(x=x,y=y)
ggplot(d, aes(x,y)) + 
  geom_point() + 
  theme_bw()

readr::write_csv(d, path="data.csv")
