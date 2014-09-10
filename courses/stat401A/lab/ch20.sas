
TITLE 'Case 20.01';
DATA case2001;
  INFILE 'case2001.csv' DSD FIRSTOBS=2;
  INPUT age sex $ status $;

PROC PRINT; RUN;

DATA case2001; SET case2001;
  IF status='Survived' THEN survived=0; ELSE survived=1;
  IF sex='Female' THEN female=1; ELSE female=0;

TITLE 'Compare to Display 20.5';
PROC GENMOD;
  MODEL survived = age female age*female / DIST=binomial;
  RUN;


TITLE 'Compare to Display 20.6';
PROC GENMOD;
  MODEL survived = age female / DIST=binomial;
  RUN;

TITLE 'Drop-in-deviance test for interaction';
PROC IML;
  p = 1-CDF('Chisquare',2*25.6281-2*23.6732,1);
  PRINT p;

TITLE ' Compare to Display 20.8';
PROC GENMOD;
  MODEL survived = female age female*age age*age female*age*age / DIST=binomial;
  RUN;

DATA case2001; SET case2001;
  surv=1-survived;
TITLE 'Compare to Display 20.9 (DATA points only)';
PROC GPLOT;
  PLOT surv*age=female;
  RUN;

TITLE 'Case 20.02';
DATA case2002;
  INFILE 'case2002.csv' DSD FIRSTOBS=2;
  INPUT lc $ fm $ ss $ bk $ ag yr cd;
  RUN;

TITLE 'Compare to Display 20.2';
PROC PRINT DATA=case2002; RUN;

TITLE 'Compare to Display 20.7 (full MODEL)';
PROC GENMOD;
  CLASS fm ss bk;
  MODEL lc = fm ag ss yr bk / DIST=binomial;
  RUN;

TITLE 'Compare to Display 20.7 (reduced MODEL)';
PROC GENMOD;
  CLASS fm ss bk;
  MODEL lc = fm ag ss yr    / DIST=binomial;
  RUN;

TITLE 'Compare to Display 20.10';
PROC GPLOT;
  WHERE bk="Bird" AND lc="LungCanc";
  PLOT yr*ag;
  RUN;

TITLE 'Compare to Display 20.12 (results agree with R, but not exactly with the book';
PROC GENMOD;
  CLASS fm ss bk;
  MODEL lc = fm ag ss yr cd yr*yr cd*cd yr*cd    / DIST=binomial;
  RUN;

PROC GENMOD;
  CLASS fm ss bk;
  MODEL lc = fm ag ss yr cd yr*yr cd*cd yr*cd bk / DIST=binomial;
  RUN;

