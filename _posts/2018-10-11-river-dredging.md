---
layout: post
title: "River dredging effect on biomass"
description: ""
category: [Consulting]
tags: []
---
{% include JB/setup %}

## Problem description

A single river has a dredged area. Two random sites are selected from areas
upstream of the dredged area, within the dredged area, and downstream of the 
dredged area.
At each site, a biomass sample is obtained.
This process is repeated three times each summer over 4 years with the same 
sites used each year. 

The model that is currently being used is 

`lmer(log(Biomass+1) ~ Treatment + Year +(1|Site), data=all)`

Client is interested in understanding the effect of treatment on biomass and
whether that effect is changing across the years.

### Client question(s)

- What model should be used to analyze these data when we are trying to 
understand the relationship between dredging and biomass?


## Consulting response

To reduce some of the correlation, average the two observations within a 
site-year-month combination.

Fit a model assuming independence and then look for patterns in residuals. 
The model should include fixed effects for treatment, year, and month. 
Due to the scientific question(s), 
you will likely want interactions between treatment and year, 
treatment and month, and possibly treatment, year, and month.




