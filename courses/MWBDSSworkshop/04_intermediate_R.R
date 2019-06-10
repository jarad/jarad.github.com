## ---- message=FALSE------------------------------------------------------
library("tidyverse")
library("MWBDSSworkshop")

## ------------------------------------------------------------------------
# Read csv files and create additional variables
icd9df = read.csv("icd9.csv")
GI     = read.csv("GI.csv") %>%
  mutate(
    date      = as.Date(date),
    weekC     = cut(date, breaks="weeks"),
    week      = as.numeric(weekC),
    weekD     = as.Date(weekC),
    facility  = as.factor(facility),
    icd9class = factor(cut(icd9, 
                           breaks = icd9df$code_cutpoint, 
                           labels = icd9df$classification[-nrow(icd9df)], 
                           right  = TRUE)),
    ageC      = cut(age, 
                    breaks = c(-Inf, 5, 18, 45 ,60, Inf)),
    zip3      = trunc(zipcode/100))

## ------------------------------------------------------------------------
ga_l <- GI %>%
  group_by(gender, ageC) %>%
  summarize(count = n())

ga_w <- ga_l %>%
  spread(ageC, count) %>%
  print(row.names = FALSE)

## ------------------------------------------------------------------------
library('xtable')
tab = xtable(ga_w,
             caption = "Total GI cases by Sex and Age Category",
             label   = "myHTMLanchor",
             align   = "ll|rrrrr") # rownames gets a column

## ------------------------------------------------------------------------
print(tab, file="table.html", type="html", include.rownames=FALSE)

## ------------------------------------------------------------------------
print(tab, type="html", include.rownames=FALSE)

## ---- results='asis'-----------------------------------------------------
print(tab, type="html", include.rownames=FALSE)

## ---- eval=FALSE---------------------------------------------------------
#  # Summarize data by facility and age category
#  
#  # Reshape data from long to wide format
#  
#  # Create HTML table
#  
#  # Save HTML to file
#  
#  # Copy-and-paste table into Word

## ------------------------------------------------------------------------
library('maps')
states = map_data("state")
ggplot(states, aes(x = long, y = lat, group = group)) + 
  geom_polygon(color="white")

## ------------------------------------------------------------------------
counties = map_data("county")
ggplot(counties, aes(x = long, y = lat, group = group)) + 
  geom_polygon(color = "white")

## ------------------------------------------------------------------------
ggplot(counties %>% filter(region=="iowa"), 
       aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "gray", color = "black")

## ------------------------------------------------------------------------
fluTrends = read.csv("fluTrends.csv", check.names=FALSE)

## ------------------------------------------------------------------------
flu_w = fluTrends %>%
  tail(n = 12) 
dim(flu_w)

## ------------------------------------------------------------------------
flu_l <- flu_w %>%
  gather(region, index, -Date)

## ------------------------------------------------------------------------
head(unique(states$region))
flu_l$region = tolower(flu_l$region)
states_merged = states %>%
  merge(flu_l, sort = FALSE, by = 'region')

## ------------------------------------------------------------------------
states_merged$Date = as.Date(states_merged$Date)
mx_date = max(states_merged$Date)
g = ggplot(states_merged %>% filter(Date == mx_date), 
       aes(x = long, y = lat, group = region, fill = index)) + 
  geom_polygon() + 
  labs(title=paste('Google Flu Trends on', mx_date), x='', y='') +
  theme_minimal() + 
  theme(legend.title = element_blank()) +
  coord_map("cylindrical")

if (require('RColorBrewer'))
  g = g + scale_fill_gradientn(colours=RColorBrewer::brewer.pal(9,"Reds")) # Thanks Annie Chen

g

## ------------------------------------------------------------------------
ggplot(states_merged, 
       aes(x=long, y=lat, group=group, fill=index)) + 
  geom_polygon() + 
  labs(title='Google Flu Trends', x='', y='') +
  theme_minimal() + 
  theme(legend.title = element_blank()) +
  facet_wrap(~Date) + 
  coord_map("cylindrical") + 
  scale_fill_gradientn(colours=brewer.pal(9,"Reds")) 

## ---- eval=FALSE---------------------------------------------------------
#  # Construct Google Flu Trends map

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("ggplot2")

## ---- eval=FALSE---------------------------------------------------------
#  # install.packages("devtools")
#  library('devtools')
#  install_github('nandadorea/vetsyn')

## ---- eval=FALSE---------------------------------------------------------
#  source("http://bioconductor.org/biocLite.R")
#  biocLite()

