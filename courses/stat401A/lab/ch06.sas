X 'cd U:\401A\sleuth3csv';

/* Creation of Displays from Chapter 6 */
DATA case0601;
  INFILE 'case0601.csv' DELIMITER=',' FIRSTOBS=2;  
  INPUT score handicap $;  
  RUN;

PROC MEANS DATA=case0601;
  CLASS handicap;
  VAR score;
  RUN;

PROC GLM DATA=case0601;
  CLASS handicap;
  MODEL score = handicap / CLPARM;
  ESTIMATE 'crutches+wheelchair - amputee+hearing' handicap -1 1 -1 0 1 / DIVISOR=2;
  TITLE 'Compare to Display 6.4';
  RUN;

PROC GLM DATA=case0601;
  CLASS handicap;
  MODEL score = handicap / CLPARM;
  LSMEANS handicap / STDERR PDIFF CL;          /* LSD, i.e. no adjustment */
  /* 
  LSMEANS handicap / STDERR PDIFF CL ADJUST=DUNNETT PDIFF=CONTROL('None');
  LSMEANS handicap / STDERR PDIFF CL ADJUST=TUKEY;
  LSMEANS handicap / STDERR PDIFF CL ADJUST=BONFERRONI;
  LSMEANS handicap / STDERR PDIFF CL ADJUST=SCHEFFE;
  */
  TITLE ' Compare to Display 6.6';
  RUN;



DATA case0602;
  INFILE 'case0602.csv' DELIMITER=',' FIRSTOBS=2;  
  INPUT proportion pair $ length; 
  percentage = proportion*100;
  RUN;

PROC MEANS DATA=case0602 N MEAN STDDEV;
  CLASS pair;
  VAR percentage;
  TITLE 'Compare to Display 6.3';
  TITLE2 'Slightly different due to rounding';
  RUN;


/* Determine linear trend contrast coefficients */
PROC IML;
  doseL={28 31 33 34 35};
  contrL=orpol(doseL,2);  /* gets linear and quadratic (I think) */
  PRINT contrL;
  QUIT;


PROC GLM DATA=case0602;
  CLASS pair;
  MODEL percentage = pair / CLPARM;
  ESTIMATE 'linear trend' pair 5 -3 1 3 -9 3;
  TITLE 'Compare to Display 6.5';
  TITLE2 'Slightly different due to rounding';
  RUN;



/* Try Kruskal-Wallis due to concerns about normality based on histograms */ 
DATA case0501;
  INFILE 'case0501.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT lifetime diet $;

PROC NPAR1WAY WILCOXON DATA=case0501;  
  CLASS diet;  
  VAR lifetime; 
  RUN;
