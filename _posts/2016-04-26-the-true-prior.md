---
layout: post
title: "The True Prior"
description: ""
category: 
tags:
---
{% include JB/setup %}

From [this post](http://andrewgelman.com/2016/04/23/what-is-the-true-prior-distribution-a-hard-nosed-answer/) on Gelman's blog which asks the question ``what is the true prior distribution?''

# My prior

My current working definition (which is admittedly poor) is ``a prior is the additional assumption a Bayesian requires to perform inference that a non-Bayesian does not require.'' 
The main point here is that a hierarchical distribution, e.g. a distribution for a random effect, is NOT a prior but rather part of the model assumptions. 
If the distribution is normal with zero mean, then part of the prior is the distributional assumption given to the variance in the model. 

I prefer to consider my prior distribution as my belief because I believe this is the way the world works, i.e. we collect information and update our beliefs. 
Thus the true prior is whatever actually represents my belief. 

# Gelman's comments

<blockquote>
    <p>1. The easy case: the prior for an exchangeable set of parameters in a hierarchical model</p>

<p>Let’s start with the easy case: you have a parameter that is replicated many times, the 8 schools or the 3000 counties or whatever. Here, the true prior is the actual population distribution of the underlying parameter, under the “urn” model in which the parameters are drawn from a common distribution. Sure, it’s still a model, but it’s often a reasonable model, in the same sense that a classical (non-hierarchical) regression has a true error distribution.</p>
</blockquote>

Given my definition above, I do not call this a prior, but rather it is a hierarchical assumption in the statistical model. 

<blockquote>
<p>2. The hard case: the prior for a single parameter in a model (or for the hyperparameters in a hierarchical model)</p>

<p>In this case, we can understand the true prior by thinking of the set of all problems to which your model might be fit... The true prior is the distribution of underlying parameter values, considering all possible problems for which your particular model (including this prior) will be fit....We’ll never know what the true prior is in this world, but the point is that it exists, and we can think of any prior that we do use as an approximation to this true distribution of parameter values for the class of problems to which this model will be fit.</p>
</blockquote>

Since we will never know what this prior is, I don't think this is helpful in the least. 
In addition, I am never trying to approximate this ``true'' prior. 
Instead, I am trying to specify my belief about the particular parameter of interest.


<blockquote>
<p>3. The hardest case: the prior for a single parameter in a model that is only being used once</p>

<p>My short answer is: for a model that is only used once, there is no true prior.</p>

<p>For another example, what’s our prior probability that Hillary Clinton will be elected president in November. We can put together what information we have, fit a model, and get a predictive probability... we are thinking of this election as one of a set of examples for which we would be making such predictions.</p>
</blockquote>

I would argue that this election is entirely unique and although there are lots of elections where we could make such predictions, my interest is in this particular election.
My interest is in making statements about my belief based on my experiences about what I think Clinton's chance of being elected is.


<blockquote>
<p>What does this do for us?</p>

<p>OK, fine, you might say. But so what? What is gained by thinking of a “true prior” instead of considering each user’s prior as a subjective choice?</p>

<p>I see two benefits. First, the link to frequentist statistics. I see value in the principle of understanding statistical methods through their average properties, and I think the approach described above is the way to bring Bayesian methods into the fold. It’s unreasonable in general to expect a procedure to give the right answer conditional on the true unknown value of the parameter, but it does seem reasonable to try to get the right answer when averaging over the problems to which the model will be fit.</p>

<p>Second, I like the connection to hierarchical models, because in many settings we can think about a parameter of interest as being part of a batch, as in the examples we’ve been talking about recently, of modeling all the forking paths at once. In which case the true prior is the distribution of all these underlying effects.</p>
</blockquote>

I too appreciate understanding statistical methods through their average properties, thus why I discuss coverage of credible intervals based on default priors. 
I'm not sure this has anything to do with true priors. 

Hierarchical models are great, but the hierarchical assumptions are model assumptions, not priors. 



