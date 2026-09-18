-- ============================================================
-- TELCO CUSTOMER CHURN ANALYSIS
-- Portfolio SQL Analysis | PostgreSQL
-- ============================================================
--
-- Dataset table: customers
-- Main analysis areas:
--   1. Customer and churn overview
--   2. Customer segmentation and tenure
--   3. Contract, payment and service analysis
--   4. Revenue and CLTV analysis
--   5. Customer risk and retention analysis
--   6. Advanced SQL: CTEs, window functions and cohort analysis
--
-- Note:
-- The source workbook/file uses non-contiguous question numbering.
-- Q20-Q23, Q28 and Q36-Q38 are not present in the supplied SQL file.
-- Their numbering is preserved rather than inventing missing questions.
-- ============================================================

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    "CustomerID" VARCHAR(50),
    "Count" INT,
    "Country" VARCHAR(100),
    "State" VARCHAR(100),
    "City" VARCHAR(100),
    "Zip Code" INT,
    "Lat Long" VARCHAR(100),
    "Latitude" DECIMAL(10,6),
    "Longitude" DECIMAL(10,6),
    "Gender" VARCHAR(20),
    "Senior Citizen" VARCHAR(10),
    "Partner" VARCHAR(10),
    "Dependents" VARCHAR(10),
    "Tenure Months" INT,
    "Phone Service" VARCHAR(10),
    "Multiple Lines" VARCHAR(30),
    "Internet Service" VARCHAR(30),
    "Online Security" VARCHAR(30),
    "Online Backup" VARCHAR(30),
    "Device Protection" VARCHAR(30),
    "Tech Support" VARCHAR(30),
    "Streaming TV" VARCHAR(30),
    "Streaming Movies" VARCHAR(30),
    "Contract" VARCHAR(50),
    "Paperless Billing" VARCHAR(10),
    "Payment Method" VARCHAR(50),
    "Monthly Charges" DECIMAL(10,2),
    "Total Charges" TEXT,
    "Churn Label" VARCHAR(10),
    "Churn Value" INT,
    "Churn Score" INT,
    "CLTV" INT,
    "Churn Reason" VARCHAR(255)
);

-- Q1.Total customers kitne hain?

select count(*) as total_customers
from customers

-- Q2.Kitne customers churn kar chuke hain?

select sum("Churn Value") as Total_churning_customers
from customers

-- Q3.Overall churn rate calculate karo.

select sum("Churn Value") * 100 / count(*) as "Total_churn_rate"
from customers

-- Q4. Average monthly charge kya hai?

select round(avg("Monthly Charges"),2) as "Avg Monthly Charge"
from customers

-- Q5.Average tenure kya hai?

select round(avg("Tenure Months"),2) as average_tenure_months
from customers

-- Q6.Maximum aur minimum monthly charge kya hai?

select max("Monthly Charges") as max_month_charge,
min("Monthly Charges") as min_month_charge
from customers

-- Q7.Kitne customers month-to-month contract par hain?

select count("Tenure Months") from customers
where "Contract" = 'Month-to-month'

-- Q8.Different contract types ka customer count nikalo.

select "Contract",count("Contract") from customers
group by "Contract"

-- Q9.Contract type ke according churn rate nikalo.

select "Contract", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Contract"

-- Q10.Internet service type ke according churn rate nikalo.

select "Internet Service", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Internet Service"

-- Q11.Payment method ke according churn rate nikalo

select "Payment Method", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Payment Method"

-- Q12.Senior citizen vs non-senior citizen churn compare karo.

select "Senior Citizen", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Senior Citizen"

-- Q13.Partner vs non-partner customers ka churn rate compare karo.

select "Partner", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Partner"

-- Q14.Dependents wale vs non-dependents customers ka churn rate compare karo.

select "Dependents", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Dependents"

-- Q15.Gender ke according churn rate calculate karo.

select "Gender", sum("Churn Value") * 100 / count(*) as Churn_rate 
from customers
group by "Gender"

-- Q16
--
-- Average monthly charges:
--
-- Churned
-- Non-churned
--
-- customers ke liye compare karo.

select "Churn Label", round(avg("Monthly Charges"),2) as Avg_month_charge
from customers
group by "Churn Label"

-- Q17.Customers ko tenure ke basis par classify karo:
-- 0–6 months       → New
-- 7–12 months      → Early
-- 13–24 months     → Growing
-- 25–48 months     → Mature
-- 49+ months       → Loyal
-- Phir har segment ka:
-- customers
-- churned customers
-- churn rate
-- nikalo.

select case 
when "Tenure Months" between 0 and 6 then 'New'
when "Tenure Months" between 7 and 12 then 'Early'
when "Tenure Months" between 13 and 24 then 'Growth'
when "Tenure Months" between 25 and 48 then 'Mature'
when "Tenure Months" >=49 then 'Loyal'
end as "tenure segment",
count(*) as customers,
sum("Churn Value") as Churn_customer,
round(sum("Churn Value") * 100 / count(*),2) as Churn_rate
from customers
group by "tenure segment"

