-- Задача 1: Найти производителей и модели мотоциклов с мощностью >150 л.с., ценой <20000$, тип 'Sport'
-- Результат отсортировать по мощности по убыванию

SELECT Vehicle.maker, Motorcycle.model
FROM Motorcycle
JOIN Vehicle ON Motorcycle.model = Vehicle.model
WHERE Motorcycle.horsepower > 150
  AND Motorcycle.price < 20000.00
  AND Motorcycle.type = 'Sport'
ORDER BY Motorcycle.horsepower DESC;