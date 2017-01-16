## ---- eval=FALSE---------------------------------------------------------
## setwd(choose.dir(getwd()))

## ------------------------------------------------------------------------
experiments = read.csv("experiments.csv")

## ---- tidy=FALSE---------------------------------------------------------
experiments2 = read.table("experiments.csv", 
                 header=TRUE, # There is a header.
                 sep=",")     # The column delimiter is a comma.

## ------------------------------------------------------------------------
all.equal(experiments, experiments2)

## ---- eval=FALSE---------------------------------------------------------
## install.packages("readr") # run this command if the readr package is not installed
## library('readr')
## experiments <- read_csv("experiments.csv")

## ---- eval=FALSE---------------------------------------------------------
## install.packages("readr") # only need to do this once
## library("readr")          # need to do this every R session
## treatment_codes <- read_csv("treatment_codes.csv")

## ---- eval=FALSE---------------------------------------------------------
## install.packages('readxl')
## library('xl')
## d = read_excel("filename.xlsx", sheet = 1) # or
## d = read_excel("filename.xlsx", sheet ="sheetName")

## ---- eval=FALSE---------------------------------------------------------
## install.packages('haven')
## library('haven')
## d = read_sas('filename.sas7bdat')

## ---- eval=FALSE---------------------------------------------------------
## library('dplyr')
## my_db <- src_sqlite("my_db.sqlite3", create = T)

## ---- eval=FALSE---------------------------------------------------------
## install.packages("RODBC")
## library('RODBC')
## 
## # RODBC Example
## # import 2 tables (Crime and Punishment) from a DBMS
## # into R data frames (and call them crimedat and pundat)
## 
## library(RODBC)
## myconn <-odbcConnect("mydsn", uid="Rob", pwd="aardvark")
## crimedat <- sqlFetch(myconn, "Crime")
## pundat <- sqlQuery(myconn, "select * from Punishment")
## close(myconn)

## ------------------------------------------------------------------------
library("dplyr")

## ---- eval=FALSE---------------------------------------------------------
## install.packages("dplyr")

## ------------------------------------------------------------------------
dim(experiments)
nrow(experiments)
ncol(experiments)

## ------------------------------------------------------------------------
names(experiments)
head(experiments)
tail(experiments)
str(experiments)

## ------------------------------------------------------------------------
summary(experiments)

## ------------------------------------------------------------------------
library("dplyr")
experiments     <- read.csv("experiments.csv")

## ------------------------------------------------------------------------
experiments %>%
  filter(code == "AI") # notice the double equal

## ------------------------------------------------------------------------
experiments %>%
  filter(win, n_cards_played > 30) %>% # win is already logical
  summary

## ------------------------------------------------------------------------
experiments %>% 
  select(n_cards_played, n_suns_played, n_owls_left) %>%
  names

experiments %>%
  select(-code, -rep, -win, -owl_score) %>%
  names

## ------------------------------------------------------------------------
experiments %>% 
  select(starts_with("n_")) %>%
  names

## ------------------------------------------------------------------------
experiments %>% 
  mutate(suns_spots_remaining   = 13 - n_suns_played,             # there are 13 sun spots
         average_owl_position   = owl_score / n_owls_left) %>% 
  head

## ------------------------------------------------------------------------
experiments %>% 
  mutate(suns_spots_remaining   = 13 - n_suns_played,
         average_owl_position   = owl_score / n_owls_left,
         average_owl_position   = ifelse(is.nan(average_owl_position), 
                                         0,                            # return 0 if NaN
                                         average_owl_position)) %>%    # otherwise leave alone
  head

## ------------------------------------------------------------------------
experiments %>%
  summarize(proportion_wins     = mean(win),
            mean_cards_played   = mean(  n_cards_played),
            median_cards_played = median(n_cards_played),
            min_cards_played    = min(   n_cards_played),
            max_cards_played    = max(   n_cards_played),
            sd_cards_played     = sd(    n_cards_played),
            var_cards_played    = var(   n_cards_played))

## ------------------------------------------------------------------------
experiments %>%
  group_by(win) %>%
  summarize(mean_cards_played   = mean(  n_cards_played),
            median_cards_played = median(n_cards_played)) %>%
  ungroup()  # this isn't necessary here, but there may be times when you want to ungroup

## ------------------------------------------------------------------------
names(experiments)
names(treatment_codes)

## ------------------------------------------------------------------------
results <- experiments %>%
  left_join(treatment_codes) # Keeps all rows in experiments and only the relevant rows in treatment_codes

## ------------------------------------------------------------------------
results2 <- experiments %>%
  left_join(treatment_codes, by="code")
all.equal(results, results2)

## ------------------------------------------------------------------------
treatment_codes <- read.csv("treatment_codes.csv", stringsAsFactors = FALSE)
experiments     <- read.csv("experiments.csv",     stringsAsFactors = FALSE)

## ---- eval=FALSE---------------------------------------------------------
## library(readr)
## treatment_codes <- read_csv("treatment_codes.csv")
## experiments     <- read_csv("experiments.csv")

