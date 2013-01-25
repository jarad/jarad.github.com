---
status: publish
published: false
layout: post
title: "Flu effectiveness"
description: ""
category: [R]
tags: [R, flu]
---
{% include JB/setup %}
 
 
 
A [post](http://blog.minitab.com/blog/adventures-in-statistics/how-effective-are-flu-shots) by [Jim Frost](http://blog.minitab.com/blog/adventures-in-statistics) came out yesterday on minitab's blog about the effectiveness of [flu vaccines](http://www.cdc.gov/flu/protect/vaccine/index.htm). Like the author of that post, 
 
> I get a flu shot every year even though I know they're not perfect. I figure they're a relatively easy and inexpensive way to reduce the chance of having a miserable week.
 
In contrast to that author, I had never thought about what 60% effectiveness means for a flu vaccine. The author collected data from two randomized controlled trials (RCT) and then explained how to analyze the data in minitab. I thought I would do the same here, but in R. 
 
## Beran Trial

    beran = data.frame(treatment = c("shot", "placebo"), flu.count = c(49, 74), 
        group.size = c(5103, 2549))
    beran

    ##   treatment flu.count group.size
    ## 1      shot        49       5103
    ## 2   placebo        74       2549

We can compare the proportions in the two groups via

    prop.test(beran$flu.count, beran$group.size)

    ## 
    ## 	2-sample test for equality of proportions with continuity
    ## 	correction
    ## 
    ## data:  beran$flu.count out of beran$group.size 
    ## X-squared = 39.35, df = 1, p-value = 3.538e-10
    ## alternative hypothesis: two.sided 
    ## 95 percent confidence interval:
    ##  -0.02677 -0.01209 
    ## sample estimates:
    ##   prop 1   prop 2 
    ## 0.009602 0.029031

Alternatively we could have analyzed this from a Bayesian perspective, e.g. using a uniform prior distribution for the flu probabilities in both groups

    n.reps = 10000
    a = b = 1  # prior hyperparameters
    p.shot = rbeta(n.reps, a + beran$flu.count[1], b + beran$group.size[1] - beran$flu.count[1])
    p.plac = rbeta(n.reps, a + beran$flu.count[2], b + beran$group.size[2] - beran$flu.count[2])
    
    quantile(p.shot - p.plac, c(0.025, 0.5, 0.975))

    ##     2.5%      50%    97.5% 
    ## -0.02698 -0.01951 -0.01267

where p.shot and p.placebo are samples of the probability from the posterior distribution. The quantiles are the 2.5%, 50%, and 97.5% quantiles for the difference in the flu probabilities for the two groups, negative indicating the shot group had a lower probability of getting the flu.
 
Now we can calculate the vaccine effectiveness and its uncertainty

    quantile(1 - p.shot/p.plac, c(0.025, 0.5, 0.975))

    ##   2.5%    50%  97.5% 
    ## 0.5283 0.6676 0.7699

So we have an estimate of 67% and a 95% credible interval of (0.53, 0.77).
 
 
 
## Monto Study

    monto = data.frame(treatment = c("shot", "placebo"), flu.count = c(28, 35), 
        group.size = c(813, 325))
    monto

    ##   treatment flu.count group.size
    ## 1      shot        28        813
    ## 2   placebo        35        325

We can compare the proportions in the two groups via

    prop.test(monto$flu.count, monto$group.size)

    ## 
    ## 	2-sample test for equality of proportions with continuity
    ## 	correction
    ## 
    ## data:  monto$flu.count out of monto$group.size 
    ## X-squared = 22.44, df = 1, p-value = 2.164e-06
    ## alternative hypothesis: two.sided 
    ## 95 percent confidence interval:
    ##  -0.11136 -0.03514 
    ## sample estimates:
    ##  prop 1  prop 2 
    ## 0.03444 0.10769

Alternatively we could have analyzed this from a Bayesian perspective, e.g. using a uniform prior distribution for the flu probabilities in both groups

    n.reps = 10000
    a = b = 1  # prior hyperparameters
    p.shot = rbeta(n.reps, a + monto$flu.count[1], b + monto$group.size[1] - monto$flu.count[1])
    p.plac = rbeta(n.reps, a + monto$flu.count[2], b + monto$group.size[2] - monto$flu.count[2])
    
    quantile(p.shot - p.plac, c(0.025, 0.5, 0.975))

    ##     2.5%      50%    97.5% 
    ## -0.11161 -0.07375 -0.03971

where p.shot and p.placebo are samples of the probability from the posterior distribution. The quantiles are the 2.5%, 50%, and 97.5% quantiles for the difference in the flu probabilities for the two groups, negative indicating the shot group had a lower probability of getting the flu.
 
Now we can calculate the vaccine effectiveness and its uncertainty

    quantile(1 - p.shot/p.plac, c(0.025, 0.5, 0.975))

    ##   2.5%    50%  97.5% 
    ## 0.4806 0.6775 0.8013

So we have an estimate of 68% and a 95% credible interval of (0.49, 0.80).
 
## Absolute effectiveness 
 
I appreciate that Jim Frost went further and was interested in how to interpret this effectiveness number. As he points out, the number is the *vaccine effectiveness* which is the inverse of the *relative risk*. Thus if you get the flu shot you are 1/3 as likely to get the flu as a nonvaccinated individual.
 
It is certainly much more meaningful to understand your probability of catching the flu if you are vaccinated versus if you are not. Jim provides these data and they are repeated here

    prob = data.frame(season = c("1997/98", "1998/99", "2006/07", "2007/08"), placebo = c(4.4, 
        10, 2.9, 10.8), flu.shot = c(2.2, 1, 1, 3.4))
    prob

    ##    season placebo flu.shot
    ## 1 1997/98     4.4      2.2
    ## 2 1998/99    10.0      1.0
    ## 3 2006/07     2.9      1.0
    ## 4 2007/08    10.8      3.4

    mean(prob$placebo)

    ## [1] 7.025

    mean(prob$flu.shot)

    ## [1] 1.9

    prob$placebo - prob$flu.shot

    ## [1] 2.2 9.0 1.9 7.4

    mean(prob$placebo - prob$flu.shot)

    ## [1] 5.125

So, if you get the flu shot your average probability of getting the flu is around 1.9% and if you do not it is around 7%, but these are extremely variable from year to year. The other aspect to consider is the [public health benefit](http://www.who.int/bulletin/volumes/86/2/07-040089/en/) from getting the flu shot and therefore not getting and spreading the flu. 
 
