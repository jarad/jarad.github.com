---
layout: post
title: ""
description: "Fish stress"
category: [Consulting]
tags: [regression, exploratory, clustering]
---
{% include JB/setup %}

## Problem description

Nine trucks with a couple hundred fish each. 
Each truck starts from the same location, but have a different destination
across 3 years.
For each truck, we have year, distance, and some water measurements. 
For a sample of fish, measures of stress were collected e.g. cortisol.
Fish measurements were taken on different samples at times 0 (at hatchery), 
2 (after arrival), 24, and 48 hrs. 

### Question

How can we perform an exploratory analysis on these data?

## Consulting response

For an exploratory analysis, plot the fish measurements vs explanatory variables
and times (or different plots for each time).

Calculate a mean and sd across the fish for each of the 36 combinations of 
truck and sample times.
For an exploratory analysis, plot the mean (and sd) 
truck-time responses versus individual explanatory variables. 
Fit a regression model for the mean (and sd) truck-time responses versus 
individual explanatory variables.

Take a look at proportion of fish that died across the times as an additional
measure of stress.
