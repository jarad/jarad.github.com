---
layout: post
title: "Ignoring interactions"
description: ""
category: [Consulting]
tags: [modeling]
---
{% include JB/setup %}

In our consulting meeting today, we discussed situations when interactions 
can be ignored. 
To focus the discussion, 
we decided to consider a hypothetical experiment with treatment and blocks so 
that the two (linear) models under consideration contain the following effects

  1. treatment, block
  1. treatment, block, and treatment-block interaction
  
The main question is when is it okay to ignore the interaction model and just 
report the non-interaction model.

**tl;dr: Basically every one wanted to at least test for the interaction in the 
second model before simply reporting the first.**


## Scenarios

To try and focus conversation, I suggested a few hypotheticals.


### There is only one replicate for each treatment-block combination

In the experiment, you only have a single replicate for each treatment-block
combination.
Can you report the non-interaction model?

**Yes, basically it is all you can do.**

Although there are some approaches to look at the saturated model, 
basically the most you can do is report the non-interaction model.


### I never looked at the interaction model

Suppose I have been introduced to regression analyses, but have somehow 
didn't get introduced or didn't understand interactions.
Is it okay for me to just report the non-interaction model?

**Ignorance is no excuse.**

This seemed to be a poor justification for ignoring the interaction model.


### You have tested the interaction and it is not significant

Suppose you looked at both models, tested the interaction, and found that it 
is not significant (say at the 0.05 level). 
Can you report the non-interaction model (perhaps also stating you testing the
interaction and found it to not be significant)?

**Yes, but why bother.**

I believe people seemed to be okay with this, but they also pointed out that 
you could just fit the interaction model (since it is suggested by the design)
and use a contrast to address the mean treatment effect.


### My only scientific interest is average treatment effects

Suppose you have indicated that average treatment effects are your primary 
interest. 
Then can you report the non-interaction model since it directly answers your
primary question?

**Generally seen as okay since generally you will be conservative, but some 
still want to look at the interaction model.**

If you ignore the interaction, your estimate for the error variance will be 
biased, but the degrees of freedom for the error increases. 
Depending on the direction of the bias, 
ignoring the interaction can be liberal or conservative with respective to 
significance of the treatment effect. 

If the F statistic for the interaction is greater than 1, 
then the estimated error variance in the non-interaction model will be larger 
than the estimated error variance in the interaction model. 
If the F statistic is enough greater than 1 (to over-compensate for the 
degrees of freedom), 
then you will be conservative if you report the non-interaction model.


### You have fit both models and qualitatively they give the same results

Suppose you looked at both models and the qualitative result for the treatment 
effect (which is what you care about) is the same under both models,
e.g. treatment is still significant in the same direction.
Can you report the non-interaction model (perhaps also stating the results
are the same (for treatment) with the interaction model)?

**Yes, but why bother.**

I believe people seemed to be okay with this, but they also pointed out that 
you could just fit the interaction model (since it is suggested by the design)
and use a contrast to address the mean treatment effect.


### Your target audience would not understand the interaction model

Suppose the results are the same from both models and your audience will have 
a hard time understanding the interaction model.
Can you report the non-interaction model?

**Does this ever occur?**

It seems people had a hard time conceiving of a situation where people would be
familiar with multiple regression models but not familiar with interactions.


### You have pre-specified your analysis and specified the non-interaction model

Suppose you have pre-specified the analysis, say for a clinical trial, 
and you specified the non-interaction model.
Can you report the non-interaction model?

**You have to, but also report the interaction model.**

Since that is what you pre-specified that you would do, 
you need to report the non-interaction model. 
But you should also take the time to fit and report the interaction model.



## Additional thoughts

In this discussion a number of other questions came up that we did not have 
time to address

  - Should these effects be fixed or random?
  - Should you include all possible interactions in more complex models, e.g. a
    4-way factorial design?
  - The educational background of the individuals in the room is generally more
    of a randomization-based rather than model-based approach to statistics. 
    So if other statisticians were in the room they may answer differently. 
    [The statistics of linear models: back to basics](https://link.springer.com/article/10.1007/BF00156745)
    was a suggested reading.