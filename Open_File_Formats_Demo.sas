/* Folder visible in the screenshot */
%let DEMO_PATH=/export/data/home/ad50586/CUPA_Demo;

/* ============================================================
   1. CSV: traditional file import
   ============================================================ */

proc import
    datafile="&DEMO_PATH/customer_open_formats.csv"
    out=work.customer_csv
    dbms=csv
    replace;
    guessingrows=max;
run;

title "CSV Data Imported into SAS";

proc print data=work.customer_csv(obs=5);
run;

title;


/* ============================================================
   2. PARQUET: direct open-format access
   No CSV conversion is performed
   ============================================================ */

libname pq parquet "&DEMO_PATH";

title "Structure of the Directly Accessed Parquet Table";

proc contents data=pq.customer_open_formats;
run;

title "Parquet Data Accessed Directly by SAS";

proc print data=pq.customer_open_formats(obs=5);
run;

title "Analysis Performed Directly on Parquet Data";

proc means data=pq.customer_open_formats
    n nmiss mean min max;
    var annual_revenue_eur risk_score;
run;

title;


/* ============================================================
   3. Use the Parquet data in a normal SAS process
   ============================================================ */

data work.customer_from_parquet;
    set pq.customer_open_formats;
run;

title "Parquet Data Used in a Standard SAS Process";

proc freq data=work.customer_from_parquet;
    tables country account_status / nocum;
run;

title;

/* Clear the library when the demonstration is complete */
libname pq clear;