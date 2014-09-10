DATA case0901;
  INFILE 'case0901.csv' DSD FIRSTOBS=2;
  INPUT flowers time light;
  early = time-1; /* time=1 is late, time=2 is early */
  lightXearly = light*early;
  RUN;
             
TITLE 'Compare to Display 9.3'; 
SYMBOL1 VALUE=CIRCLE COLOR=BLACK;
SYMBOL2 VALUE=DOT    COLOR=BLACK;
PROC GPLOT;
  PLOT flowers*light=early;
  RUN; 

TITLE 'Compare to Display 9.14';
PROC REG;
  MODEL flowers = light early lightXearly;
  RUN; 

PROC GLM;
  MODEL flowers = light early light*early / SOLUTION;
  RUN; 

/* Include main effects plus the interaction */
PROC GLM;
  MODEL flowers = light|early / SOLUTION;
  RUN; 


/******************************************************************************/
DATA case0902;
  INFILE 'case0902.csv' DSD FIRSTOBS=2;
  INPUT species $ brain body gestation litter;
  lbrain = log(brain);
  lbody = log(body);
  lgest = log(gestation);
  llitter = log(litter);
  RUN;

TITLE 'Compare to Display 9.15';
PROC REG;
  MODEL lbrain = lbody lgest llitter;
  RUN; QUIT;


