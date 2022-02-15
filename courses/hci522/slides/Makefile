CMD := gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=

all: \
  01-Introduction/01-Introduction.pdf \
  02-Scientific_Process/02-Scientific_Process.pdf \
  03-Probability/03-Probability.pdf \
  04-Binomial_distribution/04-Binomial_distribution.pdf \
  05-Binomial_analysis/05-Binomial_analysis.pdf \
  06-Normal_distribution/06-Normal_distribution.pdf \
  07-Normal_analysis/07-Normal_analysis.pdf\
  08-Statistical_inference/08-Statistical_inference.pdf

%.pdf: %.Rnw commands.tex frontmatter.tex
	/Library/Frameworks/R.framework/Resources/bin/Rscript --vanilla makeslides.R $<

