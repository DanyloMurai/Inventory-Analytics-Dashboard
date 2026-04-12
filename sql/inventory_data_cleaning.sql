-- !INVENTORY ANALYTICS PROJECT (SQLite)!
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

-- STRUCTURE CHECK

PRAGMA table_info(inventory);

-- PREVIEW THE DATA

SELECT *
FROM inventory
LIMIT 10;

-- BASIC ROW COUNT CHECK 

SELECT COUNT(*) AS row_count
FROM inventory;

-- CHECK KEY UNIQUENESS (location + sku + month)

SELECT
    location,
    sku,
    month,
    COUNT(*) AS duplicate_count
FROM inventory
GROUP BY location, sku, month
HAVING COUNT(*) > 1;

-- OVERALL KPI SUMMARY

SELECT
    COUNT(*) AS row_count,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(outflow) AS total_outflow,
    SUM(opening_stock) AS total_opening_stock,
    SUM(ending_stock) AS total_ending_stock,
    AVG(turnover_ratio) AS avg_turnover_ratio
FROM inventory;

-- MONTHLY KPI SUMMARY (ALL PERIODS)

SELECT
    month,
    COUNT(*) AS row_count,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(outflow) AS total_outflow,
    SUM(opening_stock) AS total_opening_stock,
    SUM(ending_stock) AS total_ending_stock,
    AVG(turnover_ratio) AS avg_turnover_ratio
FROM inventory
GROUP BY month
ORDER BY month;

-- MONTHLY KPI SUMMARY (EXCLUDING YEAR-END SNAPSHOT)

SELECT
    month,
    COUNT(*) AS row_count,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(outflow) AS total_outflow,
    SUM(opening_stock) AS total_opening_stock,
    SUM(ending_stock) AS total_ending_stock,
    AVG(turnover_ratio) AS avg_turnover_ratio
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY month
ORDER BY month;

-- TOP SKU BY OUTFLOW

SELECT
    sku,
    SUM(outflow) AS total_outflow,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(ending_stock) AS total_ending_stock
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY sku
ORDER BY total_outflow DESC;

-- TOP SKU BY CUSTOMER DEMAND

SELECT
    sku,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow,
    SUM(inflow) AS total_inflow,
    SUM(ending_stock) AS total_ending_stock
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY sku
ORDER BY total_customer_demand DESC;

-- TOP 10 LOCATIONS BY OUTFLOW

SELECT
    location,
    SUM(outflow) AS total_outflow,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(ending_stock) AS total_ending_stock
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY location
ORDER BY total_outflow DESC
LIMIT 10;

-- TOP 10 LOCATIONS BY CUSTOMER DEMAND (Shows which locations generate the highest demand)

SELECT
    location,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow,
    SUM(inflow) AS total_inflow,
    SUM(ending_stock) AS total_ending_stock
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY location
ORDER BY total_customer_demand DESC
LIMIT 10;

-- ABC GROUP SUMMARY

SELECT
    ABC_group,
    COUNT(*) AS row_count,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(outflow) AS total_outflow,
    SUM(ending_stock) AS total_ending_stock,
    AVG(turnover_ratio) AS avg_turnover_ratio
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY ABC_group
ORDER BY total_outflow DESC;

-- STOCKOUT RISK CASES (customer demand exceeds outflow and ending stock is zero or below)

SELECT
    month,
    sku,
    location,
    customer_demand,
    outflow,
    ending_stock,
    inflow,
    production_order,
    extra_order
FROM inventory
WHERE month <> '2023-12-31'
  AND customer_demand > outflow
  AND ending_stock <= 0
ORDER BY customer_demand DESC
LIMIT 20;

-- STOCKOUT RISK COUNT

SELECT
    COUNT(*) AS stockout_risk_count
FROM inventory
WHERE month <> '2023-12-31'
  AND customer_demand > outflow
  AND ending_stock <= 0;

-- SLOW-MOVING / EXCESS STOCK CASES

SELECT
    month,
    sku,
    location,
    opening_stock,
    inflow,
    outflow,
    ending_stock,
    customer_demand
FROM inventory
WHERE month <> '2023-12-31'
  AND ending_stock > 0
  AND outflow = 0
