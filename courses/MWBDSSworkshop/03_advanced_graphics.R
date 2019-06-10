## ---- message=FALSE------------------------------------------------------
library('tidyverse') # loads dplyr/ggplot2/readr

## ------------------------------------------------------------------------
# Read in csv files
GI     = read.csv("GI.csv")
icd9df = read.csv("icd9.csv")

# Add columns to the data.frame
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
dim(GI)
str(GI)
summary(GI)

## ---- eval=FALSE---------------------------------------------------------
#  # Create weekD variable in GI data set

## ------------------------------------------------------------------------
GI_wf <- GI %>%
  group_by(week, facility) %>%
  summarize(count = n())

## ---- eval=FALSE---------------------------------------------------------
#  nrow(GI_wf) # Should have number of weeks times number of facilities rows
#  ncol(GI_wf) # Should have 3 columns: week, facility, count
#  dim(GI_wf)
#  head(GI_wf)
#  tail(GI_wf)
#  summary(GI_wf)
#  summary(GI_wf$facility)

## ------------------------------------------------------------------------
ggplot(GI_wf, aes(x = week, y = count)) + 
  geom_point()

## ------------------------------------------------------------------------
ggplot(GI_wf, aes(x = week, y = count, color = facility)) + 
  geom_point()

## ------------------------------------------------------------------------
ggplot(GI_wf, aes(x = week, y = count, shape = facility)) + 
  geom_point()

## ---- eval=FALSE---------------------------------------------------------
#  # Construct a data set aggregated by week and age category
#  
#  # Construct a plot to look at weekly GI cases by age category.

## ------------------------------------------------------------------------
ggplot(GI_wf, aes(x = week, y = count)) + 
  geom_point() + 
  facet_wrap(~ facility)

## ------------------------------------------------------------------------
ggplot(GI_wf, aes(x = week, y = count)) + 
  geom_point() + 
  facet_wrap(~ facility, scales = "free")

## ------------------------------------------------------------------------
GI_sa <- GI %>%
  group_by(week, gender, ageC) %>%
  summarize(count = n())

## ------------------------------------------------------------------------
ggplot(GI_sa, aes(x = week, y = count)) + 
  geom_point() + 
  facet_grid(gender ~ ageC)

## ------------------------------------------------------------------------
ggplot(GI_sa, aes(x = week, y = count, shape = gender, color = gender)) + 
  geom_point() + 
  facet_wrap(~ ageC)

## ---- eval=FALSE---------------------------------------------------------
#  # Construct a plot of weekly GI counts by zip3 and ageC.

## ------------------------------------------------------------------------
IPD_w <- GI %>%
  filter(icd9class == "infectious and parasitic disease") %>%
  group_by(week) %>%
  summarize(count = n())

ggplot(IPD_w, aes(x = week, y = count)) + 
  geom_point()

## ------------------------------------------------------------------------
conditions = levels(GI$icd9class)
conditions

## ------------------------------------------------------------------------
IPDp <- GI %>%
  filter(icd9class %in% levels(icd9class)[c(1,3)])

summary(IPDp$icd9class)

## ------------------------------------------------------------------------
IPDp_w <- IPDp %>%
  group_by(week, icd9class) %>%
  summarize(count = n())

ggplot(IPDp_w, aes(x = week, y = count)) + 
  geom_point() + 
  facet_wrap(~ icd9class, scales = "free")

## ------------------------------------------------------------------------
# Combine filtering and summarizing
nIPD_w <- GI %>%
  filter(icd9class != "infectious and parasitic disease") %>%
  group_by(week, icd9class) %>%
  summarize(count = n())

ggplot(nIPD_w, aes(x = week, y = count)) + 
  geom_point() + 
  facet_wrap(~ icd9class, scales = "free")

## ------------------------------------------------------------------------
nIPDp_w <- GI %>%
  filter(!(icd9class %in% levels(icd9class)[c(1,3)])) %>%
  group_by(week, icd9class) %>%
  summarize(count = n())

ggplot(nIPDp_w, aes(x = week, y = count)) + 
  geom_point() + 
  facet_wrap(~ icd9class, scales = "free")

## ------------------------------------------------------------------------
Age60p_w <- GI %>%
  filter(age > 60) %>%
  group_by(week) %>%
  summarize(count = n())

