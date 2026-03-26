-- Задача 1: для каждого класса найти автомобили с наименьшей средней позицией
WITH CarStats AS (
    SELECT 
        Results.car,
        AVG(Results.position) AS avg_position,
        COUNT(*) AS race_count
    FROM Results
    GROUP BY Results.car
),
ClassMin AS (
    SELECT 
        Cars.class,
        MIN(CarStats.avg_position) AS min_avg_position
    FROM CarStats
    JOIN Cars ON CarStats.car = Cars.name
    GROUP BY Cars.class
)
SELECT 
    CarStats.car AS car_name,
    Cars.class AS car_class,
    CarStats.avg_position AS average_position,
    CarStats.race_count
FROM CarStats
JOIN Cars ON CarStats.car = Cars.name
JOIN ClassMin ON Cars.class = ClassMin.class AND CarStats.avg_position = ClassMin.min_avg_position
ORDER BY average_position;