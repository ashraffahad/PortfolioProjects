USE stolen_vehicles_db;

SELECT *
FROM locations;
SELECT *
FROM make_details;
SELECT *
FROM stolen_vehicles;


-- Objective 1
-- Find the number of vehicles stolen each year
SELECT 
    YEAR(date_stolen) AS year_stolen,
    COUNT(vehicle_id) AS number_of_stolen_vehicle
FROM
    stolen_vehicles
GROUP BY year_stolen;

-- Find the number of vehicles stolen each month

SELECT 
    MONTHNAME(date_stolen) AS month_stolen,
    COUNT(vehicle_id) AS number_of_stolen_vehicle
FROM
    stolen_vehicles
GROUP BY month_stolen
ORDER BY number_of_stolen_vehicle DESC;

-- Find the number of vehicles stolen each day of the week
SELECT 
    DAYNAME(date_stolen) AS day_stolen,
    COUNT(vehicle_id) AS number_of_stolen_vehicle
FROM
    stolen_vehicles
GROUP BY day_stolen
ORDER BY number_of_stolen_vehicle DESC;

-- Create a bar chart that shows the number of vehicles stolen on each day of the week
-- Answer in the Excel Sheet


-- Objective 2
-- Find the vehicle types that are most often and least often stolen

-- For most often stolen vehicle type
(SELECT vehicle_type, COUNT(vehicle_id) AS most_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY most_stolen DESC
LIMIT 1)
union all
-- For least often stolen vehicle type
(SELECT vehicle_type, COUNT(vehicle_id) AS least_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY least_stolen ASC
LIMIT 1);


-- For each vehicle type, find the average age of the cars that are stolen
SELECT 
    vehicle_type,
    ROUND(AVG(YEAR(date_stolen) - model_year), 2) AS average_years
FROM
    stolen_vehicles
GROUP BY vehicle_type
ORDER BY average_years DESC;

-- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
WITH lux_cars AS (
	SELECT 
		sv.vehicle_type, 
		CASE 
			WHEN md.make_type = 'Luxury' THEN 1 
			ELSE 0 
		END AS lux_vehicle, 
		1 AS all_cars
	FROM stolen_vehicles sv
	LEFT JOIN make_details md
	ON sv.make_id = md.make_id
)
SELECT 
	vehicle_type, 
	ROUND(SUM(lux_vehicle) / count(lux_vehicle) * 100,2) AS pct_luxury
FROM lux_cars 
GROUP BY vehicle_type
ORDER BY pct_luxury DESC;


/*Create a table where the rows represent the top 10 vehicle types, 
the columns represent the top 7 vehicle colors (plus 1 column for all other colors) 
and the values are the number of vehicles stolen */

SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicle,
	SUM(CASE WHEN color='Silver' THEN 1 ELSE 0 END) Silver,
    SUM(CASE WHEN color='White' THEN 1 ELSE 0 END) White ,
    SUM(CASE WHEN color='Black' THEN 1 ELSE 0 END) Black, 
    SUM(CASE WHEN color='Blue' THEN 1 ELSE 0 END)Blue ,
    SUM(CASE WHEN color='Red' THEN 1 ELSE 0 END) Red ,
    SUM(CASE WHEN color='Grey' THEN 1 ELSE 0 END) Grey,
    SUM(CASE WHEN color='Green' THEN 1 ELSE 0 END) Green, 
    SUM(CASE WHEN color IN('Gold','Brown','Yellow', 'Orange', 'Purple','Cream', 'Pink', NULL) THEN 1 ELSE 0 END) Other
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicle DESC
LIMIT 10;

-- Create a heat map of the table comparing the vehicle types and colors
-- Answer in Excel sheet

-- Objective 3
-- Find the number of vehicles that were stolen in each region

SELECT region, COUNT(vehicle_id) AS num_of_stolen_vehicle
FROM stolen_vehicles sv
LEFT JOIN locations l
	ON sv.location_id=l.location_id
GROUP BY region
ORDER BY num_of_stolen_vehicle DESC
;

-- Combine the previous output with the population and density statistics for each region

SELECT region, population, density, COUNT(vehicle_id) AS num_of_stolen_vehicle
FROM stolen_vehicles sv
LEFT JOIN locations l
	ON sv.location_id=l.location_id
GROUP BY region, population, density
ORDER BY num_of_stolen_vehicle DESC;

-- Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?

(SELECT  'High_Density' as AreaDensity, vehicle_type, COUNT(vehicle_id) AS num_of_stolen_vehicle
FROM stolen_vehicles sv
LEFT JOIN locations l
	ON sv.location_id=l.location_id
WHERE region in('Auckland','Nelson','Wellington')
GROUP BY vehicle_type
ORDER BY num_of_stolen_vehicle DESC
LIMIT 5)

UNION

(SELECT  'Low_Density' AreaDensity, vehicle_type, COUNT(vehicle_id) AS num_of_stolen_vehicle
FROM stolen_vehicles sv
LEFT JOIN locations l
	ON sv.location_id=l.location_id
WHERE region in('Otago','Gisborne','Southland')
GROUP BY vehicle_type
ORDER BY num_of_stolen_vehicle DESC
LIMIT 5);

-- Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region


-- Create a map of the regions and color the regions based on the number of stolen vehicles


