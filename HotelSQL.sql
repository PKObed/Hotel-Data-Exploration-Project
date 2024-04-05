--Combining all records over the years 2018, 2019, 2020 into one table as Yearly_Records

WITH Yearly_Records AS (
SELECT* FROM [2018 Records]
UNION
SELECT* FROM [2019 Records]
UNION
SELECT* FROM [2020 Records] 
)
SELECT market_segment, discount, MAX(arrival_date_year) 
FROM Yearly_Records
GROUP BY market_segment


-- Is the hotel revenue growing by year? Showing result

--There is no column that shows revenue generated hence we first need to find the day by day revenue generated
-- revenue = total stays * adr(actual daily rate)

SELECT YR.hotel, YR.arrival_date_year, SUM (YR.stays_in_weekend_nights + YR.stays_in_week_nights) AS [Total Stays], 
	   SUM(CONVERT(DECIMAL(9,2), (YR.stays_in_weekend_nights + YR.stays_in_week_nights) * YR.adr)) AS Total_Revenue 
FROM (SELECT* FROM [2018 Records]
		UNION
	  SELECT* FROM [2019 Records]
		UNION
	  SELECT* FROM [2020 Records]) AS YR
GROUP BY  YR.arrival_date_year, YR.hotel

/* From the results we can say that for both City and Resort hotels the revenue was growing from 2018 to 2019 
   but dipped in 2020, hence revenue used to grow by year until 2020. */
-- Placing above query result in a view for future visualization but changing query slightly to account for discount in Total_Revenue Column
DROP VIEW [Hotels Yearly Revenue];
CREATE VIEW [Hotels Yearly Revenue] AS
(
SELECT YR.hotel, YR.arrival_date_year, SUM (YR.stays_in_weekend_nights + YR.stays_in_week_nights) AS [Total Stays], 
	   SUM(CONVERT(DECIMAL(9,2), ((YR.stays_in_weekend_nights + YR.stays_in_week_nights) * (YR.adr * MS.Discount)) )) AS Total_Revenue 
FROM (SELECT* FROM [2018 Records]
		UNION
	  SELECT* FROM [2019 Records]
		UNION
	  SELECT* FROM [2020 Records]) AS YR
JOIN Market_Segment  MS
ON YR.market_segment = MS.market_segment
GROUP BY  YR.arrival_date_year, YR.hotel
);
SELECT* FROM [Hotels Yearly Revenue];


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Adding details in Market Segment and Meal Cost tables to the union of year tables as one complete table
SELECT YR.*, MS.Discount, Mc.Cost AS Cost_Of_Meal
FROM (SELECT* FROM [2018 Records]
		UNION
	  SELECT* FROM [2019 Records]
		UNION
	  SELECT* FROM [2020 Records])  YR
JOIN Market_Segment  MS
ON YR.market_segment = MS.market_segment
JOIN Meal_Cost  MC
ON YR.meal = MC.meal

-- Creating view of above data for future visualization
CREATE VIEW Hotel_Master AS (
SELECT YR.*, MS.Discount, Mc.Cost AS Cost_Of_Meal
FROM (SELECT* FROM [2018 Records]
		UNION
	  SELECT* FROM [2019 Records]
		UNION
	  SELECT* FROM [2020 Records])  YR
JOIN Market_Segment  MS
ON YR.market_segment = MS.market_segment
JOIN Meal_Cost  MC
ON YR.meal = MC.meal
)
SELECT * FROM Hotel_Master