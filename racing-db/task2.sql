-- Задача 2: автомобиль с наименьшей средней позицией (при равенстве – первый по алфавиту)
WITH CarStats AS (
    SELECT 
        Results.car,
        AVG(Results.position) AS avg_position,
        COUNT(*) AS race_count
    FROM Results
    GROUP BY Results.car
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
ORDER BY CarStats.avg_position, CarStats.car
LIMIT 1;