packages <- c("tidyverse","Sleuth3","knitr","rmarkdown","GGally","emmeans",
              "lme4")

install.packages(setdiff(packages, rownames(installed.packages())))  
