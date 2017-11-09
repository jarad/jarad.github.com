KnitPost <- function(input, 
                     outfile = paste0("../_posts/", 
                                      gsub("Rmd","md",input)), 
                     base.url = "/") {
  # this function is a modified version of an example here:
  # http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
  require(knitr);
  opts_knit$set(base.url = base.url)
  fig.path <- paste0("../figs/", sub(".Rmd$", "", basename(input)), "/")
  opts_chunk$set(fig.path = fig.path)
  opts_chunk$set(fig.cap = "center")
  render_jekyll()
  knit(input, outfile, envir = parent.frame())
}
