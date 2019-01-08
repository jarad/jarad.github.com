TITLE 'Paired t-test';
DATA case0202;
  INFILE 'case0202.csv' DSD FIRSTOBS=2;
  INPUT unaffected affected;

PROC TTEST DATA=case0202;
  PAIRED unaffected*affected;
  RUN;

TITLE 'Mixed effect regression';
TITLE2 'Results are the same as the paired t-test';
DATA case0202alt;
  INFILE 'case0202_alt.csv' DSD FIRSTOBS=2;
  INPUT volume schizophrenia $ twin;

PROC MIXED DATA=case0202alt;
  CLASS schizophrenia twin;
  MODEL volume=schizophrenia / SOLUTION;
  RANDOM twin;
  RUN;

TITLE 'Extending to more than 2 observations';
DATA case1301;
  INFILE 'case1301.csv' DSD FIRSTOBS=2;
  INPUT cover block $ treatment $ ;
  lrr = log(cover/(100-cover));

TITLE2 'Fixed effect regression';
PROC GLM DATA=case1301;
  CLASS block treatment(ref="CONTROL");
  MODEL lrr=treatment block / SOLUTION;
  RUN;

TITLE2 'Mixed effect regression';
PROC MIXED DATA=case1301;
  CLASS block treatment(ref="CONTROL");
  MODEL lrr=treatment / SOLUTION;
  RANDOM block / SOLUTION;
  RUN;
