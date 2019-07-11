/*ADBE is the company*/
proc import datafile='/home/u37580718/JPM_2017_2019.csv'
out=jpm
dbms=csv;
run;


data jpm1;
  set jpm;
  return=adjclose/lag(adjclose)-1;
RUN;

/*** Get return and stddev of return***/
proc means data = jpm1 mean stddev;
var return;
run;

/*fama french factors*/
PROC IMPORT OUT= ff 
            DATAFILE= '/home/u37580718/my_courses/xz400/SF ratio Sharpe ratio/FF_five_factor_daily_20190329.csv'
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


/*narrow down fama french's data to 2018 and 2019*/
DATA ff1;
  SET ff;
  DATE1 = INPUT(PUT(var1,8.),YYMMDD8.);
  FORMAT DATE1 YYMMDD10.;
  year=year(date1);
  mkt_rf_d=mkt_rf/100;
  smb_d=smb/100;
  hml_d=hml/100;
  rf_d=rf/100;
RUN;

data ff20182019;
set ff1;
where year=2018 or year =2019;
run;

proc sort data=jpm1;
by date;
run;

proc sort data=ff20182019;
by date1;
run;

proc sql;
create table jpm_ff_reg as
select * 
from jpm1,ff20182019
where jpm1.date=ff20182019.date1;
quit;



data jpm_ff_reg1;
set jpm_ff_reg;
rp=return-rf_d;/*stock return premium, or stock excess return*/
run;

proc reg data=jpm_ff_reg1;
ff_3factor: model rp = mkt_rf_d smb_d hml_d;
run;