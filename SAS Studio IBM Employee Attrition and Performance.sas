/*** 
Goal:
What company drivers impact attrition for each employee, e.g. 
does low job satisfaction or something else leads to attrition, across departments?

Are there like-employee cohorts that, as a group, 
are at a higher risk for attrition and could be addressed holistically versus individually?

What are the common themes across the employee base that could be used to form a program or 
campaign for employees that would resonate?

Dataset: IBM Employee Attrition and Performance
***/
options nocenter;

/*** Import EXCEL to SAS for analysis...ENTER THE LOCATION OF YOUR IBM DATASET IN SAS STUDIO ***/
proc import OUT     =IBM_HR_Analytics
            DATAFILE="/home/michael5/HRM Datasets/IBM Employee Attrition and Performance.xlsx" 
			DBMS	=XLSX REPLACE;
			GETNAMES=YES;
run;

title1 'Data dictionary for the dataset';
title2 'IBM HR Analytics';
     proc contents  data=IBM_HR_Analytics;      
     run;

title1 'Average Employee job satisfaction by Department';
title2 'Overall job statisfaction 1-low and 4-high';
     proc gchart    data=work.ibm_hr_analytics;
          vbar3d    Department / sumvar=JobSatisfaction type=mean outside=mean;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;


title1 'Average Employee job satisfaction by satifaction of work environment';
title2 'By department job statisfaction 1-low and 4-high';
     proc gchart    data=IBM_HR_Analytics;
          vbar3d    EnvironmentSatisfaction / sumvar=JobSatisfaction type=mean group=Department outside=mean discrete;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
   

title1 'Average Relationship Satisfaction with my Supervisor by satifaction with my work environment';
title2 'By department job statisfaction 1-low and 4-high';
     proc gchart    data=IBM_HR_Analytics;
          vbar      EnvironmentSatisfaction / sumvar=RelationshipSatisfaction type=mean group=Department discrete outside=mean;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
  
 
title1 'Average Employee job satisfaction by education';
title2 'By education feield specialty and job statisfaction 1-low and 4-high';
     proc gchart    data=IBM_HR_Analytics;
          vbar3d    EducationField / type=mean sumvar=JobSatisfaction discrete outside=mean;
          format    JobSatisfaction 4.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
          quit;
  

title1 'Average Employee job satisfaction by travel frequency';
title2 'By travel frequency and job statisfaction 1-low and 4-high';
     proc gchart    data=IBM_HR_Analytics;
          vbar3d      BusinessTravel / type=mean sumvar=JobSatisfaction discrete outside=mean;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
     quit;

/*** 
Goal:
The IBM hypotehsis is that employee satisfaction was waned which we believe is resulting in attrition of key staff; 
as such we want to understand the key drivers of satisfaction.

Research question:
What company drivers impact attrition for each employee, e.g. 
does low job satisfaction or something else that leads to attrition, across departments?
***/

     data IBM_HR_Analytics_New; 
     	set IBM_HR_Analytics;
     
          if Attrition='Yes'                      then Attrition_Indicator=1;   else Attrition_Indicator=0;
          if MaritalStatus='Married'              then Married_Indicator=1;     else Married_Indicator=0;
          if BusinessTravel='Non-Travel'          then Non_Travel_Indicator=1;  else Non_Travel_Indicator=0; 
          if Department='Research & Development'  then Research_Development=1;  else Research_Development=0;  
          if Department='Sales'                   then Sales=1;                 else Sales=0;  
          if Department='Human Resources'         then Human_Resources=1;       else Human_Resources=0;  
          if Gender='Male'                        then Male_Indicator=1;        else Male_Indicator=0;
          if OverTime='Yes'                       then OverTime_Indicator=1;    else OverTime_Indicator=0;
          AnnualIncome=MonthlyIncome*12;
     run;
     
title1 'Employee job satisfaction and the relationship with attrition';
title2 'Attrition by job satisfaction';
     proc gchart    data=IBM_HR_Analytics_New;
          hbar3d    Attrition / type=mean sumvar=JobSatisfaction discrete outside=mean;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
     quit;

title1 'Employee job satisfaction and the relationship with attrition, by department';
title2 'Attrition by department and job satisfaction';
     proc gchart    data=IBM_HR_Analytics_New;
          hbar3d    Attrition / type=mean sumvar=JobSatisfaction group=Department discrete outside=mean;
          format    JobSatisfaction comma12.2;
          label     JobSatisfaction='Job Satisfaction';
          run;
     quit;

