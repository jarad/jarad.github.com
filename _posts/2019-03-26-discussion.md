---
layout: post
title: "Complicated design and therefore analysis"
description: ""
category: [Consulting]
tags: [design, GLM, binomial]
---
{% include JB/setup %}

## Client question


### Design

Eight treatments  (2x4 factorial of germinated/not and 4 types of bacteria),
3 temperatures/chambers.
Within each chamber there are 10 pots per treatment combination. 

After the chamber, pots are set out in a greenhouse on a long shelf. 
They are organized so that the plants from each chamber are near each other.
With a chamber, the pots are put in 10 blocks with one pot of each treatment
in a block and the blocks are arranged on the shelf in order. 

Each pot has 5 plants in it and the response variable is (typically) the 
number of plants that have disease.

### Scientific question

How does temperature affect bacteria growth? 
How does germination affect bacteria growth?



## Consulting response

Plot the data.

For the initial post-chamber measurements, 
conduct separate analyses for each temperature with fixed effects for 
germinated/not germinated, bacteria types, and their interaction. 
Assess qualitative differences between chambers and indicate these differences
may be due to chambers or temperatures.


