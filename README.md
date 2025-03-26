# LogisticRegression_MLS
Multiple logistic regression models with various predictors are used to predict whether a MLS club made the playoffs in 2024.
Project Overview:
Logistic regression is used for binary qualitative response variables, and when implemented, it can be used to make accurate predictions. This can be especially useful when working with sports data, where outcomes are often two distinct events. Playoffs are a postseason series of competitions in which teams compete against each other, with the winning teams advancing. What makes a team qualify for the playoffs is determined by their game play during the regular season. This SAS program applies a logistic regression model on data from Major League Soccer to predict whether a team qualifies for the playoffs. 
README:
To access this file, open it either online in SAS OnDemand or in the downloaded SAS program. The data import step may be changed for your own datafiles. This project does not have to be just for MLS data, just be sure to change the variable names in the data visualizations and regression models. Another thing to note is that proc append will append data every time it runs, so it must only be run once during the entire session.
Dataset Information:
Data for this project was collected from https://www.mlssoccer.com/stats/clubs/#season=2025&competition=mls-regular-season&statType=general and altered slightly to have data from the past six seasons. The win loss percentage, goal differential, and passing percentage was used along with whether or not teams had made the playoffs in that particular season. Other data points were included and tested, however these three variables were the ones used for the predictors. 
Process:
Once imported into SAS, each sheet from the Excel file is trimmed of missing data and appended onto a master dataset labeled mls_stats_. Some data visualizations is run: three boxcharts, one of each predictor compared to the playoff statistic, and one scatter plot to depict the logistic relationship between the win loss percentage and whether or not a team made the playoffs. Four models are then created: 
Simple linear regression model
Two-way interaction regression model
Second-ordered regression model
A final model with win loss percentage, goal differential, and win loss percentage squared. 
These models are run on the MLS data from years 2019-2023. These data points train each model individually to then be applied to the 2024 data. Finally, the predicted probabilities for 2024 are compared to the actual playoff results for that season. A visualization is generated to compare the actual versus predicted results.
