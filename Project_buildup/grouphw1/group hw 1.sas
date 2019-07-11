PROC IMPORT OUT= jpm 
            DATAFILE= "/home/u37580763/FIN 810/JPM.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

data jpm;
  set jpm;
  ret=adjclose/lag(adjclose)-1;
run;

proc means;
var ret;
run;

proc univariate data=jpm all;
var ret;
run;

/*histogram plot*/
proc gchart data=jpm;
vbar ret;
run;
quit;

proc univariate data=jpm noprint;
var ret;
histogram ret / normal(noprint);
run;

/*interval*/
proc hpbin data=jpm output=out numbin=5 bucket ;
input ret;
run;
proc print data=out; run;

/*percentile*/
proc means data=jpm p30;
var ret;
run;

proc univariate data=jpm noprint;
var ret;
output out=percentile PCTLPTS = 30 PCTLPRE = return;
run;

/*variance and standard deviation*/
proc univariate data=jpm noprint;
var ret;
output out=var var=variance;
run;
proc print data=var;
run;

proc univariate data=jpm noprint;
var ret;
output out=std std=stddev;
run;
proc print data=std;
run;


/*MAD*/
proc means data=JPM noprint;
var ret;
output out=averet(drop=_type_ _freq_) mean= / autoname;
run;

data averet;
set averet;
label ret_mean='ret_mean';
run;

proc sql;
create table JPM_stat as
select *
from JPM,averet;
run;

data JPM_stat;
set JPM_stat;
absmeandev=abs(ret-ret_mean);
run;

proc univariate data=JPM_stat;
var absmeandev;
run;

/*semi-deviation*/
data jpm2;
set JPM_stat;
where ret<=ret_mean;
run;

data semi_dev;
set jpm2;
numerator=(ret-ret_mean)**2;
run;

proc means data=semi_dev;
var numerator;
output out=hw2
	sum=numsum;
run;

proc means data=JPM noprint;
var ret;
output out=averet(drop=_type_ _freq_) mean= n= / autoname;
run;

proc sql;
create table semi_dev2 as
select *
from hw2,averet;
run;

data semi_dev2;
set semi_dev2;
semi_deviation=sqrt(numsum/(ret_N-1));
run;


