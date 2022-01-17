CMD := gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=

ALL := \
  01-Introduction/01-Introduction.pdf

all: \
  01-Introduction/01-Introduction.pdf

%.pdf: %.Rnw commands.tex frontmatter.tex
	/Library/Frameworks/R.framework/Resources/bin/Rscript --vanilla makeslides.R $<