title1 'Employee job satisfaction correlation with attrition';
title2 'Correlation analysis between attrition and job satisfaction';
     proc corr      data=IBM_HR_Analytics_New;
          with      JobSatisfaction
                    RelationshipSatisfaction
                    EnvironmentSatisfaction
                    ;                   
          var       Attrition_Indicator;
     run;
     
title1 'All employee survey respinses and their relationship(s) with attrition';
title2 'Correlation analysis between all employee survey responses and attrition';
     proc corr      data=IBM_HR_Analytics_New nosimple;
         var        Attrition_Indicator;
         with       JobSatisfaction
                    RelationshipSatisfaction
                    EnvironmentSatisfaction
                    Research_Development 
                    Sales 
                    Non_Travel_Indicator 
                    Human_Resources
                    Married_Indicator 
                    AnnualIncome
                    DistanceFromHome
                    Education
                    Male_Indicator
                    NumCompaniesWorked
                    PercentSalaryHike
                    OverTime_Indicator
                    PerformanceRating
                    StockOptionLevel
                    TotalWorkingYears
                    TrainingTimesLastYear
                    WorkLifeBalance
                    YearsAtCompany
                    YearsInCurrentRole
                    YearsSinceLastPromotion
                    YearsWithCurrManager
                    Age;
     run;

title1 'Employee variables analyzed for relationship(s) - IBM HR Analytics';
title2 'Full matrix univariate correlation analysis between attrition by any of the variables';
     proc corr      data=IBM_HR_Analytics_New nosimple best=20;
          var       JobSatisfaction
                    RelationshipSatisfaction
                    EnvironmentSatisfaction
                    Research_Development 
                    Sales 
                    Non_Travel_Indicator 
                    Human_Resources
                    Married_Indicator 
                    AnnualIncome
                    DistanceFromHome
                    Education
                    Male_Indicator
                    NumCompaniesWorked
                    PercentSalaryHike
                    OverTime_Indicator
                    PerformanceRating
                    StockOptionLevel
                    TotalWorkingYears
                    TrainingTimesLastYear
                    WorkLifeBalance
                    YearsAtCompany
                    YearsInCurrentRole
                    YearsSinceLastPromotion
                    YearsWithCurrManager
                    Age;
     run;

title1 'Employee attrition percentage';
title2 'What is the overall attrition percent';
     proc freq     data=IBM_HR_Analytics_New;
          tables   Attrition_Indicator / plots=FreqPlot;
     run;
/*** 
Goal:
Hypothesis employee satisfaction (IBM thinks that is the reason) was waned which we believe is resulting in attrition of key staff; 
as such we want to understand the key drivers of satisfaction.

Note:
It is difficult to determine any single variable that is associated with attrition,
as such we need to run a multivariate model...i.e. Regression Model

Research question:
What company survey drivers impact attrition for each employee, e.g. 
and does low job satisfaction or other variables lead to attrition, across departments?
***/
/***---------------------------------------------------------------------------------------------------------------------- 
Regression analysis
----------------------------------------------------------------------------------------------------------------------***/
title1 'All employee variables are analyzed for relationship(s) with attrition';
title2 'This multivariate analysis between employee variables and attrition (dependent variable is the variable to model)';
title3 'What company survey drivers impact attrition for each employee?';
     proc reg       data=work.ibm_hr_analytics_new;
          model     Attrition_Indicator =
          
                    JobSatisfaction
                    RelationshipSatisfaction
                    EnvironmentSatisfaction
                    Research_Development 
                    Sales 
                    Non_Travel_Indicator 
                    Human_Resources
                    Married_Indicator 
                    AnnualIncome
                    DistanceFromHome
                    Education
                    Male_Indicator
                    NumCompaniesWorked
                    PercentSalaryHike
                    OverTime_Indicator
                    PerformanceRating
                    StockOptionLevel
                    TotalWorkingYears
                    TrainingTimesLastYear
                    WorkLifeBalance
                    YearsAtCompany
                    YearsInCurrentRole
                    YearsSinceLastPromotion
                    YearsWithCurrManager
                    Age 
                    / selection=stepwise slentry=0.05 slstay=0.05;
                    output out=ibm_hr_analytics_new p=Attrition_Prediction;
     run;
     quit;
     
     data IBM_HR_Analytics_New; 
     	set IBM_HR_Analytics_New;
     	
     	if Attrition_Prediction>0.25 then 	Modeled_Attrition='Yes';
     	else								Modeled_Attrition='No';
     	
     run;
     
title1 ' ';
title2 ' ';
title3 'How accurate is the model with actual attrition results?';
     proc freq data=IBM_HR_Analytics_New;
     	table Attrition * Modeled_Attrition;
     run;
     
     
     proc print data=IBM_HR_Analytics_New;
       where Modeled_Attrition='Yes';
     run;
     quit;
         
