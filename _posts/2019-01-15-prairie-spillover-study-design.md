---
layout: post
title: "Prairie spillover analysis"
description: ""
category: [Consulting]
tags: [design, GLMM, GLM, mixed model]
---
{% include JB/setup %}

## Question

To assess prairie spillover from remnant prairie or agricultural fields, 
transects were constructed running away from the prairie and fields into 
reconstructed prairies. 
Along each transect, quadrats were placed alternately along the transect with
distance increasing the farther you are away from the prairie or field. 

Each reconstruction had 2 transects and each transect has 7 quadrats. 

Statistical analysis was a log-transformed richness 
(with planted species and crop species removed) with type of field 
(remnant vs agriculture), categorical distance from boundary, 
and binary reconstruction species richness 
(how many species were planted in the reconstruction) and
possibly interactions in a regression model.

### Client Question





## Consulting response

Correlation between quadrats on a transect and transects within a reconstruction
should be modeled. Add a random effect for the field. Add a random effect for 
transect or, possibly, construct a serial correlation that results in quadrats
that are closer together are more correlated. 

### Questions

- Is the pairing in the figure consistent throughout the design?