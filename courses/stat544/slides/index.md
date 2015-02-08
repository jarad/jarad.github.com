---
layout: page
title: STAT 544
tagline: slides
---
{% include JB/setup %}

The following files contain code to create slides for the associated chapters of [Bayesian Data Analysis, 3rd edition](../textbook.html). You will need to have the R package `knitr` installed, i.e. 

    install.packages('knitr')

To obtain the pdf, you will need to have [LaTeX installed](http://en.wikibooks.org/wiki/LaTeX/Installation) and in the path (etc). Then download the Rnw file (as an example, I will use `Ch01.Rnw`) and run

    knitr::knit2pdf('Ch01.Rnw')

Alternatively, you can install [RStudio](http://www.rstudio.com/) and click on the `Compile PDF` button.

To extract the R code, run 

    knitr::knit('Ch01.Rnw', tangle=TRUE)

## Chapter slide source files

- [Chapter 01](Ch01.Rnw)
- [Chapter 02a](Ch02a.Rnw)
- [Chapter 02b](Ch02b.Rnw)
- [Chapter 03a](Ch03a.Rnw)
- [Chapter 04](Ch04.Rnw)
- [Chapter 05a](Ch05a.Rnw)
