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

PROC SGPLOT DATA=species;
  SCATTER Y=species X=area;
  TITLE 'Compare to Display 8.2';
  RUN;

PROC SGPLOT DATA=species;
  SCATTER Y=species X=area;
  XAXIS TYPE=log;                            /* default is base 10 */
  YAXIS TYPE=log;
  TITLE 'Compare to Display 8.2';
  RUN;
  


TITLE 'insulating fluid';
DATA fluid;
  INFILE 'case0802.csv' DSD FIRSTOBS=2;
  INPUT time voltage group $;
  ltime = log(time);
  sqrttime = sqrt(time);
  RUN;


PROC SGPLOT DATA=fluid;
  SCATTER Y=time X=voltage;
  TITLE 'Compare to Display 8.5';
  RUN;


PROC SGPLOT DATA=fluid;
  SCATTER Y=time X=voltage;
  YAXIS  TYPE=log LOGBASE=10;
  Y2AXIS TYPE=log LOGBASE=e LOGSTYLE=linear; /* currently not working */
  TITLE 'Compare to Display 8.4';
  RUN;


PROC GLM DATA=fluid PLOT=(diagnostics residuals);
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
  CLASS voltage;                     /* treating voltage as categorical */
  MODEL ltime = voltage;
  LSMEANS voltage / STDERR;
  RUN;

PROC GLM DATA=fluid;
  MODEL ltime = voltage;
  OUTPUT OUT=fluidreg 
    PREDICTED=Estimate 
    STDP = SE                        /* standard error of mean       */
    STDI = SEPred;                   /* standard error of prediction */
  RUN;

PROC PRINT DATA=fluidreg; 
  RUN;

