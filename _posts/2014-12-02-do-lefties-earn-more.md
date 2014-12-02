---
layout: post
title: "Do lefties earn more?"
description: ""
category: 
tags: [401A]
---
{% include JB/setup %}

[This article](http://www.bloombergview.com/articles/2014-12-01/lefthanded-prepare-to-earn-less) discusses a variety of (possible) differences between right-handed and left-handed individuals.
For example, 

> He found lefties on average score lower on cognitive tests than righties, even after taking into account factors such as their health as infants and family background.

Here cognitive test scores is the response, the explanatory variable of interest is handedness, and the analysis adjusts for other reasonable factors such as health as infants and family background. 
This is likely analyzed using [multiple regression](../courses/stat401A/slides/Ch09.pdf) and at some point there was a likely a [variable selection](../courses/stat401A/slides/Ch12.pdf) procedure done to account for relevant factors.
Apparently health as infants and family background remained in the model after performing this variable selection. 
Finally, the coefficient for handedness was examed and it was found that lefties average score was lower than righties after taking into account the other relevant factors. 

