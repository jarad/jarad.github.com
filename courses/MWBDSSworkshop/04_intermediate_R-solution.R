## ---- echo=FALSE, message=FALSE------------------------------------------
library('tidyverse')
library('xtable')
library('MWBDSSworkshop')

workshop(write_data = TRUE, launch_index=FALSE)

# Read csv files and create additional columns
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
# Summarize data by facility and age category
fa_l <- GI %>%
  group_by(facility, ageC) %>%
  summarize(count = n())

# Reshape data from long to wide format
fa_w <- fa_l %>%
  spread(ageC, count)

# Create HTML table
tab = xtable(fa_w,
             caption = "Total GI cases by Facility and Age Category",
             label   = "myHTMLanchor",
             align   = "ll|rrrrr") # rownames gets a column

# Save HTML to file
print(tab, file="table.html", type="html", include.rownames=FALSE)

# Copy-and-paste table into Word

## ------------------------------------------------------------------------
# Here is some code to get you started
states = map_data("state")

# Read in the data from http://www.google.org/flutrends/us/data.txt
# ** you will need to figure this part out **
# ** it is NOT trivial                     **
fluTrends = read.csv(file="http://www.google.org/flutrends/about/data/flu/us/data.txt", 
                     skip = 11, 
                     check.names=FALSE)

# Keep only the last row for the states
flu_w = fluTrends[nrow(fluTrends), c(1,3:53)]

# Reshape to long format
flu_l <- flu_w %>%
  gather(region, index, -Date)

# Merge flutrends data with map_data
flu_l$region = tolower(flu_l$region)
states_merged = merge(states, flu_l, sort=FALSE, by='region')

# Find the date
states_merged$Date = as.Date(states_merged$Date)
mx_date = max(states_merged$Date)

# Construct plot
ggplot(states_merged, aes(x=long, y=lat, group=group, fill=index)) + 
  geom_polygon() + 
  labs(title=paste('Google Flu Trends on', mx_date), x='', y='') +
  theme_minimal() + 
  theme(legend.title = element_blank()) +
  coord_map("cylindrical") 

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("surveillance")
#  help(package=surveillance)

