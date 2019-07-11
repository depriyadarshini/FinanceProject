/* Adobe stock */
proc import out= ADBE 
            datafile= "/home/u37580763/FIN 810/ADBE.csv" 
            dbms=csv replace;
     getnames=yes;
run;


/*daily return*/
data ADBE;
  set ADBE;
  ret=adjclose/lag(adjclose)-1;
run;


/*Find Safety first ratio */
/*Rl=.00011 (4%)*/

proc univariate data=ADBE noprint;
var ret;
output out=adbetotals std=stddev
	mean=expreturn
run;
proc print data=adbetotals;
run;

data adbetotals;
set adbetotals;
SFratio=(expreturn-.00011)/stddev;
run;

/*Probability of Safety first ratio*/ 
data adbetotals;
set adbetotals;
prob=(.00011-expreturn)/stddev;
run;

data adbetotals;
set adbetotals;
probability=probnorm(prob);
run;
/*the probability that the stock will be less than the acceptable level is 48%*/


/*Sharpe ratio*/
PROC IMPORT OUT= treasury 
            DATAFILE= "/home/u37580763/FIN 810/Treasury.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

proc means data=treasury noprint;
var OneMonth;
output out=adbetbill mean= / autoname;
run;

data adbesharperatio;
merge adbetbill adbetotals;
run;

data adbesharperatio;
set adbesharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;


/* Anip stock */
proc import out= ANIP 
            datafile= "/home/u37580763/FIN 810/ANIP.csv" 
            dbms=csv replace;
     getnames=yes;
run;


/*daily return*/
data ANIP;
  set ANIP;
  ret=adjclose/lag(adjclose)-1;
run;


/*Find Safety first ratio */
/*Rl=.00011 (4%)*/

proc univariate data=ANIP noprint;
var ret;
output out=aniptotals std=stddev
	mean=expreturn
run;
proc print data=aniptotals;
run;

data aniptotals;
set aniptotals;
SFratio=(expreturn-.00011)/stddev;
run;

/*Probability of Safety first ratio*/ 
data aniptotals;
set aniptotals;
prob=(.00011-expreturn)/stddev;
run;

data aniptotals;
set aniptotals;
probability=probnorm(prob);
run;
/*the probability that the stock will be less than the acceptable level is 52%*/


/*Sharpe ratio*/
proc means data=treasury noprint;
var OneMonth;
output out=aniptbill mean= / autoname;
run;

data anipsharperatio;
merge aniptbill aniptotals;
run;

data anispharperatio;
set anipsharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;


/* chegg stock */
proc import out= CHGG 
            datafile= "/home/u37580763/FIN 810/CHGG.csv" 
            dbms=csv replace;
     getnames=yes;
run;


/*daily return*/
data CHGG;
  set CHGG;
  ret=adjclose/lag(adjclose)-1;
run;


/*Find Safety first ratio */
/*Rl=.00011 (4%)*/

proc univariate data=CHGG noprint;
var ret;
output out=chggtotals std=stddev
	mean=expreturn
run;
proc print data=chggtotals;
run;

data chggtotals;
set chggtotals;
SFratio=(expreturn-.00011)/stddev;
run;

/*Probability of Safety first ratio*/ 
data chggtotals;
set chggtotals;
prob=(.00011-expreturn)/stddev;
run;

data chggtotals;
set chggtotals;
probability=probnorm(prob);
run;
/*the probability that the stock will be less than the acceptable level is 47%*/


/*Sharpe ratio*/
proc means data=treasury noprint;
var OneMonth;
output out=chggtbill mean= / autoname;
run;

data chggsharperatio;
merge chggtbill chggtotals;
run;

data chggsharperatio;
set chggsharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;

/* JPM stock*/
PROC IMPORT OUT= jpm 
            DATAFILE= "/home/u37580763/FIN 810/JPM.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

data jpm;
  set jpm;
  ret=adjclose/lag(adjclose)-1;
run;

/*Find Safety first ratio */
/*Rl=.00011 (4%)*/

proc univariate data=jpm noprint;
var ret;
output out=jpmtotals std=stddev
	mean=expreturn
run;
proc print data=jpmtotals;
run;

data jpmtotals;
set jpmtotals;
SFratio=(expreturn-.00011)/stddev;
run;

/*Probability of Safety first ratio*/ 
data jpmtotals;
set jpmtotals;
prob=(.00011-expreturn)/stddev;
run;

data jpmtotals;
set jpmtotals;
probability=probnorm(prob);
run;
/*the probability that the stock will be less than the acceptable level is 51%*/


/*Sharpe ratio*/
proc means data=treasury noprint;
var OneMonth;
output out=jpmtbill mean= / autoname;
run;

data jpmsharperatio;
merge jpmtbill jpmtotals;
run;

data jpmsharperatio;
set jpmsharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;


/* SBUX stock */
PROC IMPORT OUT= SBUX 
            DATAFILE= "/home/u37580763/FIN 810/SBUX.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

data SBUX;
  set SBUX;
  ret=adjclose/lag(adjclose)-1;
run;

/*Find Safety first ratio */
/*Rl=.00011 (4%)*/

proc univariate data=SBUX noprint;
var ret;
output out=sbuxtotals std=stddev
	mean=expreturn;
run;
proc print data=sbuxtotals;
run;

data sbuxtotals;
set sbuxtotals;
SFratio=(expreturn-.00011)/stddev;
run;

/*Probability of Safety first ratio*/ 
data sbuxtotals;
set sbuxtotals;
prob=(.00011-expreturn)/stddev;
run;

data sbuxtotals;
set sbuxtotals;
probability=probnorm(prob);
run;
/*the probability that the stock will be less than the acceptable level is 49%*/


/*Sharpe ratio*/
proc means data=treasury noprint;
var OneMonth;
output out=sbuxtbill mean= / autoname;
run;

data sbuxsharperatio;
merge sbuxtbill sbuxtotals;
run;

data sbuxsharperatio;
set sbuxsharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;

