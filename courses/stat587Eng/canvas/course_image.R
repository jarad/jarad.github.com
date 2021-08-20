library("tidyverse")

d <- expand.grid(
  Effort = c("low","medium","high"),
  Duration = 0:100
) %>%
  mutate(Knowledge = 
           Duration/100 + 
           Duration/3 * I(Effort %in% c("medium","high")) +
           Duration^2/100 * I(Effort == "high"),
         Effort = factor(Effort, levels = c("high","medium","low"))
         ) 

g <- ggplot(d, aes(Duration, Knowledge, 
              color = Effort, linetype = Effort, group = Effort)) + 
  geom_line() +
  theme_bw() +
  labs(title = "STAT 587") +
  theme(
    plot.title = element_text(size = 22),
    legend.position = c(.15,.56),
    legend.margin=margin(t = 0, unit='cm'),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()) 

m <- 4
ggsave(filename = "587_image.png", g,
       units="px", width = m*262, height = m*146)
