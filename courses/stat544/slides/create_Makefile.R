# Creates the Makefile to create lectures slides

lectures = c('Ch01',
             'Ch02a','Ch02b',
             'Ch03a',
             'Ch04',
             'Ch05a','Ch05b',
             'Ch06a','Ch07a','Ch07b','Ch10a','Ch10b',
             'Ch11a','Ch11b','Ch11c','Ch11d',
             'Ch14a','Ch14b','Ch15a','Ch15b',
             'Ch16a','Ch16b',
             'AmazonReviews')

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

