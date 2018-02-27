---
layout: post
title: "Heteroskedasticity in bird point counts"
description: ""
category: [Consulting]
tags: [Poisson regression,Poisson]
---
{% include JB/setup %}


## Problem description

### Data

Bird (Dabbling Ducks) count data on 30 wetlands for 2 years for about 10 weeks.

### Modeling

Starting with a mixed effect Poisson regression model.
Then moved to 
a mixed effect linear model using square root of the count as the response
and week as a weight (due to heteroskedasticity by week).

#### Fixed effects

- Week (numeric or categorical)
- Emergent
- Year
- Area
- Age of wetland
- WC ?

#### Random effects

- site
- site x year


### Results

Heteroskedasticity appears to exist with more variability in early weeks 
compared to later. 



## Advice

Think about

- At least for model building, use linear model with square root of count
- Treat week as categorical
- Consider repeated measures structure on random effects
- Try the analysis in SAS so that you have easier control of random effects
and error variances
