## -----------------------------------------------------------------------------------
library("tidyverse")


## -----------------------------------------------------------------------------------
getwd()


## ---- eval=FALSE--------------------------------------------------------------------
## ?setwd


## -----------------------------------------------------------------------------------
readr::write_csv(ToothGrowth, file = "ToothGrowth.csv")


## -----------------------------------------------------------------------------------
d <- readr::read_csv("ToothGrowth.csv")


## -----------------------------------------------------------------------------------
all.equal(ToothGrowth, d)


## -----------------------------------------------------------------------------------
str(ToothGrowth)
str(d)


## -----------------------------------------------------------------------------------
d <- readr::read_csv("ToothGrowth.csv",
                     col_types = cols(
                       len = col_double(),
                       supp = col_factor(),
                       dose = col_double()
                     ))


## ---- eval=FALSE--------------------------------------------------------------------
## install.packages("readxl")
## ?readxl::read_excel


## -----------------------------------------------------------------------------------
dA <- ToothGrowth %>% filter(supp == "VC")
dB <- ToothGrowth %>% filter(supp == "OJ")
bind_rows(dA, dB)


## -----------------------------------------------------------------------------------
d <- list(
  A = ToothGrowth %>% filter(supp == "VC", dose == 0.5),
  B = ToothGrowth %>% filter(supp == "VC", dose == 1),
  C = ToothGrowth %>% filter(supp == "VC", dose == 2),
  D = ToothGrowth %>% filter(supp == "OJ", dose == 0.5),
  E = ToothGrowth %>% filter(supp == "OJ", dose == 1),
  F = ToothGrowth %>% filter(supp == "OJ", dose == 2)
)


## -----------------------------------------------------------------------------------
class(d)
d[[1]]
d$B


## -----------------------------------------------------------------------------------
bind_rows(d)


## -----------------------------------------------------------------------------------
suppTranslation <- tibble(
  supp = c("VC","OJ"),
  `Delivery Method` = c("Ascorbic Acid","Orange Juice")
)


## -----------------------------------------------------------------------------------
left_join(ToothGrowth, suppTranslation, by = "supp")


## -----------------------------------------------------------------------------------
right_join(suppTranslation, ToothGrowth, by = "supp")


## -----------------------------------------------------------------------------------
len10 <- filter(ToothGrowth, len < 10)

anti_join(ToothGrowth, len10, by = c("len", "supp", "dose"))


## -----------------------------------------------------------------------------------
AirPassengers


## -----------------------------------------------------------------------------------
months <- c("Jan","Feb","Mar","Apr","May","Jun",
             "July","Aug","Sep","Oct","Nov","Dec")

d <- AirPassengers %>% 
  matrix(ncol=12) %>%
  as.data.frame() %>%
  setNames(months) %>%
  mutate(year = 1949:1960) %>%
  relocate(year)


## -----------------------------------------------------------------------------------
dl <- d %>%
  pivot_longer(Jan:Dec, names_to = "month", values_to = "passengers") %>%
  mutate(month = factor(month, levels = months)) # to order the months


## -----------------------------------------------------------------------------------
table(dl$month)


## -----------------------------------------------------------------------------------
dl %>%
  group_by(month) %>%
  summarize(
    n = n(),
    mean = mean(passengers),
    sd = sd(passengers)
  ) 


## -----------------------------------------------------------------------------------
ggplot(dl, aes(x = month, y = passengers, 
               group = year, color = year)) +
  geom_line() + 
  scale_y_log10() +
  theme_bw()


## -----------------------------------------------------------------------------------
m <- lm(log(passengers) ~ year + month, data = dl)
summary(m)


## -----------------------------------------------------------------------------------
dl %>% pivot_wider(id_cols = year, 
                   names_from = "month", 
                   values_from = "passengers")


## -----------------------------------------------------------------------------------
a <- 1
save(a, file = "a.RData")


## -----------------------------------------------------------------------------------
saveRDS(a, file = "a.RDS")
rm(a)


## -----------------------------------------------------------------------------------
b <- readRDS("a.RDS")


## -----------------------------------------------------------------------------------
unlink("ToothGrowth.csv")
unlink("a.RData")
unlink("a.RDS")

