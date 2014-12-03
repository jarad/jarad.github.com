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

The phrase *even after* is probably misleading as it implies there was difference even before taking into account those factors. 
But if these factors were not accounted for, i.e. the data were treated as two-sample data and the cognitive test scores were compared for righties and lefties, it is likely that no significant difference was found. 
The reason for this is that there is so much variability in cognitive tests scores within a handedness due to differences in factors such as health as infants and family background. 
So it is most likely that the significant differences between lefties and righties only appears *after* taking into account factors such as health as infants and family background. 
The latter comparison, taking into account other factors, is likely the relevant comparison, but it becomes easier to [lie with statistics](http://en.wikipedia.org/wiki/How_to_Lie_with_Statistics) by specifically searching for a combination of explanatory variables that result in a significant difference in cognitive test scores due to handedness.
