---
layout: post
title: "Setting Excel dates to the ISO standard"
description: ""
category: [Consulting]
tags: [dates, Excel, STRIPS]
---
{% include JB/setup %}

I've always been annoyed that Excel changes my dates to a particular format and
then I have to go back and fix the dates. 

## Excel's problem(s) with dates

This came up at a recent [STRIPS](https://www.nrem.iastate.edu/research/STRIPS/)
Data Subteam meeting. 
[Megan O'Donnell](excel 1900 leap year)
mentioned that Excel has (or had) an issue with dates when cross platforms, 
e.g. Windows and Mac.

Apparently the Windows and Mac version used a different 
[date origin](https://support.microsoft.com/en-us/help/214330/differences-between-the-1900-and-the-1904-date-system-in-excel). 
Thus, if you open a file on a Windows and the same file on a Mac, it will 
(or previously would) show you different dates. 

Apparently this is not the only issue with Excel dates as apparently Excel
erroneously treats the year 
[1900 as a leap year](https://support.microsoft.com/en-us/help/214326/excel-incorrectly-assumes-that-the-year-1900-is-a-leap-year). 
And, according to 
[this wikipedia article](https://en.wikipedia.org/wiki/Leap_year_bug), 
this bug is now being promoted as a standard for the
Ecma Office Open XML (OOXML) specification.


## Partial solution

The ISO 8601 standard on dates suggests recording dates in the YYYYMMDD format
or, if you prefer, YYYY-MM-DD. 
The latter is also conveniently recognized as a date by `as.Date()` in R.

While I don't have a fix for the previous section,
we can at least fix dates as displayed in Excel. 
Well, I don't have a fix for the above section, 
You can 
[force Excel to use your preferred date format](https://www.extendoffice.com/documents/excel/4165-excel-convert-mm-dd-yyyy-to-yyyymmdd.html)
which I have been doing for a while.

You can also set the system default in both 
[Windows](https://superuser.com/questions/989370/how-to-make-date-yyyy-mm-dd-iso-8601-the-default-in-excel) and 
[Mac](https://apple.stackexchange.com/questions/308056/how-to-set-system-short-date-to-iso-format-yyyy-mm-dd-in-high-sierra).
Why haven't I done this sooner?????

