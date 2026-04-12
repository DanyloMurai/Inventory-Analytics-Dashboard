# Inventory-Analytics-Dashboard
End-to-end portfolio project where I transformed a raw multi-header Excel inventory dataset using Python, validated and explored it with SQL, and built a Power BI dashboard to monitor demand, stock movement, stockout risk, and slow-moving inventory.

# Project Objective
The goal of this project was to build a complete analytics workflow starting from a raw Excel dataset and ending with an interactive Power BI dashboard that highlights demand patterns, inventory flow, stockout risks, and slow-moving stock.

# Tools used
- Python (pandas)
- SQL (SQLite / DBeaver)
- Power BI

# Dataset Overview
(!The project is based on real operational warehouse data from a large technical paper manufacturer. Therefore, all confidential information removed and anonymized by the owner of the dataset!)
The dataset contains 2023 inventory movement data, including:
- opening stock
- customer demand
- production orders
- extra orders
- inflow
- outflow
- ending stock
- turnover ratio
- ABC group classification

# What I Did
- cleaned a complex multi-header Excel dataset in Python
- transformed the data from wide format to long analytical format
- validated and explored the dataset with SQL
- built a 3-page Power BI dashboard:
 - Overview
 - SKU & Location Analysis
 - Stock Risk

# Key Insights
- The total ending stock exceeded the total opening stock, indicating overall inventory accumulation during the year
- A small number of SKUs generated most of the total outflow and demand
- Several location-SKU-month combinations showed potential stockout risk where customer demand exceeded outflow and ending stock dropped to zero
- The dataset also contained repeated cases of positive ending stock with zero outflow, suggesting slow-moving or excess inventory

## Repository Structure 
``` text
data/
notebooks/
powerbi/
sql/
images/
README.md
```
# Dashboard Preview
## Overview
<img width="1163" height="651" alt="1" src="https://github.com/user-attachments/assets/eaa663de-ab72-4c7f-bc49-db3fc9d9ef23" />

## SKU & Location Analysis
<img width="1165" height="653" alt="2" src="https://github.com/user-attachments/assets/664f0ac9-1c8b-473a-bc7a-e7ad5592a1ac" />

## Stock Risk
<img width="1166" height="655" alt="3" src="https://github.com/user-attachments/assets/d0e01ea7-d391-4295-a22b-c0104d5bc847" />

# Author
Created by Danylo Murai as a portfolio project for Business / Data Analytics roles.
