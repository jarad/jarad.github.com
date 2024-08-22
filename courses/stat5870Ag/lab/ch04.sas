X 'cd U:\401A\sleuth3csv';

/*****************************************************/
/* Chapter 4                                         */
/*****************************************************/

DATA case0401;
  INFILE 'case0401.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT incidents launch $;

PROC PRINT DATA=case0401; 
  TITLE 'Display 4.1';
  RUN;

PROC NPAR1WAY DATA=case0401 SCORES=DATA;
  CLASS launch;
  VAR incidents;
  EXACT;
  TITLE 'Statistical conclusion on page 86';
  RUN;

DATA case0402;
  INFILE 'case0402.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT time treatment $ censored;

PROC NPAR1WAY DATA=case0402 WILCOXON HL;
  CLASS treatment;
  VAR time;
  RUN;




/* Sign and signed rank tests */
DATA case0202;
  INFILE 'case0202.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT unaffected affected;
  diff = unaffected-affected;

PROC UNIVARIATE DATA=case0202;
    VAR diff;
    TITLE 'sign and signed rank tests, results on page 101';
    RUN;
