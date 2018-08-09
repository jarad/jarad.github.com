---
layout: post
title: ""
description: "Sniper-spotter"
category: [Consulting]
tags: [repeated measures, split plot, cross-over, regression, contrasts]
---
{% include JB/setup %}

## Problem description

Factors 
 - Feedback: Private (18 teams) v Public (19 teams)
 - Teams have 1 sniper and 2 spotters
 - 4 trials for each team: 
   - first three trials have the same sniper
   - last trial has a different sniper

Responses (unclear what type of responses there are)
 - some team responses
 - some individuals respones
 
### Questions
 
- Do the teams/individuals learn?
- 

## Consulting response

Two possible approaches are 1) simplify and analyze with simpler models or 
2) model the whole structure and build contrasts. 
This experiment is a repeated measures, partial cross-over, split-plot design 
and thus will be complicated to construct. 

### Simplify and analyze with simpler models

This approach would involve calculating the appropriate differences to address
the scientific questions of interest. 
For example, to understand the impact of feedback on learning through 
differences in trial 1 and trial 3 at the team level, you can calculate 
differences for each team between trial 1 and trial 3 and then you just have 
a t-test model to compare public vs private.

### Model the whole structure and build contrasts

#### Team responses

A model for team responses will be relatively straight-forward but will need a
random effect for team that may call for a more sophisticated error structure
than exchangeability.

#### Individual responses

The individual responses have a split-plot structure with cross-over due to the
switching between trial 3 and trial 4.
