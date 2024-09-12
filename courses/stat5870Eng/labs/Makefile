CMD := gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=
  
all: lab01/lab01.R \
	lab02/lab02.R \
	lab03/lab03.R \
	lab04/lab04.R \
	lab05/lab05.R \
	lab06/lab06.R \
	lab07/lab07.R \
	lab08/lab08.R \
	lab09/lab09.R \
	lab10/lab10.R \
	lab11/lab11.R \
	lab12/lab12.R 
  
%.html: %.Rmd
	Rscript --vanilla makelabs.R $<
	
%.R: %.Rmd
	Rscript --vanilla makelabs.R $<

