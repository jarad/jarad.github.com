## ----libraries, message=FALSE, warning=FALSE--------------------------------------------------------------------------
library(dplyr)
library(ggplot2)


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----venn_setup, out.width='0.6\\textwidth'---------------------------------------------------------------------------
l = 101
circle = data.frame(
  loc = c(rep("top", l),rep("bot",l)),
  x   = c(seq(-1, 1, length=l), seq(1, -1, length=l))) %>%
  mutate(y   = sqrt(1-x^2)*ifelse(loc=="bot",-1,1))
  
indent = circle %>%
  mutate(x = x-0.5,
         x = ifelse(x>0,-x,x))

yint = sqrt(1-.5^2)

Aonly = indent %>% mutate(set="Aonly")
Bonly = indent %>% mutate(x=-x, set="Bonly")

AandB = data.frame(loc=c(rep("left",l),rep("right",l)),
                   y = c(seq(-yint,yint,length=l), seq(yint,-yint,length=l))) %>%
  mutate(set="AandB",
         x = (sqrt(1-y^2)-.5)*ifelse(loc=="left",-1,1))

# ggplot(Bonly, aes(x,y,fill=set)) + 
#   geom_polygon(color="black") + 
#   coord_fixed() +
#   theme_minimal()
  

all = rbind(Aonly,Bonly,AandB) %>%
  mutate(union = TRUE,
         intersection = set == "AandB",
         difference = set == "Aonly",
         complement = set == "Bonly") %>%
  tidyr::gather(operation,value,union,intersection,complement,difference) %>%
  mutate(operation = factor(operation, 
                            levels=c("union","intersection","complement","difference")))


ggplot(all, aes(x,y, group=set, fill=value)) + 
  geom_rect(data = all %>% filter(operation == "complement"), fill="red", 
            xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, alpha = 0.3) + 
  geom_polygon(color="black") + 
#  geom_polygon(data=all %>% filter(set=="Aonly"), color="black") + 
  facet_wrap(~operation) + 
  coord_fixed() +
#  theme_minimal() +
  scale_fill_manual(values=c("gray","red")) + 
  annotate("text", label="A", x=-1, y=.5,size=8) + 
  annotate("text", label="B", x= 1, y=.5,size=8) +
  theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank())

