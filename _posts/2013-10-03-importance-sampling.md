---
layout: post
title: "Importance sampling"
description: ""
category: 615
tags: [Monte Carlo, importance sampling]
---
{% include JB/setup %}

Continuing with our [rejection sampling example]({{BASE_PATH}}/615/2013/10/03/rejection-sampling/), we now turn to importance sampling. 
We still have a target distribution f(x) and a proposal distribution q(x).
But instead of throwing away samples like we did in rejection sampling, we keep all the samples but give them weights. 
The weights are proportional to the ratio of the target to the proposal.
They are only proportional because we renormalize them to sum to 1. 

Set up the target and proposal densities and sample. 


{% highlight r %}
a = 5
b = 12
target = function(x) dbeta(x, a, b)
proposal = dunif
n = 1000
points = runif(n)
{% endhighlight %}


So far, everything is the same as rejection sampling. Now we calculate the weights. 


{% highlight r %}
w = target(points)/proposal(points)

curve(target, lwd = 2)
points(points, w, col = "red", pch = 1, lwd = 2)
{% endhighlight %}

![center](/../figs/2013-10-03-importance-sampling/unnamed-chunk-2.png) 


Since our proposal is the uniform distribution, the unnormalized weights exactly match the density of our target. 
We can use this weighted sample for any purpose, e.g. estimation of expectations or densities. 
But sometimes it is more convenient to have an unweighted sample. 
If so, we can resample from our weights with replacement to obtain an unweighted sample.



{% highlight r %}
points2 = points[sample(n, n, w, replace = TRUE)]
{% endhighlight %}



{% highlight text %}
## Warning: Walker's alias method used: results are different from R < 2.2.0
{% endhighlight %}


These unweighted samples should look like our target density. 


{% highlight r %}
hist(points2, freq = FALSE)
curve(target, lwd = 2, add = TRUE)
{% endhighlight %}

![center](/../figs/2013-10-03-importance-sampling/unnamed-chunk-4.png) 


But notice that there are duplications in this sample.


{% highlight r %}
dup = table(as.factor(points2))
{% endhighlight %}


The plot below shows that the duplicated points are more often found where the target density is high. 


{% highlight r %}
plot(as.numeric(names(dup)), as.numeric(dup), xlim = c(0, 1), ylim = c(0, 10), 
    col = "blue", ylab = "# of duplicates", xlab = "Location", lwd = 2)
points(points, rep(0, n), lwd = 2, col = "red", pch = 1)
curve(target, lwd = 2, add = TRUE, col = "gray")
{% endhighlight %}

![center](/../figs/2013-10-03-importance-sampling/unnamed-chunk-6.png) 





