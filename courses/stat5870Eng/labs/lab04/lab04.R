# Author: Jarad Niemi
# Date:   2024-09-16
# Purpose: Exploratory statistics including summary statistics and graphical
#          statistics using ggplot2 (included in tidyverse)
#-------------------------------------------------------------------------------


## install.packages("tidyverse")

## install.packages(c("dplyr","tidyr","ggplot2"))

## library("dplyr")
## library("tidyr")
## library("ggplot2")

library("tidyverse")

theme_set(theme_bw()) # comment this line to see what default plots look like

# Create data
y <- c(3, 4.5, 7, 8, 1, -3, 4, 10, 8)

# Sample size
length(y)

# Measures of center
mean(y)
median(y)

# Mode
sort(table(y), decreasing = TRUE)

# Quantile
quantile(y, probs = 0.05) # 0.05 sample quantile and 5%-tile

# Min and max
min(y)
max(y)

# Measures of spread
var(y)
sd(y)

range(y)                                 # gives c(min(y), max(y))
diff(range(y))                           # range

diff(quantile(y, probs = c(0.25, 0.75))) # interquartile range

# Summary
summary(y)

# Summary statistics
dim(airquality)
head(airquality)
tail(airquality)
summary(airquality)

## ?airquality

airquality <- airquality %>%
  dplyr::mutate(Date = as.Date(paste("1973",Month,Day,sep="/"))) 

ggplot(airquality,     # data.frame containing the data
       aes(x=Ozone)) + # a column name from the data.frame
  geom_histogram()     # create a histogram

ggplot(airquality, aes(x=Ozone)) + 
  geom_histogram(bins = 40)

ggplot(airquality, aes(x=Ozone)) + 
  geom_histogram(aes(y=..density..), bins = 40)



ggplot(airquality,     
       aes(x=1,y=Ozone)) + 
  geom_boxplot()     

ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot()     



ggplot(airquality, aes(x = Date, y = Ozone)) +
  geom_point()

ggplot(airquality, aes(x = Date, y = Ozone)) +
  geom_line()

ggplot(airquality, aes(x = Solar.R, y = Ozone)) +
  geom_point()



ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_point() 

ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_jitter() 

ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot(color='grey',                 # make the boxes not so obvious
               outlier.shape = NA) +         # remove outliers, 
  geom_point()                               # because they get plotted here

ggplot(airquality,     
       aes(x=Month, y=Ozone, group=Month)) + 
  geom_boxplot(color='grey',                 # make the boxes not so obvious
               outlier.shape = NA) +         # remove outliers, 
  geom_jitter()                              # because they get plotted here



airquality_long <- airquality %>%
  dplyr::select(-Month, -Day) %>%              # Remove these columns
  tidyr::pivot_longer(-Date,
                      names_to  = "response",
                      values_to = "value")

dim(airquality)
dim(airquality_long)

head(airquality_long)
summary(airquality_long)
table(airquality_long$response)

ggplot(airquality_long, 
       aes(x = Date, y = value, 
           linetype = response,
           color = response, 
           group = response)) +
  geom_line()

ggplot(airquality_long, aes(Date, value)) +
  geom_point() + 
  facet_wrap(~response)

ggplot(airquality_long, aes(Date, value)) +
  geom_line() + 
  facet_wrap(~response,scales="free_y")

ggplot(airquality_long, aes(Date, value)) +
  geom_line() + 
  facet_wrap(.~response,scales="free_y")

ggplot(airquality_long, aes(Date, value)) +
  geom_line() + 
  facet_wrap(response ~ .,scales="free_y")

airquality2 <- airquality_long %>%
  tidyr::pivot_wider(
    names_from  = response, 
    values_from = value)

g <- ggplot(airquality2,
       aes(x = Temp, y = Wind)) +
  geom_point()

g # Then you can see the plot by just typing the object name

g <- g +
  labs(x = "Temperature (F)",
       y = "Wind speed (mph)",
       title = "New York (May-September 1973)")

g

g <- g + theme_classic()
g

g <- g + geom_smooth(method="lm")
g

ggplot(airquality2,
       aes(x = Temp, y = Wind)) +
  geom_point() +
  geom_smooth(method = "lm") + 
  labs(x = "Temperature (F)",
       y = "Wind speed (mph)",
       title = "New York (May-September 1973)") 



## ggsave(filename = "plot.png",
##        plot     = g,
##        width    = 5,
##        height   = 4)
