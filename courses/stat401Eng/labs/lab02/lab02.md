(Do this after changing your working directory, see below.) To follow along, use the [lab02 code](lab02.R) and download [experiments.csv](experiments.csv) and [treatment\_codes.csv](treatment_codes.csv).

<a name="reading">Reading Data into R</a>
-----------------------------------------

In this section, we will learn how to read in csv or Excel files into R. We focus on csv files because they are simplest to import, they can be easily exported from Excel (or other software), and they are portable, i.e. they can be used in other software.

### <a name="working_directory">Changing your working directory</a>

One of the first tasks after starting R is to change the working directory. To set,

-   in RStudio: Session \> Set Working Directory \> Choose Directory... (Ctrl + Shift + H)
-   in R GUI (Windows): File \> Change Dir...
-   in R GUI (Mac): Misc \> Change Working Directory...

Or, you can just run the following command

``` r
setwd(choose.dir(getwd()))
```

Make sure you have write access to this directory.

### Reading data into R

Data are stored in many different formats. I will focus on data stored in a csv file, but mention approaches to reading in data stored in Excel, SAS, Stata, SPSS, and database formats.

#### Reading a csv file into R

The most common way I read data into R is through a csv file. csv stands for comma-separated value file and is a standard file format for data. The utils package (which is installed and loaded with base R) has a function called `read.csv` for reading csv files into R. For example,

``` r
experiments = read.csv("experiments.csv")
```

In order for this code to execute correctly, you need to have the [experiments.csv](experiments.csv) in your working directory.

This created a `data.frame` object in R called `experiments`.

The utils package has the `read.table()` function which is a more general function for reading data into R and it has many options. We could have gotten the same results if we had used the following code:

``` r
experiments2 = read.table("experiments.csv", 
                 header=TRUE, # There is a header.
                 sep=",")     # The column delimiter is a comma.
```

To check if the two data sets are equal, use the following

``` r
all.equal(experiments, experiments2)
```

    ## [1] TRUE

