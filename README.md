# 📊 LPG Gas Agency Sales & Refill Cycle Analytics
**Google Data Analytics Professional Certificate - Capstone Project**

## 🎯 Business Case & Overview
This project applies the Google Data Analytics methodology (**Ask, Prepare, Process, Analyze, Share, Act**) to solve real-world operational challenges in a regional LPG Gas Distribution Agency. By analyzing 800+ consumer transactions, the project aims to identify customer refill lags, track seasonal sales patterns, and evaluate digital booking adoption.

### 🛠️ Tech Stack & Architecture
* **Data Warehouse / Cloud SQL:** Google BigQuery Sandbox
* **Business Intelligence / BI Visualizations:** Power BI Desktop
* **Data Connection Architecture:** Import Mode (Cloud Data Warehouse to BI Desktop)

---

## 🧭 The 6-Phase Data Analytics Journey

### 1. Ask (Problem Statement)
* Why do rural consumers experience a significantly delayed cylinder booking cycle compared to urban consumers?
* Which specific months or seasons experience consistent sales dips?
* Why is digital booking adoption (Mobile App/WhatsApp) lagging despite high smartphone penetration?

### 2 & 3. Prepare & Process (Data Engineering & Cleaning)
Data was ingested into Google BigQuery. Built structural safeguards to convert tracking string fields into true `DATE` formats and handled anomalous rows where delivery dates incorrectly preceded booking logs.

### 4. Analyze (SQL Queries & Feature Engineering)
Advanced window functions (`LAG` and `DATE_DIFF`) were used to calculate delivery processing days and compute consumer transaction gaps (`DaysSinceLastRefill`).

```sql
-- Core Analytical Query executed in Google BigQuery
CREATE OR REPLACE TABLE `gasagencyproject.sales_data.clean_sales_powerbi` AS
WITH base_cleaned AS (
  SELECT 
    CustomerID, CustomerType, Location, BookingMethod, CylinderSize_KG, AmountPaid,
    BookingDate AS BookingDate,
    DeliveryDate AS DeliveryDate
  FROM `gasagencyproject.sales_data.raw_sales`
)
SELECT 
  *,
  DATE_DIFF(DeliveryDate, BookingDate, DAY) AS DaysToDeliver,
  DATE_DIFF(BookingDate, LAG(BookingDate) OVER(PARTITION BY CustomerID ORDER BY BookingDate), DAY) AS DaysSinceLastRefill
FROM base_cleaned
WHERE DeliveryDate >= BookingDate OR DeliveryDate IS NULL;
```

### 5. Share (Power BI Insights)
An interactive executive dashboard was engineered in Power BI Desktop establishing three critical focal points:
* **The 9-Day Rural Gap:** Proved that rural households average a **36-day refill cycle** compared to **27 days** in urban areas.
* **Seasonal Sales Valleys:** Identified repeatable sales contractions during winter blocks (Nov-Jan) and regional festival weeks.
* **IVRS Over-Dominance:** Discovered that **over 80%** of customer bookings go through legacy IVRS, overloading backend channels.

### 6. Act (Strategic Recommendations)
1. **Targeted Rural Distribution Camps:** Deploy localized, fixed-day delivery vehicles to rural centers to capture lagging demand.
2. **Pre-Seasonal Inventory & Campaign Management:** Run proactive SMS alerts and volume booking strategies ahead of predictable winter slumps.
3. **On-Field Digital Literacy Push:** Incentivize delivery staff to onboard counter and IVRS users to WhatsApp booking pipelines, reducing agency call volumes.

