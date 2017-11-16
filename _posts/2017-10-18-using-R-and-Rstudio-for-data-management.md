---
layout: post
title: "Using R and RStudio for data management"
description: ""
category: 
tags: [R,RStudio,data management]
---
{% include JB/setup %}

Working with the 
[STRIPS](https://www.nrem.iastate.edu/research/STRIPS/)
and
[Iowa Monarch Conservation Consortium](https://monarch.ent.iastate.edu/),
I have need for knowing the tools available in R for data management. 

I just found the book 
[Using R and Rstudio for Data Management, ....](http://a.co/grtlBGG)
by 
[Nicholas J. Horton](https://www.amherst.edu/people/facstaff/nhorton)
and [Ken Kleinman](https://www.umass.edu/sphhs/person/faculty/ken-kleinman)
which looks promising but has only a single chapter on data input/output
and a single chapter on data management.

## Data input/output

The first chapter of the book has the standard read/write functions for 
reading and writing data from various formats. 
The chapter is brief in that there is a single example of each read/write
function with, at most, one additional argument being discussed. 
Thus it is really a quick reference for those already familiar with R, 
but need to know what the function would be to read data in from another source.

The one function I was previously unaware of is `data.entry()` which allows a 
spreadsheet-like interface to enter data. 
For example,


{% highlight r %}
x = 1:4
data.entry(x)
{% endhighlight %}

will open up a spreadsheet that allows you to enter additional values for `x`
as well as add additional columns. 
Unfortunately this function is antiquated allowing only numeric and character
variables and provided no checks to make sure the data entered is valid.

## Data Management

The second chapter of the book contains information on what the authors refer 
to as Data Management but what I would call Data Manipulation. 
They discuss the creation of the new variables, the combining of data.frames, 
converting data.frames from wide to tall (or vice versa), etc.
All of this is vital, but I'm interested in Data Management in terms of Data
Entry, Data Checking, Metadata creation, etc.

There is a little bit of discussion on metadata through the use of the R
command `comment()` which I was unfamiliar with, but the authors suggest that 
we don't use this. 
[Apparently](https://stats.stackexchange.com/questions/4335/what-is-a-good-use-of-the-comment-function-in-r/4336#4336)
there are some similar functions in the 
[Hmisc package](https://cran.r-project.org/web/packages/Hmisc/index.html) 
that perform similar functions, e.g. `label()` and `units()`. 

## Summary

I think the R statistics community needs to create a good approach to data 
entry, e.g. automatic checking of data as it is entered, as one key aspect
of the data management pipeline. 
The `data.entry()` or `View()` functions maybe something to build on.

Overall, we need an approach to Data Management in R that includes data entry,
data checking, metadata creation, data manipulation, etc. 
Likely this will need to be an Opinionated approach to Data Management in R
(see [Opinionated Analysis](https://peerj.com/preprints/3210.pdf))
much the way that the [tidyverse](https://www.tidyverse.org/) is an 
opinionated approach to data manipulation.
