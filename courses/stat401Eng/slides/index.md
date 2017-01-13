---
layout: page
title: STAT 544
tagline: slides
---
{% include JB/setup %}

Below are source (Rnw) and handouts for all course lectures. 
Instructions for compiling the Rnw files can be found below.

## Chapter slide source files


|Topic|Source|Handouts|
|---|---|---|
|Data Management|[Set01.Rnw](Set01/Set01_data_management.Rnw)|[Set01.pdf](Set01/Set01_data_management.pdf)|
|Data|[Set02.Rnw](Set02/Set02_data.Rnw)|[Set02.pdf](Set02/Set02_data.pdf)|

  



## Rnw compilation instructions

From the Rnw files you can construct the pdf slides or extract the R code.
You will need to have the R package `knitr` installed, i.e. 

    install.packages('knitr')

### Slides

To obtain the pdf, you will need to have [LaTeX installed](http://en.wikibooks.org/wiki/LaTeX/Installation) and in the path (etc). Then download the Rnw file (as an example, I will use `Ch01.Rnw`) and run

    knitr::knit2pdf('Set01_data_management.Rnw')

Alternatively, you can install [RStudio](http://www.rstudio.com/) and click on the `Compile PDF` button.

### R Code

To extract the R code, run 

    knitr::knit('Set01_data_management.Rnw', tangle=TRUE)