ggplot(Age60p_w, aes(x = week, y = count)) + 
  geom_point()

## ------------------------------------------------------------------------
Age_lte30_w <- GI %>%
  filter(age <= 30) %>%
  group_by(week) %>%
  summarize(count = n())

ggplot(Age_lte30_w, aes(x = week, y = count)) + 
  geom_point()

## ------------------------------------------------------------------------
Age30to60_w <- GI %>%
  filter(age > 30, age <= 60) %>% # This includes those who are 60, but not those who are 30
  group_by(week) %>%
  summarize(count = n())

ggplot(Age30to60_w, aes(x = week, y = count)) + 
  geom_point()

## ------------------------------------------------------------------------
two_dates = as.Date(c("2007-01-01", "2007-12-31"))

## ------------------------------------------------------------------------
early <- GI %>% filter(date <  two_dates[1])
late  <- GI %>% filter(date >= two_dates[2])
mid   <- GI %>% filter(date >= two_dates[1], date < two_dates[2])

## ------------------------------------------------------------------------
early_w <- early %>% group_by(week) %>% summarize(count = n())
late_w  <- late  %>% group_by(week) %>% summarize(count = n())
mid_w   <- mid   %>% group_by(week) %>% summarize(count = n())

g1 = ggplot(early_w, aes(x = week, y = count)) + geom_point()
g2 = ggplot(late_w,  aes(x = week, y = count)) + geom_point()
g3 = ggplot(mid_w,   aes(x = week, y = count)) + geom_point()

## ------------------------------------------------------------------------
# you may need to run install.packages("gridExtra")
if (require('gridExtra'))
  gridExtra::grid.arrange(g1,g3,g2)

## ------------------------------------------------------------------------
cut_dates <- c(as.Date("1900-01-01"),
               two_dates,
               Sys.Date())

GI_time <- GI %>% 
  mutate(time = cut(date, 
                    breaks = cut_dates, 
                    labels = c("early","mid","late"))) %>%
  group_by(week, time) %>%
  summarize(count = n())

ggplot(GI_time,
       aes(x = week, y = count)) +
  geom_point() +
  facet_wrap(~ time, ncol = 1, scales = "free")

## ---- eval=FALSE---------------------------------------------------------
#  # Filter the data to zipcode 206xx between Jan 1, 2008 and Dec 31, 2008
#  
#  # Aggregate the date for each week in this time frame
#  
#  # Construct the plot of weekly GI counts in zipcode 206xx.

## ------------------------------------------------------------------------
GI$weekD = as.Date(GI$weekC) 

GI_sum <- GI %>%
  group_by(weekD, gender, ageC) %>%
  summarize(count = n())

ggplot(GI_sum, aes(x = weekD, y = count, color = gender)) + 
  geom_point(size = 3) + 
  facet_grid(ageC ~ ., scales = "free_y")

## ------------------------------------------------------------------------
levels(GI_sum$ageC)
levels(GI_sum$ageC) = paste("Age:", c("<5","5-18","18-45","45-60",">60"))
table(GI_sum$ageC)

## ------------------------------------------------------------------------
g = ggplot(GI_sum, aes(x = weekD, y = count, color = gender)) + 
  geom_point(size = 3) + 
  facet_grid(ageC ~ ., scales = "free_y")
g

## ------------------------------------------------------------------------
g = g + scale_color_manual(values=c("hotpink","blue"), name='Gender')
g

## ------------------------------------------------------------------------
g = g + 
  labs(title = "Weekly GI cases", x = "Year", y = "Weekly count") + 
  theme(legend.position = "bottom")
g

## ------------------------------------------------------------------------
g = g + theme_bw()
g

## ---- eval=FALSE---------------------------------------------------------
#  ?theme_bw
#  ?theme

## ------------------------------------------------------------------------
g = g + theme(title = element_text(size=rel(2)),
              text = element_text(size=16),
              legend.background = element_rect(fill  = "white", 
                                               size  = .5, 
                                               color = "black"))
g

## ------------------------------------------------------------------------
g
ggsave("plot.pdf")

## ------------------------------------------------------------------------
ggsave("plot.pdf", width=14, height=8)

