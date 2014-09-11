X 'cd U:\401A\sleuth3csv';

/***************************************************************/
/* Chapter 21
/***************************************************************/

TITLE 'Case 21.01';
DATA case2101; 
  INFILE 'case2101.csv' DSD FIRSTOBS=2;
  INPUT island $ area atrisk extinct;
  larea=log(area);
  proportion = extinct/atrisk;
  logit = log(proportion/(1-proportion));
  
TITLE 'Compare to Display 21.1';
PROC PRINT; RUN;

TITLE 'Compare to Display 21.2';
PROC GPLOT;
  PLOT logit*larea;
  RUN;

TITLE 'Compare to Display 21.6';
PROC GENMOD;
  MODEL extinct/atrisk = larea / DIST=binomial;
  RUN;



TITLE 'Case 21.02';
DATA case2102;
  INFILE 'case2102.csv' DSD FIRSTOBS=2;
  INPUT morph $ distance placed removed;
  proportion = removed/placed;
  logit = log(proportion/(1-proportion));

TITLE 'Compare to Display 21.3';
PROC PRINT; RUN;

TITLE 'Compare to Display 21.4';
PROC GPLOT;
  PLOT logit*distance=morph;
  RUN;

TITLE 'Compare to Display 21.8 (full MODEL)';
PROC GENMOD;
  CLASS morph;
  MODEL removed/placed = morph distance morph*distance / DIST=binomial;
  OUTPUT OUT=case2102Out P=predict RESDEV=devres COOKD=cookd;
  RUN;

TITLE 'Compare to Display 21.8 (reduced MODEL)';
PROC GENMOD;
  CLASS morph;
  MODEL removed/placed = morph distance                / DIST=binomial;
  RUN;

TITLE 'Drop-in-deviance test for interaction';
PROC IML;
  p = 1-CDF('Chisquare',25.1614-13.2299,1);
  PRINT p;

TITLE 'Compare to Display 21.5';
DATA case2102Out; SET case2102Out;
  proportion = removed/placed;
  RUN;

PROC GPLOT;
  PLOT cookd*predict;
  RUN;

TITLE 'Compare to Display 21.9';
PROC PRINT; RUN;


