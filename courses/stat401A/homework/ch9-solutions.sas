library(Sleuth3)
library(ggplot2)

#9.13
TITLE '9.13';
DATA case0702;
  INFILE 'case0702.csv' DSD FIRSTOBS=2;
  INPUT Time pH;
  lTime = log(Time);

PROC GLM DATA=case0702 PLOTS=ALL;
  MODEL pH = Time / SOLUTION;
  RUN;

PROC GLM DATA=case0702 PLOTS=ALL;
  MODEL pH = Time|Time / SOLUTION;
  RUN;

PROC GLM DATA=case0702 PLOTS=ALL;
  MODEL pH = lTime / SOLUTION;
  RUN;

PROC GLM DATA=case0702 PLOTS=ALL;
  MODEL pH = lTime|lTime / SOLUTION;
  RUN;


TITLE '9.15';
DATA ex0915;
  INFILE 'ex0915.csv' DSD FIRSTOBS=2;
  INPUT Year Yield Rainfall;

PROC GLM DATA=ex0915 PLOTS=ALL;
  MODEL Yield = Rainfall / SOLUTION;
  RUN;

PROC GLM DATA=ex0915 PLOTS=ALL;
  MODEL Yield = Rainfall|Rainfall / SOLUTION;
  OUTPUT OUT=ex0915reg RESIDUALS=resid;
  RUN;

PROC SGPLOT DATA=ex0915reg;
  SCATTER y=resid x=Year;
  RUN;

DATA ex0915new;
  INPUT Rainfall Year;
  DATALINES;
6.8 1890
7.8 1890
10.5 1890
11.5 1890
15.5 1890
16.5 1890
6.8 1927
7.8 1927
10.5 1927
11.5 1927
15.5 1927
16.5 1927
;

DATA ex0915;
  SET ex0915 ex0915new;

PROC GLM DATA=ex0915 PLOTS=ALL;
  MODEL Yield = Rainfall|Rainfall Year / SOLUTION;
  OUTPUT OUT=ex0915reg PREDICTED=predicted;
  RUN;

PROC PRINT DATA=ex0915reg;
  WHERE Yield='.';
  RUN;



TITLE '9.18';
DATA ex0918; 
   INFILE 'ex0918.csv' DSD FIRSTOBS=2; 
   INPUT Continent $ Latitude Females SE_Females Males SE_Males Ratio SE_Ratio;  RUN;

PROC SORT DATA=ex0918; 
  BY Continent Latitude;

PROC TRANSPOSE DATA=ex0918 OUT=ex0918long(rename=(COL1=WingSize)); 
  BY Continent Latitude; 
  VAR Females Males; 
  RUN;

DATA ex0918long;
  SET ex0918long; 
  Sex = _NAME_;

PROC GLM DATA=ex0918long PLOTS=ALL;
  CLASS Sex(REF='Male') Continent(REF='NA');
  MODEL WingSize = Latitutde|Sex|Continent / SOLUTION;
  RUN;



TITLE '9.23';
DATA ex0923;
  INFILE 'ex0923.csv';
  INPUT Subject Gender $ AFQT Educ Income2005;
  lIncome2005 = log(Income2005);

TITLE2 'Diagnostic plots show non-constant variance and non-normality';
PROC GLM DATA=ex0923 PLOTS=ALL;
  CLASS Gender(REF='Male');
  MODEL Income2005 = Gender AFQT Educ / SOLUTION;
  RUN;

TITLE2 'Diagnostic plots look better when using log(Income2005)';
PROC GLM DATA=ex0923 PLOTS=ALL;
  CLASS Gender(REF='Male');
  MODEL lIncome2005 = Gender AFQT Educ / SOLUTION;
  RUN;

PROC GLM DATA=ex0923 PLOTS=ALL;
  CLASS Gender(REF='Male');
  MODEL lIncome2005 = Gender AFQT|Educ / SOLUTION;
  RUN;
