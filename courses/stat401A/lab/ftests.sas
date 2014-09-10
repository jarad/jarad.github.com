/* 
The main purpose of this lab is 3-fold:
1 - Discuss the F-tests that SAS automatically generates
2 - Construct contrasts
3 - Construct contrasts at a specific level of an explanatory variable
*/

DATA d;
  INFILE 'ex1031.csv' DSD FIRSTOBS=2;
  INPUT CommonName $ Genus $ Species $ group $ BodyMass ClutchVolume;
  x = log(BodyMass);
  y = log(ClutchVolume);


TITLE '10.3 Extra sums of squres F-tests';
TITLE2 'Full model';
PROC GLM;
  CLASS group(ref='Mani');
  MODEL y = group x / SOLUTION;
  RUN;

TITLE2 'Reduced model';
PROC GLM;
  CLASS group(ref='Mani');
  MODEL y = x / SOLUTION;
  RUN;

/* 
  F-test for above reduced vs full models 
  Full: SSE=129.369500, df=436
  Red : SSE=156.078320, df=441

  Extra Sum of Squares = ESS = 156.078320-129.369500 = 26.70882
  Extra deg of freedom = Edf = 441-436 = 5
  MSE_full = 0.296719
  F = (ESS/Edf)/MSE_full = 18.00 ~ F_{5,436}
*/

/* 
  Type  I  sum of squares: build the model sequentially in the order provided
  Type III sum of squares: remove one term from full model
*/


TITLE '10.2.3 Contrasts';
/* What if we wanted to know 
  1) the difference between Maternal and Paternal,
  2) the Maternal mean, 
  3) the Maternal mean at x=1, or 
  5) the difference between Maternal and Paternal at x=1? 
*/

TITLE2 'Parallel lines model';
PROC GLM;
  CLASS group(ref='Mani');
  MODEL y = group x / SOLUTION;
  ESTIMATE 'Maternal - Paternal' group 0 0 1 0 -1;
  ESTIMATE 'Maternal mean' Intercept 1 group 0 0 1 0 0;
  LSMEANS group / AT x=0 CL;
  LSMEANS group / AT x=1 CL;
  RUN;


TITLE2 'Separate lines model';
PROC GLM;
  CLASS group(ref='Mani');
  MODEL y = group|x / SOLUTION;
  LSMEANS group / AT x=0 PDIFF CL; 
  LSMEANS group / AT x=1 PDIFF CL; 
  RUN;

  QUIT;
