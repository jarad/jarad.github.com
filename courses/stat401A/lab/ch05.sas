X 'cd U:\401A\sleuth3csv';

/* Chapter 5 */

DATA mice;  
  INFILE 'case0501.csv' DELIMITER=',' FIRSTOBS=2;  
  INPUT lifetime diet $;  
  RUN;

PROC PRINT DATA=mice (OBS=10); RUN;

PROC BOXPLOT DATA=mice;
  PLOT lifetime*diet;
  TITLE 'Compare to Display 5.1';
  RUN;

PROC MEANS DATA=mice MAXDEC=1 N MIN MAX MEAN STDDEV CLM;  
  CLASS diet;   
  VAR lifetime;  
  TITLE 'Compare to Display 5.2';
  RUN;

PROC ANOVA DATA=mice;
  CLASS diet;
  VAR lifetime;
  TITLE 'Compare to statistical conclusions';
  RUN;

/* Alternatively */
PROC GLM DATA=mice;
  CLASS diet;
  MODEL lifetime = diet;
  LSMEANS diet / DIFF CL; /* Pairwise comparisons */
  RUN;



DATA spock;
  INFILE 'case0502.csv' DELIMITER=',' FIRSTOBS=2;
  INPUT percent judge $;
  RUN;

PROC PRINT DATA=spock (OBS=10); RUN;

PROC ANOVA DATA=spock;
  CLASS judge;
  MODEL percent = judge;
  TITLE 'Compare to Display 5.5 & 5.10';
  RUN;

PROC GLM DATA=spock PLOTS=(DIAGNOSTICS RESIDUALS);
  CLASS judge;
  MODEL percent = judge;
  RUN;

DATA spock; SET spock;
  others = 1;
  IF judge="Spock's" THEN others=0;
  RUN;

PROC PRINT DATA=spock; RUN; /* Just to check the previous DATA step */

PROC ANOVA DATA=spock;
  CLASS judge others;
  MODEL percent = others judge(others);
  TITLE 'Compare to Display 5.12';
  RUN;


/* May need for homework */
TITLE 'Residual plots';
PROC GLM DATA=spock PLOTS=(DIAGNOSTICS RESIDUALS);
  CLASS judge;
  MODEL percent=judge;
  OUTPUT OUT=spockres PREDICTED=predicted RESIDUAL=residual;
  RUN;

PROC GPLOT DATA=spockres;
  PLOT residual*predicted;
  RUN;
  

