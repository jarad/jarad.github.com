library("tidyverse")
library("ToyotaSiennaGasMileage")

d <- ToyotaSiennaGasMileage %>%
  mutate(mpg = miles/fuel,
         day = as.numeric(date - as.Date("2012-07-27")))

readr::write_csv(d, path="ToyotaSiennaGasMileage.csv")
