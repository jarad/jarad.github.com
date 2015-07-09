---
layout: post
title: "Probability interpretation for Mars rescue mission"
description: ""
category: 
tags: [probability-interpretation]
---
{% include JB/setup %}

I am currently reading [The Martian](http://amzn.to/1NVSMox) by [Andy Weir](http://amzn.to/1KXtOVH). Okay, I'm not really reading it but rather listening to it on CD during long car rides. If you are interested in reading this book, you may want to stop reading this blog now because there will be spoilers below. 

Due to chaotic and dangerous conditions, Mark Watney gets stranded on Mars. At one point, mission control is considering a supply drop to Mars, but due to the necessary timing is considering foregoing the standard checks performed once the supply payload is loaded onto the rocket. The mission commander questions payload specialist, the individual typically charged with performing these checks, about the history of these checks. Here is a paraphrasing of their conversation:

> Commander: How often do these checks find something?

> Specialist: About 1 in 20 launches.

> Commander: And how often would the find have resulted in a mission failure. 

> Specialist: About half the time. 

> Commander: So there is a 1 in 40 chance of mission failure if we don't do these checks. 

In [STAT 544](courses/stat544) this spring, I tried to convince my class that the only reasonable way of interpreting this type of statement is as a personal belief about the probability of mission failure. In the future, either the mission fails (due to something the checks would have found) or it doesn't, i.e. there is no randomness here. Also, we cannot reasonably interpret this probability as a frequency of mission failures for similar (identical?) launches since there are no launches under similar circumstances, i.e. sending a supply payload under severe time constraints. 

If there is no randomness in the event and we cannot use a frequency argument, how can we interpret this probability statement? I think the only reasonable way to interpret this probability is as a statement about personal belief. So the Commander, based on all of his experience and the data presented, believes that the probability is 0.025 that the mission will result in a failure (due to the lack of checks). We might argue that, due to the severe time constraints placed on the mission, that this is a lower bound on the probability, but without any information on missions with time constraints like this one it would be hard to quantify how much larger this probability should be. 

It may come as no surprise that the mission did fail and as a result of something the check would have easily caught and been able to fix. 
