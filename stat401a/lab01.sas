DATA case0101;
  INFILE 'U:/401A/sleuth3csv/case0101.csv' DSD FIRSTOBS=2;
  INPUT score treament $;

PROC MEANS DATA=case0101;
  VAR score;
  BY treatment;
  RUN;

