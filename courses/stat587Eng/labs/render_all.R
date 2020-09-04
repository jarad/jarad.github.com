# Render all 

source("packages.R")

wd <- getwd()

labs <- c(paste0("lab", sprintf("%02d", 1:12)), "labData")

for (lab in labs[6:13]) {
  setwd(paste(wd, lab, sep = "/"))
  rmarkdown::render(paste0(lab,".Rmd"))
  knitr::knit(paste0(lab,".Rmd"), tangle = TRUE)
}
