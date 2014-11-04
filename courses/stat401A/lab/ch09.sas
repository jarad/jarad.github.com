X 'cd U:\401A\sleuth3csv';

DATA case1002;
  INFILE 'case1002.csv' DSD FIRSTOBS=2;
  LENGTH Type $22.; /* Let Type be up to 22 characters */
  INPUT Energy Type $ Mass;
  lEnergy = log(Energy);
  lMass   = log(Mass);

  /* Construct variables by hand            */

  /* Higher order terms                     */
  lMass2 = lMass ** 2;

  /* Numeric coding of categorical variable */
  typeNumeric = 1; /* echolocating bats     */
  IF Type='non-echolocating bats'  THEN typeNumeric = 2;
  IF Type='non-echolocating birds' THEN typeNumeric = 3;

  /* Dummy/indicator variables             */
  IF Type='echolocating bats'      THEN   eBats = 1; ELSE   eBats = 0;
  IF Type='non-echolocating bats'  THEN  neBats = 1; ELSE  neBats = 0;
  IF Type='non-echolocating birds' THEN neBirds = 1; ELSE neBirds = 0;

  /* Interactions                           */
    eBatsXlMass =   eBats * lMass;
   neBatsXlMass =  neBats * lMass;
  neBirdsXlMass = neBirds * lMass;

/* Verify columns */
PROC PRINT DATA=case1002; RUN;


TITLE  'Higher order terms';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lEnergy = lMass lMass2;

PROC GLM DATA=case1002; 
  MODEL lEnergy = lMass|lMass;
  RUN;


TITLE  'Categorical variables';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lEnergy = neBats neBirds;

PROC GLM DATA=case1002;
  CLASS Type(ref='echolocating bats');
  MODEL lEnergy = Type / SOLUTION;

PROC GLM DATA=case1002;
  CLASS typeNumeric(ref='1');
  MODEL lEnergy = typeNumeric / SOLUTION;
  RUN;

TITLE2 '(these are not equivalent)';
PROC GLM DATA=case1002;
  CLASS typeNumeric;
  MODEL lEnergy = typeNumeric / SOLUTION;

PROC GLM DATA=case1002;
  MODEL lEnergy = typeNumeric / SOLUTION; /* treats typeNumeric as continuous */
  RUN;


TITLE  'Change reference level';
TITLE2 '(these are equivalent)';
PROC GLM DATA=case1002;
  MODEL lEnergy = eBats neBats; /* notice these dummy variables are different */

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lEnergy = Type / SOLUTION;
  RUN;


TITLE  'Additional explanatory variables';
PROC GLM DATA=case1002;
  MODEL lEnergy = lMass eBats neBats;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lEnergy = lMass Type / SOLUTION;
  RUN;


TITLE  'Interactions';
PROC GLM DATA=case1002;
  MODEL lEnergy = lMass eBats neBats eBatsXlMass neBatsXlMass;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lEnergy = lMass Type lMass*Type / SOLUTION;

PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lEnergy = lMass|Type / SOLUTION;
  RUN;


TITLE2 'but this only includes the interaction and not the main effects';
PROC GLM DATA=case1002;
  CLASS Type(ref='non-echolocating birds');
  MODEL lEnergy = lMass*Type / SOLUTION;
  RUN;


/* Apparently SOLUTION is needed whenever the explanatory variables are not all numeric */







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


