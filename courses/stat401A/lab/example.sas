
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

/* Compare to Display 7.9 */
PROC GLM DATA=bigbang PLOT=diagnostics;
  MODEL distance = velocity;
  TITLE 'compare to Display 7.8';
  OUTPUT OUT=bigbangreg PREDICTED=fitted RESIDUAL=resid;
  RUN;

PROC PRINT DATA=bigbangreg; RUN;

