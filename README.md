🛍️ Retail Sales Analytics — SQL + Power BI Dashboard
<img width="1536" height="1024" alt="ChatGPT Image Nov 23, 2025, 12_50_41 AM" src="https://github.com/user-attachments/assets/2cad6ad4-ffd3-49e1-bfd0-5a5158146fb5" />


A complete end-to-end Business Intelligence project with clean data modeling, SQL transformations, and interactive visual dashboards.

📌 📑 Project Overview

This project analyzes a 100K-record Retail Sales dataset using SQL for data preparation and Power BI for building a 6-page interactive dashboard.
The goal is to uncover insights about sales performance, customer behavior, marketing efficiency, product profitability, and regional patterns.

This project demonstrates:

Data cleaning & data modeling

SQL joins, constraints, views, and indexing

Power BI relationships, visuals, measures (DAX)

Insight-based storytelling and dashboard design

🏗️ 🗂️ Tech Stack

SQL (MySQL): Data cleaning, schema creation, constraints, joins, indexing

Power BI: Data modeling, DAX, visualizations, storytelling

Excel/CSV: Source data handling

📘 📊 Dataset Details
Tables Used
Table Name	Rows	Description
Sales	100,000	Fact table — revenue, profit, units, marketing metrics
Customer	19,865	Customer demographics, segment, loyalty
Product	1,000	Product details, category
Region	3	Region → Country → Continent mapping
Date	366	Full calendar table with year, quarter, month
Key Columns

Sales: Revenue, Profit, Units Sold, Discount Applied, Clicks, Impressions, Ad CTR, Ad CPC, Ad Spend

Customer: Customer Segment, Gender, Age Group, Annual Income

Product: Category, Product Name

Region: Region Name, Country, Continent

Date: Full_Date, Year, Quarter, Month

🧱 📐 SQL Data Modeling
Key Steps Performed

✔ Created Primary Keys & Foreign Keys
✔ Removed duplicates
✔ Cleaned marketing & sales anomalies
✔ Built Star Schema with:

FactSales

DimCustomer

DimProduct

DimRegion

DimDate

✔ Created a Materialized View (vw_sales_fact) to join all tables for Power BI
✔ Added Indexing (Date_ID, Region_ID, Customer_ID, Product_ID)

📊 📘 Power BI Dashboard (6 Pages)
1️⃣ Home / Navigation Page

Clean dark theme UI

Project intro, navigation buttons

Business purpose and sections overview

2️⃣ Sales Performance Dashboard

KPIs

Total Revenue

Total Profit

Total Units Sold

Avg Conversion Rate

Visuals

Revenue trend (line chart)

Profit by Month

Sales by Product Category (bar)

Best-selling products matrix

Slicers → Year, Category, Region

Insights

Identifies seasonal trends

Highlights profitable months

Shows high-performing categories

3️⃣ Customer Analytics Dashboard

Charts

Customer segments distribution

Age-group wise revenue

Gender-based sales insights

Loyalty score impact

Region-wise customer count

Purpose

Understand who buys most

How demographics affect sales

4️⃣ Product Performance Dashboard

Charts

Category contribution (treemap)

Units Sold vs Revenue (scatter)

Top & bottom 10 products

Discount impact on revenue

Purpose

Identify best & worst products

Evaluate discount strategy

5️⃣ Regional Insights Dashboard

Visuals

Map: Revenue by Country

Bar chart: Units sold by region

KPI: Region Performance Score (Profit ÷ Customers)

Average Order Value (AOV)

6️⃣ Marketing Analytics (Ads Dashboard)

Charts

Ad Spend vs Revenue

Impressions → Clicks → Conversions funnel

CTR & CPC effectiveness

ROI contribution by region/category

Purpose

Shows where marketing money works

Optimizes campaigns

🧠 📌 Key Insights Uncovered

Peak revenue occurs during Q3 & Q4

Electronics & Fashion lead the product sales

Younger customers (18–34) contribute the most revenue

Region 3 has higher Profit-to-Customer ratio

Good correlation between Ad Spend and Revenue

🛠️ ⚙️ DAX Measures Used

Total Revenue

Total Profit

Total Units Sold

Average Discount

Average Order Value

Conversion Efficiency

Region Performance Score

YoY, MoM calculations (optional enhancements)

🎯 🤵 Business Value

✔ Helps leadership understand profit drivers
✔ Enables tracking of product and customer behavior
✔ Improves marketing ROI decisions
✔ Supports region-wise planning & resource allocation
✔ Delivers a dashboard-ready BI system for real use

🖼️ 📸 Dashboard Preview

(Add your dashboard screenshots here)

📌 How to Run the Project

Run SQL schema and import CSV files

Create schema + constraints

Create the vw_sales_fact view

Load into Power BI using MySQL connector

Build relationships

Add measures

Apply theme + build visuals

🏁 Conclusion

This project showcases complete Business Intelligence workflow:
Data → SQL Processing → Modeling → Power BI Visualization → Insights.

It demonstrates strong command over:
✔ SQL engineering
✔ BI dashboard development
✔ Data storytelling
✔ Analytical thinking
