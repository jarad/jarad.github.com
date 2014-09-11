X 'cd U:\401A\sleuth3csv';

/*****************************************************/
/* Chapter 4                                         */
/*****************************************************/

DATA case0401;
  INFILE 'case0401.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT incidents launch $;

/* Display 4.1 */
PROC PRINT DATA=case0401; 
  RUN;

/* Statistical conclusion on page 86 */
PROC NPAR1WAY DATA=case0401 SCORES=DATA;
  CLASS launch;
  VAR incidents;
  EXACT;
  RUN;

DATA case0402;
  INFILE 'case0402.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT time treatment $ censored;

PROC NPAR1WAY DATA=case0402 WILCOXON HL;
  CLASS treatment;
  VAR time;
  RUN;