/*** 
Goal:
Hypothesis employee satisfaction (IBM thinks that is the reason) was waned which we believe is resulting in attrition of key staff; 
as such we want to understand the key drivers of satisfaction.

Research question:
Now that we know some of the company drivers that impact attrition for each employee, 
are there like-employee cohorts (groups of employees) that are at a higher risk for attrition 
and could be addressed holistically, as a group, versus individually?
***/

/***---------------------------------------------------------------------------------------------------------------------- 
Cluster analysis
----------------------------------------------------------------------------------------------------------------------***/
title1 'Employee clusters (grouping of employees) based on attrition';
title2 'This cluster analysis is used to cluster employess into actionable groups for HR programs';
title3 'Are there like-employee groups that are at a higher risk for 
attrition and could be addressed holistically versus individually?';

     proc fastclus  data=IBM_HR_Analytics_New maxclusters=4 
     
                    out =IBM_HR_Analytics_New cluster=Employee_Cluster;
                    
          var       Attrition_Indicator
                    JobSatisfaction
                    RelationshipSatisfaction
                    EnvironmentSatisfaction
                    Research_Development 
                    Sales 
                    Non_Travel_Indicator 
                    Human_Resources
                    Married_Indicator 
                    AnnualIncome
                    DistanceFromHome
                    Education
                    Male_Indicator
                    NumCompaniesWorked
                    PercentSalaryHike
                    OverTime_Indicator
                    PerformanceRating
                    StockOptionLevel
                    TotalWorkingYears
                    TrainingTimesLastYear
                    WorkLifeBalance
                    YearsAtCompany
                    YearsInCurrentRole
                    YearsSinceLastPromotion
                    YearsWithCurrManager
                    ;
     run;
     quit;
     
     proc print data=IBM_HR_Analytics_New;
     	var EmployeeNumber
     		Employee_Cluster
     		leave;
     run;

title1 'Employee cluster plot';
title2 'Cluster plot to group employess into visible clusters';
title3 'Shows some employees are distant from their cluster centroid - center of the cluster';
     proc candisc data=IBM_HR_Analytics_New ncan=2 out=outcan noprint;
     
          class 		Employee_Cluster;
            var         Attrition_Indicator
                        JobSatisfaction
                        RelationshipSatisfaction
                        EnvironmentSatisfaction
                        Research_Development 
                        Sales 
                        Non_Travel_Indicator 
                        Human_Resources
                        Married_Indicator 
                        AnnualIncome
                        DistanceFromHome
                        Education
                        Male_Indicator
                        NumCompaniesWorked
                        PercentSalaryHike
                        OverTime_Indicator
                        PerformanceRating
                        StockOptionLevel
                        TotalWorkingYears
                        TrainingTimesLastYear
                        WorkLifeBalance
                        YearsAtCompany
                        YearsInCurrentRole
                        YearsSinceLastPromotion
                        YearsWithCurrManager
                        ;
     run;
     proc sgplot data = outcan; 
          scatter y = can1 x = can2  / group = Employee_Cluster; 
          label     can1='Group of variables for max seperation'
                    can2='Group of variables for max seperation';   
     run;

title1 'Employee clusters different characteristics';
title2 'Cluster analysis to cluster employess into actionable clusters';
     proc tabulate  data=IBM_HR_Analytics_New;
     
          class     Employee_Cluster;
          
         
          var       Attrition_Indicator 
                    JobSatisfaction 
                    Married_Indicator
                    AnnualIncome
                    Age
                    YearsSinceLastPromotion
                    DistanceFromHome    
                    YearsWithCurrManager     
                    NumCompaniesWorked
                    WorkLifeBalance
                    YearsInCurrentRole
                    OverTime_Indicator
                    Research_Development
                    StockOptionLevel
                    Non_Travel_Indicator
                    ;
                    
          tables    Attrition_Indicator      *mean='% Attrition'                *f=percent12.2 
                    JobSatisfaction          *mean='Job Satisfaction'           *f=comma12.2 
                    Married_Indicator        *mean='% Married'                  *f=percent12.2 
                    AnnualIncome             *mean='Annual Income'              *f=dollar12. 
                    Age                      *mean='Age'                        *f=comma12.
                    YearsSinceLastPromotion  *mean='Years Since Last Promotion' *f=comma12.2 
                    DistanceFromHome         *mean='Distance From Home'         *f=comma12.2 
                    YearsWithCurrManager     *mean='Years With Current Manager' *f=comma12.2 
                    NumCompaniesWorked       *mean='Number Companies Worked'    *f=comma12.2 
                    WorkLifeBalance          *mean='Work Life Balance'          *f=comma12.2 
                    YearsInCurrentRole       *mean='Years In Current Role'      *f=comma12.2 
                    OverTime_Indicator       *mean='% Worked Over Time'         *f=percent12.2 
                    StockOptionLevel		 *mean='Stock Option Level'         *f=percent12.2 
                    Non_Travel_Indicator	 *mean='% Not Traveling'            *f=percent12.2 
                    n='Number of Employees'
                    
                    ,Employee_Cluster='Employee Cluster' all='Overall';
     run;

