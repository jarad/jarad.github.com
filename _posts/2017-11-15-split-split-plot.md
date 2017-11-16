---
layout: post
title: "Split-split plot"
description: ""
category: [Consulting]
tags: [modeling,split plot,split-split plot]
---
{% include JB/setup %}



## Data structure

### Split-split plot design

2 sites:

- site 1 has 2 years
- site 2 has 1 years 

3 treatments:

- whole plot: mowing (2 levels: mowed or not mowed)
- subplot: herb (3 levels)
- subsubplot: seeding rate (3 levels)

4 blocks at each site

### Response

Response is number of seedlings which has a lot of zeros which means it is 
(marginally) extremely right-skewed.
Site 1 observations in the second year is seedling survival in year 2.


## Current analysis

Separately consider each site-year combination. 
Mixed-effect Poisson regression model with fixed effects:

- block
- mowing
- herb
- seed
- mowing X herb
- herb X seed
- mowing X weed
- mowing X herb X seed

and random effects:

- block X mowing
- block X mowing X herb.

### SAS PROC GLIMMIX

Model did not converge. 
All fixed effect interactions were removed.
Model converged, but overdispersion is present and the estimated variance for 
block X mowing is large (1.6) on this log-link. 

## Exploratory analysis

Often have all zeros for certain combinations which would result in 
non-convergence of the model with all the interactions.

## Advice

Cell-means model is too general because some combinations of treatment have 
all zeros. 
Dropping fixed effect interactions is one way to simplify the model. 

Another approach is to 
treat herb and seeding rate to be continuous and have a linear effect on the 
mean in order to deal with combinations that have all zeros.
The mowing X block X herb interaction should use a categorical version of 
herb rather than the continuous version of the herb so that there is a random
effect associated with the subsubplot rather than a different slope associated
with the subsubplot.

It turns out that this model seems to fit well for these data. 
The variance estimate is large for the mowing X block X herb random effect 
rather than for the mowing X block random effect.

Another option is to eliminate the treatment herbicide treatment as basically 
the seedling count is also zero for this treatment.
