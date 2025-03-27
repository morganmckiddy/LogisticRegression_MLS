ods graphics on;
options validvarname=v7;

* 2019 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2019 
dbms = xlsx 
replace;
sheet = '2019';
getnames=yes;
run;
proc sort data=s2019;
    by Club;
run;

data s19;
set s2019;
if missing(Club) then delete;
year = 2019;
run;

* 2020 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2020 
dbms = xlsx 
replace;
sheet = '2020';
getnames=yes;
run;
proc sort data=s2020;
    by Club;
run;

data s20;
set s2020;
if missing(Club) then delete;
year = 2020;
run;

* 2021 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2021 
dbms = xlsx 
replace;
sheet = '2021';
getnames=yes;
run;
proc sort data=s2021;
    by Club;
run;

data s21;
set s2021;
if missing(Club) then delete;
year = 2021;
run;

* 2022 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2022
dbms = xlsx 
replace;
sheet = '2022';
getnames=yes;
run;
proc sort data=s2022;
    by Club;
run;

data s22;
set s2022;
if missing(Club) then delete;
year = 2022;
run;

* 2023 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2023 
dbms = xlsx 
replace;
sheet = '2023';
getnames=yes;
run;
proc sort data=s2023;
    by Club;
run;

data s23;
set s2023;
if missing(Club) then delete;
year = 2023;
run;

* 2024 ;
proc import datafile = '/home/u63750516/DSC 390/Datasets/MLSStatsNew.xlsx' 
out = s2024 
dbms = xlsx 
replace;
sheet = '2024';
getnames=yes;
run;
proc sort data=s2024;
    by Club;
run;

data s24;
set s2024;
if missing(Club) then delete;
year = 2024;
run;

* append sheets to singular data file ;
proc append base = mls_stats_ data = s19 force;
run;
proc append base = mls_stats_ data = s20 force;
run;
proc append base = mls_stats_ data = s21 force;
run;
proc append base = mls_stats_ data = s22 force;
run;
proc append base = mls_stats_ data = s23 force;
run;
proc append base = mls_stats_ data = s24 force;
run;

proc print data = mls_stats_;
run;


* create visualizations ;
proc sgplot data = mls_stats_;
vbox WinLossPct / category = Playoffs;
xaxis label = "Made Playoffs (0 = no, 1 = yes)";
yaxis label = "Win/Loss Percentage";
title 'Win/Loss Percentage grouped by Playoffs';
run;

proc sgplot data = mls_stats_;
scatter x = WinLossPct y = Playoffs;
run;

proc sgplot data = mls_stats_;
scatter x = GD y = Playoffs;
run;

proc sgplot data = mls_stats_;
scatter x = Pass_ y = Playoffs;
run;

proc sgplot data = mls_stats_;
vbox GD / category = Playoffs;
xaxis label = "Made Playoffs (0 = no, 1 = yes)";
yaxis label = "Goal Differential";
title 'Goal Differential grouped by Playoffs';
run;

proc sgplot data = mls_stats_;
vbox Pass_ / category = Playoffs;
xaxis label = "Made Playoffs (0 = no, 1 = yes)";
yaxis label = "Pass Percentage";
title 'Pass Percentage grouped by Playoffs';
run;


* run regression models ;

* simple linear regression prediction ;
proc logistic data=mls_stats_ (where=(year <= 2023)) descending;
title "Simple Linear Regression Model for MLS Stats";
model Playoffs = WinLossPct GD Pass_;
store mls_simple_logistic_model;
run;

proc plm restore = mls_simple_logistic_model;
score data = mls_stats_ (where = (year = 2024))out=pred_2024 predicted = p_Playoff;
run;

data pred_2024;
set pred_2024;
probability = 1 / (1 + exp(-p_Playoff));
if probability >= 0.5 then p_Playoff_binary = 1; * probability = log odds ;
else p_Playoff_binary = 0;
run;

proc print data=pred_2024;
var Club Playoffs probability p_Playoff_binary;
title "Predicted vs. Actual Playoff Results for 2024";
run;

proc sgplot data=pred_2024;
yaxis label="Made Playoffs";
vbar Club / response=Playoffs;
vbar Club / response=p_Playoff_binary
barwidth=0.5
transparency=0.2;
run;


* Multiple linear regression prediction (2-way interactions) ;
proc logistic data=mls_stats_ (where=(year <= 2023)) descending;
title "Multiple Regression Model with only 2-way interactions";
model Playoffs = WinLossPct GD Pass_ WinLossPct*GD WinLossPct*Pass_ GD*Pass_;
store mls_2way_logistic_model;
run;

proc plm restore = mls_2way_logistic_model;
score data = mls_stats_ (where = (year = 2024))out=pred_2024 predicted = p_Playoff;
run;

data pred_2024;
set pred_2024;
probability = 1 / (1 + exp(-p_Playoff)); 
if probability >= 0.5 then p_Playoff_binary = 1; 
else p_Playoff_binary = 0;
run;

proc print data=pred_2024;
var Club Playoffs probability p_Playoff_binary;
title "Predicted vs. Actual Playoff Results for 2024";
run;

proc sgplot data=pred_2024;
yaxis label="Made Playoffs";
vbar Club / response=Playoffs;
vbar Club / response=p_Playoff_binary
barwidth=0.5
transparency=0.2;
run;


* Multiple linear regression prediction (2nd ordered terms) ;
proc logistic data=mls_stats_ (where=(year <= 2023)) descending;
title "Multiple Regression Model with 2nd Ordered Terms";
model Playoffs = WinLossPct GD Pass_ WinLossPct*WinLossPct GD*GD Pass_*Pass_;
store mls_2nd_logistic_model;
run;

proc plm restore = mls_2nd_logistic_model;
score data = mls_stats_ (where = (year = 2024))out=pred_2024 predicted = p_Playoff;
run;

data pred_2024;
set pred_2024;
probability = 1 / (1 + exp(-p_Playoff));
if probability >= 0.5 then p_Playoff_binary = 1; 
else p_Playoff_binary = 0;
run;

proc print data=pred_2024;
var Club Playoffs probability p_Playoff_binary;
title "Predicted vs. Actual Playoff Results for 2024";
run;

proc sgplot data=pred_2024;
yaxis label="Made Playoffs";
vbar Club / response=Playoffs;
vbar Club / response=p_Playoff_binary
barwidth=0.5
transparency=0.2;
run;

* Multiple regression prediction (Win/Loss%, GD, Win/Loss%^2) ;
proc logistic data=mls_stats_ (where=(year <= 2023)) descending;
title "Multiple Regression Model with Win/Loss %, GD, and Win/Loss %^2";
model Playoffs = WinLossPct GD WinLossPct*WinLossPct;
store mls_logistic_model;
run;

proc plm restore = mls_logistic_model;
score data = mls_stats_ (where = (year = 2024))out=pred_2024 predicted = p_Playoff;
run;

data pred_2024;
set pred_2024;
probability = 1 / (1 + exp(-p_Playoff));
if probability >= 0.5 then p_Playoff_binary = 1; 
else p_Playoff_binary = 0;
run;

proc print data=pred_2024;
var Club Playoffs probability p_Playoff_binary;
title "Predicted vs. Actual Playoff Results for 2024";
run;

proc sgplot data=pred_2024;
yaxis label="Made Playoffs";
vbar Club / response=Playoffs;
vbar Club / response=p_Playoff_binary
barwidth=0.5
transparency=0.2;
run;


proc sgplot data=pred_2024;
yaxis label="Win Loss Pct";
vbar Playoffs / response=WinLossPct
barwidth=0.5
transparency=0.2;
run;
