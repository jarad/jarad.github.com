---
layout: post
title: "soccer analytics"
description: ""
category: sports
tags: [soccer]
---
{% include JB/setup %}

A friend sent me a link to <http://www.statsbomb.com/> with a particular link to [an article about football (soccer) analytics](http://www.statsbomb.com/2013/08/shooooot-a-paradigm-shift-in-how-we-watch-football/). Rather than responding to him over email, I thought I would just post about the blog post:

Overall, I like the article because it is talking about how statistics (or analytics) will go mainstream and how it will change the way people watch soccer. If this happens, great! It will encourage [numeracy](http://en.wikipedia.org/wiki/Numeracy) via a medium, soccer or sports in general, that is interesting to many people. 

Now, with a more critical eye, here are some thoughts on the article:

> I think it was the encounter with Paul Riley’s SPAM model that happened first. Somewhere along the way, I ran into Sander Ijtsma’s work in a similar vein. Then Colin Trainor and Constantinos Chappas started writing about ExpG, and my brain permanently switched.
>
>
> All of these models evaluate shots taken by teams, but not by the player taking them or whether they are on target, provoke a save, or whatever. They simply evaluate them by looking at where the shots are taken from.

It should not be a virtue that the models ignore the player taking the shots, or whether they are on target, etc. An improved model would certainly take this information into account.

The picture from the SPAM model, at least according to the blog post, looks like 

![soccer shots](http://www.statsbomb.com/wp-content/uploads/2013/08/474x360xSPAM_graphic.jpg.pagespeed.ic.yEXayE7LaC.jpg) 

where the onfield numbers indicate the expected number of shots before a goal is scored from that location. So a few ideas pop into my head

- Why list the expected number of shots rather than the probability of make the shot? Is this so we don't have to deal with decimals? In any case, the probability is just one divided by the number provided. 
- There are only 3 (maybe 4) zones in the entire game? Certainly a shot from the top of the arc should have a different probability of going in than a shot from the corner. I would certainly like to see a much finer grid.
- Is this intentionally symmetric (the 18s on both sides of the goal) or did the data just work out that way? 
- What are DFKs? I didn't bother to check. I'm assuming Pens are penalty kicks.

> Shots from beyond 25 yards are useless.

Tell that to the guy who scores one which will happen, on average, once every 33 attempts (according to the model). 

> Now when some fool blasts away from 30 yards, I kind of groan, and think, “Well, that was a waste of a perfectly good possession.”

It is a lot harder to get a shot from inside the box than it is from 30 yards. So if you cannot get the ball into the box, you should probably be taking a shot from outside. 

Here is a shot heatmap for Josip Ilicic

![shot heatmap for Josip Ilicic](http://www.statsbomb.com/wp-content/uploads/2013/06/ilicic_heatmap.jpg,qw=538.pagespeed.ce.tnuHzgOfqa.jpg)

This figure is much better than the previous because the resolution of the spatial grid is much finer. It is certainly helpful if I am defending against Ilicic because I understand his tendency is to shoot just outside of the box from just right of the arc. 

I'm certainly interested in statistics going mainstream, so I hope that these trends continue and that the data become more readily available. 

