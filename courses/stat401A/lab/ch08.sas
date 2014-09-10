
/***************************************************************/
/* Chapter 8
/***************************************************************/

/* Read in species DATA */
DATA species;
  INFILE 'case0801.csv' DSD FIRSTOBS=2;
  INPUT area species;

/* Compare to Display 8.1 */
PROC PRINT; RUN; 

/* Compare to Display 8.2 */
axis1 logbase=10;
axis2 logbase=10;
PROC GPLOT DATA=species;
  PLOT species*area;
  PLOT species*area / HAXIS=axis1 VAXIS=axis2;
  RUN;
  
TITLE 'insulating fluid';
DATA fluid;
  INFILE 'case0802.csv' DSD FIRSTOBS=2;
  INPUT time voltage group $;
  ltime = log(time);
  l10time = log10(time);
  sqrttime = sqrt(time);
  RUN;

PROC GPLOT DATA=fluid;
  PLOT l10time*voltage;
  PLOT2 ltime*voltage;
  TITLE 'Compare to Display 8.4';
  TITLE2 'Regression line looks slightly off';
  RUN;

PROC GPLOT DATA=fluid;
  PLOT time*voltage;
  TITLE 'Compare to Display 8.5';
  RUN;

/* Compare to Display 8.6 */
TITLE 'Hypothetical scatterplots of response versus explanatory variable';
DATA hypothetical;
  INFILE 'hypothetical.csv' DSD FIRSTOBS=2;
  INPUT x y1 y2 y3 y4 y5 y6;
  RUN;

PROC GPLOT;
  PLOT y1*x;
  PLOT y2*x;
  PLOT y3*x;
  PLOT y4*x;
  PLOT y5*x;
  PLOT y6*x;
  RUN;

PROC GLM DATA=fluid PLOT=diagnostics;
  MODEL sqrttime = voltage;
  TITLE 'Compare to Display 8.7';
  RUN;

/* Lack of fit ANOVA table, compare to Display 8.10 */
PROC REG DATA=fluid;
  MODEL ltime = voltage / LACKFIT;    /* Does not work in PROC GLM */
  TITLE 'Compare to Display 8.10';
  RUN;



TITLE 'Compare to Display 8.11';
PROC MEANS DATA=fluid N MEAN STD STDERR;
  CLASS voltage;
  VAR ltime;
  RUN;

PROC GLM DATA=fluid;
  CLASS voltage;
  MODEL ltime = voltage;
  LSMEANS voltage / STDERR;
  RUN;

PROC GLM DATA=fluid;
  MODEL ltime = voltage;
  OUTPUT OUT=fluidreg PREDICTED=Estimate STDP=SE;
  RUN;

PROC PRINT DATA=fluidreg; RUN;

QUIT; /* If SAS says `PROC XXXX running' */