/*** 
Goal:
Hypothesis employee satisfaction (IBM thinks that is the reason) was waned which we believe is resulting in attrition of key staff; 
as such we want to understand the key drivers of satisfaction.

Research question:
Now that we know that there are like-employee cohorts (group of employees) that are at a higher risk 
for attrition and could be addressed holistically versus individually - What are the common themes 
across the employee groups that could be used to form an HR intervention program using a few attributes?
***/

/***---------------------------------------------------------------------------------------------------------------------- 
Factor analysis
----------------------------------------------------------------------------------------------------------------------***/
title1 'Employee common factors';
title2 'Factor analysis to create common themes among employess to create an actionable program';
title3 'What are the common themes across the employee base that could be used to form a program for 
employees that would resonate with them?';

     proc factor data=IBM_HR_Analytics_New
                    (drop=    distance HourlyRate EmployeeNumber 
                              EmployeeCount DailyRate MonthlyRate StandardHours) 
                              
          n=4 score out=IBM_HR_Analytics_New;
     run;

     data IBM_HR_Analytics_New; 
     	set IBM_HR_Analytics_New;
     	          
               if Factor1>max(Factor2,Factor3,Factor4) then Factor='Factor 1';
          else if Factor2>max(Factor1,Factor3,Factor4) then Factor='Factor 2';
          else if Factor3>max(Factor2,Factor1,Factor4) then Factor='Factor 3';
          else if Factor4>max(Factor2,Factor3,Factor1) then Factor='Factor 4';
     run;
     
title3 'Select the top 4 Factor / themes by Employee Cluster to help develop an HR retention program, 
that likely influences whether an employee stays or leaves';
     proc tabulate data=IBM_HR_Analytics_New;
     	class 	Employee_Cluster 
     			Factor;
     	var   	Attrition_Indicator;
     	tables	Employee_Cluster, Factor*(Attrition_Indicator)*mean*f=8.4; 
     run;
     
title3 'Select the top 4 Factor / themes by Employee Cluster to help develop an HR retention program, 
that likely influences whether an employee stays or leaves';
     proc tabulate data=IBM_HR_Analytics_New;
     	class 	Employee_Cluster 
     			Factor;
     	 var    Attrition_Indicator 
                JobSatisfaction 
                Married_Indicator
                AnnualIncome
                Age
                YearsSinceLastPromotion
                DistanceFromHome    
                YearsWithCurrManager     
                NumCompaniesWorked
                WorkLifeBalance
                YearsInCurrentRole
                OverTime_Indicator
                Research_Development
                StockOptionLevel
                Non_Travel_Indicator
                ;
                    
          tables    Attrition_Indicator      *mean='% Attrition'                *f=percent12.2 
                    JobSatisfaction          *mean='Job Satisfaction'           *f=comma12.2 
                    Married_Indicator        *mean='% Married'                  *f=percent12.2 
                    AnnualIncome             *mean='Annual Income'              *f=dollar12. 
                    Age                      *mean='Age'                        *f=comma12.
                    YearsSinceLastPromotion  *mean='Years Since Last Promotion' *f=comma12.2 
                    DistanceFromHome         *mean='Distance From Home'         *f=comma12.2 
                    YearsWithCurrManager     *mean='Years With Current Manager' *f=comma12.2 
                    NumCompaniesWorked       *mean='Number Companies Worked'    *f=comma12.2 
                    WorkLifeBalance          *mean='Work Life Balance'          *f=comma12.2 
                    YearsInCurrentRole       *mean='Years In Current Role'      *f=comma12.2 
                    OverTime_Indicator       *mean='% Worked Over Time'         *f=percent12.2 
                    StockOptionLevel		 *mean='Stock Option Level'         *f=percent12.2 
                    Non_Travel_Indicator	 *mean='% Not Traveling'            *f=percent12.2 
                    n='Number of Employees'
                    
                    ,Factor='Employee Factor' all='Overall';
     run;
     
  






