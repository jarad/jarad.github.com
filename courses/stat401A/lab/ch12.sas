

/***********************************************************************/
/* Chapter 12                                                          */
/***********************************************************************/

TITLE 'Case 12.01';
DATA case1201;
  INFILE 'case1201.csv' DSD FIRSTOBS=2;
  INPUT state $ sat takers income years public expend rank;
  ltakers = log(takers);
  IF state='"Alaska"' THEN DELETE;
  RUN;

TITLE2 'Compare to Display 12.1';
PROC PRINT; RUN;

TITLE2 'Compare to Display 12.4';
PROC SGSCATTER;
  matrix takers rank years income public expend sat;
RUN; QUIT;

TITLE2 'Compare to Section 12.3.4 ';
PROC REG;
  MODEL sat=ltakers rank years income public expend / SELECTION=forward;
  MODEL sat=ltakers rank years income public expend / SELECTION=backward;
  MODEL sat=ltakers rank years income public expend / SELECTION=stepwise SLENTRY = 0.10 SLSTAY = 0.15;
  RUN; QUIT;

TITLE2 'Compare to Display 12.9';
PROC REG;
  MODEL sat=ltakers rank years income public expend / SELECTION=Cp AIC SBC; /* SBC is our BIC */
  PLOT cp.*np. / CMALLOWS=blue VAXIS=0 to 10 BY 1;
  RUN; QUIT;




PROC GLMSELECT;
  /* Can include a CLASS statement here which you cannot do in PROC REG */
  MODEL sat=ltakers rank years income public expend / SELECTION=stepwise CHOOSE=SBC; 
  RUN;

