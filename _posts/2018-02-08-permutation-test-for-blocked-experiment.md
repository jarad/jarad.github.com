---
layout: post
title: "Permutation test for randomized complete block design"
description: ""
category: [Consulting]
tags: [permutation test,randomized complete block design,RCBD]
---
{% include JB/setup %}


## Data

Treatments:

 - 1 plant
 - 5 plants
 - 10 plants
 
Response is number of eggs in each treatment across 32 blocks
 
### Question

Can we do a permutation test to determine whether there is an effect of 
treatment?
 
## Analysis

For a blocked design, 
the permutation test should permute treatments within a block.

Previously used a negative binomial regression model.


## Advice



### Concerns

How is the experiment run? 
Are all 32 blocks run simultaneously? 
Is there only one cage and it is reused 32 times. 
How many butterflies are put in each cage?

### Permutation test

Permute treatments within a block

### Responsible variable

There is a decision to be made about whether the response is the number of eggs
(in a treatment unit) or the number of eggs per plant (in a treatment unit).

