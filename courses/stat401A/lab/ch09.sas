X 'cd U:\401A\sleuth3csv';

DATA case1002;
  INFILE 'case1002.csv' DSD FIRSTOBS=2;
  LENGTH Type $22.; /* Let Type be up to 22 characters */
  INPUT Mass Type $ Energy;
  lMass = log(Mass);

  /* Construct variables by hand            */

  /* Higher order terms                     */
  Energy2 = Energy ** 2;

  /* Numeric coding of categorical variable */
  typeNumeric = 1; /* echolocating bats     */
  IF Type='non-echolocating bats'  THEN typeNumeric = 2;
  IF Type='non-echolocating birds' THEN typeNumeric = 3;

  /* Dummy/indicator variables             */
  IF Type='echolocating bats'      THEN   eBats = 1; ELSE   eBats = 0;
  IF Type='non-echolocating bats'  THEN  neBats = 1; ELSE  neBats = 0;
  IF Type='non-echolocating birds' THEN neBirds = 1; ELSE neBirds = 0;

  /* Interactions                           */
    eBatsXenergy =   eBats * Energy;
   neBatsXenergy =  neBats * Energy;
  neBirdsXenergy = neBirds * Energy;

/* Verify columns */
PROC PRINT DATA=case1002; RUN;


TITLE  'Higher order terms';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lMass = Energy + Energy2;

PROC GLM DATA=case1002; 
  MODEL lMass = Energy|Energy;
  RUN;


TITLE  'Categorical variables';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lMass = neBats neBirds;

PROC GLM DATA=case1002;
  CLASS Type(ref='echolocating bats');
  MODEL lMass = Type;

PROC GLM DATA=case1002;
  CLASS typeNumeric(ref=1);
  MODEL lmass = typeNumeric;

TITLE2 '(these are not equivalent)';
PROC GLM DATA=case1002;
  CLASS typeNumeric;
  MODEL lMass = typeNumeric;

PROC GLM DATA=case1002;
  MODEL lMass = typeNumeric;
  RUN;


TITLE  'Change reference level';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lMass = eBats neBats;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lMass = Type;
  RUN;


TITLE  'Additional explanatory variables';
PROC GLM DATA=case1002;
  MODEL lMass = Energy eBats neBats;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lMass = Energy Type;
  RUN;


TITLE  'Interactions';
PROC GLM DATA=case1002;
  MODEL lMass = Energy eBats neBats eBatsXenergy neBatsXenergy;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lMass = Energy Type Energy*Type;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lMass = Energy|Type;
  RUN;


TITLE2 'but this is different';
PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lMass = Energy*Type;
  RUN;










/***************************************************************/
/* Chapter 9
/***************************************************************/

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


