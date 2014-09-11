/* The first thing to do is change your working directory by 
 * running the command below. */ 
X 'cd U:\401A\sleuth3csv';

/* The bottom right should now say U:\401A\sleuth3csv. 
 * If it doesn't, please let us know. */


/* Calculate distribution probabilities and quantiles */
PROC IML;  
  /* For calculating pvalues */
  p1 = 1-cdf('NORMAL',2);            /* P(Z       >  2 ) */  
  p2 = 1-cdf('T',3,5);               /* P(t_5     >  3 ) */  
  p3 = 1-cdf('T',3,5)+cdf('T',-3,5); /* P(t_5     > |3|) */ 
  p4 = 1-cdf('F',5,25,26);           /* P(F_25,26 >  5 ) */  

  /* Critical values for constructing confidence intervals */ 
  q1 = quantile('NORMAL',.975);      /* 0.975=P(Z < q1)     */  
  q2 = quantile('T',.975,5);         /* 0.975=P(t_5 < q2)   */  
  PRINT p1, p2, p3, p4, q1, q2; 
  QUIT; 





DATA case0201;
  INFILE 'case0201.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT year depth;
  RUN;

PROC PRINT DATA=case0201 (OBS=10);
  RUN;

PROC UNIVARIATE DATA=case0201 PLOTS;
  BY year;
  VAR depth;
  TITLE 'Display 2.1';
  RUN;

PROC TTEST DATA=case0201 H0=0 SIDES=2 ALPHA=0.05;
  CLASS year;
  VAR depth;
  TITLE 'Results under Display 2.1';
  RUN;




DATA case0202;
  INFILE 'case0202.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT unaffected affected;
  diff = unaffected-affected;

PROC PRINT DATA=case0202; 
  TITLE 'Display 2.2';
  RUN;

PROC UNIVARIATE DATA=case0202 PLOTS;
  VAR diff;
  TITLE 'Results on page 101';
  RUN;

PROC TTEST DATA=case0202;
  VAR diff;
  TITLE 'Results above Display 2.2 and on the next page';
  RUN;

PROC MEANS DATA=case0201 N MEAN STD;
  CLASS year;
  VAR depth;
  TITLE 'Displays 2.8, 2.9, 2.10';
  RUN;


/* Getting help
 *
 * The best way I have found to get help is to google the PROC and other keywords, e.g.
 * 
 * proc ttest one-sided hypothesis
 *
 * the two most helpful sites are
 *  - support.sas.com
 *  - www.ats.ucla.edu
*/
