/* To subset your data, you want to use the WHERE statement */
/* either within the DATA step or within a PROC step.       */

DATA case0402;
  INFILE 'case0402.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT time treatment $ censored;

/* create a new data set with only uncensored observations */
/* the new dataset is called 'uncensored'                  */
DATA uncensored; SET case0402;
  WHERE censored=0;

/* Notice that this data only has censored values equal to 0 */
PROC PRINT DATA=uncensored; RUN;

DATA conventional; SET case0402;
  WHERE treatment='Conventi'; 
/* by default, SAS only reads in the first 8 characters */
/* so here we use 'Conventi' rather than 'Conventional' */

/* only has the conventional treatment observations */ 
PROC PRINT DATA=conventional; RUN;

/***********************************************************/
/* T-tests                                                 */
/***********************************************************/

/* Use the subsetted data set. */
PROC TTEST DATA=uncensored;
  CLASS treatment;
  VAR time;
  RUN;
/* it is not reasonable to throw out the censored observations */
/* this is just for demonstration                              */

/* The results above match the results from the analysis below */
/* where the WHERE statement is used within PROC TTEST         */
PROC TTEST DATA=case0402;
  WHERE censored=0;
  CLASS treatment;
  VAR time;
  RUN;
