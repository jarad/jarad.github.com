---
layout: post
title: "Complete survey data using tidyr"
description: ""
category: [R]
tags: [data management, tidyr, survey]
---

{% include JB/setup %}

I prefer [line lists](https://outbreaktools.ca/background/line-lists/) for data
recording any type of survey data. 
These line lists only recorded "cases" and therefore are missing any time the 
data are 0. 
Thus, I'm often in the scenario where I want to 
[complete](https://tidyr.tidyverse.org/reference/complete.html)
the data so that 0s are included.

Imagine the real data are 


{% highlight r %}
library("tidyverse")
d = tribble(
  ~year, ~month, ~species, ~count,
  2018, 05, "A", 0,
  2018, 05, "B", 0,
  2018, 06, "A", 0,
  2018, 06, "B", 0,
  2019, 05, "A", 1, 
  2019, 05, "B", 0, 
  2019, 06, "A", 1, 
  2019, 06, "B", 1, 
  2020, 05, "A", 1, 
  2020, 05, "B", 1, 
  2020, 06, "A", 0, 
  2020, 06, "B", 1, 
)
d
{% endhighlight %}



{% highlight text %}
## # A tibble: 12 x 4
##     year month species count
##    <dbl> <dbl> <chr>   <dbl>
##  1  2018     5 A           0
##  2  2018     5 B           0
##  3  2018     6 A           0
##  4  2018     6 B           0
##  5  2019     5 A           1
##  6  2019     5 B           0
##  7  2019     6 A           1
##  8  2019     6 B           1
##  9  2020     5 A           1
## 10  2020     5 B           1
## 11  2020     6 A           0
## 12  2020     6 B           1
{% endhighlight %}

But if we record only the non-zero counts, we have the following incomplete
data.frame.


{% highlight r %}
d_incomplete = d %>% dplyr::filter(count > 0)
d_incomplete
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 4
##    year month species count
##   <dbl> <dbl> <chr>   <dbl>
## 1  2019     5 A           1
## 2  2019     6 A           1
## 3  2019     6 B           1
## 4  2020     5 A           1
## 5  2020     5 B           1
## 6  2020     6 B           1
{% endhighlight %}

So, we need to complete this data frame so that it looks just like the
original. 
We don't have all the information in `d_incomplete` because we don't even 
know that surveys were completed in 2018 or in month 5 of year 2019. 
So, we have another source of information that tells us about which surveys
occurred.


{% highlight r %}
surveys = d %>% dplyr::select(year, month) %>% unique
surveys
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 2
##    year month
##   <dbl> <dbl>
## 1  2018     5
## 2  2018     6
## 3  2019     5
## 4  2019     6
## 5  2020     5
## 6  2020     6
{% endhighlight %}

Now, we can augment this surveys data frame with the species information
by [merging two data.frames](https://stackoverflow.com/questions/11693599/alternative-to-expand-grid-for-data-frames)


{% highlight r %}
surveys_with_species = merge(surveys, 
                             tibble::tibble(species = unique(d$species)), 
                             by = NULL) %>%
  arrange(year, month, species)

surveys_with_species
{% endhighlight %}



{% highlight text %}
##    year month species
## 1  2018     5       A
## 2  2018     5       B
## 3  2018     6       A
## 4  2018     6       B
## 5  2019     5       A
## 6  2019     5       B
## 7  2019     6       A
## 8  2019     6       B
## 9  2020     5       A
## 10 2020     5       B
## 11 2020     6       A
## 12 2020     6       B
{% endhighlight %}

Finally we can 
[join](https://dplyr.tidyverse.org/reference/join.tbl_df.html) 
the incomplete data.frame with this data.frame that contains all the surveys
and species. 
This will create NAs that we will with 0.


{% highlight r %}
this = dplyr::right_join(d_incomplete, 
                         surveys_with_species, 
                         by = c("year","month","species")) %>%
  tidyr::replace_na(list(count = 0))

this
{% endhighlight %}



{% highlight text %}
## # A tibble: 12 x 4
##     year month species count
##    <dbl> <dbl> <chr>   <dbl>
##  1  2018     5 A           0
##  2  2018     5 B           0
##  3  2018     6 A           0
##  4  2018     6 B           0
##  5  2019     5 A           1
##  6  2019     5 B           0
##  7  2019     6 A           1
##  8  2019     6 B           1
##  9  2020     5 A           1
## 10  2020     5 B           1
## 11  2020     6 A           0
## 12  2020     6 B           1
{% endhighlight %}

I'm not thrilled with this solution, but at least it is a solution