--
-- Q18
--
-- Monthly charges ko classify karo:
--
-- < $30       → Low
-- $30–60      → Medium
-- $60–100     → High
-- > $100      → Premium
--
-- Phir churn rate calculate karo.

select case 
when "Monthly Charges" < 30 then 'Low'
when "Monthly Charges" between 30 and 60 then 'Medium'
when "Monthly Charges" between 60 and 100 then 'High'
when "Monthly Charges" > 100 then 'Premium'
end as "Monthly charges distribution" ,
round(sum("Churn Value") * 100 / count(*),2) as Churn_rate
from customers 
group by "Monthly charges distribution"

--
-- Q19
--
-- Customer Risk Segment banao:
--
-- High Risk
-- Medium Risk
-- Low Risk
--
-- Business logic tum khud define karoge based on:
--
-- contract
-- tenure
-- monthly charges
-- services
-- payment method

select "CustomerID", "Monthly Charges", "Tenure Months","Churn Label", case
when "Churn Score" < 30 then 'Low risk'
when "Churn Score" between 30 and 60 then 'Medium Risk'
when "Churn Score" > 60 then 'High Risk'
end  as "Risk_Segment"
from customers

select case
when "Churn Score" < 30 then 'Low risk'
when "Churn Score" between 30 and 60 then 'Medium Risk'
when "Churn Score" > 60 then 'High Risk'
end  as "Risk_Segment",
count(*) as total_customers
from customers
group by "Risk_Segment"

--
-- Q24
--
-- Un customers ko identify karo jinka monthly charge overall average se greater hai.

select "CustomerID","Monthly Charges"
from customers
where "Monthly Charges" > (select round(avg("Monthly Charges"),2) from customers)

--
-- Q25
--
-- Aise customers identify karo jinki tenure average tenure se kam hai aur jo churn kar chuke hain.

select "CustomerID","Tenure Months","Churn Label"
from customers
where "Tenure Months" < (select round(avg("Tenure Months"),2) from customers) and "Churn Label"='Yes'

--
-- Q26
--
-- Har contract type mein average se higher monthly charges wale customers identify karo.

WITH contract_avg AS (
    SELECT
        "CustomerID",
        "Contract",
        "Monthly Charges",
        AVG("Monthly Charges") OVER (
            PARTITION BY "Contract"
        ) AS contract_avg
    FROM customers
)

SELECT
    "CustomerID",
    "Contract",
    "Monthly Charges",
    ROUND(contract_avg, 2) AS contract_avg
FROM contract_avg
WHERE "Monthly Charges" > contract_avg
ORDER BY "Contract", "Monthly Charges" DESC;

--
-- Q27
--
-- Aise customers find karo jo apne contract segment ke average se zyada pay kar rahe hain.

WITH contract_avg AS (
    SELECT
        "CustomerID",
        "Contract",
        "Monthly Charges",
        AVG("Monthly Charges") OVER (
            PARTITION BY "Contract"
        ) AS avg_monthly_charges
    FROM customers
)

SELECT
    "CustomerID",
    "Contract",
    "Monthly Charges",
    ROUND(avg_monthly_charges, 2) AS contract_avg
FROM contract_avg
WHERE "Monthly Charges" > avg_monthly_charges
ORDER BY "Contract", "Monthly Charges" DESC;

--
-- Q29
--
-- CTE use karke top 10 highest-churn segments identify karo.
--
-- Segment combination:
--
-- Contract + InternetService
--
--

WITH segment_churn AS (
    SELECT
        "Contract",
        "Internet Service",
        COUNT(*) AS total_customers,
        SUM("Churn Value") AS churned_customers,
        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM customers
    GROUP BY
        "Contract",
        "Internet Service"
)

SELECT
    "Contract",
    "Internet Service",
    total_customers,
    churned_customers,
    churn_rate
FROM segment_churn
ORDER BY churn_rate DESC
LIMIT 10;

--
-- Q30
--
-- CTE use karke:
--
-- High monthly charge + low tenure + month-to-month contract
--
-- customers identify karo

WITH details AS (
    SELECT
        "CustomerID",
        "Monthly Charges",
        "Tenure Months",
        "Contract",
        AVG("Monthly Charges") OVER () AS avg_monthly_charge
    FROM customers
)

SELECT
    "CustomerID",
    "Monthly Charges",
    "Tenure Months",
    "Contract",
    ROUND(avg_monthly_charge, 2) AS avg_monthly_charge
FROM details
WHERE "Monthly Charges" > avg_monthly_charge
  AND "Tenure Months" BETWEEN 0 AND 6
  AND "Contract" = 'Month-to-month'
ORDER BY "Tenure Months" DESC;

--
-- Q31 — RANK()
--
-- Har contract type ke andar customers ko monthly charges ke basis
-- par rank karo.

select "Contract" , "Monthly Charges" ,
RANK() OVER (
    PARTITION BY "Contract"
    ORDER BY "Monthly Charges" DESC
) AS rank
from customers

