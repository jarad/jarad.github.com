## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("tidyverse")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)




## ----echo=TRUE, size = 'scriptsize'-----------------------------------------------------------------------------------
keyboard <- read.csv("keyboard.csv")
t.test(speed_wpm ~ type, data = keyboard)


## ----echo = TRUE, fig.height=2.4--------------------------------------------------------------------------------------
library("ggplot2") # use install.packages("ggplot2") to install this package

ggplot(keyboard, aes(type, speed_wpm)) + geom_boxplot()


## ----R-boxplot, echo = TRUE, eval=FALSE-------------------------------------------------------------------------------
## ggplot(keyboard, aes(type, speed_wpm, color = type)) +
##   geom_jitter(width = 0.1) +
##   geom_boxplot(outlier.shape = NA, fill = NA) +
##   labs(x = "Keyboard type",
##        y = "Typing speed (words per minute)",
##        title = "Typing speed comparison: Dvorak vs qwerty") +
##   theme_bw()


## ----fig.height=3.4---------------------------------------------------------------------------------------------------
ggplot(keyboard, aes(type, speed_wpm, color = type)) +
  geom_jitter(width = 0.1) +
  geom_boxplot(outlier.shape = NA, fill = NA) +
  labs(x = "Keyboard type",
       y = "Typing speed (words per minute)",
       title = "Typing speed comparison: Dvorak vs qwerty") +
  theme_bw()

