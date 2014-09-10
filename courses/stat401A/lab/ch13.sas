  
/***********************************************************************/
/* Chapter 13                                                          */
/***********************************************************************/
  
TITLE 'Case 13.01';
DATA case1301;
  INFILE 'case1301.csv' DSD FIRSTOBS=2;
  INPUT cover block $ treat $;
  regratio = log(cover/(100-cover));

PROC PRINT; RUN;

TITLE2 'Compare to Display 13.10';
PROC GLM; /* Could also use PROC ANOVA */
  CLASS block treat;
  MODEL regratio=block|treat;
  RUN;

TITLE2 'Compare to Display 13.11 & 13.13';
PROC GLM;
  CLASS block treat;
  MODEL regratio=block treat;
  /*                              C  L Lf LfF  f fF */
  ESTIMATE 'large fish'    treat  0  0 -1   1 -1  1 / DIVISOR=2;
  ESTIMATE 'small fish'    treat -1 -1  1   0  1  0 / DIVISOR=2;
  ESTIMATE 'limpits'       treat -1  1  1   1 -1 -1 / DIVISOR=3;
  ESTIMATE 'limpitsXsmall' treat  2 -2  1   1 -1 -1 / DIVISOR=4;
  ESTIMATE 'limpitsXlarge' treat  0  0 -1   1  1 -1 / DIVISOR=2;
  RUN;



/* Use of LSMEANS even in a model with the interaction */
PROC GLM;
  CLASS block treat;
  MODEL regratio = block|treat;
  LSMEANS treat / CL PDIFF;       /* marginal    treatment differences */
  LSMEANS block*treat / CL PDIFF; /* conditional treatment differences */
  RUN;


TITLE 'Case 13.02';
DATA case1302;
  INFILE 'case1302.csv' DSD FIRSTOBS=2;
  INPUT company $ treat $ score;
  RUN;

TITLE2 'Comare to Display 13.14';
PROC GPLOT;
  PLOT score*companY=treat;
  RUN; QUIT;

TITLE2 'Compare to Display 13.15';
PROC PRINT; RUN;

TITLE2 'Compare to Display 13.16';
PROC GLM;
  CLASS company treat;
  MODEL score=company|treat;
  RUN;

TITLE2 'Compare to Display 13.18';
PROC GLM PLOT=(diagnostics residuals);
  CLASS company treat;
  MODEL score=company treat / SOLUTION;
  OUTPUT OUT=case1302Out R=resid P=predict;
  RUN;





  


