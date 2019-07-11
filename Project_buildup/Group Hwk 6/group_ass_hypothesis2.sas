/** value v growth firms***/

/*** Adobe ***/
PROC IMPORT OUT= riskfree 
            DATAFILE= "/home/u37580718/ADBE_2010_2019_Ticker.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data riskfree1;
  set riskfree;
  return=adjclose/lag(adjclose)-1;
RUN;



/** get year, month, weekday from date**/
data riskfree1;
set riskfree1;
year=year(date);
run;

data riskfree2;
set riskfree1;
where (year>=2015) and (year<=2019); 
run;

/** JPM **/
PROC IMPORT OUT= jpm 
            DATAFILE= "/home/u37580718/JPM_2010_2019_Ticker.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data jpm1;
  set jpm;
  return=adjclose/lag(adjclose)-1;
RUN;

data jpm1;
set jpm1;
year=year(date);
run;

data jpm2;
set jpm1;
where (year>=2015) and (year<=2019); 
run;

/*** merge jpm and adobe tables**/

proc sort data=jpm2;
by date;
run;

proc sort data=riskfree2;
by date;
run;

/** join tables **
proc sql;
create table jpm_adbe as
select * from jpm2 outer union
select * from riskfree2
order by ticker;
quit;
**/



proc append base=jpm2
			data = riskfree2 force;
run;




data jpm_adbe1;
set jpm2;
if ticker="JPM" then d_stock=1;
else d_stock=0;
run;



proc sort data=jpm_adbe1;
by d_stock;
run;
proc means data=jpm_adbe1;
by d_stock;
var return;
run;

/**** by ticker ***/
ods graphics on;  

proc ttest data=jpm_adbe1 cochran ci=equal umpu;
 	   class d_stock;
       var return;
   run;



















