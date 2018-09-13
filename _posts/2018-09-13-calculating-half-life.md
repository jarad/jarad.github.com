---
layout: post
title: "Calculating half-life"
description: ""
category: [Consulting]
tags: [regression, pigs, random effect]
---
{% include JB/setup %}

## Problem description

Half-life of drug in SCID, pigs that have no immune system. 
A total of 6 SCID pigs and 8 SCID pigs in 3 litters where the first litter 
was bottle fed and the latter two were nursed. The first litter has 2 SCID pigs
and 2 non-SCID pigs. 

Main scientific question is whether there is a difference in half-life between 
SCID and non-SCID pigs. 

Approach 1) Currently modeling the log of the amount of drug and calculating the half-life.
Then fitting another model for the calculated half-life using SCID and litter
as fixed effects.

Approach 2) Separately fitting a mixed effect model on the log of the amount of drug and 
including SCID, time, and SCID x time as fixed effects and a random effect for 
pig. 

Client question is "How are these models the same/different?"


## Consulting response

Approach 2) has a common slope for all pigs. 
If a random coefficient for time by pig is included in Approach 2), 
it gets closer to the first approach. 

We would suggest modeling the logarithm of the drug amount using 
litter, SCID, time, and SCID x time as fixed affects and (time|pig) as a random
effect.

The main quantity of interest to answer the scientific question of interest is 
the coefficient for the SCID x time interaction which determines if there is 
a difference in degradation, on average, between the SCID and non-SCID pigs. 
It may be of interest to calculate the slope (coefficient for time) for both 
SCID and non-SCID pigs along with their confidence intervals. Then to interpret
the half-life, use the equation halflife = ln(2)/slope to calculate the point
estimate and confidence interval for the halflife. 


