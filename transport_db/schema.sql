-- Удаление таблиц, если они существуют (для чистого пересоздания)
DROP TABLE IF EXISTS Bicycle;
DROP TABLE IF EXISTS Motorcycle;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Vehicle;

-- Создание таблицы Vehicle
CREATE TABLE Vehicle (
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type ENUM('Car', 'Motorcycle', 'Bicycle') NOT NULL,
    PRIMARY KEY (model)
);

-- Создание таблицы Car
CREATE TABLE Car (
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL,
    horsepower INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    transmission ENUM('Automatic', 'Manual') NOT NULL,
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

-- Создание таблицы Motorcycle
CREATE TABLE Motorcycle (
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL,
    horsepower INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    type ENUM('Sport', 'Cruiser', 'Touring') NOT NULL,
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

-- Создание таблицы Bicycle
CREATE TABLE Bicycle (
    serial_number VARCHAR(20) NOT NULL,
    model VARCHAR(100) NOT NULL,
    gear_count INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    type ENUM('Mountain', 'Road', 'Hybrid') NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);