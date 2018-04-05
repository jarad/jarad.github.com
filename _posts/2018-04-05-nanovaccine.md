---
layout: post
title: "Nanovaccine"
description: ""
category: [Consulting]
tags: [ANOVA, PCA]
---
{% include JB/setup %}

## Problem description

Each treatment is a vaccine plus an adjuvant.
There are a total of 4 treatments associated with 4 adjuvants. 
Innoculate 16 mice per treatment. 
At 3 different time points post treatment, 
blood samples are drawn and reactivity to 80 different peptides was 
measured where
reactivity near zero indicates little reactivity.



## Advice

Take log of reactivity. 
Run ANOVA for comparing all means except control and adjust for false 
discovery rate. 
Use PCA to check for interesting patterns.