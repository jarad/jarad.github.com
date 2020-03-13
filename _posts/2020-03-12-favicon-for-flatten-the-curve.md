---
layout: post
title: "Code to create a favicon for Flatten the Curve"
description: ""
category: [News]
tags: [flattenthecurve]
---

{% include JB/setup %}

Borrowing [instructions from r-bloggers](https://www.r-bloggers.com/creating-a-favicon-with-r/)


{% highlight r %}
library("tidyverse")

d <- data.frame(x = seq(0,8, by = 0.1)) %>%
  mutate(`No intervention` = dnorm(x, 2, 0.8),
         `With intervention` = dnorm(x, 5, 2)) %>%
  pivot_longer(-x, names_to = "intervention", values_to = "count") %>%
  mutate(zero = 0)

favicon = ggplot(d, aes(x, ymin = zero, ymax = count, fill = intervention)) +
  geom_ribbon(alpha = 0.8) +
  theme_void() +
  theme(legend.position = "none") 

favicon
{% endhighlight %}

![center](/../figs/2020-03-12-favicon-for-flatten-the-curve/unnamed-chunk-1-1.png)

{% highlight r %}
ggsave("favicon32.png", 
       plot = favicon, scale = 1, width = 1, height = 1, dpi = 32, bg = "transparent")
{% endhighlight %}