--
-- Q32 — DENSE_RANK()
--
-- Har InternetService category mein highest-paying customers
-- identify karo.

select "Internet Service" , "Monthly Charges" , 
DENSE_RANK() OVER (
    PARTITION BY "Internet Service"
    ORDER BY "Monthly Charges" DESC
) AS payment_rank
from customers

--
-- Q33 — ROW_NUMBER()
--
-- Har contract category ke top 5 highest-value
-- customers identify karo

WITH ranked_customers AS (
    SELECT
        "CustomerID",
        "Contract",
        "Monthly Charges",
        ROW_NUMBER() OVER (
            PARTITION BY "Contract"
            ORDER BY "Monthly Charges" DESC
        ) AS row_num
    FROM customers
)

SELECT
    "CustomerID",
    "Contract",
    "Monthly Charges",
	"row_num"
FROM ranked_customers
WHERE row_num <= 5
ORDER BY "Contract", "Monthly Charges" DESC;

--
-- Q34 — PARTITION BY
--
-- Calculate:
--
-- Customer Monthly Charge
-- Segment Average Monthly Charge
-- Difference from Segment Average

SELECT
    "CustomerID",
    "Contract",
    "Monthly Charges" AS customer_monthly_charge,

    AVG("Monthly Charges") OVER (
        PARTITION BY "Internet Service"
    ) AS segment_avg_monthly_charge,

    "Monthly Charges"
    - AVG("Monthly Charges") OVER (
        PARTITION BY "Internet Service"
    ) AS difference_from_segment_avg

FROM customers;

--
-- Q35
--
-- Customer ke monthly charge ko uske contract category ke average se compare karo.
--
-- Output:
--
-- CustomerID
-- Contract
-- MonthlyCharges
-- ContractAvgCharges
-- Difference

select "CustomerID", "Contract", "Monthly Charges",
avg("Monthly Charges") over(partition by "Contract") as "avg_monthly_charge",
"Monthly Charges" - avg("Monthly Charges") over(partition by "Contract") as "Difference"
from customers

--
-- LEVEL 9 — Cohort Analysis
--
-- Ye bahut important interview concept hai.
--
-- Customers ko tenure cohorts mein divide karo:
--
-- 0–3 months
-- 4–6 months
-- 7–12 months
-- 13–24 months
-- 25–36 months
-- 37–48 months
-- 49+ months

select "CustomerID","Tenure Months",
case
    WHEN "Tenure Months" BETWEEN 0 AND 3 THEN '0–3 months'
    WHEN "Tenure Months" BETWEEN 4 AND 6 THEN '4–6 months'
    WHEN "Tenure Months" BETWEEN 7 AND 12 THEN '7–12 months'
    WHEN "Tenure Months" BETWEEN 13 AND 24 THEN '13–24 months'
    WHEN "Tenure Months" BETWEEN 25 AND 36 THEN '25–36 months'
    WHEN "Tenure Months" BETWEEN 37 AND 48 THEN '37–48 months'
    ELSE '49+ months'
END AS "tenure_cohort"
from customers

--
-- Q39
--
-- Har cohort ka:
--
-- Customer count
-- Churn count
-- Churn rate
-- Avg monthly charge
-- Avg total charge
--
-- calculate karo.

with Cohort as (
select "CustomerID","Tenure Months","Churn Value","Monthly Charges","Total Charges",
case
    WHEN "Tenure Months" BETWEEN 0 AND 3 THEN '0–3 months'
    WHEN "Tenure Months" BETWEEN 4 AND 6 THEN '4–6 months'
    WHEN "Tenure Months" BETWEEN 7 AND 12 THEN '7–12 months'
    WHEN "Tenure Months" BETWEEN 13 AND 24 THEN '13–24 months'
    WHEN "Tenure Months" BETWEEN 25 AND 36 THEN '25–36 months'
    WHEN "Tenure Months" BETWEEN 37 AND 48 THEN '37–48 months'
    ELSE '49+ months'
END AS "tenure_cohort"
from customers
)
select "tenure_cohort",
count("CustomerID") as "customer_count",sum("Churn Value") as "churn count",
sum("Churn Value") * 100 / count("CustomerID") as "churn rate",
avg("Monthly Charges") as "Avg_monthly_charge",
AVG(NULLIF(TRIM("Total Charges"), '')::numeric) AS "avg_total_charge"
from Cohort
group by "tenure_cohort"

--
-- Q40
--
-- Identify karo:
--
-- Which customer lifecycle stage has the highest churn risk?
-- 0-3 months has highest churn risk

--
-- Q41
--
-- Total monthly revenue calculate karo.
--
-- SUM(MonthlyCharges)
--

select sum("Monthly Charges") as "total revenure" from customers

--
-- Q42
--
-- Churned customers se associated monthly revenue calculate karo.
--

select sum("Monthly Charges") as "total revenure" from customers
where "Churn Label" = 'Yes'

--
-- Q43
--
-- Churned customers ka estimated annual revenue exposure calculate karo.

