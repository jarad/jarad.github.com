## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")


## ----set_seed, echo=FALSE------------------------------------------------------------------------
set.seed(20220215)


## ------------------------------------------------------------------------------------------------
library("survey")
data(nhanes)
nhanes %>% filter(is.na(HI_CHOL)) %>% head

