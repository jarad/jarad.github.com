## ---- echo=FALSE, message=FALSE------------------------------------------
library('ggplot2')
library('dplyr')
library('MWBDSSworkshop')

workshop(write_data = TRUE, launch_index  = FALSE) # to make sure csv files are available

## ---- echo=FALSE---------------------------------------------------------
# Read in csv files
GI     = read.csv("GI.csv")
icd9df = read.csv("icd9.csv")

## ---- echo=FALSE---------------------------------------------------------
# Mutate data.frame
GI <- GI %>%
  mutate(
    date      = as.Date(date),
    weekC     = cut(date, breaks="weeks"),
    week      = as.numeric(weekC),
    facility  = as.factor(facility),
    icd9class = factor(cut(icd9, 
                           breaks = icd9df$code_cutpoint, 
                           labels = icd9df$classification[-nrow(icd9df)], 
                           right  = TRUE)),
    ageC      = cut(age, 
                    breaks = c(-Inf, 5, 18, 45 ,60, Inf)),
    zip3      = trunc(zipcode/100))

## ------------------------------------------------------------------------
# Create weekD variable in GI data set
GI$weekD = as.Date(GI$weekC) # could have used mutate
str(GI$weekD)

## ------------------------------------------------------------------------
# Construct a data set aggregated by week and age category
GI_wa <- GI %>%
  group_by(week, ageC) %>%
  summarize(count = n())

# Construct a plot to look at weekly GI cases by age category
ggplot(GI_wa, aes(x = week, y = count, color = ageC)) + geom_point()

ggplot(GI_wa, aes(x = week, y = count, shape = ageC)) + geom_point()

ggplot(GI_wa, aes(x = week, y = count, shape = ageC, color = ageC)) + geom_point()

## ------------------------------------------------------------------------
# Construct data set 
GI_za <- GI %>%
  group_by(week, zip3, ageC) %>%
  summarize(count = n())

# Construct plot of weekly GI counts by zip3 and ageC
ggplot(GI_za, aes(x = week, y = count)) + 
  geom_point() + 
  facet_grid(ageC ~ zip3)

## ------------------------------------------------------------------------
# Filter the data to zipcode 206xx in 2008
zip206_w <- GI %>%
  mutate(year = as.numeric(format(date, "%Y"))) %>%
  filter(zip3 == 206,
         year == 2008) %>%
  group_by(week) %>% 
  summarize(count = n())


# Construct the plot of weekly GI counts in zipcode 206xx.
ggplot(zip206_w, aes(x = week, y = count)) + 
  geom_point()