select sum("Monthly Charges")*12 as "total revenure" from customers
where "Churn Label" = 'Yes'

--
-- Q44
--
-- Top 20% highest-paying customers mein kitne churned hain?

WITH ranked_customers AS (
    SELECT
        "CustomerID",
        "Total Charges",
        "Churn Value",
        NTILE(5) OVER (
            ORDER BY  nullif(trim("Total Charges"),'')::numeric DESC
        ) AS pay_group
    FROM customers
)

SELECT
    COUNT("CustomerID") AS "top_20_percent_customers",
    SUM("Churn Value") AS "churned_customers"
FROM ranked_customers
WHERE pay_group = 1;

--
-- Q45
--
-- High-value churned customers ki revenue exposure calculate karo

WITH ranked_customers AS (
    SELECT
        "CustomerID",
        "Total Charges",
        "Churn Value",
        NTILE(5) OVER (
            ORDER BY NULLIF(TRIM("Total Charges"), '')::numeric DESC
        ) AS pay_group
    FROM customers
)

SELECT
    SUM(NULLIF(TRIM("Total Charges"), '')::numeric) AS "revenue_exposure"
FROM ranked_customers
WHERE pay_group = 1
  AND "Churn Value" = 1;

--
-- Q46
--
-- Average CLTV:
--
-- Churned
-- Non-churned
--
-- customers ke liye calculate karo.

select avg("CLTV") as "Customer Lifetime Value" , "Churn Label"
from customers
group by "Churn Label"

--
-- Q47
--
-- Top 10% CLTV customers identify karo.

select "CustomerID" , "CLTV" , ntile(10) over (order by "CLTV" desc) as "CLTV customer"
from customers

--
-- Q48
--
-- Top CLTV customers mein churn rate calculate karo.
--

with cte as (
select "CustomerID" ,"Churn Value" , "CLTV", ntile(10) over (order 
by "CLTV" desc) as "Top CLTV"  from customers
) 
select 
sum("Churn Value") * 100 / count("CustomerID") as "churn rate"
from cte
where "Top CLTV" = 1

--
-- Q49
--
-- High CLTV + Churned customers identify karo.

select "CustomerID", "Churn Label" , "CLTV"
from customers
where "CLTV" > (select avg("CLTV") from customers) and 
"Churn Label" = 'Yes' 

--
-- LEVEL 12 — Customer Segmentation
--
-- Ab tum SQL se mini CRM analytics system banaoge.
--
-- Customer segments:
--
-- Segment A
--
-- High CLTV + High churn risk
--
-- Segment B
--
-- High CLTV + Low churn risk
--
-- Segment C
--
-- Low CLTV + High churn risk
--
-- Segment D
--
-- Low CLTV + Low churn risk

-- Q50
--
-- Har segment ka:
--
-- customers
-- churn rate
-- average revenue
-- average CLTV
--
-- calculate karo.

WITH cte AS (
    SELECT 
        "CustomerID",
        "Churn Value",
        "Churn Score",
        "CLTV",
        "Total Charges",
        AVG("CLTV") OVER () AS avg_cltv
    FROM customers
),

cte1 AS (
    SELECT 
        "CustomerID",
        "Churn Value",
        "Churn Score",
        "CLTV",
        "Total Charges",
        CASE 
            WHEN "CLTV" > avg_cltv 
                 AND "Churn Score" > 60
                THEN 'Segment A'

            WHEN "CLTV" > avg_cltv 
                 AND "Churn Score" <= 60
                THEN 'Segment B'

            WHEN "CLTV" <= avg_cltv 
                 AND "Churn Score" > 60
                THEN 'Segment C'

            ELSE 'Segment D'
        END AS "Customer_segment"
    FROM cte
)

SELECT 
    "Customer_segment",

    COUNT("CustomerID") AS "customers",

    SUM("Churn Value") * 100.0 
        / COUNT("CustomerID") AS "churn_rate",

    AVG(
        NULLIF(TRIM("Total Charges"), '')::NUMERIC
    ) AS "average_revenue",

    AVG("CLTV") AS "average_cltv"

FROM cte1

GROUP BY "Customer_segment"
ORDER BY "Customer_segment";

--
-- Q51
--
-- Retention campaign ke liye customers identify karo jinke:
--
-- Contract = Month-to-month
-- AND
-- Tenure < 12 months
-- AND
-- MonthlyCharges > average
-- AND
-- Churn = Yes

select "CustomerID", "Contract","Tenure Months","Churn Label",
"Monthly Charges"
from customers where "Contract" = 'Month-to-month'
and "Tenure Months" < 12
and "Monthly Charges"  > (select avg("Monthly Charges") from customers)
and "Churn Label" = 'Yes'

--
-- Q52
--
-- Ab criteria improve karo:
--
-- High CLTV
-- +
-- High Monthly Charges
-- +
-- High Churn Risk

select "CustomerID" , "CLTV", "Monthly Charges" , "Churn Score"
from customers
where "CLTV" > (select avg("CLTV") from customers)
and "Monthly Charges" > (select avg("Monthly Charges") from customers)
and "Churn Score" > (select avg("Churn Score") from customers)