The `read.csv` function is available in base R, but these days I will often use the `read_csv` function in the [readr](https://cran.r-project.org/web/packages/readr/index.html). See below for how to install packages using the `install.packages` function.

``` r
install.packages("readr") # run this command if the readr package is not installed
library('readr')
experiments <- read_csv("experiments.csv")
```

The two main differences are

-   this function does NOT make R friendly column names (and therefore the column names are "pretty")
-   this function does NOT turn strings into factors

#### Activity

Read the [treatment\_codes.csv](treatment_codes.csv) into R and save it into an R object named `treatment_codes. If you have extra time, try to figure out how to use the`read\_csv`function from the`readr\` package to read the file in.

``` r
treatment_codes <- read.csv("treatment_codes.csv")
```

``` r
install.packages("readr") # only need to do this once
library("readr")          # need to do this every R session
treatment_codes <- read_csv("treatment_codes.csv")
```

<button title="Show a solution" type="button" onclick="if(document.getElementById('readcsv_activity_solution') .style.display=='none') {document.getElementById('readcsv_activity_solution') .style.display=''}else{document.getElementById('readcsv_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
### <a name="excel">Reading Excel files</a>

My main suggestion for reading Excel files into R is to

1.  Save the Excel file as a csv
2.  Read the csv file into R using `read.csv`

This approach will work regardless of any changes Excel makes in its document structure.

Reading an Excel file into R is done using the `read_excel` function from the [readxl](https://cran.r-project.org/web/packages/readxl/index.html) R package. Unfortunately many scenarios can cause this process to not work. When it works, it looks like this

``` r
install.packages('readxl')
library('xl')
d = read_excel("filename.xlsx", sheet = 1) # or
d = read_excel("filename.xlsx", sheet ="sheetName")
```

Again, if these approaches don't work, you can `Save as...` a csv file in Excel.

### Read SAS, Stata, or SPSS data files

The `haven` package provides functionality to read in SAS, Stata, and SPSS files. An example of reading a SAS file is

``` r
install.packages('haven')
library('haven')
d = read_sas('filename.sas7bdat')
```

#### Read a database file

There are many different types of databases, so the code you will need will be specific to the type of database you are trying to access.

The [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) package,
which we will discussing today, has a [number of functions to read from some databases](https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html). The code will look something like

``` r
library('dplyr')
my_db <- src_sqlite("my_db.sqlite3", create = T)
```

The [RODBC](https://cran.r-project.org/web/packages/RODBC/index.html) package has a [number of functions to read from some databases](http://www.statmethods.net/input/dbinterface.html). The code might look something like

``` r
install.packages("RODBC")
library('RODBC')

# RODBC Example
# import 2 tables (Crime and Punishment) from a DBMS
# into R data frames (and call them crimedat and pundat)

library(RODBC)
myconn <-odbcConnect("mydsn", uid="Rob", pwd="aardvark")
crimedat <- sqlFetch(myconn, "Crime")
pundat <- sqlQuery(myconn, "select * from Punishment")
close(myconn)
```

Manipulating `data.frame`s in R
-------------------------------

Some basic `data.frame` information is available using base R functions. But manipulating the `data.frame` becomes a lot easier using the [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html).

You can check to see if a package is installed, by running

``` r
library("dplyr")
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

If you get an error, you will likely need to install the package.

``` r
install.packages("dplyr")
```

### Basic `data.frame` information

The dimensions of the `data.frame` can be found using `dim`, `nrow`, and `ncol`.

``` r
dim(experiments)
```

    ## [1] 1560    7

``` r
nrow(experiments)
```

    ## [1] 1560

``` r
ncol(experiments)
```

    ## [1] 7

The contents of the `data.frame` can be assessed using the following functions:

``` r
names(experiments)
```

    ## [1] "code"           "rep"            "win"            "n_cards_played"
    ## [5] "n_suns_played"  "owl_score"      "n_owls_left"

``` r
head(experiments)
```

    ##   code rep   win n_cards_played n_suns_played owl_score n_owls_left
    ## 1   AI   8  TRUE             24             8         0           0
    ## 2   TV   2  TRUE             33             9         0           0
    ## 3   JP   5 FALSE             40            13        18           4
    ## 4   EC   5  TRUE             37            11         0           0
    ## 5   MW   3  TRUE             28            10         0           0
    ## 6   JC   1  TRUE             32             8         0           0

``` r
tail(experiments)
```

    ##      code rep   win n_cards_played n_suns_played owl_score n_owls_left
    ## 1555   FG   9  TRUE             38            12         0           0
    ## 1556   IG  10 FALSE             40            13         1           1
    ## 1557   LW   9 FALSE             33            13        73           4
    ## 1558   OZ   4 FALSE             25            13        86           5
    ## 1559   BX   1  TRUE             29            11         0           0
    ## 1560   OV   6  TRUE             32            11         0           0

``` r
str(experiments)
```

    ## 'data.frame':    1560 obs. of  7 variables:
    ##  $ code          : Factor w/ 158 levels "AB","AC","AH",..: 4 112 54 21 72 52 4 118 109 45 ...
    ##  $ rep           : int  8 2 5 5 3 1 7 10 2 7 ...
    ##  $ win           : logi  TRUE TRUE FALSE TRUE TRUE TRUE ...
    ##  $ n_cards_played: int  24 33 40 37 28 32 26 34 24 37 ...
    ##  $ n_suns_played : int  8 9 13 11 10 8 7 13 7 13 ...
    ##  $ owl_score     : int  0 0 18 0 0 0 0 15 0 17 ...
    ##  $ n_owls_left   : int  0 0 4 0 0 0 0 5 0 3 ...

To start running some statistics on the `data.frame` a quick function is the `summary` function:

``` r
summary(experiments)
```

    ##       code           rep           win          n_cards_played 
    ##  AC     :  10   Min.   : 1.00   Mode :logical   Min.   : 8.00  
    ##  AH     :  10   1st Qu.: 3.00   FALSE:660       1st Qu.:24.00  
    ##  AI     :  10   Median : 5.00   TRUE :900       Median :32.00  
    ##  AM     :  10   Mean   : 5.49   NA's :0         Mean   :30.33  
    ##  AU     :  10   3rd Qu.: 8.00                   3rd Qu.:37.00  
    ##  BF     :  10   Max.   :10.00                   Max.   :47.00  
    ##  (Other):1500                                                  
    ##  n_suns_played     owl_score       n_owls_left   
    ##  Min.   : 0.00   Min.   :  0.00   Min.   :0.000  
    ##  1st Qu.: 8.00   1st Qu.:  0.00   1st Qu.:0.000  
    ##  Median :12.00   Median :  0.00   Median :0.000  
    ##  Mean   :10.35   Mean   : 16.81   Mean   :1.561  
    ##  3rd Qu.:13.00   3rd Qu.: 22.00   3rd Qu.:3.000  
    ##  Max.   :13.00   Max.   :162.00   Max.   :6.000  
    ## 

Notice (under `win` column) that R will tell you if any observations are `Not Available` using `NA`.

### Subsetting a `data.frame`

First, let's make sure the `dplyr` package is loaded and `experiments` is loaded.

``` r
library("dplyr")
experiments     <- read.csv("experiments.csv")
```

There are numerous ways in `dplyr` to subset observations:

-   `filter()`
-   `distinct()`
-   `sample_frac()`
-   `sample_n()`
-   `slice()`
-   `top_n()`

By far the most common one for me is to `filter()`. This function will return all rows that match a set of logical criteria. For example, perhaps we want to extract all observations with treatment code `AI`.

``` r
experiments %>%
  filter(code == "AI") # notice the double equal
```

    ##    code rep  win n_cards_played n_suns_played owl_score n_owls_left
    ## 1    AI   8 TRUE             24             8         0           0
    ## 2    AI   7 TRUE             26             7         0           0
    ## 3    AI  10 TRUE             23             6         0           0
    ## 4    AI   9 TRUE             25             7         0           0
    ## 5    AI   6 TRUE             26             7         0           0
    ## 6    AI   5 TRUE             26            10         0           0
    ## 7    AI   1 TRUE             31            11         0           0
    ## 8    AI   3 TRUE             23             7         0           0
    ## 9    AI   2 TRUE             29             8         0           0
    ## 10   AI   4 TRUE             25             5         0           0

You can also filter by multiple criteria.

``` r
experiments %>%
  filter(win, n_cards_played > 30) %>% # win is already logical
  summary
```

    ##       code          rep           win          n_cards_played 
    ##  TV     :  9   Min.   : 1.000   Mode:logical   Min.   :31.00  
    ##  FJ     :  8   1st Qu.: 3.000   TRUE:297       1st Qu.:33.00  
    ##  PE     :  8   Median : 6.000   NA's:0         Median :35.00  
    ##  AU     :  7   Mean   : 5.481                  Mean   :35.76  
    ##  DS     :  7   3rd Qu.: 8.000                  3rd Qu.:38.00  
    ##  FB     :  7   Max.   :10.000                  Max.   :45.00  
    ##  (Other):251                                                  
    ##  n_suns_played     owl_score  n_owls_left
    ##  Min.   : 7.00   Min.   :0   Min.   :0   
    ##  1st Qu.:10.00   1st Qu.:0   1st Qu.:0   
    ##  Median :11.00   Median :0   Median :0   
    ##  Mean   :10.86   Mean   :0   Mean   :0   
    ##  3rd Qu.:12.00   3rd Qu.:0   3rd Qu.:0   
    ##  Max.   :12.00   Max.   :0   Max.   :0   
    ## 

#### Activity

Use the `treatment_codes` `data.frame` to keep only observations that used the `random` strategy and 6 owls. If you get done with this quickly, keep only observations that used 2 or more owls but less than 6.

``` r
treatment_codes %>%
  filter(strategy == "random", n_owls == 6) %>%
  summary
```

    ##    n_players     n_owls  n_cards_per_player              strategy
    ##  Min.   :2   Min.   :6   Min.   :2          last_owl_farthest:0  
    ##  1st Qu.:2   1st Qu.:6   1st Qu.:2          last_owl_random  :0  
    ##  Median :3   Median :6   Median :3          random           :9  
    ##  Mean   :3   Mean   :6   Mean   :3                               
    ##  3rd Qu.:4   3rd Qu.:6   3rd Qu.:4                               
    ##  Max.   :4   Max.   :6   Max.   :4                               
    ##                                                                  
    ##       code  
    ##  FA     :1  
    ##  JE     :1  
    ##  KP     :1  
    ##  LC     :1  
    ##  NZ     :1  
    ##  OA     :1  
    ##  (Other):3

``` r
treatment_codes %>%
  filter(n_owls >= 2, n_owls < 6) %>%
  summary
```

    ##    n_players     n_owls     n_cards_per_player              strategy 
    ##  Min.   :2   Min.   :2.00   Min.   :2          last_owl_farthest:36  
    ##  1st Qu.:2   1st Qu.:2.75   1st Qu.:2          last_owl_random  :36  
    ##  Median :3   Median :3.50   Median :3          random           :36  
    ##  Mean   :3   Mean   :3.50   Mean   :3                                
    ##  3rd Qu.:4   3rd Qu.:4.25   3rd Qu.:4                                
    ##  Max.   :4   Max.   :5.00   Max.   :4                                
    ##                                                                      
    ##       code    
    ##  AC     :  1  
    ##  AH     :  1  
    ##  AI     :  1  
    ##  AM     :  1  
    ##  AU     :  1  
    ##  BF     :  1  
    ##  (Other):102

<button title="Show a solution" type="button" onclick="if(document.getElementById('filter_activity_solution') .style.display=='none') {document.getElementById('filter_activity_solution') .style.display=''}else{document.getElementById('filter_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
If we want to subset the columns, we use the `select()` function. If used by itself, then it will keep any named columns and remove any names pre-fixed with a "-".

``` r
experiments %>% 
  select(n_cards_played, n_suns_played, n_owls_left) %>%
  names
```

    ## [1] "n_cards_played" "n_suns_played"  "n_owls_left"

``` r
experiments %>%
  select(-code, -rep, -win, -owl_score) %>%
  names
```

    ## [1] "n_cards_played" "n_suns_played"  "n_owls_left"

Since there are still many rows here, I only print out the column names.

Sometimes, it would be more efficient to perform some *fuzzy* matching using one of these functions:

-   `contains()`
-   `ends_with()`
-   `everything()`
-   `matches()`
-   `num_range()`
-   `one_of()`
-   `starts_with()`

For example, keep only columns that start with "n\_"

``` r
experiments %>% 
  select(starts_with("n_")) %>%
  names
```

    ## [1] "n_cards_played" "n_suns_played"  "n_owls_left"

#### Activity

Use the `treatment_codes` `data.frame` to extract all the codes (and only codes) for treatments that had two players and three owls.

``` r
treatment_codes %>%
  filter(n_players == 2, n_owls == 3) %>%
  select(code)
```

    ##   code
    ## 1   WW
    ## 2   DU
    ## 3   XC
    ## 4   RG
    ## 5   GB
    ## 6   WH
    ## 7   JC
    ## 8   YQ
    ## 9   AU

<button title="Show a solution" type="button" onclick="if(document.getElementById('filterselect_activity_solution') .style.display=='none') {document.getElementById('filterselect_activity_solution') .style.display=''}else{document.getElementById('filterselect_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
### Making new variables

Proper data management requires that raw data remain raw and that scripts are written to create analyzable data sets. These scripts will often need to construct new variables for future analyses. The `dplyr` mutate function can be used to add new columns to the `data.frame`.

``` r
experiments %>% 
  mutate(suns_spots_remaining   = 13 - n_suns_played,             # there are 13 sun spots
         average_owl_position   = owl_score / n_owls_left) %>% 
  head
```

    ##   code rep   win n_cards_played n_suns_played owl_score n_owls_left
    ## 1   AI   8  TRUE             24             8         0           0
    ## 2   TV   2  TRUE             33             9         0           0
    ## 3   JP   5 FALSE             40            13        18           4
    ## 4   EC   5  TRUE             37            11         0           0
    ## 5   MW   3  TRUE             28            10         0           0
    ## 6   JC   1  TRUE             32             8         0           0
    ##   suns_spots_remaining average_owl_position
    ## 1                    5                  NaN
    ## 2                    4                  NaN
    ## 3                    0                  4.5
    ## 4                    2                  NaN
    ## 5                    3                  NaN
    ## 6                    5                  NaN

Notice the `NaN` when we divided by zero. If there are no owls left, then it makes more sense that the average owl position is zero (which indicates the nest).

``` r
experiments %>% 
  mutate(suns_spots_remaining   = 13 - n_suns_played,
         average_owl_position   = owl_score / n_owls_left,
         average_owl_position   = ifelse(is.nan(average_owl_position), 
                                         0,                            # return 0 if NaN
                                         average_owl_position)) %>%    # otherwise leave alone
  head
```

    ##   code rep   win n_cards_played n_suns_played owl_score n_owls_left
    ## 1   AI   8  TRUE             24             8         0           0
    ## 2   TV   2  TRUE             33             9         0           0
    ## 3   JP   5 FALSE             40            13        18           4
    ## 4   EC   5  TRUE             37            11         0           0
    ## 5   MW   3  TRUE             28            10         0           0
    ## 6   JC   1  TRUE             32             8         0           0
    ##   suns_spots_remaining average_owl_position
    ## 1                    5                  0.0
    ## 2                    4                  0.0
    ## 3                    0                  4.5
    ## 4                    2                  0.0
    ## 5                    3                  0.0
    ## 6                    5                  0.0

#### Activity

For each observation, calculate the number of non sun cards played.

``` r
experiments %>% 
  mutate(n_non_sun_cards_played = n_cards_played - n_suns_played) %>%    
  head
```

    ##   code rep   win n_cards_played n_suns_played owl_score n_owls_left
    ## 1   AI   8  TRUE             24             8         0           0
    ## 2   TV   2  TRUE             33             9         0           0
    ## 3   JP   5 FALSE             40            13        18           4
    ## 4   EC   5  TRUE             37            11         0           0
    ## 5   MW   3  TRUE             28            10         0           0
    ## 6   JC   1  TRUE             32             8         0           0
    ##   n_non_sun_cards_played
    ## 1                     16
    ## 2                     24
    ## 3                     27
    ## 4                     26
    ## 5                     18
    ## 6                     24

<button title="Show a solution" type="button" onclick="if(document.getElementById('mutate_activity_solution') .style.display=='none') {document.getElementById('mutate_activity_solution') .style.display=''}else{document.getElementById('mutate_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
### Summarizing data

We will often want to summarize large `data.frame`s. The `dplyr` `summarize` function will allow us to do this summarization.

``` r
experiments %>%
  summarize(proportion_wins     = mean(win),
            mean_cards_played   = mean(  n_cards_played),
            median_cards_played = median(n_cards_played),
            min_cards_played    = min(   n_cards_played),
            max_cards_played    = max(   n_cards_played),
            sd_cards_played     = sd(    n_cards_played),
            var_cards_played    = var(   n_cards_played))
```

    ##   proportion_wins mean_cards_played median_cards_played min_cards_played
    ## 1       0.5769231          30.32949                  32                8
    ##   max_cards_played sd_cards_played var_cards_played
    ## 1               47          9.0673         82.21594

Often, we will want to perform these summarizations on groups. In order to do this we will first

1.  Group the `data.frame` and then
2.  Perform the summarization within each group

``` r
experiments %>%
  group_by(win) %>%
  summarize(mean_cards_played   = mean(  n_cards_played),
            median_cards_played = median(n_cards_played)) %>%
  ungroup()  # this isn't necessary here, but there may be times when you want to ungroup
```

    ## # A tibble: 2 × 3
    ##     win mean_cards_played median_cards_played
    ##   <lgl>             <dbl>               <dbl>
    ## 1 FALSE          36.47727                  37
    ## 2  TRUE          25.82111                  26

#### Activity

Calculate the average number of cards played after grouping by the number of owls left.

``` r
experiments %>%
  group_by(n_owls_left) %>%
  summarize(mean_cards_played   = mean(  n_cards_played),
            median_cards_played = median(n_cards_played))
```

    ## # A tibble: 7 × 3
    ##   n_owls_left mean_cards_played median_cards_played
    ##         <int>             <dbl>               <dbl>
    ## 1           0          25.82111                26.0
    ## 2           1          38.07447                38.0
    ## 3           2          36.28421                37.0
    ## 4           3          38.28000                39.5
    ## 5           4          36.15966                36.0
    ## 6           5          35.94891                36.0
    ## 7           6          34.72174                35.0

<button title="Show a solution" type="button" onclick="if(document.getElementById('summarize_activity_solution') .style.display=='none') {document.getElementById('summarize_activity_solution') .style.display=''}else{document.getElementById('summarize_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
### Combining `data.frame`s

The `experiment` `data.frame` is set up with *blinding*. In order to *unblind* these data, we will combine it with the `treatment_codes` `data.frame`.

These two `data.frame`s have the `code` column in common:

``` r
names(experiments)
```

    ## [1] "code"           "rep"            "win"            "n_cards_played"
    ## [5] "n_suns_played"  "owl_score"      "n_owls_left"

``` r
names(treatment_codes)
```

    ## [1] "n_players"          "n_owls"             "n_cards_per_player"
    ## [4] "strategy"           "code"

So, now let's create a new `data.frame` that has combines the information in both of the other `data.frame`s.

``` r
results <- experiments %>%
  left_join(treatment_codes) # Keeps all rows in experiments and only the relevant rows in treatment_codes
```

    ## Joining, by = "code"

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factors with different levels, coercing to character vector

You were told that it was combining by code (which is correct), but you might have wanted to enforce that yourself.

``` r
results2 <- experiments %>%
  left_join(treatment_codes, by="code")
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factors with different levels, coercing to character vector

``` r
all.equal(results, results2)
```

    ## [1] TRUE

The warning here is not important, although it is annoying. To avoid these warnings, I often use

``` r
treatment_codes <- read.csv("treatment_codes.csv", stringsAsFactors = FALSE)
experiments     <- read.csv("experiments.csv",     stringsAsFactors = FALSE)
```

or, using the [readr](https://cran.r-project.org/web/packages/readr/index.html) package.

``` r
library(readr)
treatment_codes <- read_csv("treatment_codes.csv")
experiments     <- read_csv("experiments.csv")
```

There are other ways of joining `data.frame`s in R, but `left_join` is by far the one that I use the most often.

#### Activity - Putting it all together

Perform the following:

1.  Combine the `experiment` and `treatment` `data.frame`s by column `code`.
2.  Remove the `code` column (as it is no longer needed).
3.  Subset to only include only observations are used

-   the "last owl farthest" strategy
-   four or more owls
-   three players

1.  Calculate the number of games and win proportion after grouping by

-   number of owls
-   number of players
-   number of cards per player

``` r
experiments %>%
  left_join(treatment_codes, by="code") %>%
  select(-code) %>%
  filter(strategy == "last_owl_farthest", 
         n_owls >= 4,
         n_players == 3) %>%
  group_by(n_players, n_owls, n_cards_per_player) %>%
  summarize(
    n_games = n(),
    win_proportion = mean(win))
```

    ## Source: local data frame [9 x 5]
    ## Groups: n_players, n_owls [?]
    ## 
    ##   n_players n_owls n_cards_per_player n_games win_proportion
    ##       <int>  <int>              <int>   <int>          <dbl>
    ## 1         3      4                  2      10      0.9000000
    ## 2         3      4                  3      10      0.8000000
    ## 3         3      4                  4       9      0.5555556
    ## 4         3      5                  2      10      0.7000000
    ## 5         3      5                  3       9      0.8888889
    ## 6         3      5                  4      10      0.3000000
    ## 7         3      6                  2      10      0.4000000
    ## 8         3      6                  3      10      0.0000000
    ## 9         3      6                  4      10      0.1000000

<button title="Show a solution" type="button" onclick="if(document.getElementById('everything_activity_solution') .style.display=='none') {document.getElementById('everything_activity_solution') .style.display=''}else{document.getElementById('everything_activity_solution') .style.display='none'}">
Show/Hide Solution
</button>
