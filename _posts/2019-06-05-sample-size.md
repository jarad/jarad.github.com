---
layout: post
title: "Sample size"
description: ""
category: [Consulting]
tags: [sample size, power]
---

{% include JB/setup %}

## Approaches for sample size determination

1. n=3 for each combination of treatments
1. as large as budget allows
1. SE/CI width for quantity of interest
1. 80% power (for 5% Type I error) for quantity of interest

CI width depends primarily on the SE while power also depends on a hypothesized
value (or pilot study) for the quantity of interest.

### Sample size calculations based on power approach

We need the client to tell us

- Type I error rate (a)
- Power (b)
- Within treatment variability (s)
- Hypothesized difference for quantity of interest (d)

Shifted t approximation

d = (t_{1-a/2,df} + t_{b,df})*se

where df and se are functions of n. 
For example, if n is the number of observations per group, then

- one sample (paired) t-test: se = s/sqrt(n), df=n-1
- two sample t-test: se = s*sqrt(2/n), df=2n-2
- interaction for 2x2 factorial: se = s*sqrt(4/n), df=4n-4
- main effect in a 2x3 factorial: se = s*sqrt(2/3n), df = 6n-6
- iteraction in a 2x3 factorial: se = s*sqrt(3/4n), df = 6n-6

With multiple comparisons can adjust Type I error using Bonferroni. 
For multiple outcomes, use most important or outcome with the smallest 
d/s.


