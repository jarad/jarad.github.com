## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-----------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("lme4")


## ----set_seed, echo=FALSE-------------------------------------------------------------------------
set.seed(20220215)


## ----fig.height = 3-------------------------------------------------------------------------------
opar = par(mar=c(5,4,0,2)+0.1)
curve(ifelse(x>0,-x^2+1,NA), -1, 1, axes=FALSE, frame.plot=TRUE,
      xlab="", ylab="", ylim=c(0,1.1),
      lty=2)
axis(1, c(0,1), c("0","Distance"))
axis(2, c(0,1), c("0","Height"))
rect(-1,0,0,1, density = 1)
points(0,1.03,pch=19, cex=2)
arrows(-0.3,1.03,-0.1,1.03, length=0.1)
text(-0.45,1.03,"force")
par(opar)


## -------------------------------------------------------------------------------------------------
ggplot(Sleuth3::case1001, aes(Height, Distance)) +
  geom_point() +
  theme_bw()


## ----tidy=FALSE, echo=TRUE------------------------------------------------------------------------
# Construct the variables by hand
m1 = lm(Distance ~ Height,                             case1001)
m2 = lm(Distance ~ Height + I(Height^2),               case1001)
m3 = lm(Distance ~ Height + I(Height^2) + I(Height^3), case1001)

coefficients(m1)
coefficients(m2)
coefficients(m3)


## ----echo=FALSE-----------------------------------------------------------------------------------
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }

  if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}



## ----echo=FALSE-----------------------------------------------------------------------------------
g = ggplot(case1001, aes(x=Height, y=Distance)) + geom_point(size=3)
multiplot(
  g + theme_bw(),
  g + stat_smooth(method="lm")                                    + theme_bw(),
  g + stat_smooth(method="lm", formula = y ~ x + I(x^2))          + theme_bw(),
  g + stat_smooth(method="lm", formula = y ~ x + I(x^2) + I(x^3)) + theme_bw(),
  layout = matrix(1:4,2,byrow=TRUE)
)


## ----echo=FALSE-----------------------------------------------------------------------------------
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

m <- longnosedace %>%
  tidyr::gather(variable, value, -stream, -count, -acreage)

ggplot(m %>% filter(variable %in% c("maxdepth","no3")), aes(x=value,y=count)) +
  geom_point(size=2) +
  facet_wrap(~variable, scales="free") +
  theme_bw()


## ----echo = TRUE, size="scriptsize"---------------------------------------------------------------
m <- lm(count ~ maxdepth + no3, longnosedace)
summary(m)


## ----echo = TRUE, size="scriptsize"---------------------------------------------------------------
ci <- confint(m)
ci


## -------------------------------------------------------------------------------------------------
case1301_subset = case1301 %>% filter(Block %in% c("B1","B2") & Treat %in% c("L","Lf","LfF"))

ggplot(case1301_subset, aes(x = Treat, y = Cover,
                            color = Block, shape = Block)) +
  geom_jitter(height = 0, width = 0.05, size = 2) +
  theme_bw() +
  theme(legend.position = "bottom")


## -------------------------------------------------------------------------------------------------
summary(mM <- lm(Cover ~ Block + Treat, case1301_subset))


## -------------------------------------------------------------------------------------------------
ci <- confint(mM)
ci


## -------------------------------------------------------------------------------------------------
summary(mI <- lm(Cover ~ Block * Treat, case1301_subset))


## -------------------------------------------------------------------------------------------------
ci <- confint(mI)
ci


## ----echo=FALSE-----------------------------------------------------------------------------------
newdata = case1301_subset %>% select(Block,Treat) %>% unique()

fit = newdata %>%
  mutate(`Main effects` = predict(mM, newdata = newdata),
         `Interaction`  = predict(mI, newdata = newdata)) %>%
  tidyr::gather(model, Cover, `Main effects`, `Interaction`) %>%
  dplyr::mutate(model = factor(model, levels = c("Main effects","Interaction")))


ggplot(fit, aes(x = Treat, y = Cover,
                color = Block, linetype = Block, group = Block, shape = Block)) +
  geom_line() +
  geom_point() +
  facet_grid(.~model) +
  theme_bw() +
  theme(legend.position = "bottom")


## -------------------------------------------------------------------------------------------------
mM <- lm(log(Energy) ~ log(Mass) + Type, case1002)
ggplot(case1002, aes(x = Mass, y = Energy, color = Type, shape = Type)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  theme_bw() +
  theme(legend.position = "bottom")


## ----echo = TRUE----------------------------------------------------------------------------------
summary(mM <- lm(log(Energy) ~ log(Mass) + Type, case1002))


## -------------------------------------------------------------------------------------------------
ci <- confint(mM)
ci


## ----echo = TRUE----------------------------------------------------------------------------------
summary(mI <- lm(log(Energy) ~ log(Mass) * Type, case1002))


## -------------------------------------------------------------------------------------------------
ci <- confint(mI)
ci


## ----echo=FALSE-----------------------------------------------------------------------------------
newdata = expand.grid(Mass = c(1,250), Type = levels(case1002$Type))

fit = newdata %>%
  mutate(`Main effects` = predict(mM, newdata = newdata),
         `Interaction`  = predict(mI, newdata = newdata)) %>%
  tidyr::gather(model, Energy, `Main effects`, `Interaction`) %>%
  dplyr::mutate(model = factor(model, levels = c("Main effects","Interaction")),
                Energy = exp(Energy)) # not sure why predict doesn't do the exp()


ggplot(fit, aes(x = Mass, y = Energy, color = Type, linetype = Type)) +
  geom_line() +
  scale_x_log10() +
  scale_y_log10() +
  facet_grid(.~model) +
  theme_bw() +
  theme(legend.position = "bottom")


## -------------------------------------------------------------------------------------------------
mM = lm(count ~ no3 + maxdepth, longnosedace)
summary(mM)


## -------------------------------------------------------------------------------------------------
ci <- confint(mM)
ci


## -------------------------------------------------------------------------------------------------
mI = lm(count ~ no3*maxdepth, longnosedace)
summary(mI)


## -------------------------------------------------------------------------------------------------
ci <- confint(mI)
ci


## ----echo=FALSE-----------------------------------------------------------------------------------
newdata = expand.grid(maxdepth = c(26,63,160), no3 = c(0,8))
me = lm(count ~ no3 + maxdepth, data = longnosedace)
int = lm(count ~ no3 * maxdepth, data = longnosedace)

fit = newdata %>%
  mutate(`Main effects` = predict(me, newdata = newdata),
         `Interaction`  = predict(int, newdata = newdata)) %>%
  tidyr::gather(model,count, `Main effects`, `Interaction`) %>%
  dplyr::mutate(model = factor(model, levels = c("Main effects","Interaction")))


ggplot(fit, aes(x = no3, y = count, color = maxdepth, group = maxdepth)) +
  geom_line() +
  facet_grid(.~model) +
  theme_bw()

