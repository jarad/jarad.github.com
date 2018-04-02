## ----install_packages, eval=FALSE----------------------------------------
## install.packages(c("GGally","tidyr"))

## ----load_packages-------------------------------------------------------
library("dplyr")
library("tidyr")
library("ggplot2")
library("GGally")
library("Sleuth3")

## ------------------------------------------------------------------------
ggplot(case1001, aes(Height, Distance)) +
  geom_point() + theme_bw()

## ------------------------------------------------------------------------
# First create the variables yourself
case1001_tmp <- case1001 %>%
  mutate(Height2 = Height * Height,
         Height3 = Height * Height2)

# Then run the regression
m1 <- lm(Distance ~ Height + Height2 + Height3, data = case1001_tmp)

## ------------------------------------------------------------------------
new <- data.frame(Height = 500) %>%
  mutate(Height2 = Height * Height,  # Need to manually create the
         Height3 = Height * Height2) # quadratic and cubic terms
predict(m1, new)

## ------------------------------------------------------------------------
m2 <- lm(Distance ~ Height + I(Height^2) + I(Height^3), data = case1001) # or
m3 <- lm(Distance ~ poly(Height, 3, raw = TRUE),        data = case1001)

## ------------------------------------------------------------------------
new <- data.frame(Height = 500)
predict(m2, new) # or
predict(m3, new)

