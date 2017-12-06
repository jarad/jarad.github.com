---
layout: page
title: "Utility scripts"
description: ""
group: 
---
{% include JB/setup %}

This page is dedicated to utility functions that I use often, but can never seem to remember them and typically end up googling for the answer. 

## Find-and-replace in lots of files

The following is based on 
[this blog post](https://blog.josephscott.org/2005/08/18/perl-oneliner-recursive-search-and-replace/).

To find-and-replace a string in lots of files use [perl pie](https://www.garron.me/en/bits/pearl-pie-search-replace-substitute-text-all-files-terminal.html), e.g. 

    $ perl -p -i -e 's/search-this-string/replace-with-this-string/g' ./*.R
    
To replace `search-this-string` with `replace-with-this-string` in all `.R` files.

Sometimes we want to perform this recursively, 
this can be done with the following line

    $ find . -name '*.R' -print0 | xargs -0 perl -pi -e 's/oldstring/newstring/g'
