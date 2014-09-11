X 'cd U:\401A\sleuth3csv';

/*************************************************************/
/* Chapter 7
/*************************************************************/
DATA bigbang;
  INFILE 'case0701.csv' DSD FIRSTOBS=2;
  INPUT velocity distance;
  RUN;

PROC GPLOT DATA=bigbang;
  PLOT distance*velocity;
  TITLE 'Compare to Display 7.1';
  RUN;

DATA carcass;
  INFILE 'case0702.csv' DSD FIRSTOBS=2;
  INPUT hours pH;    /* In the dataset, the first variable is called 'time' */
  lhours = log(hours);
  RUN;

TITLE 'Compare to Display 7.3';
PROC PRINT DATA=carcass; RUN;

PROC REG DATA=carcass;
  MODEL pH = lhours;
  TITLE 'Compare to Display 7.4';
  RUN;

/* Compare to Display 7.9 */
PROC GLM DATA=bigbang PLOT=diagnostics;
  MODEL distance = velocity;
  TITLE 'compare to Display 7.8';
  OUTPUT OUT=bigbangreg PREDICTED=fitted RESIDUAL=resid;
  RUN;

PROC PRINT DATA=bigbangreg; RUN;

PROC MEANS DATA=bigbang MEAN;
  VAR velocity;
  RUN;

/* centering trick (simple way) */
DATA bigbang; SET bigbang;
  centered=velocity-373.125;
  RUN;

PROC GLM DATA=bigbang;
  MODEL distance = centered;
  RUN;


PROC PRINT DATA=bigbang; RUN;

/* Sample correlation coefficient */
PROC CORR DATA=bigbang; RUN;

PROC GLM DATA=carcass;
  MODEL pH=lhours;
  OUTPUT OUT=carcassreg LCLM=l95m UCLM=u95m LCL=l95p UCL=u95p;
  TITLE 'Compare to Displays 7.10 and 7.12';
  RUN;

PROC PRINT DATA=carcassreg; RUN;
