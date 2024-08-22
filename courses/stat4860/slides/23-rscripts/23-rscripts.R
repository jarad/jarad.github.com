## -----------------------------------------------------------------------------------------
# This script will perform ...
#
# Author: Jarad Niemi
# Written: 09 Apr 2023
# Modified: 10 Apr 2023 by Alex Wold


## -----------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("ggResidpanel")
library("emmeans")


## ---- eval=FALSE, comment=""--------------------------------------------------------------
source("01-read_data.R")
source("02-wrangle_data.R")

