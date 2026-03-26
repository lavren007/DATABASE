-- Задача 2: Объединённая информация о транспорте, удовлетворяющем критериям
-- Автомобили: мощность >150, объём <3 л, цена <35000
-- Мотоциклы: мощность >150, объём <1.5 л, цена <20000
-- Велосипеды: число передач >18, цена <4000
-- Сортировка по мощности по убыванию (NULL в конце)

SELECT Vehicle.maker, Car.model, Car.horsepower, Car.engine_capacity, 'Car'
FROM Car
JOIN Vehicle ON Car.model = Vehicle.model
WHERE Car.horsepower > 150
  AND Car.engine_capacity < 3.00
  AND Car.price < 35000.00

UNION

SELECT Vehicle.maker, Motorcycle.model, Motorcycle.horsepower, Motorcycle.engine_capacity, 'Motorcycle'
FROM Motorcycle
JOIN Vehicle ON Motorcycle.model = Vehicle.model
WHERE Motorcycle.horsepower > 150
  AND Motorcycle.engine_capacity < 1.50
  AND Motorcycle.price < 20000.00

UNION

SELECT Vehicle.maker, Bicycle.model, NULL, NULL, 'Bicycle'
FROM Bicycle
JOIN Vehicle ON Bicycle.model = Vehicle.model
WHERE Bicycle.gear_count > 18
  AND Bicycle.price < 4000.00

ORDER BY horsepower DESC;