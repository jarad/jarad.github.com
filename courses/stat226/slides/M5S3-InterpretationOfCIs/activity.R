library("tidyverse")

# As class starts pass out a container with slips of paper for each observation.
# Ask students to quickly take out 4 slips of paper, write down the numbers, 
# put the slips of paper back in the container, and pass the container to the 
# next individual/group.



# Create csv file to be overwritten during class
n <- 100; mu = 10
d <- data.frame(i=1:n, xbar = rnorm(n,mu,1/sqrt(4))) %>%
  mutate(lower = round(xbar - 1,1),
         upper = round(xbar + 1,1)) %>%
  select(lower,upper)

write_csv(d, "CIs.csv")


# Calculate these from the population
mu = 69.2; 









sigma = 4.3

# Ask students to construct CIs based on the known population standard deviation
# and assuming the population is normally distributed.
# Open the CIs.csv file and enter each individual/groups' endpoints: lower then upper



# Create plot for in-class demonstration
d <- read_csv("CIs.csv") %>%
  mutate(includes = ifelse(lower <= mu & mu <= upper, "Yes", "No"),
         i = 1:n())

ggplot(d, aes(x=lower, xend=upper, y=i, yend=i, color = includes)) +
  geom_segment() +
  theme_bw() +
  geom_vline(xintercept = mu) +
  labs(x="Confidence interval", y = "Trial (i)") +
  scale_y_reverse()
