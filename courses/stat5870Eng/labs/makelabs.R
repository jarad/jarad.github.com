args = commandArgs(trailingOnly = TRUE)

library("knitr")

setwd(dirname(args[1]))

Rmd_file = basename(args[1])

rmarkdown::render(input = Rmd_file)        # make html
purl(input = Rmd_file, documentation = 0L) # make R code
