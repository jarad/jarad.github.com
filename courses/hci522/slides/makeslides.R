args = commandArgs(trailingOnly = TRUE)

library("knitr")

setwd(dirname(args[1]))

Rnw_file = basename(args[1])
pdf_file = gsub(".Rnw", ".pdf", Rnw_file)
tex_file = gsub(".Rnw", ".tex", Rnw_file)
R_file   = gsub(".Rnw", ".R",   Rnw_file)


knit(input = Rnw_file,
     output = tex_file)

tools::texi2pdf(tex_file)

knit(input = Rnw_file,
     output = R_file,
     tangle = TRUE)
