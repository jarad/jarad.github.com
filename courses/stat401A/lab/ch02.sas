DATA case0201;
  INFILE 'case0201.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT year depth;

PROC PRINT DATA=case0201;
  RUN;

/* Something like Display 2.1, see the boxplots */
PROC UNIVARIATE DATA=case0201 PLOTS;
  BY year;
  VAR depth;
  RUN;

/* Results under Display 2.1 */
PROC TTEST DATA=case0201;
  CLASS year;
  VAR depth;
  RUN;


DATA case0202;
  INFILE 'case0202.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT unaffected affected;
  diff = unaffected-affected;

/* Display 2.2 */
PROC PRINT DATA=case0202; 
  RUN;

/* also results on page 101 */
PROC UNIVARIATE DATA=case0202 PLOTS;
  VAR diff;
  RUN;

/* Results above Display 2.2 and on the next page */
PROC TTEST DATA=case0202;
  VAR diff;
  RUN;

/* Displays 2.8, 2.9, 2.10 */
PROC MEANS DATA=case0201 N MEAN STD;
  CLASS year;
  VAR depth;
  RUN;
