---
layout: post
title: "Flow cytometry"
description: ""
category: [Consulting]
tags: [manova, repeated measures]
---
{% include JB/setup %}

## Problem description

Flow cytometry on 29 healthy and 21 infected individuals. 
For healthy individuals, measured proportions of cells of 5 different types once.
For infected individuals, measured proportions 3 times at different stages in
the infection. 
Scientific question is to understand differences between healthy and 
infected individuals and temporal changes in the infected group in cell 
type proportions.


## Consulting response

A repeated measures MANOVA is one possible approach to analyze the infected individuals.
We would typically use SAS to fit models like these.
It appears you can do a 
[repeated measures MANOVA](https://stats.stackexchange.com/questions/183441/correct-way-to-perform-a-one-way-within-subjects-manova-in-r), but this may not allow an appropriate correlation 
structure for both healthy and infected individuals. 




