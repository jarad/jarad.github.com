---
layout: post
title: "Bayes Rule for haploid identification"
description: ""
category: [Consulting]
tags: [modeling]
---
{% include JB/setup %}

Two genotypes: haploid and diploid. 

Over a series of 9 days, root lengths on various plants are measured. 
The goal is, for a new sample, determine whether the sample comes from a 
haploid or a diploid based on its root length.


## Advice

Use Bayes Rule. 
Let H be haploid and L>k be the event the root length is greater than a 
cutoff of k. 
Bayes Rule says 

P(H|L>k) = 
P(L>k|H)P(H)/(P(L>k|H)P(H) + P(L>k|D)P(D)) = 
1/[P(L>k|D)/P(L>k|H) x P(D)/P(H)]

where 

- P(H) is the prevalence of haploids, P(D) = 1-P(H)
- P(L>k|H), [P(L>k|D)] is the probability a haploid [diploid] has root length greater than k

The prevalence needs to be determined from external data, 
but the probability the root length is greater than k can be determined from
the data at hand. 
Uncertainty could be incorporated in these probabilities by assuming a prior.