## ------------------------------------------------------------------------
# From http://www.biostathandbook.com/multipleregression.html
longnosedace <- structure(list(stream = structure(1:67, .Label = c("BASIN_RUN", 
"BEAR_BR", "BEAR_CR", "BEAVER_DAM_CR", "BEAVER_RUN", "BENNETT_CR", 
"BIG_BR", "BIG_ELK_CR", "BIG_PIPE_CR", "BLUE_LICK_RUN", "BROAD_RUN", 
"BUFFALO_RUN", "BUSH_CR", "CABIN_JOHN_CR", "CARROLL_BR", "COLLIER_RUN", 
"CONOWINGO_CR", "DEAD_RUN", "DEEP_RUN", "DEER_CR", "DORSEY_RUN", 
"FALLS_RUN", "FISHING_CR", "FLINTSTONE_CR", "GREAT_SENECA_CR", 
"GREENE_BR", "GUNPOWDER_FALLS", "HAINES_BR", "HAWLINGS_R", "HAY_MEADOW_BR", 
"HERRINGTON_RUN", "HOLLANDS_BR", "ISRAEL_CR", "LIBERTY_RES", 
"LITTLE_ANTIETAM_CR", "LITTLE_BEAR_CR", "LITTLE_CONOCOCHEAGUE_CR", 
"LITTLE_DEER_CR", "LITTLE_FALLS", "LITTLE_GUNPOWDER_R", "LITTLE_HUNTING_CR", 
"LITTLE_PAINT_BR", "MAINSTEM_PATUXENT_R", "MEADOW_BR", "MILL_CR", 
"MORGAN_RUN", "MUDDY_BR", "MUDLICK_RUN", "NORTH_BR", "NORTH_BR_CASSELMAN_R", 
"NORTHWEST_BR", "NORTHWEST_BR_ANACOSTIA_R", "OWENS_CR", "PATAPSCO_R", 
"PINEY_BR", "PINEY_CR", "PINEY_RUN", "PRETTYBOY_BR", "RED_RUN", 
"ROCK_CR", "SAVAGE_R", "SECOND_MINE_BR", "SENECA_CR", "SOUTH_BR_CASSELMAN_R", 
"SOUTH_BR_PATAPSCO", "SOUTH_FORK_LINGANORE_CR", "TUSCARORA_CR"
), class = "factor"), count = c(13L, 12L, 54L, 19L, 37L, 2L, 
72L, 164L, 18L, 1L, 53L, 16L, 32L, 21L, 23L, 18L, 112L, 25L, 
5L, 26L, 8L, 15L, 11L, 11L, 87L, 33L, 22L, 98L, 1L, 5L, 1L, 38L, 
30L, 12L, 24L, 6L, 15L, 38L, 84L, 3L, 18L, 63L, 239L, 234L, 6L, 
76L, 25L, 8L, 23L, 16L, 6L, 100L, 80L, 28L, 48L, 18L, 36L, 19L, 
32L, 3L, 106L, 62L, 23L, 2L, 26L, 20L, 38L), acreage = c(2528L, 
3333L, 19611L, 3570L, 1722L, 583L, 4790L, 35971L, 25440L, 2217L, 
1971L, 12620L, 19046L, 8612L, 3896L, 6298L, 27350L, 4145L, 1175L, 
8297L, 7814L, 1745L, 5046L, 18943L, 8624L, 2225L, 12659L, 1967L, 
1172L, 639L, 7056L, 1934L, 6260L, 424L, 3488L, 3330L, 2227L, 
8115L, 1600L, 15305L, 7121L, 5794L, 8636L, 4803L, 1097L, 9765L, 
4266L, 1507L, 3836L, 17419L, 8735L, 22550L, 9961L, 4706L, 4011L, 
6949L, 11405L, 904L, 3332L, 575L, 29708L, 2511L, 18422L, 6311L, 
1450L, 4106L, 10274L), do2 = c(9.6, 8.5, 8.3, 9.2, 8.1, 9.2, 
9.4, 10.2, 7.5, 8.5, 11.9, 8.3, 8.3, 8.2, 10.4, 8.6, 8.5, 8.7, 
7.7, 9.9, 6.8, 9.4, 7.6, 9.2, 8.6, 9.1, 9.7, 8.6, 8.3, 9.5, 6.4, 
10.5, 9.5, 8.3, 9.3, 9.1, 6.8, 9.6, 10.2, 9.7, 9.5, 9.4, 8.4, 
8.5, 8.3, 9.3, 8.9, 7.4, 8.3, 7.4, 8.2, 8.4, 8.6, 8.9, 8.3, 9.3, 
9.2, 9.8, 8.4, 6.8, 7.7, 10.2, 9.9, 7.6, 7.9, 10, 9.3), maxdepth = c(80L, 
83L, 96L, 56L, 43L, 51L, 91L, 81L, 120L, 46L, 56L, 37L, 120L, 
103L, 105L, 42L, 65L, 51L, 57L, 60L, 160L, 48L, 109L, 50L, 78L, 
41L, 65L, 50L, 73L, 26L, 60L, 85L, 133L, 62L, 44L, 67L, 54L, 
110L, 56L, 85L, 58L, 34L, 150L, 93L, 53L, 130L, 68L, 51L, 121L, 
48L, 63L, 107L, 79L, 61L, 52L, 100L, 70L, 39L, 73L, 33L, 73L, 
60L, 45L, 46L, 60L, 96L, 90L), no3 = c(2.28, 5.34, 0.99, 5.44, 
5.66, 2.26, 4.1, 3.2, 3.53, 1.2, 3.25, 0.61, 2.93, 1.57, 2.77, 
0.26, 6.95, 0.34, 1.3, 5.26, 0.44, 2.19, 0.73, 0.25, 3.37, 2.3, 
3.3, 7.71, 2.62, 3.53, 0.25, 2.34, 2.41, 3.49, 2.11, 0.81, 0.33, 
3.4, 3.54, 2.6, 0.51, 1.19, 3.31, 5.01, 1.71, 4.38, 2.05, 0.84, 
1.32, 0.29, 1.56, 1.41, 1.02, 4.06, 4.7, 4.57, 2.17, 6.81, 2.09, 
2.47, 0.63, 4.17, 1.58, 0.64, 2.96, 2.62, 5.45), so4 = c(16.75, 
7.74, 10.92, 16.53, 5.91, 8.81, 5.65, 17.53, 8.2, 10.85, 11.12, 
18.87, 11.31, 16.09, 12.79, 17.63, 14.94, 44.93, 21.68, 6.36, 
20.24, 10.27, 7.1, 14.21, 7.51, 9.72, 5.98, 26.44, 4.64, 4.46, 
9.82, 11.44, 13.77, 5.82, 13.37, 8.16, 7.6, 9.22, 5.69, 6.96, 
7.41, 12.27, 5.95, 10.98, 15.77, 5.74, 12.77, 16.3, 7.36, 2.5, 
13.22, 14.45, 9.07, 9.9, 5.38, 17.84, 10.17, 9.2, 5.5, 7.61, 
12.28, 10.75, 8.37, 21.16, 8.84, 5.45, 24.76), temp = c(15.3, 
19.4, 19.5, 17, 19.3, 12.9, 16.7, 13.8, 13.7, 14.3, 22.2, 16.8, 
18, 15, 18.4, 18.2, 24.1, 23, 21.8, 19.1, 22.6, 14.3, 19, 18.5, 
21.3, 20.5, 18, 16.8, 20.5, 20.1, 24.5, 12, 21, 20.2, 24, 14.9, 
24, 20.5, 19.5, 17.5, 16, 17.5, 18.1, 24.3, 13.1, 16.9, 17, 21, 
18.5, 18, 20.8, 23, 21.8, 19.7, 18.9, 18.6, 23.6, 19.2, 17.7, 
18, 21.4, 17.7, 20.1, 18.5, 18.6, 15.4, 15)), .Names = c("stream", 
"count", "acreage", "do2", "maxdepth", "no3", "so4", "temp"), class = "data.frame", row.names = c(NA, 
-67L))

## ------------------------------------------------------------------------
head(longnosedace)
summary(longnosedace)

ggpairs(longnosedace %>% select(-stream)) +
  theme_bw()

## ------------------------------------------------------------------------
m <- lm(sqrt(count) ~ no3 + maxdepth, data = longnosedace)
summary(m)

## ------------------------------------------------------------------------
m1 <- lm(sqrt(count) ~ no3 + maxdepth + no3:maxdepth, data = longnosedace)
summary(m1)

## ------------------------------------------------------------------------
m2 <- lm(sqrt(count) ~ no3*maxdepth, data = longnosedace)
summary(m2)

## ------------------------------------------------------------------------
m3 <- lm(sqrt(count) ~ (no3 + maxdepth)^2, data = longnosedace)
summary(m3)

## ---- eval=FALSE---------------------------------------------------------
## ?formula

## ---- eval=FALSE---------------------------------------------------------
## help(package="Sleuth3")

