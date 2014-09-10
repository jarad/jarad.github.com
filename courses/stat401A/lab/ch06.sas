/* Creation of Displays from Chapter 6 */
DATA discrimination;
  INFILE 'case0601.csv' DELIMITER=',' FIRSTOBS=2;  
  INPUT score handicap $;  
  RUN;

DATA fish;
  INFILE 'case0602.csv' DELIMITER=',' FIRSTOBS=2;  
  INPUT proportion pair $ length; 
  percentage = proportion*100;
  RUN;

PROC MEANS DATA=fish N MEAN STDDEV;
  CLASS pair;
  VAR percentage;
  TITLE 'Compare to Display 6.3';
  TITLE2 'Slightly different due to rounding';
  RUN;

PROC MEANS DATA=discrimination;
  CLASS handicap;
  VAR score;
  RUN;

PROC GLM DATA=discrimination;
  CLASS handicap;
  MODEL score = handicap / CLPARM;
  ESTIMATE 'crutches+wheelchair - amputee+hearing' handicap -1 1 -1 0 1 / DIVISOR=2;
  TITLE 'Compare to Display 6.4';
  RUN;

PROC GLM DATA=fish;
  CLASS pair;
  MODEL percentage = pair / CLPARM;
  ESTIMATE 'linear trend' pair 5 -3 1 3 -9 3;
  TITLE 'Compare to Display 6.5';
  TITLE2 'Slightly different due to rounding';
  RUN;

PROC GLM DATA=discrimination;
  CLASS handicap;
  MODEL score = handicap / CLPARM;
  LSMEANS handicap / STDERR PDIFF CL;          /* LSD, i.e. no adjustment */
  /* 
  LSMEANS handicap / STDERR PDIFF CL ADJUST=DUNNETT;
  LSMEANS handicap / STDERR PDIFF CL ADJUST=TUKEY;
  LSMEANS handicap / STDERR PDIFF CL ADJUST=BONFERRONI;
  LSMEANS handicap / STDERR PDIFF CL ADJUST=SCHEFFE;
  */
  TITLE ' Compare to Display 6.6';
  RUN;


/* Try Kruskal-Wallis due to concerns about normality based on histograms */ 
PROC NPAR1WAY WILCOXON DATA=mice;  
  CLASS diet;  
  VAR lifetime; 
  RUN;
