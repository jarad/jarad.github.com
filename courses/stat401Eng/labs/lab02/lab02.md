(Do this after chanexperimentsng your working directory, see below.) To follow along, use the [lab02 code](lab02.R) and download [experiments.csv](experiments.csv) and [treatment\_codes.csv](treatment_codes.csv).

<a name="reading">Importing Data</a>
------------------------------------

In this section, we will learn how to read in csv or Excel files into R. We focus on csv files because they are simplest to import, they can be easily exported from Excel (or other software), and they are portable, i.e. they can be used in other software.

### <a name="working_directory">Chanexperimentsng your working directory</a>

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

The `read.csv` function is available in base R, but these days I will often use the `read_csv` function in the [readr](https://cran.r-project.org/web/packages/readr/index.html).

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
