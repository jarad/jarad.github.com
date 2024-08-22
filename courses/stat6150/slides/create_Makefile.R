# Creates the Makefile to create lectures slides

lectures = c('M1-1')

#######################################################################

makefile = 'Makefile'

screen_width = 70

catf = function(...) cat(..., '\n', sep='', file=makefile, append=TRUE)

cat(rep('#', screen_width), '\n', sep='', file=makefile, append=FALSE)
catf('#     DO NOT TOUCH: Automatically created using create_Makefile.R')
catf(rep('#', screen_width),'\n')

#################################################

pdfs = paste0(lectures,'.pdf', collapse=' ')

catf('lectures: ', pdfs, '\n')

catf('clean:')
catf('\trm -f *.aux *.dvi *.fdb_latexmk *.fls *.log *.nav *.out *.snm *.synctex.gz *.tex *.toc *.vrb')

catf('zip: lectures\n\tzip stat544.zip ', pdfs)


#################################################

catf(rep('#', screen_width),'\n')

for (l in lectures) {
  catf(l, ': ', l, '.pdf')
  catf(l,'.pdf: ',l,'.Rnw')
  catf('\tRscript -e "library(knitr); knit(\'',l,'.Rnw\')"')
  catf('\tpdflatex ',l,'.tex')
  catf('\tpdflatex ',l,'.tex')
  catf()
}

