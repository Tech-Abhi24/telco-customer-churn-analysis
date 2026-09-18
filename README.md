# Telco Customer Churn Analysis

An end-to-end customer churn analytics project using PostgreSQL, SQL, Power Query, and Power BI.

## 📌 Project Overview

This project analyses customer churn in a telecommunications dataset and converts customer-level data into business-focused insights.

The analysis covers customer churn patterns, contract types, tenure, payment methods, services, customer value, revenue exposure, and churn-related customer risk.

The project combines SQL-based analysis with an interactive two-page Power BI dashboard.

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Calculate the overall customer churn rate
- Analyse churn across different contract types
- Understand how customer tenure relates to churn
- Compare churn across payment methods
- Analyse churn across individual services
- Explore customer value using CLTV
- Identify high-value customers with churn-related risk
- Estimate monthly revenue exposed to churn
- Build a customer risk score using multiple customer attributes
- Present the analysis through an interactive Power BI dashboard

---

## 🛠️ Tools & Technologies

- **PostgreSQL**
- **SQL**
- **Power Query**
- **Power BI**
- **DAX**
- **GitHub**

---

## 🔄 Project Workflow

```text
Customer Data
      ↓
Data Quality Checks
      ↓
PostgreSQL / SQL Analysis
      ↓
Customer Segmentation
      ↓
Risk & Revenue Analysis
      ↓
Power Query Transformation
      ↓
Power BI Dashboard
      ↓
Interactive Business Insights

```

# 📊 Power BI Dashboard

The Power BI report contains two main pages.

## 1. Telco Customer Churn Analysis

The first page provides an overall view of customer churn.

Main KPIs
Total Customers
Active Customers
Monthly Revenue
Churn Rate
Churned Customers
Main Visuals
Churn by Payment Method
Churn by Contract
Churn by Tenure
Churn by Services
Average Monthly Charge by Churn Status
Interactivity

The page includes interactive filters for:

Contract
Payment Method
Churn Label

Users can select different categories to explore how the customer base and churn metrics change.

## 2. Customer Risk Analysis

The second page focuses on customer value and churn-related risk.

Main KPIs
Average CLTV
Revenue at Risk
Main Analysis
Average Churn Score by Contract
High-Value Customer Analysis
Customer-level CLTV and Churn Score
CLTV vs Churn Score
Monthly Revenue at Risk by Contract
Top Reasons for Customer Churn
Customer Value vs Monthly Charges
Churn-related customer filtering

The page combines customer value and churn indicators to provide a more detailed view of customers who may require further analysis.

## 📈 Selected Dashboard Metrics

The current dashboard displays approximately:

Metric	Value
Total Customers	7K
Active Customers	5K
Monthly Revenue	2.74M
Churn Rate	26.54%
Churned Customers	2K
Average CLTV	4.40K
Revenue at Risk	834.79K

These values represent the current dashboard view. Interactive filters can change the displayed results.

## 🔍 Key Analysis
Contract Analysis

The project compares churn across different contract types.

Current dashboard values:

Contract	Churn Rate
Month-to-month	42.71%
One year	11.27%
Two year	2.83%

This analysis helps identify differences in churn behaviour across contract structures.

## Tenure Analysis

Customers are grouped into four tenure ranges:

0–12 months
13–24 months
25–48 months
49+ months

Current dashboard values:

Tenure Group	Churn Rate
0–12 months	47.44%
13–24 months	28.71%
25–48 months	20.39%
49+ months	9.51%
Payment Method Analysis

The project compares customer churn across available payment methods.

This analysis is used to identify differences in churn behaviour between payment categories.

## Service Analysis

The project analyses churn across individual telecom services, including:

Device Protection
Internet Service
Online Backup
Online Security
Phone Service
Streaming Movies
Streaming TV
Tech Support

Service-level data was transformed in Power Query to support consistent service-based analysis in Power BI.

## 💰 Customer Value & Revenue Analysis

Customer value is analysed using CLTV and monthly charges.

The project includes:

CLTV segmentation
Top customer value percentiles
High-value customer identification
High-value customers with churn-related risk
Monthly revenue exposure
Revenue at risk by contract
Customer value vs churn analysis

The current dashboard reports approximately:

Revenue at Risk: 834.79K

## ⚠️ Customer Risk Analysis

A customer risk score was developed using multiple customer-level indicators.

The analysis considers factors such as:

Contract type
Customer tenure
Monthly charges
Technical support availability
Security services
Payment method

The purpose of the score is to create a structured way to identify customers with multiple churn-related risk indicators.

## 🧮 SQL Analysis

The PostgreSQL analysis is available in:

sql/churn_analysis.sql

The SQL file contains the detailed analysis performed during the project.

SQL concepts used
SELECT
WHERE
GROUP BY
HAVING
ORDER BY
CASE
Aggregate functions
Conditional aggregation
Subqueries
Common Table Expressions (CTEs)
Window functions
RANK()
DENSE_RANK()
NTILE()
Percentile calculations
Customer segmentation
Cohort-style analysis
Revenue analysis
Risk scoring


# 📂 Repository Structure


telco-customer-churn-analysis/
│
├── README.md
│
├── sql/
│   └── churn_analysis.sql
│
├── powerbi/
│   └── telco_churn_dashboard.pbix
│
└── screenshots/
    ├── executive_overview.png
    └── customer_risk_analysis.png



## 📁 Project Files

sql/churn_analysis.sql

Contains the PostgreSQL queries used for:

Customer analysis
Churn analysis
Contract analysis
Tenure analysis
Payment analysis
Service analysis
CLTV analysis
Revenue exposure
Customer risk analysis


# powerbi/telco_churn_dashboard.pbix

Contains the complete interactive Power BI report with:

Two dashboard pages
KPIs
Charts
Slicers
Customer risk analysis
Interactive page navigation


# screenshots/

Contains screenshots of the completed Power BI dashboard for quick viewing directly from GitHub.


# ❓ Business Questions Explored

The project addresses questions such as:

How many customers have churned?
What is the overall churn rate?
How does churn vary by contract type?
How does churn change across customer tenure?
How does churn differ by payment method?
Which services show different churn patterns?
Which customers belong to high-value groups?
Which high-value customers also show churn-related risk?
How much monthly revenue is exposed to churn?
How can multiple customer attributes be combined into a risk score?
Which customer segments require further investigation?
How does customer value relate to churn-related indicators?


# 💡 Project Outcome

This project demonstrates an end-to-end data analytics workflow:

SQL Analysis
     ↓
Data Transformation
     ↓
Customer Segmentation
     ↓
Risk & Revenue Analysis
     ↓
KPI Development
     ↓
Power BI Dashboard
     ↓
Interactive Business Reporting

The final result combines detailed SQL analysis with an interactive Power BI report, allowing both the underlying analytical process and the final business presentation to be reviewed.

# 📌 Data Note

The project uses a telecommunications customer churn dataset containing customer demographics, services, contract information, billing information, customer value indicators, and churn-related fields.

The raw dataset is not included in this repository.

## 👤 Author

Abhishek Verma

MSc Data Science & Machine Learning
Carl von Ossietzky Universität Oldenburg
