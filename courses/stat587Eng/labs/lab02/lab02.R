## ---- eval=FALSE--------------------------------------------------------------
## install.packages("tidyverse")


## ---- eval=FALSE--------------------------------------------------------------
## install.packages(c("dplyr","tidyr","ggplot2"))


## ---- eval=FALSE--------------------------------------------------------------
## library("dplyr")
## library("tidyr")
## library("ggplot2")


## -----------------------------------------------------------------------------
library("tidyverse")


## -----------------------------------------------------------------------------
dim(airquality)
head(airquality)
tail(airquality)
summary(airquality)


## ---- eval=FALSE--------------------------------------------------------------
## ?airquality


## -----------------------------------------------------------------------------
airquality <- airquality %>%
  mutate(Date = as.Date(paste("1973",Month,Day,sep="/"))) 


## -----------------------------------------------------------------------------
ggplot(airquality,     # data.frame containing the data
       aes(x=Ozone)) + # a column name from the data.frame
  geom_histogram()     # create a histogram


## -----------------------------------------------------------------------------
ggplot(airquality, aes(x=Ozone)) + 
  geom_histogram(bins = 40)


## -----------------------------------------------------------------------------
ggplot(airquality, aes(x=Ozone)) + 
  geom_histogram(aes(y=..density..), bins = 40)




## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=1,y=Ozone)) + 
  geom_boxplot()     


## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot()     


## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot(color='grey',                 # make the boxes not so obvious
               outlier.shape = NA) +         # remove outliers, 
  geom_jitter() +                            # because they get plotted here
  theme_bw()                                 # Change the theme to remove gray




## -----------------------------------------------------------------------------
ggplot(airquality, aes(x = Date, y = Ozone)) +
  geom_point()


## -----------------------------------------------------------------------------
ggplot(airquality, aes(x = Date, y = Ozone)) +
  geom_line()


## -----------------------------------------------------------------------------
ggplot(airquality, aes(x = Solar.R, y = Ozone)) +
  geom_point()




## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_point() 


## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_jitter() 


## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot(color='grey',                 # make the boxes not so obvious
               outlier.shape = NA) +         # remove outliers, 
  geom_point() +                             # because they get plotted here
  theme_bw()                                 # Change the theme to remove gray


## -----------------------------------------------------------------------------
ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot(color='grey',                 # make the boxes not so obvious
               outlier.shape = NA) +         # remove outliers, 
  geom_jitter() +                            # because they get plotted here
  theme_bw()                                 # Change the theme to remove gray




## -----------------------------------------------------------------------------
airquality_long <- airquality %>%
  select(-Month, -Day) %>%              # Remove these columns
  tidyr::gather(response, value, -Date)


## -----------------------------------------------------------------------------
dim(airquality)
dim(airquality_long)

head(airquality_long)
summary(airquality_long)
table(airquality_long$response)


## -----------------------------------------------------------------------------
ggplot(airquality_long, 
       aes(x = Date, y = value, 
           linetype = response,
           color = response, 
           group = response)) +
  geom_line()


## -----------------------------------------------------------------------------
ggplot(airquality_long, aes(Date, value)) +
  geom_point() + 
  facet_wrap(~response)


## -----------------------------------------------------------------------------
ggplot(airquality_long, aes(Date, value)) +
  geom_line() + 
  facet_wrap(~response,scales="free_y")


## -----------------------------------------------------------------------------
airquality2 <- airquality_long %>%
  tidyr::spread(response, value)


## -----------------------------------------------------------------------------
g <- ggplot(airquality2,
       aes(x = Temp, y = Wind)) +
  geom_point()

g # Then you can see the plot by just typing the object name


## -----------------------------------------------------------------------------
g <- g +
  labs(x = "Temperature (F)",
       y = "Wind speed (mph)",
       title = "New York (May-September 1973)")

g


## -----------------------------------------------------------------------------
g <- g + theme_bw()
g


## -----------------------------------------------------------------------------
g <- g + geom_smooth(method="lm")
g


## -----------------------------------------------------------------------------
ggplot(airquality2,
       aes(x = Temp, y = Wind)) +
  geom_point() +
  geom_smooth(method = "lm") + 
  labs(x = "Temperature (F)",
       y = "Wind speed (mph)",
       title = "New York (May-September 1973)") + 
  theme_bw()




## ----eval=FALSE---------------------------------------------------------------
## ggsave(filename = "plot.png", plot = g, width = 5, height = 4)

