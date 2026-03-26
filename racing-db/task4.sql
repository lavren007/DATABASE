-- Задача 4: автомобили со средней позицией лучше средней по классу (в классе >=2 автомобиля)
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
        AVG(CarStats.avg_position) AS class_avg_position,
        COUNT(*) AS car_count
    FROM CarStats
    JOIN Cars ON CarStats.car = Cars.name
    GROUP BY Cars.class
    HAVING COUNT(*) >= 2
)
SELECT 
    CarStats.car AS car_name,
    Cars.class AS car_class,
    CarStats.avg_position AS average_position,
    CarStats.race_count,
    Classes.country AS car_country
FROM CarStats
JOIN Cars ON CarStats.car = Cars.name
JOIN Classes ON Cars.class = Classes.class
JOIN ClassAvg ON Cars.class = ClassAvg.class
WHERE CarStats.avg_position < ClassAvg.class_avg_position
ORDER BY car_class, average_position;