---
layout: post
title: "Reading a directory of data with drake"
description: ""
category: [R]
tags: [R, drake]
---

{% include JB/setup %}

[drake](https://github.com/ropensci/drake) 
is an R package that provides 
[make](https://www.gnu.org/software/make/) functionality entirely within R.
That is, it will run a set of commands in a hierarchical (or tree) structure. 
Then, when when pieces of that structure changes, 
drake will only re-run the pieces that need to be re-run. 

I have been using 
[these two functions](https://gist.github.com/jarad/8f3b79b33489828ab8244e82a4a0c5b3) 
to read in a directory worth of data. 
Everytime I run these functions, 
I need to re-read the entire directory. 
It would be more convenient if I could use drake, or something similar, 
so that I only need to reread the files that have changed. 

So here is a script that will perform that process

{% highlight r %}
library("drake")

dir.create("data")
{% endhighlight %}



{% highlight text %}
## Warning in dir.create("data"): 'data' already exists
{% endhighlight %}



{% highlight r %}
write.csv(data.frame(g = 1, x = 1), file = "data/g1.csv")
write.csv(data.frame(g = 2, x = 2), file = "data/g2.csv")
files = list.files("data", "*.csv", full.names = TRUE)

add2 = function(d) { # example function to apply to each individual data.frame
  d$x = d$x+2
  return(d)
}

plan = drake_plan( # This is where you define the set of commands to run
  data  = target(
    read.csv(file_in(file)),
    transform = map(file = !!files)
  ),
  add2  = target(
    add2(data),
    transform = map(data)
  ),
  all = target(
    dplyr::bind_rows(add2),
    transform = combine(add2)
  ),
  out = saveRDS(all, file = file_out("all.RDS"))
)
{% endhighlight %}

Let's take a look at the plan

{% highlight r %}
plan # Take a look at the targets and commands that will be run
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 2
##   target              command                                              
##   <chr>               <expr>                                               
## 1 add2_data_data.g1.… add2(data_data.g1.csv)                              …
## 2 add2_data_data.g2.… add2(data_data.g2.csv)                              …
## 3 all                 dplyr::bind_rows(add2_data_data.g1.csv, add2_data_da…
## 4 data_data.g1.csv    read.csv(file_in("data/g1.csv"))                    …
## 5 data_data.g2.csv    read.csv(file_in("data/g2.csv"))                    …
## 6 out                 saveRDS(all, file = file_out("all.RDS"))            …
{% endhighlight %}

Now to actually run the plan use 


{% highlight r %}
make(plan)
{% endhighlight %}



{% highlight text %}
## ▶ target data_data.g1.csv
{% endhighlight %}



{% highlight text %}
## ▶ target add2_data_data.g1.csv
{% endhighlight %}



{% highlight text %}
## ▶ target all
{% endhighlight %}



{% highlight text %}
## ▶ target out
{% endhighlight %}

If you try to run the plan again, drake tells you 


{% highlight r %}
make(plan)
{% endhighlight %}



{% highlight text %}
## ✓ All targets are already up to date.
{% endhighlight %}

Now if a file changes, you can just rerun the plan. 


{% highlight r %}
write.csv(data.frame(g = 1, x = 11), file = "data/g1.csv")
make(plan)
{% endhighlight %}



{% highlight text %}
## ▶ target data_data.g1.csv
{% endhighlight %}



{% highlight text %}
## ▶ target add2_data_data.g1.csv
{% endhighlight %}



{% highlight text %}
## ▶ target all
{% endhighlight %}



{% highlight text %}
## ▶ target out
{% endhighlight %}


