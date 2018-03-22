---
layout: post
title: "Incomplete block design"
description: ""
category: [Consulting]
tags: [design, incomplete block]
---
{% include JB/setup %}


## Problem description

### Design

The experiment has 9 genotypes, 2 treatments, and 3 blocks. 
Each block only has a limited number of experimental units and 
thus a block was limited to have 3 genotypes under both treatments and 
2 checks/controls. 
Typically the checks/controls are replicated while some of the other 
genotype-treatment combinations may not be replicated.

SAS is having difficulty fitting the model even when constructing a new 
"treatment" variable that combines genotype-treatment into a single 
variable.


## Advice

SAS should be able to fit this model perhaps the new treatment variable is 
miscoded?

