## ----libraries, message=FALSE, warning=FALSE, echo=FALSE-------------------------------------------------------
library("tidyverse")
library("emmeans") # install.packages("Sleuth3")


## ----set_seed, echo=FALSE--------------------------------------------------------------------------------------
set.seed(2)


## ----eval=FALSE, size="normalsize"-----------------------------------------------------------------------------
## lm(Dependent ~ Independent, data = MyData)


## ----eval=FALSE, size="normalsize"-----------------------------------------------------------------------------
## lm(Dependent ~ Block + Treatment, data = MyData)


## ----eval=FALSE, size="small"----------------------------------------------------------------------------------
## # Main effects
## lm(Dependent ~ Block + Treatment,                   data = MyData)
## 
## # Interaction
## lm(Dependent ~ Block + Treatment + Block:Treatment, data = MyData) # or
## lm(Dependent ~ Block * Treatment,                   data = MyData)


## ----eval=FALSE, size="normalsize"-----------------------------------------------------------------------------
## lm(Difference ~ 1, data = MyData)

