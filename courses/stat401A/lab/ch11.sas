/***********************************************************************/
/* Chapter 11                                                          */
/***********************************************************************/

TITLE 'Case 11.01';
DATA case1101;
  INFILE 'case1101.csv' DSD FIRSTOBS=2;
  INPUT subject metabolism activity sex $ alcohol $;
  RUN;

TITLE2 'Compare to Display 11.1';
PROC PRINT; RUN;

TITLE2 'Compare to Display 11.2';
PROC SGPLOT;
  SCATTER X=activity Y=metabolism / GROUP=sex MARKERCHAR=alcohol;
  RUN;

TITLE2 'Compare to Display 11.9';
PROC GLM DATA=case1101 PLOTS=(diagnostics residuals);
  CLASS sex alcohol;
  MODEL metabolism = activity|sex|alcohol / SOLUTION; 
  OUTPUT OUT=case1101Out R=resid P=predict;
  RUN; QUIT;

TITLE2 'Compare to Display 11.7';
PROC GPLOT;
  PLOT resid*predict;
  RUN;

PROC PRINT; RUN;

TITLE2 'Compare to Display 11.9';
PROC GLM DATA=case1101 PLOTS=(diagnostics residuals);
  CLASS sex alcohol;
  MODEL metabolism = activity|sex|alcohol / SOLUTION;
  WHERE subject<31;
  RUN; QUIT;

TITLE2 'Compare to Display 11.12';
PROC GLM DATA=case1101 PLOTS=(diagnostics residuals);
  CLASS sex;
  MODEL metabolism = activity|sex;
  OUTPUT OUT=case1101Out2 R=resid P=predict STUDENT=student H=leverage COOKD=cookd;
  RUN; QUIT;

 /* To find the obserations */
PROC SORT DATA=case1101Out2;
  BY DESCENDING cookd;
  RUN;

PROC PRINT DATA=case1101Out2 (obs=10); RUN;



/**************************** Case 11.02 ******************************/
TITLE2 'Case 11.02';
DATA case1102;
  INFILE 'case1102.csv' DSD FIRSTOBS=2;
  INPUT brain liver time treat $ days sex $ weight loss tumor;
  response = log(brain/liver);
  ltime = log(time);
  i = _n_;                /* A variable for the observation number */
  RUN;

TITLE2 'Compare to Display 11.4';
PROC PRINT; RUN;

TITLE2 'Compare to Display 11.5';
PROC GPLOT;
  PLOT response*ltime=treat;
  RUN; QUIT;


PROC GLM PLOTS=(diagnostics residuals);
  CLASS time treat days sex;
  MODEL response=time treat time*treat days sex weight loss tumor / SOLUTION;
  OUTPUT OUT=case1102Out R=resid P=predict;
  RUN; QUIT;

TITLE2 'Compare to Display 11.6';
PROC GPLOT;
  PLOT resid*predict;
  PLOT resid*i; /* not in display 11.6 */
  RUN;


/**************************** Case 09.02 *****************************/
DATA case0902;
  INFILE 'case0902.csv' DSD FIRSTOBS=2;
  INPUT species $ brain body gest litter;
  lbrain = log(brain);
  lgest  = log(gest);
  lbody  = log(body);
  RUN;

PROC REG;
  MODEL lbrain = lgest lbody;
  OUTPUT OUT=case0902Out R=resid;
  RUN;

DATA case0902Out; SET case0902Out;
  pres  = resid+0.66782*lgest;
  pres2 = lbrain-(-0.45728+0.55117*lbody);
  RUN;

TITLE2 'Compare to Display 11.15';
PROC GPLOT;
  PLOT lbrain*lgest;
  PLOT pres*lgest;
  PLOT pres2*lgest;
  RUN;


