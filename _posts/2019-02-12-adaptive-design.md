---
layout: post
title: "Adaptive design of glove sensitivity"
description: ""
category: [Consulting]
tags: [design, GLMM, logistic]
---
{% include JB/setup %}

## Question

Test how gloves affect fingertip sensitivity. 5 types of gloves. 
Fingertip sensitivity is measured by a dome with 9 different distances between
grooves. 

Participants were always started on a middle distance dome and the goal
is to determine which orientation the dome is in. 
The participant gets 10 attempts for each distance.
Then if the participant does well, the distance is decreased making the test
more difficult or, if the participant did well, the distance is increased
making the test easier.
Typically stopping after either the participant gets 8 or above or 3-4 different
domes.




## Consulting response

Options:

- Just use the data for the start groove distance assuming everybody started 
with the same groove distance.
- Summarize each participant-glove by the end groove level and us this as the
response. The issue here is that the data were not collected consistently. 
- Take a weighted average of the dome groove distance with a weight that is 
related to the proportion correct. 
- Fit a mixed effect logistic regression model with fixed effects for glove and 
distance (continuous) and fixed/random effects for student. 
This model assumes there is no order effect for distance and gloves 
and the missing data are missing at random.

For next time:

- Randomly assign the order of gloves within each subject
- Have a procedure for distance and stick to it.
