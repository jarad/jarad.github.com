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
  mutate(inflation = c(NA,diff(cpi))/cpi) %>%
  filter(!is.na(unemployment)) %>%
  select(Year, month, inflation, unemployment)

write_csv(d, path="inflation_vs_unemployment.csv")

ggplot(d, aes(unemployment, inflation)) + 
  geom_point() + 
  stat_smooth(method="lm")

m <- lm(inflation ~ unemployment, d)
summary(m)




# Kaggle data
insurance <- read_csv("insurance.csv")


ggplot(insurance, aes(bmi, charges, color=smoker, shape=sex)) + 
  geom_point() + 
  stat_smooth(method="lm")



# Analytics Vidhya
# https://datahack.analyticsvidhya.com/contest/practice-problem-big-mart-sales-iii/

sales <- read_csv("sales.csv") %>%
  filter(Item_Visibility > 0,
         Item_Visibility < 0.15,
         Item_Type == "Frozen Foods")

write_csv(sales, path="frozen_foods.csv")

ggplot(sales, aes(Item_Visibility, Item_Outlet_Sales)) +
  geom_point() + 
  stat_smooth(method="lm")

ggplot(sales, aes(Item_Visibility, Item_Outlet_Sales)) + 
  geom_point() + 
  stat_smooth(method="lm")


summary(lm(Item_Outlet_Sales ~ Item_Visibility, data = sales))
