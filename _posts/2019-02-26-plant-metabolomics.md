---
layout: post
title: "Plant metabolomics"
description: ""
category: [Consulting]
tags: []
---
{% include JB/setup %}

15 species with 3 plants per species and 2 technical replicates of a vector
(length of 27) metabolomic measurements on each plant. 
The metabolites can be split into sugars (3) and amino acids (24). 
Plant species can be categorized by Section (10 levels) and Pollinator 
species (5 levels).
Also, pollinator species are not mutually exclusive, 
i.e. each plant species can be pollinated by more than 1 species. 
Each plant species flowers at day or night.




### Question

What affects metabolite expression? Section or pollinator species?

### Previous analysis

1. PCA on 27 vector response (averaged over technical rep?). 
Unclear how to interpret.
1. Analyze each metabolite separately. Average metabolite measurements across
technical replicates. Fit cell means model, a mean for each species, and 
construct contrasts for pairwise comparisons among section and pairwise
comparison among pollinator species. 
1. Analyze each metabolite separately. Average metabolite measurements across
technical replicates and plants within a species. Fit a model with section 
and assess an F-test with pvalue for inclusion of section. Fit a model with
pollinator species and assess an F-test with pvalue for inclusion of 
pollinator species. 


## Consulting response

With 15 species, making statements about differences among section and 
differences among pollinator species seems tenuous. 
In addition, these 15 species can be a large portion of the species within a
section and therefore finite population corrections my be needed.
