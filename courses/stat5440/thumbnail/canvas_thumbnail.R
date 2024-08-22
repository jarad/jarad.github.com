# Author: Jarad Niemi
# Date:   2024-01-19
# Purpose: Create thumbnail for Canvas course card

library("tidyverse")
library("knitr")



# Prior
a <- 2
b <- 3

# Data
y <- 6
n <- 10

d <- data.frame(x = seq(from = 0, to = 1,length = 1001)) %>%
  mutate(Prior = dbeta(x, a, b),
         Data  = dbeta(x, y, n-y),
         Posterior = dbeta(x, a+y, b+n-y)) %>%
  pivot_longer(Prior:Posterior,
               names_to = "Distribution",
               values_to = "density")


ggplot(d, aes(x = x, y = density, 
              color= Distribution, linetype = Distribution)) +
  geom_line() +
  scale_x_continuous(limits = range(d$x)) +
  scale_y_continuous(limits = range(d$density)) +
  theme_bw() +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        
        
        panel.spacing = unit(2, "mm"),
        
        legend.position="none",
        panel.background=element_blank(),
        # panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank())


foo <- "canvas_thumbnail.png"
ggsave(foo, 
       
       # Canvas course card resolution
       width = 262,
       height = 146,
       units = "px")

knitr::plot_crop(foo)
