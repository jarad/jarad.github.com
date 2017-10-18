---
layout: post
title: "Data entry in R"
description: ""
category: 
tags: [R, data management]
---
{% include JB/setup %}

My post yesterday mentioned that I would appreciate tools in R for data entry. 
Yesteday I mentioned that basing it off `data.entry()` or `View()` might make 
sense, but an alternative is to base it off 
[shiny](https://cran.r-project.org/web/packages/shiny/index.html).
Googling "data entry shiny", 
one of the first hits is 
[a blog post from 2015](http://deanattali.com/2015/06/14/mimicking-google-form-shiny/)
by 
[Dean Attali](http://deanattali.com/aboutme/) showing how to use shiny to 
recreate a [Google Form](https://www.google.com/forms/about/).

The developed app was used for a class to obtain data from students. 
In my opinion, to convert this into a form to allow for data entry, we would 
want to 

  - check input values
  - save form data as a file (rather than into a data.frame)
  
The check input could execute continuously or only when the user tried to save
the information in the form. 
The form should also allow you to update the reasonable values, 
e.g. suppose you had a maximum value for the data but your actual data point
was higher than this maximum value (but was correct) then you would want to 
change the maximum allowable value.
Alternatively, the check input could execute when the user tried to save the 
information in the form and indicate any entry errors.
  
It would be nice to also have an additional shiny app that allows you to 
easily construct the desired form. 
This app would allow you to set up, for each piece of data being entered,

  1. name
  1. type
  1. acceptable values
  
Ideally it would also allow you to organize the different pieces of data on 
the page. 

Once executed, this app would create another app or tab (or something) that 
would create the desired data entry form. 
