---
layout: post
title: "Non-significance after adjusting"
description: ""
category:  [Teaching]
tags: [media,STAT 401A]
---
{% include JB/setup %}

In a Washington Post article today concerning end-of-life treatments for doctors compared to the rest of us, Carolyn Johnson writes

> They found that the majority of physicians and non-physicians were hospitalized in the last six months of life and that the small difference between the two groups was not statistically significant after adjusting for other variables.

From what I can understand about the scientific article based on this article, I appreciate how the scientists performed their statistical analysis. 
It appears the scientists 

1. Provided a two-sample comparison for physicians vs non-physicians. 
1. Performed a regression analysis in order to include relevant variables and assessed the coefficient for the physician indicator.

The details are all important here. I would appreciate the post actually providing some metric of the difference. For instance percentages of physicians and non-physicians that were hospitalized in the last six months of life or mean number of months (out of 6) with standard deviation that physicians and non-physicians were hospitalized. 
For the regression analysis, the metric will depend on the response (whether it was binary or continuous).
Fortunately some metrics are provided in the remainder of the article, e.g. percentage of individuals who spent time in the ICU. 

More importantly, my initial reaction to the statement was that the easiest way to obtain non-significance is to just include too many other explanatory variables thus decreasing the degrees of freedom for error. 
In addition, any relationship between an explanatory variable and being a physician will result in a colinearity issue that could obscure the actual relationship between physician and time spent in hospital. 
So although with no adjustment there was little difference between physicians and non-physicians, I would have expected that after adjustment there would be a larger difference and that it may end up significant. 

Nonetheless, I'm not surprised by the ultimate conclusion.
That physicians act like anybody else at the end of life. 