ORDER BY ending_stock DESC
LIMIT 20;

-- SLOW-MOVING COUNT

SELECT
    COUNT(*) AS slow_moving_count
FROM inventory
WHERE month <> '2023-12-31'
  AND ending_stock > 0
  AND outflow = 0;

-- SKU-LEVEL STOCKOUT RISK SUMMARY

SELECT
    sku,
    COUNT(*) AS stockout_risk_cases,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow
FROM inventory
WHERE month <> '2023-12-31'
  AND customer_demand > outflow
  AND ending_stock <= 0
GROUP BY sku
ORDER BY stockout_risk_cases DESC, total_customer_demand DESC;

-- SKU-LEVEL SLOW-MOVING SUMMARY (which SKUs most often appear in slow-moving situations)

SELECT
    sku,
    COUNT(*) AS slow_moving_cases,
    SUM(ending_stock) AS total_ending_stock,
    SUM(customer_demand) AS total_customer_demand
FROM inventory
WHERE month <> '2023-12-31'
  AND ending_stock > 0
  AND outflow = 0
GROUP BY sku
ORDER BY total_ending_stock DESC, slow_moving_cases DESC;

-- LOCATION-LEVEL STOCKOUT RISK SUMMARY (which locations most often show stockout-risk patterns)

SELECT
    location,
    COUNT(*) AS stockout_risk_cases,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow
FROM inventory
WHERE month <> '2023-12-31'
  AND customer_demand > outflow
  AND ending_stock <= 0
GROUP BY location
ORDER BY stockout_risk_cases DESC, total_customer_demand DESC
LIMIT 20;

-- LOCATION-LEVEL SLOW-MOVING SUMMARY (which locations most often show slow-moving inventory patterns)

SELECT
    location,
    COUNT(*) AS slow_moving_cases,
    SUM(ending_stock) AS total_ending_stock,
    SUM(customer_demand) AS total_customer_demand
FROM inventory
WHERE month <> '2023-12-31'
  AND ending_stock > 0
  AND outflow = 0
GROUP BY location
ORDER BY total_ending_stock DESC, slow_moving_cases DESC
LIMIT 20;

-- DEMAND COVERAGE BY SKU

SELECT
    sku,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow,
    ROUND(
        CASE
            WHEN SUM(customer_demand) = 0 THEN NULL
            ELSE SUM(outflow) * 1.0 / SUM(customer_demand)
        END,
        3
    ) AS demand_coverage_ratio
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY sku
ORDER BY demand_coverage_ratio ASC;

-- MONTHLY DEMAND COVERAGE

SELECT
    month,
    SUM(customer_demand) AS total_customer_demand,
    SUM(outflow) AS total_outflow,
    ROUND(
        CASE
            WHEN SUM(customer_demand) = 0 THEN NULL
            ELSE SUM(outflow) * 1.0 / SUM(customer_demand)
        END,
        3
    ) AS demand_coverage_ratio
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY month
ORDER BY month;

-- MONTHLY STOCK GROWTH / DECLINE

SELECT
    month,
    SUM(opening_stock) AS total_opening_stock,
    SUM(ending_stock) AS total_ending_stock,
    SUM(ending_stock) - SUM(opening_stock) AS stock_change
FROM inventory
WHERE month <> '2023-12-31'
GROUP BY month
ORDER BY month;

-- YEAR-END SNAPSHOT ONLY

SELECT
    month,
    COUNT(*) AS row_count,
    SUM(customer_demand) AS total_customer_demand,
    SUM(inflow) AS total_inflow,
    SUM(outflow) AS total_outflow,
    SUM(opening_stock) AS total_opening_stock,
    SUM(ending_stock) AS total_ending_stock,
    AVG(turnover_ratio) AS avg_turnover_ratio
FROM inventory
WHERE month = '2023-12-31'
GROUP BY month;

-- CHECK NON-ZERO PRODUCTION ORDERS

SELECT
    month,
    sku,
    location,
    production_order,
    extra_order
FROM inventory
WHERE production_order IS NOT NULL
  AND production_order <> 0
LIMIT 20;
