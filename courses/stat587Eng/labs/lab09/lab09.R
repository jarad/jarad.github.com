## ----install_packages, eval=FALSE----------------------------------------
## install.packages("GGally")

## ----load_packages-------------------------------------------------------
library("tidyverse")
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
# Modified from http://rcompanion.org/rcompanion/e_05.html
Input = ("
stream                   count acreage  dO2   maxdepth  no3   so4     temp
BASIN_RUN                  13         2528    9.6  80        2.28  16.75   15.3
BEAR_BR                    12         3333    8.5  83        5.34   7.74   19.4
BEAR_CR                    54        19611    8.3  96        0.99  10.92   19.5
BEAVER_DAM_CR              19         3570    9.2  56        5.44  16.53   17
BEAVER_RUN                 37         1722    8.1  43        5.66   5.91   19.3
BENNETT_CR                  2          583    9.2  51        2.26   8.81   12.9
BIG_BR                     72         4790    9.4  91        4.1    5.65   16.7
BIG_ELK_CR                164        35971   10.2  81        3.2   17.53   13.8
BIG_PIPE_CR                18        25440    7.5  120       3.53   8.2    13.7
BLUE_LICK_RUN               1         2217    8.5  46        1.2   10.85   14.3
BROAD_RUN                  53         1971   11.9  56        3.25  11.12   22.2
BUFFALO_RUN                16        12620    8.3  37        0.61  18.87   16.8
BUSH_CR                    32        19046    8.3  120       2.93  11.31   18
CABIN_JOHN_CR              21         8612    8.2  103       1.57  16.09   15
CARROLL_BR                 23         3896   10.4  105       2.77  12.79   18.4
COLLIER_RUN                18         6298    8.6  42        0.26  17.63   18.2
CONOWINGO_CR              112        27350    8.5  65        6.95  14.94   24.1
DEAD_RUN                   25         4145    8.7  51        0.34  44.93   23
DEEP_RUN                    5         1175    7.7  57        1.3   21.68   21.8
DEER_CR                    26         8297    9.9  60        5.26  6.36    19.1
DORSEY_RUN                  8         7814    6.8  160       0.44  20.24   22.6
FALLS_RUN                  15         1745    9.4  48        2.19  10.27   14.3
FISHING_CR                 11         5046    7.6  109       0.73   7.1    19
FLINTSTONE_CR              11        18943    9.2  50        0.25  14.21   18.5
GREAT_SENECA_CR            87         8624    8.6  78        3.37   7.51   21.3
GREENE_BR                  33         2225    9.1  41        2.3    9.72   20.5
GUNPOWDER_FALLS            22        12659    9.7  65        3.3    5.98   18
HAINES_BR                  98         1967    8.6  50        7.71  26.44   16.8
HAWLINGS_R                  1         1172    8.3  73        2.62   4.64   20.5
HAY_MEADOW_BR               5          639    9.5  26        3.53   4.46   20.1
HERRINGTON_RUN              1         7056    6.4  60        0.25   9.82   24.5
HOLLANDS_BR                38         1934   10.5  85        2.34  11.44   12
ISRAEL_CR                  30         6260    9.5  133       2.41  13.77   21
LIBERTY_RES                12          424    8.3  62        3.49   5.82   20.2
LITTLE_ANTIETAM_CR         24         3488    9.3  44        2.11  13.37   24
LITTLE_BEAR_CR              6         3330    9.1  67        0.81   8.16   14.9
LITTLE_CONOCOCHEAGUE_CR    15         2227    6.8  54        0.33   7.6    24
LITTLE_DEER_CR             38         8115    9.6  110       3.4    9.22   20.5
LITTLE_FALLS               84         1600   10.2  56        3.54   5.69   19.5
LITTLE_GUNPOWDER_R          3        15305    9.7  85        2.6    6.96   17.5
LITTLE_HUNTING_CR          18         7121    9.5  58        0.51   7.41   16
LITTLE_PAINT_BR            63         5794    9.4  34        1.19  12.27   17.5
MAINSTEM_PATUXENT_R       239         8636    8.4  150       3.31   5.95   18.1
MEADOW_BR                 234         4803    8.5  93        5.01  10.98   24.3
MILL_CR                     6         1097    8.3  53        1.71  15.77   13.1
MORGAN_RUN                 76         9765    9.3  130       4.38   5.74   16.9
MUDDY_BR                   25         4266    8.9  68        2.05  12.77   17
MUDLICK_RUN                 8         1507    7.4  51        0.84  16.3    21
NORTH_BR                   23         3836    8.3  121       1.32   7.36   18.5
NORTH_BR_CASSELMAN_R       16        17419    7.4  48        0.29   2.5    18
NORTHWEST_BR                6         8735    8.2  63        1.56  13.22   20.8
NORTHWEST_BR_ANACOSTIA_R  100        22550    8.4  107       1.41  14.45   23
OWENS_CR                   80         9961    8.6  79        1.02   9.07   21.8
PATAPSCO_R                 28         4706    8.9  61        4.06   9.9    19.7
PINEY_BR                   48         4011    8.3  52        4.7    5.38   18.9
PINEY_CR                   18         6949    9.3  100       4.57  17.84   18.6
PINEY_RUN                  36        11405    9.2  70        2.17  10.17   23.6
PRETTYBOY_BR               19          904    9.8  39        6.81   9.2    19.2
RED_RUN                    32         3332    8.4  73        2.09   5.5    17.7
ROCK_CR                     3          575    6.8  33        2.47   7.61   18
SAVAGE_R                  106        29708    7.7  73        0.63  12.28   21.4
SECOND_MINE_BR             62         2511   10.2  60        4.17  10.75   17.7
SENECA_CR                  23        18422    9.9  45        1.58   8.37   20.1
SOUTH_BR_CASSELMAN_R        2         6311    7.6  46        0.64  21.16   18.5
SOUTH_BR_PATAPSCO          26         1450    7.9  60        2.96   8.84   18.6
SOUTH_FORK_LINGANORE_CR    20         4106   10.0  96        2.62   5.45   15.4
TUSCARORA_CR               38        10274    9.3  90        5.45  24.76   15
WATTS_BR                   19          510    6.7  82        5.25  14.19   26.5
")

longnosedace = read.table(textConnection(Input),header=TRUE)

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

## ------------------------------------------------------------------------
m4 <- lm(sqrt(count) ~ (no3 + maxdepth + acreage)^2, data = longnosedace) # main effects and two-way interactions
summary(m4)

m5 <- lm(sqrt(count) ~ (no3 + maxdepth + acreage)^3, data = longnosedace) # main effects, two-way interactions, and three-way interaction
summary(m5)

m5 <- lm(sqrt(count) ~ no3 * maxdepth * acreage, data = longnosedace) # main effects, two-way interactions, and three-way interaction
summary(m5)

## ---- eval=FALSE---------------------------------------------------------
## ?formula

## ---- eval=FALSE---------------------------------------------------------
## help(package="Sleuth3")

