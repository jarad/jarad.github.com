---
layout: page
title: STAT 544
tagline: slides
---
{% include JB/setup %}

Below are source (Rnw) and handouts for all course lectures. Instructions for compiling the Rnw files can be found below.

## Chapter slide source files

- Chapter 1
  - Bayesian statistics [Ch01.Rnw](Ch01/Ch01.Rnw) [Ch01.pdf](Ch01/Ch01.pdf)
- Chapter 2
  - Binomial model/priors [Ch02a.Rnw](Ch02/Ch02a.Rnw) [Ch02a.pdf](Ch02/Ch02a.pdf)
  - Normal model/computation [Ch02b.Rnw](Ch02/Ch02b.Rnw) [Ch02a.pdf](Ch02/Ch02b.pdf)
- Chapter 3
  - Independent binomials/normal [Ch03a.Rnw](Ch03/Ch03a.Rnw) [Ch03a.pdf](Ch03/Ch03a.pdf)
  - Multinomial/multivariate normal [Ch03b.Rnw](Ch03/Ch03b.Rnw) [Ch03b.pdf](Ch03/Ch03b.pdf)
- Chapter 4
  - Data asympotitics [Ch04.Rnw](Ch04/Ch04.Rnw) [Ch04.pdf](Ch04/Ch04.pdf)
- Chapter 5
  - Binomial hierarchical model [Ch05a.Rnw](Ch05/Ch05a.Rnw) [Ch05a.pdf](Ch05/Ch05a.pdf)
  - de Finetti/normal hierarchical model [Ch05b.Rnw](Ch05/Ch05b.Rnw) [Ch05b.pdf](Ch05/Ch05b.pdf)
- Chapter 6
  - Model checking [Ch06.Rnw](Ch06/Ch06.Rnw) [Ch06.pdf](Ch06/Ch06.pdf)
- Chapter 7
  - Hypothesis testing [Ch07a.Rnw](Ch07/Ch07a.Rnw) [Ch07a.pdf](Ch07/Ch07a.pdf)
  - Comparison to LRTs [Ch07b.Rnw](Ch07/Ch07b.Rnw) [Ch07b.pdf](Ch07/Ch07b.pdf)
- Reviews
  - [AmazonReviews.Rnw](AmazonReviews/AmazonReviews.Rnw) [AmazonReviews.pdf](AmazonReviews/AmazonReviews.pdf)
  - [MidtermReview.Rnw](MidtermReview/midterm_review.Rnw) [MidtermReview.pdf](MidtermReview/midterm_review.pdf)
  
Below are (to be organized)
  
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


## Rnw compilation instructions

The following files contain code to create slides for the associated chapters of [Bayesian Data Analysis, 3rd edition](../textbook.html). You will need to have the R package `knitr` installed, i.e. 

    install.packages('knitr')

To obtain the pdf, you will need to have [LaTeX installed](http://en.wikibooks.org/wiki/LaTeX/Installation) and in the path (etc). Then download the Rnw file (as an example, I will use `Ch01.Rnw`) and run

    knitr::knit2pdf('Ch01.Rnw')

Alternatively, you can install [RStudio](http://www.rstudio.com/) and click on the `Compile PDF` button.

To extract the R code, run 

    knitr::knit('Ch01.Rnw', tangle=TRUE)
