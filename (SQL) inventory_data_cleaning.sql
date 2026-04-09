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