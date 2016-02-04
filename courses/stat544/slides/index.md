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

- [Chapter 01](Ch01/Ch01.Rnw)
- [Chapter 02a](Ch02/Ch02a.Rnw)
- [Chapter 02b](Ch02/Ch02b.Rnw)
- [Chapter 03a](Ch03/Ch03a.Rnw)
- [Chapter 03b](Ch03/Ch03b.Rnw)
- [Chapter 04](Ch04/Ch04.Rnw)
- [Chapter 05a](Ch05/Ch05a.Rnw)
- [Chapter 05b](Ch05/Ch05b.Rnw)
- [Chapter 06a](Ch06/Ch06a.Rnw)
- [Chapter 07a](Ch07/Ch07a.Rnw)
- [Chapter 07b](Ch07/Ch07b.Rnw)
- [AmazonReviews](AmazonReviews/AmazonReviews.Rnw)
- [Midterm Review](MidtermReview/midterm_review.Rnw)
- [Chapter 10a](Ch10/Ch10a.Rnw)
- [Chapter 10b](Ch10/Ch10b.Rnw)
- [Chapter 11a](Ch11/Ch11a.Rnw)
- [Chapter 11b](Ch11/Ch11b.Rnw)
- [Chapter 11c](Ch11/Ch11c.Rnw)
- [Chapter 11d](Ch11/Ch11d.Rnw)
- [Chapter 14a](Ch14/Ch14a.Rnw)
- [Chapter 14b](Ch14/Ch14b.Rnw)
- [Chapter 15a](Ch15/Ch15a.Rnw)
- [Chapter 15b](Ch15/Ch15b.Rnw)
- [Chapter 16a](Ch16/Ch16a.Rnw)
- [Chapter 16b](Ch16/Ch16b.Rnw)

