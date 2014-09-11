X 'cd U:\401A\sleuth3csv';

/***************************************************************/
/* Chapter 10
/***************************************************************/

DATA case1001;
  INFILE 'case1001.csv' DSD FIRSTOBS=2;
  INPUT distance height;
  height250 = height-250;
  height250sq = height250*height250;
  heightsq = height*height;
  heightcu = heightsq*height;
  RUN;

TITLE 'Compare to Display 10.7';
PROC REG;
  MODEL distance = height heightsq;
  MODEL distance = height250 height250sq;
  RUN; QUIT;

TITLE 'Compare to Display 10.11';
PROC GLM DATA=case1001;
  MODEL distance = height heightsq;
  RUN; QUIT;

TITLE 'Compare to Display 10.13';
PROC REG DATA=case1001;
  MODEL distance = height heightsq heightcu;
  RUN; QUIT;


/******************************************************************************/
DATA case1002;
  INFILE 'case1002.csv' DSD FIRSTOBS=2;
  LENGTH type $ 30;
  INPUT mass type $ energy;
  lenergy = log(energy);
  lmass = log(mass);
  IF type='non-echolocating birds' THEN bird=1; ELSE bird=0;
  IF type='echolocating bats'      THEN ebat=1; ELSE ebat=0;
  RUN;

PROC PRINT; RUN;

TITLE 'Compare to Display 10.4'; 
PROC GPLOT;
  PLOT lenergy*lmass=type;
  RUN;

TITLE 'Compare to Display 10.6';
PROC REG;
  MODEL lenergy = lmass bird ebat;
  RUN; QUIT;

TITLE 'Compare to Display 10.12';
PROC GLM;
  MODEL lenergy = lmass bird ebat lmass*bird lmass*ebat;
  RUN; 

/* SAS can run the F-test for you */
/* look at the lmass*type line in the Type III SS table */
PROC GLM;
  CLASS type(ref='non-echolocating bats');
  MODEL lenergy = lmass|type;
  RUN; 

TITLE 'Compare to Display 10.15';
PROC GLM DATA=case1002;
  CLASS type(ref='non-echolocating bats');
  MODEL lenergy = lmass type;
  ESTIMATE 'Birds minus echolocating bats' type -1 1 0;
  RUN; 


/******************************************************************************/
TITLE 'A comment on indicator variables';
DATA diet;
  INFILE 'case0501.csv' DSD FIRSTOBS=2;
  INPUT lifetime diet $;
  RUN;

/* Run ANOVA */
PROC ANOVA DATA=diet;
  CLASS diet;
  MODEL lifetime = diet;
  RUN;

/* Run regression using PROC REG */
/* PROC REG requires you to manually create indicator variables */
DATA diet; SET diet;
  IF diet='N/N85' THEN ind1=1; ELSE ind1=0;
  IF diet='N/R40' THEN ind2=1; ELSE ind2=0;
  IF diet='N/R50' THEN ind3=1; ELSE ind3=0;
  IF diet='R/R50' THEN ind4=1; ELSE ind4=0;
  IF diet='lopro' THEN ind5=1; ELSE ind5=0;
  RUN; 

PROC REG DATA=diet;
  MODEL lifetime = ind1 ind2 ind3 ind4 ind5;
  RUN;

/* Run regression using PROC GLM */
/* PROC GLM creates indicator variables for you */
PROC GLM DATA=diet;
  CLASS diet(ref='NP');;
  MODEL lifetime = diet / SOLUTION;
  RUN;


/******************************************************************************/
TITLE 'A comment on interaction terms';
/* Recall this model used earlier */
PROC GLM DATA=case1002;
  MODEL lenergy = lmass bird ebat lmass*bird lmass*ebat;
  RUN; QUIT;

/* GLM automatically creates indicator variables */
PROC GLM DATA=case1002;
  CLASS type;
  MODEL lenergy = lmass type lmass*type / SOLUTION;
  RUN; QUIT;


