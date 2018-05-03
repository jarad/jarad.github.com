---
layout: post
title: "Binary response with temporal explanatory variables"
description: ""
category: [Consulting]
tags: [LDA, binary]
---
{% include JB/setup %}

## Problem description

240 plots (with a 160 soybean plants) in a field where we measure a continuous 
response for each of 8 wavelengths repeated over 12 days that are close but 
not quite equally spaced. 
In addition, we measure a binary SDS diseased/not diseased status.
Both the wavelength measurements and diseased status are measured at the plot 
level.

Client wants to do a functional analysis based on a suggestion from their 
advisor.

### Scientific question

Want to classify disease status based on wavelength information.

### Questions

Will disease status of plots affect nearby plots?

## Advice

Use final disease status as the response. 
For each timepoint and wavelength, perform a t-test with the two groups 
determined by disease status. 
See how the significance changes temporally.


