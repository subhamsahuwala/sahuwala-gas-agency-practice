CREATE OR REPLACE TABLE `gasagencyproject.sales_data.clean_sales_powerbi` AS
WITH base_cleaned AS (
  SELECT 
    CustomerID,
    CustomerType,
    Location,
    BookingMethod,
    CylinderSize_KG,
    AmountPaid,
    
    -- Kyunki columns pehle se DATE hain, hum bas empty text checking ko bypass kar rhe hain
    BookingDate AS BookingDate,
    DeliveryDate AS DeliveryDate

  FROM `gasagencyproject.sales_data.raw_sales`
)

SELECT 
  CustomerID,
  CustomerType,
  Location,
  BookingMethod,
  CylinderSize_KG,
  AmountPaid,
  BookingDate,
  DeliveryDate,
  
  -- Delivery hone me kitne din lage
  DATE_DIFF(DeliveryDate, BookingDate, DAY) AS DaysToDeliver,
  
  -- Do refill ke beech me kitne din ka gap tha (Customer booking cycle)
  DATE_DIFF(
    BookingDate, 
    LAG(BookingDate) OVER(PARTITION BY CustomerID ORDER BY BookingDate), 
    DAY
  ) AS DaysSinceLastRefill

FROM base_cleaned
-- Bad data entries ko nikalne ke liye
WHERE DeliveryDate >= BookingDate OR DeliveryDate IS NULL;