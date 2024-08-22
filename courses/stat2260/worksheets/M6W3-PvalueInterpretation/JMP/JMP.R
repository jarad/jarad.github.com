set.seed(20181030)


readr::write_csv(data.frame(y = rnorm(15, 102, 30)),     path="sim1.csv")
readr::write_csv(data.frame(y = rnorm(76, -33, 4)),      path="sim2.csv")
readr::write_csv(data.frame(y = rnorm(143253, 0.1, 10)), path="sim3.csv")


# Elasticity
readr::write_csv(data.frame(elasticity = rnorm(20, 55, 5)), path="elasticity.csv")