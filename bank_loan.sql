SELECT *
FROM bank_loan_db.financial_loan;

SELECT COUNT(*)
FROM bank_loan_db.bank_loan;

Alter table bank_loan_db.bank_loan
add column con_issue_date date;

#Converting the date values in the 'issue_date' column to a valid date format and adding the values into the column 'con_issue_date'
set SQL_SAFE_UPDATES=0;
UPDATE bank_loan_db.bank_loan
SET con_issue_date = CASE
    WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y')
    WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y')
    WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d')
    ELSE NULL
END;
select*
from bank_loan_db.bank_loan;

ALTER table bank_loan_db.bank_loan
drop column issue_date;

Alter table bank_loan_db.bank_loan
change column con_issue_date issue_date date;

-- Adding column as 'col_last_credit_pull_date' to the table

ALTER table bank_loan_db.bank_loan
add column col_last_credit_pull_date date;

UPDATE bank_loan_db.bank_loan
SET  col_last_credit_pull_date = CASE
    WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y')
    WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y')
    WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d')
    ELSE NULL
END;

alter table bank_loan_db.bank_loan
drop column last_credit_pull_date;

Alter table bank_loan_db.bank_loan
change column col_last_credit_pull_date last_credit_pull_date date;

select* from bank_loan_db.bank_loan;
-- Repeating the same steps for the' next_payment_date' coulmn

ALTER table bank_loan_db.bank_loan
add column col_next_payment_date date;

UPDATE bank_loan_db.bank_loan
SET col_next_payment_date = CASE
    WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y')
    WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y')
    WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d')
    ELSE NULL
END;
alter table bank_loan_db.bank_loan
change column con_last_payment_date last_payment_date date;

alter table bank_loan_db.bank_loan
drop column next_payment_date;

alter table bank_loan_db.bank_loan
change column col_next_payment_date next_payment_date date;

-- Last_payment_date
alter table bank_loan_db.bank_loan
add column con_last_payment_date date;

UPDATE bank_loan_db.bank_loan
SET con_last_payment_date = CASE
    WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y')
    WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y')
    WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d')
    ELSE NULL
END;

Alter table bank_loan_db.bank_loan
drop column last_payment_date;

alter table bank_loan_db.bank_loan
change column con_last_payment_date last_payment_date date;

select *
from bank_loan_db.bank_loan

-- Calculate the total application receive

use bank_loan_db;
select count(id) as total_loan_applications
from bank_loan_db.bank_loan;

-- Calculate MTD Total Loan Application
select count(id) as MTD_Total_loan_applications
from bank_loan_db.bank_loan where month(issue_date)=12 and year(issue_date)=2021;--- 4314

--  Calculate PMTD Total Loan Application
select count(id) as PMTD_Total_loan_applications
from bank_loan_db.bank_loan where month(issue_date)=11 and year(issue_date)=2021; -- 4035

-- Calculate MOM Total Loan Application
WITH MTD_APP AS(
select count(id) as MTD_Total_loan_applications
from bank_loan_db.bank_loan where month(issue_date)=12 and year(issue_date)=2021),
PMTD_app AS(
select count(id) as PMTD_Total_loan_applications
from bank_loan_db.bank_loan where month(issue_date)=11 and year(issue_date)=2021)
Select ((MTD.MTD_Total_loan_applications-PMTD.PMTD_Total_loan_applications)/PMTD.PMTD_Total_Loan_Applications*100) as MOM_Total_Loan_Applications
from MTD_app MTD,PMTD_app PMTD;

-- Calculate the total funded amount
select sum(loan_amount) as Total_loan_amount
From bank_loan_db.bank_loan;-- 435757075

-- Calcluate the MTD Total Funded amount
select sum(loan_amount) as MTD_Total_Funded_amount
From bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021; -- 53981425

-- Calculate PMTD of total funded amount
select sum(loan_amount) as PMTD_Total_Funded_amount
From bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021; -- 47754825

With MTD_funded as(
select sum(loan_amount) as MTD_Total_Funded_amount
From bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021),
PMTD_funded as(
select sum(loan_amount) as PMTD_Total_Funded_amount
From bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021)
select ((MTD.MTD_Total_Funded_amount-PMTD.PMTD_Total_Funded_amount/PMTD.PMTD_Total_Funded_amount)*100)AS MOM_Total_Funded_Amount
From MTD_Funded MTD,PMTD_Funded PMTD;

-- Calculate the Total amount Received
select sum(total_payment) as Total_Amount_Received
from bank_loan_db.bank_loan;-- 473070933

-- Calcluate the MTD Total Payment
select sum(total_payment)as MTD_Total_Amount_Received
From bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021; -- 58074380

-- Calcluate the PMTD Total payment
select sum(total_payment)as PMTD_Total_Amount_Received
From bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021;-- 50132030

-- Calculating  the MOM Total Amount RECEIVED
With MTD_payment as(
select sum(total_payment)as MTD_Total_Amount_Received
From bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021),
PMTD_payment as(
select sum(total_payment)as PMTD_Total_Amount_Received
From bank_loan_db.bank_loan 
where month(issue_date)=11 and year(issue_date)=2021)
select ((MTD.MTD_Total_Amount_received-PMTD.PMTD_Total_Amount_Received)/PMTD.PMTD_Total_Amount_Received*100) as MOM_Total_Amount_Received
from MTD_payment MTD,PMTD_payment PMTD;

-- Calculating the Avg Int Rate
select avg(int_rate)*100 as Avg_interest_rate
from bank_loan_db.bank_loan;

