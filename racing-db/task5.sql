-- Задача 5: автомобили со средней позицией > 3.0
-- выводятся автомобили с низкой средней позицией,
-- результаты сортируются по количеству таких автомобилей в классе

WITH CarStats AS (
    SELECT 
        Results.car,
        AVG(Results.position) AS avg_position,
        COUNT(*) AS race_count
    FROM Results
    GROUP BY Results.car
),
LowPositionCars AS (
    SELECT 
        CarStats.car,
        CarStats.avg_position,
        CarStats.race_count,
        Cars.class,
        Classes.country
    FROM CarStats
    JOIN Cars ON CarStats.car = Cars.name
    JOIN Classes ON Cars.class = Classes.class
    WHERE CarStats.avg_position > 3.0
),
ClassLowCount AS (
    SELECT 
        class,
        COUNT(*) AS low_position_count
    FROM LowPositionCars
    GROUP BY class
)
SELECT 
    LPC.car AS car_name,
    LPC.class AS car_class,
    LPC.avg_position AS average_position,
    LPC.race_count,
    LPC.country AS car_country,
    CLC.low_position_count
FROM LowPositionCars LPC
JOIN ClassLowCount CLC ON LPC.class = CLC.class
ORDER BY CLC.low_position_count DESC, LPC.class, LPC.avg_position;