X 'cd U:\401A\sleuth3csv';

/***************************************************************/
/* Chapter 8
/***************************************************************/

DATA species;
  INFILE 'case0801.csv' DSD FIRSTOBS=2;
  INPUT area species;

PROC PRINT; 
  TITLE 'Compare to Display 8.1';
  RUN; 

axis1 logbase=10;
axis2 logbase=10;
PROC GPLOT DATA=species;
  PLOT species*area;
  PLOT species*area / HAXIS=axis1 VAXIS=axis2;
  TITLE 'Compare to Display 8.2';
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
  RUN;

PROC GPLOT DATA=fluid;
  PLOT time*voltage;
  TITLE 'Compare to Display 8.5';
  RUN;


PROC GLM DATA=fluid PLOT=diagnostics;
  MODEL sqrttime = voltage;
  TITLE 'Compare to Display 8.7';
  RUN;

PROC REG DATA=fluid;
  MODEL ltime = voltage / LACKFIT;    /* Lack-of-fit F-test does not work in PROC GLM */
  TITLE 'Compare to Display 8.10';
  RUN;




PROC MEANS DATA=fluid N MEAN STD STDERR;
  CLASS voltage;
  VAR ltime;
  TITLE 'Compare to Display 8.11';
  RUN;

PROC GLM DATA=fluid;
  CLASS voltage; /* treating voltage as categorical */
  MODEL ltime = voltage;
  LSMEANS voltage / STDERR;
  RUN;

PROC GLM DATA=fluid;
  MODEL ltime = voltage;
  OUTPUT OUT=fluidreg 
    PREDICTED=Estimate 
    STDP = SE            /* standard error of mean       */
    STDI = SEPred;       /* standard error of prediction */
  RUN;

PROC PRINT DATA=fluidreg; 
  RUN;