## ---- eval=FALSE---------------------------------------------------------
#  biocLite("edgeR")

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("MWBDSSworkshop_0.4.tar.gz",
#                   repos = NULL,
#                   type  = "source")

## ------------------------------------------------------------------------
add = function(a,b) {
  return(a+b)
}
add(1,2)

## ------------------------------------------------------------------------
add_vector = function(v) {
  sum = 0
  for (i in 1:length(v)) sum = sum + v[i]
  return(sum)
}

## ------------------------------------------------------------------------
alert = function(y,threshold=100) {
  # y is the time series 
  # an alert is issue for any y above the threshold (default is 100)
  factor(ifelse(y>threshold, "Yes", "No"))
}

## ------------------------------------------------------------------------
GI_w <- GI %>%
  group_by(weekD) %>%
  summarize(count = n())

GI_w$alert = alert(y = GI_w$count, threshold = 150)

ggplot(GI_w, aes(x = weekD, y = count, color = alert)) + 
  geom_point() + 
  scale_color_manual(values = c("black","red"))

## ---- eval=FALSE---------------------------------------------------------
#  # Read in the data perhaps as a csv file
#  
#  # Create some table and save them to html files
#  
#  # Create some figures and save them to jpegs
#  
#  # Run some outbreak detection algorithms and produce figures

## ---- eval=FALSE---------------------------------------------------------
#  source("script.R")

## ---- eval=FALSE---------------------------------------------------------
#  install.packages('shiny')
#  library('shiny')
#  runGitHub('NLMichaud/WeeklyCDCPlot')

## ------------------------------------------------------------------------
visits_by_age = GI %>%
  filter(age > 18, age < 80) %>%
  group_by(age) %>%
  summarize(count = n()) 

## ------------------------------------------------------------------------
ggplot(visits_by_age, aes(x = age, y = count)) + 
  geom_point() + 
  scale_y_log10()

## ------------------------------------------------------------------------
m = lm(log(count) ~ age, data = visits_by_age)
summary(m)

## ------------------------------------------------------------------------
ggplot(visits_by_age, aes(x = age, y = count)) + 
  geom_point() + 
  scale_y_log10() +
  stat_smooth(method = "lm") # use `se=FALSE` if you do not want to see the uncertainty 

## ------------------------------------------------------------------------
opar = par(mfrow=c(2,3)) # Create a 2x3 grid of plots
plot(m, 1:6, ask=FALSE)  # 6 residual plots
par(opar)                # Revert to original graphics settings

## ------------------------------------------------------------------------
m = lm(log(count) ~ age + I(age^2), data = visits_by_age)
summary(m)

## ------------------------------------------------------------------------
ggplot(visits_by_age, aes(x = age, y = count)) + 
  geom_point() + 
  scale_y_log10() +
  stat_smooth(method = "lm", formula = y ~ x + I(x^2)) 

## ------------------------------------------------------------------------
m = loess(log(count) ~ age, data = visits_by_age)
summary(m)

## ------------------------------------------------------------------------
ggplot(visits_by_age, aes(x = age, y = count)) + 
  geom_point() + 
  scale_y_log10() +
  stat_smooth()  # default is loess

## ------------------------------------------------------------------------
m = glm(count ~ age + I(age^2), data = visits_by_age, family = "poisson")
summary(m)

## ------------------------------------------------------------------------
ggplot(visits_by_age, aes(x = age, y = count)) + 
  geom_point() + 
  stat_smooth(method = "glm", formula = y ~ x + I(x^2), 
              method.args = list(family = "poisson"))

## ------------------------------------------------------------------------
visits_by_age_and_facility = GI %>% 
  filter(age > 18, age < 80) %>%
  filter(facility != 259) %>%       # only 1 observation in this facility
  group_by(facility, age) %>%
  summarize(count = n())

## ------------------------------------------------------------------------
ggplot(visits_by_age_and_facility, aes(x = age, y = count)) + 
  facet_wrap(~facility) +
  scale_y_log10() +
  geom_point()

## ------------------------------------------------------------------------
library("lme4")
m = lmer(log(count) ~ age + I(age^2) + (age+I(age^2)|facility), 
         data = visits_by_age_and_facility)

## ------------------------------------------------------------------------
visits_by_age_and_facility = visits_by_age_and_facility %>%
  mutate(age = scale(age))

m = lmer(log(count) ~ age + I(age^2) + (age+I(age^2)|facility), 
         data = visits_by_age_and_facility)
summary(m)

## ------------------------------------------------------------------------
visits = GI %>%
  filter(age > 18, age < 80) %>%
  filter(facility != 259) %>%       # only 1 observation in this facility
  group_by(facility, age, gender) %>%
  summarize(count = n())

## ------------------------------------------------------------------------
ggplot(visits, aes(x = age, y = count, color = gender, shape = gender)) + 
  facet_wrap(~facility) +
  scale_y_log10() +
  geom_point()

## ------------------------------------------------------------------------
library("randomForest")
m = randomForest(log(count) ~ age + gender + facility, data = visits)
m
importance(m)

## ------------------------------------------------------------------------
dim(visits)