-- Calculating the MTD Avg_interest_rate
select avg(int_rate)*100 as MTD_Avg_interest_rate
from bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021; -- 12.356040797403738

-- Calculating the PMTD Avg_interest_rate
select avg(int_rate)*100 as PMTD_Avg_interest_rate
from bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021; -- 11.941717472118796

-- Calculate MOM Avg Interest rate
With MTD_Avg_int as(
select avg(int_rate)*100 as MTD_Avg_interest_rate
from bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021),
PMTD_Avg_int as(
select avg(int_rate)*100 as PMTD_Avg_interest_rate
from bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021)
select ((MTD.MTD_Avg_interest_rate-PMTD.PMTD_Avg_interest_rate)/PMTD.PMTD_Avg_interest_rate*100) as MOM_Avg_Interest_rate
from MTD_avg_int MTD,PMTD_avg_int PMTD;

-- Calculate the Avg Debt to Income ratio(DTI)
 select avg(dti)*100 as MTD_Avg_DTI
from bank_loan_db.bank_loan;

-- Calculate MTD DIT
select avg(dti)*100 as MTD_Avg_DTI
from bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021;

-- Calculate PMTD_Avg_DTI
select avg(dti)*100 as PMTD_Avg_DTI
from bank_loan_db.bank_loan
where month(issue_date)=11 and year(issue_date)=2021;

-- Calculate MOM Avg_dti
WITH MTD_DTI AS (
    SELECT AVG(dti) AS MTD_Avg_DTI
    FROM bank_loan_db.bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_DTI AS (
    SELECT AVG(dti) AS PMTD_Avg_DTI
    FROM bank_loan_db.bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT 
    ((MTD.MTD_Avg_DTI - PMTD.PMTD_Avg_DTI) / PMTD.PMTD_Avg_DTI) * 100 AS MOM_Avg_DTI
FROM MTD_DTI MTD, PMTD_DTI PMTD;

-- Calculating the Good loan Application Percentage
SELECT 
    COUNT(CASE 
              WHEN loan_status = 'Fully paid' OR loan_status = 'Current' 
              THEN id 
         END) * 100.0 / COUNT(id) AS good_loan_percentage
FROM bank_loan_db.bank_loan;

-- Calculating the total Good loan applications
select count(id) as Good_loan_applications
from bank_loan_db.bank_loan
WHERE loan_status = 'Fully paid' OR loan_status = 'Current';

-- CALCULATING THE GOOD loan Funded amount
select sum(loan_amount) as Good_Loan_funded_amount
from bank_loan_db.bank_loan
 WHERE loan_status = 'Fully paid' OR loan_status = 'Current';

-- Calculating the Good loan received Amount
Select sum(total_payment) as Good_loan_Amount_Received
from bank_loan_db.bank_loan
 WHERE loan_status = 'Fully paid' OR loan_status = 'Current';

-- Bad Loan Issue
-- Calculating Bad loan Percentage
SELECT 
    COUNT(CASE 
              WHEN loan_status = 'Charged off'
              THEN id 
         END) * 100.0 / COUNT(id) AS Bad_loan_percentage
FROM bank_loan_db.bank_loan;

-- Calculting total count of Bad loan applications
select count(id) as Bad_loan_applications
from bank_loan_db.bank_loan
 WHERE loan_status = 'Charged off';
 
 -- Calculate the bad loan funded amount
 Select sum(loan_amount) as Bad_loan_Funded_Amount
from bank_loan_db.bank_loan
 WHERE loan_status = 'Charged off';

-- Calculating the loan_count, Total_Amount_Received, Total_funded_amount, Interest_rate, DTI on the basis of the loan status
select loan_status,
count(id) as Loan_count,
sum(total_payment) as Total_Amount_Received,
sum(loan_amount) as Total_funded_Amount,
Avg(int_rate*100) as interest_rate,
Avg(dti*100) as DTI
from bank_loan_db.bank_loan
group by loan_status;

-- Calculating MTD_Total_Amount_Received, MTD_Total_Funded_Amount on the basis of loan_status
select loan_status,
sum(total_payment) as MTD_Total_Amount_Received,
sum(loan_amount) asMTD_Total_Funded_Amount
from bank_loan_db.bank_loan
where month(issue_date)=12 and year(issue_date)=2021
group by loan_status;

-- Calculting monthly_total_Loan_Applications, Total_Funded_amount and total_amount_received 
-- Bank Loan Report| OVERVIEW- MONTH
select 
month(issue_date) as month_number,
MONTHNAME(issue_date) as month_name,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by month(issue_date), monthname(issue_date)
order by month(issue_date);

-- Bank Loan Report| OVERVIEW- STATES
select 
address_state as state,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by address_state
order by address_state;

-- Bank Loan Report| OVERVIEW- TERM
select 
Term as term,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by term
order by term;

-- Bank Loan Report| OVERVIEW- Employee Length
select 
emp_length as Employee_Length,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by emp_length
order by emp_length;

-- Bank Loan Report| OVERVIEW- Purpose
select 
purpose as Purpose_of_loan,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by purpose
order by purpose;

-- Bank Loan Report| OVERVIEW- Home ownership
select 
home_ownership as HOME_OWNERSHIP,
count(id) as Total_Loan_applications,
sum(Loan_Amount) as Total_Funded_Amount,
sum(total_payment) as total_Amount_Received
from bank_loan_db.bank_loan
group by home_ownershiP
order by home_ownership;

select*
from bank_loan_db.bank_loan;

