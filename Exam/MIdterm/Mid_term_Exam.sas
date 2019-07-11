/*All the answers that contains explanation not coding is in word file please 
refer to the word document. Word document includes everything code+result+explanation.*/



data exam;
input year return;
datalines;
2005 -.0714
2006 .0162
2007 .0248
2008 -.0259
2009 .0937
2010 -.0055
2011 -.0089
2012 -.0919
2013 -.0511
2014 -.0049
2015 .0684
2016 .0304
; run;

/*1. Geometric mean*/
data exam_geo;
set exam; return_1=return+1; run;
proc surveymeans data=exam_geo geomean;
var return_1; run;

/*2. Arithmetic mean */
proc means data=exam; var return; run;

/*3.Which one will be a better estimate for the portfolio’s 
performance (annual return) for the 12 years period? And why? 
(No more than 50 words).
 */
/*Answer in word file*/








/*Part two Statistics of NVDIA weekly returns*/
proc import out=NVIDIA
datafile="/home/u37560128/my_courses/xz400/midterm 2019/NVDA weekly price 2016 2018.csv"
dbms=csv replace;
getnames=yes;
run;
/*Weekly return*/
data NVIDIA; set NVIDIA;
ret=Adj_Close/lag(Adj_Close)-1; run;

/*Arithmetic mean*/
proc means; var ret; run;

proc univariate data=NVIDIA all; var ret; run;
/*Percentile*/
proc means data=NVIDIA p95; var ret; run;

/*Trimmed Mean
The 90% trimmed mean is the mean of the values 
after truncating the lowest and highest 5% of the values.
The Winsorized and Trimmed Means are insensitive to Outliers. 
They should be reported rather than mean when the data is highly skewed.

Trimmed Mean : Removing extreme values and then calculate mean after filtering out the extreme values. 10% Trimmed Mean means calculating 10th and 90th percentile values and removing values above these percentile values.

Winsorized Mean : Capping extreme values and then calculate mean after capping extreme values at kth percentile level. It is same as trimmed mean except removing the extreme values, we are capping at kth percentile level.
*/
/*we are calculating 90% Winsorized Mean.*/
ods select winsorizedmeans;
ods output winsorizedmeans=means;
proc univariate winsorized = 0.05 data=NVIDIA;
var ret;
run;
/*we are calculating 90% trimmed Mean.*/
ods select trimmedmeans;
ods output trimmedmeans=means;
proc univariate trimmed = 0.05 data=NVIDIA;
var ret;
run;


proc means data=NVIDIA noprint;
var ret;
output out=var var=variance; run;
proc print data=var; run;
/*Standard deviation*/
proc univariate data=NVIDIA noprint; var ret;
output out=std std=stddev; run;
proc print data=std; run;
/*Median*/
proc univariate data=NVIDIA noprint; var ret;
output out=std median=Median; run;
proc print data=std; run;



/*MAD*/
proc means data=nvidia noprint;
var ret;
output out=averet(drop=_type_ _freq_) median= mean= /autoname;
run;

data averet;
set averet;
label ret_median='ret_Median'; run;

proc print data=averet; run;

proc sql;
create table NVIDIA_stat as select * from nvidia, averet; run;

data NVIDIA_stat;
set NVIDIA_stat;
absmeandev=abs(ret-ret_mean);
run;
proc univariate data=NVIDIA_stat;
var absmeandev; run;
/*Semi deviation*/

data nvidia2;
set NVIDIA_stat;
where ret<=ret_mean;
run;
data semi_dev;
set nvidia2;
numerator=(ret-ret_mean)**2;
run;
proc means data=semi_dev;
var numerator;
output out=midterm2
	sum=numsum;
run;

proc means data=nvidia noprint; var ret;
output out=averet(drop=_type_ _freq_) mean= n= / autoname;
run;

proc sql; 
create table semi_dev2 as select *
from midterm2,averet; 
run;
/*Semi-deviation*/
data semi_dev2; set semi_dev2;
semi_deviation=sqrt(numsum/(ret_N-1)); run; 
proc print data=semi_dev2; run;

/* 9Q Modal interval of 10 equally spaced grouped returns*/
proc hpbin data=NVIDIA output=Modal_stats numbin=10 bucket;
input ret; run;
proc print data=Modal_stats; run;
/*10Q Skewness
Skewness is a measure of the degree of asymmetry of a distribution. 
If skewness is close to 0, it means data is normal.
*/
ods select Moments;
proc univariate data=NVIDIA;
var ret; run;
/*skewness between 0.5 and +1, the distribution is moderately skewed..
A positive skewed data means that there are a few extreme large
values which turns its mean to skew positively. It is also called right skewed.*/


/*Q11. (11)	Do NVDA’s weekly returns have a symmetrical distribution
Ans- Histogram shows visually whether data is normally distributed.*/

proc univariate data=NVIDIA noprint;
var ret;
Histogram/ Normal(COLOR=RED); run;
/*A symmetric distribution is a type of distribution where the left side of the distribution 
mirrors the right side. 
By definition, a symmetric distribution is never a skewed distribution.
A normal distribution is a symmetric distribution*/
ods select TestsforNormality;
proc univariate data=NVIDIA normal;
var ret; run;
/*Answer B not symmetric distribution.*/
/*Kurtosis*/

proc means data=NVIDIA kurtosis;
var ret; run;
/*Kurtosis is greater than 3, data set has heavier tails than the normal distribution.*/

/* Q3. Comparison between NVIDIA and Russell 3000*/


/*Nvidia Stock*/
proc import out=NVIDIA
datafile="/home/u37560128/my_courses/xz400/midterm 2019/NVDA weekly price 2016 2018.csv"
dbms=csv replace;
getnames=yes; run;