--
-- Q53
--
-- Top 100 customers identify karo jinhe retention team ko first contact karna chahiye.

SELECT
    "CustomerID",
    "CLTV",
    "Churn Score",
    "Churn Value",
    "Monthly Charges",
    "Contract"
FROM customers
WHERE "Churn Score" > 60
ORDER BY "CLTV" DESC, "Churn Score" DESC
LIMIT 100;

--
-- Q54
--
-- Does higher monthly spending actually lead to higher churn?
--
-- Sirf average compare mat karo.
--
-- Monthly charge buckets banao aur churn rate compare karo.

SELECT
    CASE
        WHEN "Monthly Charges" < 30 THEN 'Below 30'
        WHEN "Monthly Charges" BETWEEN 30 AND 50 THEN '30-50'
        WHEN "Monthly Charges" BETWEEN 50 AND 70 THEN '50-70'
        ELSE 'Above 70'
    END AS "Monthly Charge Bucket",

    COUNT("CustomerID") AS "Customers",

    SUM("Churn Value") * 100.0
        / COUNT("CustomerID") AS "Churn Rate"

FROM customers

GROUP BY
    CASE
        WHEN "Monthly Charges" < 30 THEN 'Below 30'
        WHEN "Monthly Charges" BETWEEN 30 AND 50 THEN '30-50'
        WHEN "Monthly Charges" BETWEEN 50 AND 70 THEN '50-70'
        ELSE 'Above 70'
    END

ORDER BY
    MIN("Monthly Charges");

--
-- Q55
--
-- Are new customers more likely to churn than loyal customers?
--
-- Tenure cohorts use karo.

with Cohort as (
select "CustomerID","Tenure Months","Churn Value","Monthly Charges","Total Charges",
case
    WHEN "Tenure Months" BETWEEN 0 AND 3 THEN '0–3 months'
    WHEN "Tenure Months" BETWEEN 4 AND 6 THEN '4–6 months'
    WHEN "Tenure Months" BETWEEN 7 AND 12 THEN '7–12 months'
    WHEN "Tenure Months" BETWEEN 13 AND 24 THEN '13–24 months'
    WHEN "Tenure Months" BETWEEN 25 AND 36 THEN '25–36 months'
    WHEN "Tenure Months" BETWEEN 37 AND 48 THEN '37–48 months'
    ELSE '49+ months'
END AS "tenure_cohort"
from customers
)
select "tenure_cohort",
sum("Churn Value") * 100 / count("CustomerID") as "churn rate"
from Cohort
group by "tenure_cohort"
order by "churn rate"

--
-- Q56
--
-- Is month-to-month contract the biggest churn driver?
--
-- Contract × tenure combination analyse karo.

WITH contract_tenure AS (
    SELECT
        "Contract",
        CASE
            WHEN "Tenure Months" BETWEEN 0 AND 6 THEN 'New'
            WHEN "Tenure Months" BETWEEN 7 AND 12 THEN 'Early'
            WHEN "Tenure Months" BETWEEN 13 AND 24 THEN 'Growing'
            WHEN "Tenure Months" BETWEEN 25 AND 48 THEN 'Mature'
            WHEN "Tenure Months" >= 49 THEN 'Loyal'
        END AS tenure_segment,

        COUNT(*) AS total_customers,

        SUM("Churn Value") AS churned_customers,

        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        ) AS churn_rate

    FROM customers

    GROUP BY
        "Contract",
        tenure_segment
)

SELECT *
FROM contract_tenure
ORDER BY churn_rate DESC;

--
-- Q57
--
-- Which combination of services is associated with the lowest churn?
--
-- Example:
--
-- OnlineSecurity
-- +
-- TechSupport
-- +
-- DeviceProtection

select "Online Security" , "Device Protection" ,
"Tech Support" , sum("Churn Value") * 100 / count("CustomerID")
as "Churn rate" from customers
group by "Online Security" , "Device Protection" ,
"Tech Support" order by "Churn rate"

--
-- Q58
--
-- Which payment method has the highest churn?
--
-- But then:
--
-- Is payment method actually the problem?
--
-- Contract type ke according break down karo.
--
-- Yahan tum confounding samajhna start karoge.

select "Payment Method" , "Contract",
round(sum("Churn Value") * 100.0 / count(*),3) as "churn rate"
from customers
group by "Payment Method" , "Contract"
order by "churn rate" desc

--
-- Q59
--
-- Find:
--
-- Month-to-month customers with tenure < 12 months and monthly charges above the 75th percentile.
--
-- Yahan tumhe percentile / statistical SQL use karna padega.

SELECT
    "CustomerID",
    "Contract",
    "Tenure Months",
    "Monthly Charges"

FROM customers

WHERE "Contract" = 'Month-to-month'
  AND "Tenure Months" < 12
  AND "Monthly Charges" > (
      SELECT
          PERCENTILE_CONT(0.75)
          WITHIN GROUP (
              ORDER BY "Monthly Charges"
			 
          )
      FROM customers
  );

