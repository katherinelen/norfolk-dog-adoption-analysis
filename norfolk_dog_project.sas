/* ================================================================
   Norfolk Dog Adoption Project
   Author: Katherine Len

   This script:
   1. Imports the Norfolk Animal Care & Adoption Center CSV
   2. Cleans and prepares the data (dogs only)
   3. Computes monthly intake, adoptions, and adoption rate
   4. Creates age groups and adoption rates by age
   5. Produces main plots for your project
   ================================================================ */

options validvarname=any;   /* allow spaces in column names */

/*---------------------------------------------------------------
  1. IMPORT NORFOLK CSV

---------------------------------------------------------------*/

proc import datafile="/home/u64312543/Norfolk_Animal_Care_and_Adoption_Center__NACC_.csv"
    out=norfolk_raw
    dbms=csv
    replace;
    guessingrows=max;
    getnames=yes;
run;

/*===============================================================
  2. CLEAN DATA: DOGS ONLY, DATES, AGE, LENGTH OF STAY, ADOPTED
===============================================================*/

data norfolk_clean;
    set norfolk_raw;

    /* 2.1 Keep only dogs */
    where upcase('Animal Type'n) = "DOG";

    /* 2.2 Use Intake Date and Outcome Date as SAS dates
          (they're already numeric with MMDDYY10.)           */
    format Intake_Date Outcome_Date date9.;
    Intake_Date  = 'Intake Date'n;
    Outcome_Date = 'Outcome Date'n;

    /* 2.3 Length of stay in days */
    if not missing(Outcome_Date) and not missing(Intake_Date) then
        Length_of_Stay = Outcome_Date - Intake_Date;
    else Length_of_Stay = .;

    /* 2.4 Age in years = Years Old + Months Old / 12 */
    Age_Years = .;
    if not missing('Years Old'n) then Age_Years = 'Years Old'n;
    if not missing('Months Old'n) then
        Age_Years = sum(Age_Years, 'Months Old'n / 12);

    /* 2.5 Flag adopted dogs */
    length Adopted 3;
    if upcase('Outcome Type'n) = "ADOPTION" then Adopted = 1;
    else if missing('Outcome Type'n) then Adopted = .;   /* still in care */
    else Adopted = 0;
run;

/*===============================================================
  3. MONTHLY INTAKES, ADOPTIONS, ADOPTION RATE, AVG LOS
===============================================================*/

/* 3.1 Add MonthDate (first day of intake month) */

data norfolk_analysis;
    set norfolk_clean;
    Year      = year(Intake_Date);
    Month     = month(Intake_Date);
    MonthDate = mdy(Month, 1, Year);
    format MonthDate yymmn6.;
run;

/* 3.2 compute monthly totals */

proc sql;
    create table norfolk_monthly as
    select
        MonthDate,
        year(MonthDate)  as Year,
        month(MonthDate) as Month,

        count(*) as Total_Intakes,

        sum(case when Adopted = 1 then 1 else 0 end) as Total_Adoptions,

        avg(Length_of_Stay) as Avg_LOS
    from norfolk_analysis
    group by MonthDate
    order by MonthDate;
quit;

/* 3.3 Compute adoption rate */

data norfolk_monthly;
    set norfolk_monthly;
    if Total_Intakes > 0 then Adoption_Rate = Total_Adoptions / Total_Intakes;
    else Adoption_Rate = .;
    format Adoption_Rate percent8.1;
run;

/* Check */
proc contents data=norfolk_monthly; run;
proc print data=norfolk_monthly (obs=10); run;


/*===============================================================
  4. AGE GROUPS & ADOPTION RATES BY AGE GROUP
===============================================================*/

data norfolk_agegroups;
    set norfolk_clean;
    length Age_Group $ 15;

    if missing(Age_Years) then Age_Group = "Unknown";
    else if Age_Years < 1 then Age_Group = "Puppy (<1)";
    else if Age_Years < 3 then Age_Group = "Young (1-3)";
    else if Age_Years < 7 then Age_Group = "Adult (3-7)";
    else Age_Group = "Senior (7+)";
run;

proc freq data=norfolk_agegroups;
    tables Age_Group / nocum;
run;

proc sql;
    create table adoption_by_age as
    select
        Age_Group,
        count(*) as Total_Dogs,
        sum(case when Adopted = 1 then 1 else 0 end) as Adopted_Dogs,
        calculated Adopted_Dogs / calculated Total_Dogs as Adoption_Rate
    from norfolk_agegroups
    group by Age_Group;
quit;

proc print data=adoption_by_age; run;


/*===============================================================
  5. MAIN PLOTS FOR PROJECT
===============================================================*/

ods graphics on;

/* 5.1 Monthly adoption rate over time */
title "Norfolk Monthly Dog Adoption Rate Over Time";
proc sgplot data=norfolk_monthly;
    series x=MonthDate y=Adoption_Rate / markers;
    xaxis label="Month" grid;
    yaxis label="Adoption Rate" grid;
run;
title;

/* 5.2 Monthly intakes vs adoptions */
title "Norfolk Dog Intakes vs Adoptions per Month";
proc sgplot data=norfolk_monthly;
    series x=MonthDate y=Total_Intakes / markers legendlabel="Intakes";
    series x=MonthDate y=Total_Adoptions / markers legendlabel="Adoptions";
    xaxis label="Month";
    yaxis label="Count";
run;
title;

/* 5.3 Average length of stay by month */
title "Average Length of Stay (Days) in Norfolk Shelter by Month";
proc sgplot data=norfolk_monthly;
    series x=MonthDate y=Avg_LOS / markers;
    xaxis label="Month";
    yaxis label="Average Length of Stay (Days)";
run;
title;


/* 5.4 Age distribution */
title "Age Distribution of Dogs in Norfolk Shelter";
proc sgplot data=norfolk_clean;
    histogram Age_Years;
    density Age_Years;
    xaxis label="Age (Years)";
run;
title;

/* 5.5 Adoption rate by age group */
title "Norfolk Dog Adoption Rate by Age Group";
proc sgplot data=adoption_by_age;
    vbar Age_Group / response=Adoption_Rate datalabel;
    yaxis label="Adoption Rate" values=(0 to 1 by 0.1);
    format Adoption_Rate percent8.1;
run;
title;

ods graphics off;

/* ======================= END OF SCRIPT ======================= */