/*Weekly return*/
data NVIDIA; set NVIDIA;
ret=Adj_Close/lag(Adj_Close)-1; run;

/*Finding Safety First Ratio
= (Expected Return on Portfolio - Investor's minimum required return)/standard deviation of portfolio*/
/*Investor's minimum return = 0.00058
 or 3% weekly*/

proc univariate data=NVIDIA noprint; var ret;
output out=nvidiatotals std=stddev mean=Exp_return; run;
proc print data=nvidiatotals; run;

data nvidiatotals; set nvidiatotals;
SFratio=(Exp_return-.00058)/stddev; run;

/*Probability of Safety First ratio*/
data nvidiatotals; set nvidiatotals;
probability=probnorm((.00058-Exp_return)/stddev); run;
/*The probability that the stock will be less than the acceptable 
level is 43%. */
/*Sharpe ratio*/
proc import out=treasury
datafile="/home/u37560128/my_courses/Priya_course_work/Financial Analytics/project/1mon_tbill_2016_2018.csv"
dbms=csv replace; getnames=yes; run;

proc means data=treasury noprint;
var BC_1MONTH;
output out=nvidiatbill mean= / autoname; run;

data nvidiasharperatio;
merge nvidiatbill nvidiatotals; run;

data nvidiasharperatio;
set nvidiasharperatio;
Sharpe=(Exp_return-((BC_1MONTH_Mean/100)/52))/stddev; run;

proc print data=nvidiasharperatio; run;

/*1 Russell 3000 statistics*/

proc import out=Russell
datafile="/home/u37560128/my_courses/Priya_course_work/Financial Analytics/project/Russell3000_weekly_2016_2018.csv"
dbms=csv replace; getnames=yes; run;

/*Weekly return*/
data Russell; set Russell;
ret=Adj_Close/lag(Adj_Close)-1; run;

/*Find the Safety First Ratio
= (Expected Return on Portfolio - Investor's minimum required return)/standard deviation of portfolio*/
/*Investor's minimum return = 0.00058
 or 3% weekly*/

proc univariate data=Russell noprint;
var ret;
output out=russelltotals std=stddev mean=Exp_return; run;

data russelltotals; set russelltotals;
SFratio=(Exp_return-0.00058)/stddev; run;

/*Probability of Safety First ratio*/
data russelltotals; set russelltotals;
probability=probnorm((0.00058-Exp_return)/stddev); run;

/*The probability that the stock will be less than the acceptable level is 47% . */

/*Sharpe ratio*/
proc import out=treasury
datafile="/home/u37560128/my_courses/Priya_course_work/Financial Analytics/project/1mon_tbill_2016_2018.csv"
dbms=csv replace; getnames=yes; run;

proc means data=treasury noprint;
var BC_1MONTH;
output out=russelltbill mean= / autoname; run;

data russellsharperatio;
merge russelltbill russelltotals; run;

data russellsharperatio;
set russellsharperatio;
Sharpe=(Exp_return-((BC_1MONTH_Mean/100)/52))/stddev; run;

proc print data=russellsharperatio; run;

/***************************NVIDIA CAPM************************************/
proc import out=NVIDIA
datafile="/home/u37560128/my_courses/xz400/midterm 2019/NVDA weekly price 2016 2018.csv"
dbms=csv replace;
getnames=yes; Datarow=2;
run;

proc import out=riskfree
datafile="/home/u37560128/my_courses/Priya_course_work/Financial Analytics/project/1mon_tbill_2016_2018.csv"
dbms=csv replace; getnames=yes; datarow=2; run;

proc import out=R3000
datafile="/home/u37560128/my_courses/Priya_course_work/Financial Analytics/project/Russell3000_weekly_2016_2018.csv"
dbms=csv replace; getnames=yes; datarow=2; run;

proc contents data=nvidia; run;
proc contents data=riskfree; run;
proc contents data=r3000; run;

data nvidia1; set nvidia; nvidia_return=Adj_Close/lag(Adj_Close)-1; run;

data r1; set r3000; r_return=Adj_Close/lag(Adj_Close)-1;
rename date=rdate; run;

data riskfree1; set riskfree;
tdate=datepart(new_date);
ttime=timepart(new_date);
format tdate MMDDYY10. ttime time8.;

t_weeklyreturn=BC_1MONTH/100/52; run;

proc sort data=nvidia1; by date; run;
proc sort data=r1; by rdate; run;
proc sort data=riskfree1; by tdate; run;
proc sql;
create table nvidia_reg as select
nvidia1.nvidia_return, nvidia1.date, r1.r_return, r1.rdate, riskfree1.t_weeklyreturn, riskfree1.tdate
from nvidia1,r1, riskfree1
where nvidia1.date=riskfree1.tdate and nvidia1.date=r1.rdate and riskfree1.tdate=r1.rdate
order by nvidia1.date, r1.rdate, riskfree1.tdate; quit;

data nvidia_reg1;
set nvidia_reg;
rp=nvidia_return-t_weeklyreturn; /*Stock return premium, or stock excess return*/
mrp=r_return-t_weeklyreturn;  /*market return premium, or market excess return*/
run;

ods graphics on;



proc reg data=nvidia_reg1;
capm: model rp=mrp; run;
ods graphics off;

/*6Q
NVIDIA's weekly return-.03/52=0.007+1.794*(.06/52)
NVIDIA's weekly return=
0.007+(1.794*.06/52)+(.03/52)=0.0096.
annual return= (.0096*365/7)=.5030 */  

/**************FINISH*************/


















