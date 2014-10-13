X 'cd U:\401A\sleuth3csv';

/*************************************************************/
/* Chapter 7
/*************************************************************/
DATA case0701;
  INFILE 'case0701.csv' DSD FIRSTOBS=2;
  INPUT velocity distance;
  RUN;

PROC GPLOT DATA=case0701;
  PLOT distance*velocity;
  TITLE 'Compare to Display 7.1';
  RUN;

/* Compare to Display 7.9 */
PROC GLM DATA=case0701 PLOT=diagnostics;
  MODEL distance = velocity;
  OUTPUT OUT=case0701reg PREDICTED=fitted RESIDUAL=resid; 
  TITLE 'Compare to Display 7.9';
  RUN;

PROC PRINT DATA=case0701reg; 
  TITLE 'Compare to Display 7.8';
  RUN;


/* centering the explanatory variable */
PROC MEANS DATA=case0701 MEAN;
  VAR velocity;
  RUN;

DATA case0701; SET case0701;
  centered=velocity-373.125; /* Need to manually put in the mean */
  RUN;

PROC PRINT DATA=case0701; RUN;

PROC GLM DATA=case0701;
  MODEL distance = centered;
  RUN;


/* Sample correlation coefficient */
PROC CORR DATA=case0701; RUN;



DATA case0702;
  INFILE 'case0702.csv' DSD FIRSTOBS=2;
  INPUT hours pH;    /* In the dataset, the first variable is called 'time' */
  lhours = log(hours);
  RUN;

TITLE 'Compare to Display 7.3';
PROC PRINT DATA=case0702; RUN;

/* PROC REG can only be used for continuous explanatory variables
   we will use PROC REG later for variable selection */
PROC REG DATA=case0702;
  MODEL pH = lhours;
  TITLE 'Compare to Display 7.4';
  RUN;

PROC GLM DATA=case0702;
  MODEL pH = lhours;
  OUTPUT OUT=case0702reg LCLM=l95m UCLM=u95m LCL=l95p UCL=u95p; /* bands for mean and prediction */
  TITLE 'Compare to Displays 7.10 and 7.12';
  RUN;

PROC PRINT DATA=case0702reg; RUN;
