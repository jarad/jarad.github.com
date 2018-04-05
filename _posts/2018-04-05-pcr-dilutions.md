---
layout: post
title: "PCR Dilutions"
description: ""
category: [Consulting]
tags: [PCR]
---
{% include JB/setup %}

## Problem description

Dilution experiment where at each dilution there are 3 samples and within these 
there are an additional 10 sub-samples.
Measurements on these samples are taken, 
but for values 40 and above, the result is censored.

The main question of interest is to provide a probability the next observation
from a particular sample will be censored given one observation from that 
sample. 

## Advice

Given the data we have, we can construct a curve for the relationships between
the standard deviation and mean in the original data. 
From the consultant, 
it appears the relationship is positive. 

Since we only have one observation for the main question of interest, 
the value for this observation is our best guess about the mean for that sample
and the standard deviation will be determined by the mean-sd relationship in
the previous paragraph. 
Given the mean and standard deviation, 
you can calculate a probability a normal with that mean and sd will be above 
the censoring threshold. 