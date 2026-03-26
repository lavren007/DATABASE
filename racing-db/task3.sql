-- Задача 3: классы с наименьшей средней позицией (средняя позиция по классу)
WITH CarStats AS (
    SELECT 
        Results.car,
        AVG(Results.position) AS avg_position,
        COUNT(*) AS race_count
    FROM Results
    GROUP BY Results.car
),
ClassAvg AS (
    SELECT 
        Cars.class,
        AVG(CarStats.avg_position) AS class_avg_position
    FROM CarStats
    JOIN Cars ON CarStats.car = Cars.name
    GROUP BY Cars.class
),
MinClassAvg AS (
    SELECT MIN(class_avg_position) AS min_avg
    FROM ClassAvg
),
TargetClasses AS (
    SELECT class
    FROM ClassAvg
    WHERE class_avg_position = (SELECT min_avg FROM MinClassAvg)
),
ClassTotalRaces AS (
    SELECT 
        Cars.class,
        COUNT(DISTINCT Results.race) AS total_races
    FROM Cars
    JOIN Results ON Cars.name = Results.car
    GROUP BY Cars.class
)
SELECT 
    CarStats.car AS car_name,
    Cars.class AS car_class,
    CarStats.avg_position AS average_position,
    CarStats.race_count,
    Classes.country AS car_country,
    ClassTotalRaces.total_races
FROM CarStats
JOIN Cars ON CarStats.car = Cars.name
JOIN Classes ON Cars.class = Classes.class
JOIN ClassTotalRaces ON Cars.class = ClassTotalRaces.class
WHERE Cars.class IN (SELECT class FROM TargetClasses)
ORDER BY CarStats.avg_position;