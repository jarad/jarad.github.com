library("tidyverse")
library("zoo")

# Data obtained from https://www.bls.gov/cpi/
cpi <- read_csv("cpi.csv", skip = 11) %>%
  gather(month, cpi, -Year) 
  
# Data obtained from https://www.bls.gov/
unemployment <- read_csv("unemployment.csv", skip = 11) %>%
  gather(month, unemployment, -Year)

# Combine
d <- left_join(cpi, unemployment, by=c("Year","month")) %>%
  mutate(
    ym = paste0(month,Year),
    date = as.yearmon(ym)) %>% 
  arrange(date) %>%
  mutate(inflation = c(NA,diff(cpi))/cpi)

ggplot(d, aes(unemployment, inflation)) + 
  geom_point() + 
  stat_smooth(method="lm")

m <- lm(inflation ~ unemployment, d)
summary(m)




# Kaggle data
insurance <- read_csv("insurance.csv")


ggplot(insurance, aes(age, charges, color=smoker, shape=sex)) + 
  geom_point() + 
  stat_smooth(method="lm")

