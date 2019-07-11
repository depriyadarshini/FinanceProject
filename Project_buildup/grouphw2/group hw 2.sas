data adbesharperatio;
set adbesharperatio;
Sharpe=(expreturn-((OneMonth_Mean/100)/365))/stddev;
run;
proc print data=adbesharperatio;
run;