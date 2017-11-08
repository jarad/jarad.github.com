---
layout: post
title: "Ignoring interactions (part 2)"
description: ""
category: [Consulting]
tags: [modeling,interactions]
---
{% include JB/setup %}

This is a continuation of a 
[previous meeting]().

## Data structure

This time there is a specific client who has a completely randomized
block design with two factors at two levels and a completely 
randomized design within each block with 2 replicates of each 
combination of the two factors. 

Since only 8 experimental units, 
can be analyzed at a time, 
the blocks are groupings in time and 
blocks were constructed by ensuring the average weight in each 
block was similar. 

Three-way interaction is significant, 
but the clients are wondering if they can remove this interaction.

### ANOVA table for fixed effects

#### Treating as 2 treatment factors

|Factor|df|
|------|--|
|B|3|
|Z|1|
|D|1|
|ZxD|1|
|-|-|
|BxZ|3|
|BxD|3|
|BxZxD|3|
|-|-|
|Error|16|

#### Treating as 1 treatment with 4 levels

Alternatively, you could consider 1 treatment with
4 levels rather than 
2 treatments each with 2 levels and have the following table.

|Factor|df|
|------|--|
|B|3|
|T|3|
|-|-|
|BxT|9|
|-|-|
|Error|16|


## Advice

### Look at treatment effect estimates within blocks

With a significant three-way interaction, estimate treatment effects within blocks. 
You can always report block-specific effects, 
but this may get complicated.

 - If these effects are similar, you may want to report averages over the blocks.
 - If these effects are dissimilar, you should report block-specific effects. 
   
### Treat blocks interactions as random effects
   
One option is to treat the block interactions as random effects.
If these estimated variances are similar, 
then there is an argument for pooling the interactions 
into a single interaction. 
Alternatively, considering the treatment combinations as a 
single treatment effect with 4 levels would suggest combining
the interactions into a single interaction.

If the estimates variances are dissimilar, 
then whether to pool or not is inconclusion because 
the variability in these estimates is large.
But there may be scientific knowledge that suggests 
we should treat the interactions separately.

