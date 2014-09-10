
TITLE 'Case 22.01';
DATA case2201;
  INFILE 'case2201.csv' DSD FIRSTOBS=2;
  INPUT age matings;

TITLE 'Compare to Display 22.1';
PROC PRINT; RUN;

TITLE 'Compare to Display 22.2';
PROC PLOT;
  PLOT matings*age;
  RUN;

TITLE 'Compare to Display 22.6';
PROC GENMOD;
  MODEL matings = age age*age / DIST=poisson;
  RUN;

TITLE 'Compare to Display 22.8';
PROC GENMOD;
  MODEL matings = age         / DIST=poisson;
  RUN;

TITLE 'Drop-in-deviance test for quadratic term';
PROC IML;
  p = 1-CDF('Chisquare',51.0116-50.8262,1);
  PRINT p;

TITLE 'Lack-of-fit test for reduced model';
PROC IML;
  p = 1-CDF('Chisquare', 51.0116, 39);
  PRINT p;

TITLE 'Case 22.02';
DATA case2202;
  INFILE 'case2202.csv' DSD FIRSTOBS=2;
  INPUT site salamanders pctcover forestage;

TITLE 'Compare to Display 22.3';
PROC PRINT; RUN;

TITLE 'Compare to Display 22.4';
PROC GPLOT;
  PLOT salamanders*pctcover;
  RUN;

DATA case2202; SET case2202;
  IF pctcover>70 THEN closure=1; ELSE closure=0;

TITLE 'Compare to Display 22.7 AND Display 22.10 (full MODEL)';
PROC GENMOD PLOTS=ALL;
  MODEL salamanders = forestage forestage*forestage
                      pctcover pctcover*pctcover forestage*pctcover 
                      closure
                      closure*forestage closure*forestage*forestage 
                      closure*pctcover closure*pctcover*pctcover closure*forestage*pctcover
                      / DIST=poisson;
  OUTPUT OUT=case2202Out RESDEV=devres p=predict;
  RUN;

TITLE 'Compare to Display 22.7';
PROC GPLOT;
  PLOT devres*predict;
  RUN;

TITLE 'Compare to Display 22.9';
PROC GPLOT;
  PLOT forestage*pctcover;
  PLOT salamanders*pctcover;
  PLOT salamanders*forestage;
  RUN; quit;

TITLE 'Compare to Display 22.10 (reduced MODEL)';
PROC GENMOD;
  MODEL salamanders = pctcover pctcover*pctcover closure pctcover*closure pctcover*pctcover*closure 
        / DIST=poisson;
  RUN;