--
-- Q60
--
-- Find customers whose monthly charge is in the top 10% within their contract category.

WITH ranked_customers AS (
    SELECT
        "CustomerID",
        "Contract",
        "Monthly Charges",

        NTILE(10) OVER (
            PARTITION BY "Contract"
            ORDER BY "Monthly Charges" DESC
        ) AS charge_bucket

    FROM customers
)

SELECT
    "CustomerID",
    "Contract",
    "Monthly Charges"
FROM ranked_customers
WHERE charge_bucket = 1
ORDER BY "Contract", "Monthly Charges" DESC;

--
-- Q61
--
-- Find customers whose CLTV is above the 90th percentile
-- but who churned.

select "CustomerID", "Churn Label", "CLTV"
from customers
where "CLTV" > (
select percentile_cont(0.9)
within group(order by "Monthly Charges")
from customers
) and "Churn Label" = 'No'

--
-- Q62
--
-- Duplicate customers identify karo.

SELECT
    "CustomerID",
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY "CustomerID"
HAVING COUNT(*) > 1;

WITH duplicates AS (
    SELECT
        "CustomerID"
    FROM customers
    GROUP BY "CustomerID"
    HAVING COUNT(*) > 1
)

SELECT c.*
FROM customers c
JOIN duplicates d
    ON c."CustomerID" = d."CustomerID"
ORDER BY c."CustomerID";

--
-- Q63
--
-- NULL values identify karo.

WHERE "Total Charges" IS NULL;

SELECT COUNT(*) AS null_count
FROM customers
WHERE "Total Charges" IS NULL;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE "CustomerID" IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE "Monthly Charges" IS NULL) AS monthly_charges_nulls,
    COUNT(*) FILTER (WHERE "Total Charges" IS NULL) AS total_charges_nulls,
    COUNT(*) FILTER (WHERE "Contract" IS NULL) AS contract_nulls,
    COUNT(*) FILTER (WHERE "Tenure Months" IS NULL) AS tenure_nulls

FROM customers

--
-- Q64
--
-- Invalid / inconsistent values identify karo.

WHERE
    "Tenure Months" < 0
    OR "Monthly Charges" < 0
    OR "Churn Value" NOT IN (0, 1)
    OR "Churn Label" NOT IN ('Yes', 'No')
    OR "Contract" NOT IN ('Month-to-month', 'One year', 'Two year')
    OR ("Churn Value" = 1 AND "Churn Label" <> 'Yes')
    OR ("Churn Value" = 0 AND "Churn Label" <> 'No');

