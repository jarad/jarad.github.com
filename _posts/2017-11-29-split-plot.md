---
layout: post
title: "Split plot"
description: ""
category: [Consulting]
tags: [modeling,split plot,lattice design]
---
{% include JB/setup %}

Looking at the effect of 3 different crates and 2 types of lamps on 
behavior of pigs. 
There are 3 barns each with 20 crates whose types are randomly determined
and never changed. 
The 20 crates are arranged in 2 rows of 10 with some columns being closer to 
the door. 
There will be 8 replicates of this experiment although the crate locations
will never be changed.

Currently the data is being collected for the first replicate.


## Advice

### Look at residuals from a simple analysis of the first replicate

Fit a model that simply includes crates, lamps, and their interaction. 
Then look at the residuals to see if patterns emerge in terms of 
barns, rows, columns, etc. 

### Ask to move the crates into an alpha-lattice design

Apparently moving the crates is hard. 
But a much better design could be used for these data to block the data 
better. 

