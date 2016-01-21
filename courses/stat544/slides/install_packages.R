if (!require("pacman")) install.packages("pacman")
pacman::p_load(package1, package2, package_n)

packs = c('plyr','dplyr','reshape2','xtable','ggplot2',
          'Sleuth3','MCMCpack','animate','rjags','runjags')

pacman::p_load(char = packs)