--
-- Q65
--
-- TotalCharges` ko numeric mein properly convert karo.

SELECT
    NULLIF(TRIM("Total Charges"), '')::NUMERIC AS total_charges_numeric
FROM customers;

--
-- Q66
--
-- Check karo:
--
-- MonthlyCharges × Tenure ≈ TotalCharges
--
-- Aur identify karo unusual records.

WITH details AS (
    SELECT
        "CustomerID",
        "Monthly Charges",
        "Tenure Months",
        NULLIF(TRIM("Total Charges"), '')::NUMERIC AS total_charges,

        "Monthly Charges" * "Tenure Months" AS expected_charges
    FROM customers
)

SELECT
    "CustomerID",
    "Monthly Charges",
    "Tenure Months",
    total_charges,
    ROUND(expected_charges, 2) AS expected_charges,
    ROUND(total_charges - expected_charges, 2) AS difference
FROM details
WHERE ABS(total_charges - expected_charges) > 10
ORDER BY ABS(total_charges - expected_charges) DESC;

--
-- Q67
--
-- “Why are customers leaving?”
--
-- SQL se top churn drivers identify karo.

-- Step 1 — Contract-wise churn

SELECT
    "Contract",
    COUNT(*) AS total_customers,
    SUM("Churn Value") AS churned_customers,
    ROUND(
        SUM("Churn Value") * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY "Contract"
ORDER BY churn_rate DESC;

--
-- Step 2 — Internet Service-wise churn

SELECT
    "Internet Service",
    COUNT(*) AS total_customers,
    SUM("Churn Value") AS churned_customers,
    ROUND(
        SUM("Churn Value") * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY "Internet Service"
ORDER BY churn_rate DESC;

--
-- Step 3 — Payment Method-wise churn

SELECT
    "Payment Method",
    COUNT(*) AS total_customers,
    SUM("Churn Value") AS churned_customers,
    ROUND(
        SUM("Churn Value") * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY "Payment Method"
ORDER BY churn_rate DESC;

--
-- Step 4 — Service-related drivers

SELECT
    "Tech Support",
    COUNT(*) AS total_customers,
    SUM("Churn Value") AS churned_customers,
    ROUND(
        SUM("Churn Value") * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY "Tech Support"
ORDER BY churn_rate DESC;

WITH churn_drivers AS (

    SELECT
        'Contract' AS driver,
        "Contract" AS category,
        COUNT(*) AS customers,
        SUM("Churn Value") AS churned_customers,
        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM customers
    GROUP BY "Contract"

    UNION ALL

    SELECT
        'Internet Service',
        "Internet Service",
        COUNT(*),
        SUM("Churn Value"),
        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        )
    FROM customers
    GROUP BY "Internet Service"

    UNION ALL

    SELECT
        'Payment Method',
        "Payment Method",
        COUNT(*),
        SUM("Churn Value"),
        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        )
    FROM customers
    GROUP BY "Payment Method"

    UNION ALL

    SELECT
        'Tech Support',
        "Tech Support",
        COUNT(*),
        SUM("Churn Value"),
        ROUND(
            SUM("Churn Value") * 100.0 / COUNT(*),
            2
        )
    FROM customers
    GROUP BY "Tech Support"
)

SELECT *
FROM churn_drivers
ORDER BY churn_rate DESC;

--
-- ### Q68
--
-- “Which customers should we save first?”
--
-- High-value + high-risk customers.

WITH customer_risk AS (
    SELECT
        "CustomerID",
        "Monthly Charges",
        "Churn Score",
        "Churn Value",
        "Contract",
        "Tenure Months",
		"Churn Label",
        AVG("Monthly Charges") OVER () AS avg_monthly_charge

    FROM customers
)

SELECT
    "CustomerID",
    "Monthly Charges",
    "Churn Score",
    "Contract",
    "Tenure Months",
	"Churn Label"
FROM customer_risk
WHERE "Monthly Charges" > avg_monthly_charge
  AND "Churn Score" > 60
  AND "Churn Value" = 0
ORDER BY "Monthly Charges" DESC, "Churn Score" DESC;

--
-- Q69
--
-- “How much revenue is at risk?”
--
-- Calculate revenue exposure.

WITH high_risk_customers AS (
    SELECT
        "CustomerID",
        "Monthly Charges",
        "Churn Score",
        "Churn Value",

        AVG("Monthly Charges") OVER () AS avg_monthly_charge

    FROM customers
)

SELECT
    COUNT(*) AS customers_at_risk,
    ROUND(SUM("Monthly Charges"), 2) AS monthly_revenue_at_risk
FROM high_risk_customers
WHERE "Monthly Charges" > avg_monthly_charge
  AND "Churn Score" > 60
  AND "Churn Value" = 0;

--
-- Q70
--
-- “Which customer segment should receive retention offers?”
--
-- Segment ranking.

SELECT
    "Contract" AS customer_segment,
	"Internet Service",
    COUNT(*) AS customers,
    SUM("Churn Value") AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN "Churn Label" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(AVG("Monthly Charges"), 2) AS avg_monthly_charges
FROM customers
GROUP BY "Contract" , "Internet Service"
ORDER BY "churn_rate" DESC;

--
-- Q71
--
-- “Should we focus on new customers or existing customers?”
--
-- Cohort analysis.

SELECT
CASE
WHEN "Tenure Months" BETWEEN 0 AND 6 THEN 'New'
WHEN "Tenure Months" BETWEEN 7 AND 12 THEN 'Early'
WHEN "Tenure Months" BETWEEN 13 AND 24 THEN 'Growing'
WHEN "Tenure Months" BETWEEN 25 AND 48 THEN 'Mature'
WHEN "Tenure Months" >= 49 THEN 'Loyal'
END AS tenure_segment,
round(sum("Churn Value")*100.0/count(*),2) as "churn rate"
from customers
group by "tenure_segment"
order by "churn rate"
		

--
-- Q72
--
-- “Which services should we bundle?”
--
-- Service adoption × churn analysis.

SELECT
    'Online Security' AS service,
    COUNT(*) FILTER (WHERE "Online Security" = 'Yes') AS customers,
    COUNT(*) FILTER (
        WHERE "Online Security" = 'Yes' AND "Churn Label" = 'Yes'
    ) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Online Security" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Online Security" = 'Yes'), 0),
        2
    ) AS churn_rate
FROM customers

UNION ALL

SELECT
    'Online Backup',
    COUNT(*) FILTER (WHERE "Online Backup" = 'Yes'),
    COUNT(*) FILTER (
        WHERE "Online Backup" = 'Yes' AND "Churn Label" = 'Yes'
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Online Backup" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Online Backup" = 'Yes'), 0),
        2
    )
FROM customers

UNION ALL

SELECT
    'Device Protection',
    COUNT(*) FILTER (WHERE "Device Protection" = 'Yes'),
    COUNT(*) FILTER (
        WHERE "Device Protection" = 'Yes' AND "Churn Label" = 'Yes'
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Device Protection" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Device Protection" = 'Yes'), 0),
        2
    )
FROM customers

UNION ALL

SELECT
    'Tech Support',
    COUNT(*) FILTER (WHERE "Tech Support" = 'Yes'),
    COUNT(*) FILTER (
        WHERE "Tech Support" = 'Yes' AND "Churn Label" = 'Yes'
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Tech Support" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Tech Support" = 'Yes'), 0),
        2
    )
FROM customers

UNION ALL

SELECT
    'Streaming TV',
    COUNT(*) FILTER (WHERE "Streaming TV" = 'Yes'),
    COUNT(*) FILTER (
        WHERE "Streaming TV" = 'Yes' AND "Churn Label" = 'Yes'
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Streaming TV" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Streaming TV" = 'Yes'), 0),
        2
    )
FROM customers

UNION ALL

SELECT
    'Streaming Movies',
    COUNT(*) FILTER (WHERE "Streaming Movies" = 'Yes'),
    COUNT(*) FILTER (
        WHERE "Streaming Movies" = 'Yes' AND "Churn Label" = 'Yes'
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Streaming Movies" = 'Yes' AND "Churn Label" = 'Yes'
        ) / NULLIF(COUNT(*) FILTER (WHERE "Streaming Movies" = 'Yes'), 0),
        2
    )
FROM customers

ORDER BY churn_rate ASC;

--
-- Q73
--
-- “Which contract should we promote?”
--
-- Contract × churn × revenue analysis.

select "Contract" , 
sum("Churn Value") * 100.0 / count(*) as
"churn rate",
sum("Monthly Charges")
from customers
group by "Contract"

--
-- Q74
--
-- For every contract type, find the top 10% highest-value customers who are at risk of churn.

WITH cte AS
(
    SELECT
        "CustomerID",
        "Contract",
        "CLTV",
        "Churn Score",
        NTILE(10) OVER (
            PARTITION BY "Contract"
            ORDER BY "CLTV" DESC
        ) AS top_10
    FROM customers
)

SELECT
    "Contract",
    COUNT("CustomerID") AS at_risk_high_value_customers
FROM cte
WHERE top_10 = 1
  AND "Churn Score" > (
      SELECT AVG("Churn Score")
      FROM customers
  )
GROUP BY "Contract"
ORDER BY at_risk_high_value_customers DESC;

--
-- Q75
--
-- Find the highest-risk customer in every city.

WITH cte AS
(
    SELECT
        "CustomerID",
        "City",
        "Churn Score",
        ROW_NUMBER() OVER (
            PARTITION BY "City"
            ORDER BY "Churn Score" DESC
        ) AS "risk Level"
    FROM customers
)

SELECT
    "CustomerID",
    "City",
    "Churn Score"
FROM cte
WHERE "risk Level" = 1;

--
-- Q76
--
-- Find customers whose monthly charge is:
--
-- higher than their contract average AND higher than their internet-service average.

with cte as(
select "CustomerID" ,"Contract" ,
"Monthly Charges" , 
avg("Monthly Charges") over(partition by "Contract")
"avg_monthly_charge",
avg("Monthly Charges") over (partition by 
"Internet Service") as "avg_monnth"
from customers
)
select "CustomerID" , "Contract" , 
"Monthly Charges" from cte
where "Monthly Charges" > "avg_monthly_charge"
and "Monthly Charges" > "avg_monnth"

--
-- Q77
--
-- Create a Customer Risk Score using SQL.

WITH cte AS
(
    SELECT
        "CustomerID",
        "Contract",
        "Tenure Months",
        "Monthly Charges",
        "Tech Support",
        "Online Security",
        "Payment Method",

        -- Risk Score
        (
            CASE
                WHEN "Contract" = 'Month-to-month' THEN 3
                ELSE 0
            END

            +

            CASE
                WHEN "Tenure Months" < 12 THEN 3
                ELSE 0
            END

            +

            CASE
                WHEN "Monthly Charges" > (
                    SELECT AVG("Monthly Charges")
                    FROM customers
                ) THEN 2
                ELSE 0
            END

            +

            CASE
                WHEN "Tech Support" = 'No' THEN 2
                ELSE 0
            END

            +

            CASE
                WHEN "Online Security" = 'No' THEN 2
                ELSE 0
            END

            +

            CASE
                WHEN "Payment Method" = 'Electronic check' THEN 2
                ELSE 0
            END
        ) AS risk_score

    FROM customers
)

SELECT
    "CustomerID",
    "Contract",
    "Tenure Months",
    "Monthly Charges",
    "risk_score",

    CASE
        WHEN risk_score >= 8 THEN 'Critical'
        WHEN risk_score BETWEEN 5 AND 7 THEN 'High'
		WHEN risk_score BETWEEN 3 AND 4 THEN 'Medium'
        ELSE 'Low'
    END AS risk_level

FROM cte
ORDER BY risk_score DESC;

--
-- Q78
--
-- Create a Retention Priority Score:
--
-- Risk Score × CLTV
--
-- Then rank every customer.

with cte as
(select "CustomerID","Churn Score" , "CLTV",
("Churn Score" * "CLTV") as "Retention Priority Score"
from customers)
select "CustomerID","Retention Priority Score",
RANK() OVER (ORDER BY "Retention Priority Score" DESC) AS "Customer rank"
from cte
