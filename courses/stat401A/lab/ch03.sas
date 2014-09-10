/*****************************************************/
/* Chapter 3                                         */
/*****************************************************/

DATA case0301;
  INFILE 'case0301.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT rainfall treatment $;
  lrainfall = log(rainfall);

/* Display 3.1 */
PROC SORT DATA=case0301;
  BY treatment;

PROC PRINT DATA=case0301;
  BY treatment;
  RUN;

/* Display 3.2 */
PROC BOXPLOT DATA=case0301;
  PLOT (rainfall lrainfall)*treatment;
  RUN;

/* Results on the bottom of page 59 */
PROC TTEST DATA=case0301;
  CLASS treatment;
  VAR lrainfall;
  RUN;

DATA case0302;
  INFILE 'case0302.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT dioxin veteran $;

/* Display 3.3 */
PROC BOXPLOT DATA=case0302;
  PLOT dioxin*veteran;
  RUN;

/* Results on the top of page 62 */
PROC TTEST DATA=case0302 SIDED=L;
  CLASS veteran;
  VAR dioxin;
  RUN;

PROC TTEST DATA=case0302 SIDED=U PLOTS=none ORDER=DATA;
  CLASS veteran;
  VAR dioxin;
  RUN;

