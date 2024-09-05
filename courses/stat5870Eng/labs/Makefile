CMD := gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=
  
all: lab01/lab01.html \
	lab02/lab02.html \
	lab03/lab03.html \
	lab04/lab04.html \
	lab05/lab05.html \
	lab06/lab06.html \
	lab07/lab07.html \
	lab08/lab08.html \
	lab09/lab09.html \
	lab10/lab10.html \
	lab11/lab11.html \
	lab12/lab12.html 
  
%.html: %.Rmd
	Rscript --vanilla makelabs.R $<
	
%.R: %.Rmd
	Rscript --vanilla makelabs.R $<

