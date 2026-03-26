-- Задача 3: предпочтения клиентов по типу отелей
WITH HotelCategory AS (
    SELECT 
        Hotel.ID_hotel,
        Hotel.name AS hotel_name,
        AVG(Room.price) AS avg_price,
        CASE 
            WHEN AVG(Room.price) < 175 THEN 'Дешевый'
            WHEN AVG(Room.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS category
    FROM Hotel
    JOIN Room ON Hotel.ID_hotel = Room.ID_hotel
    GROUP BY Hotel.ID_hotel, Hotel.name
),
CustomerHotels AS (
    SELECT DISTINCT
        Customer.ID_customer,
        Customer.name,
        HotelCategory.hotel_name,
        HotelCategory.category
    FROM Customer
    JOIN Booking ON Customer.ID_customer = Booking.ID_customer
    JOIN Room ON Booking.ID_room = Room.ID_room
    JOIN HotelCategory ON Room.ID_hotel = HotelCategory.ID_hotel
),
CustomerCategory AS (
    SELECT 
        ID_customer,
        name,
        CASE 
            WHEN MAX(CASE WHEN category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
            WHEN MAX(CASE WHEN category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        STRING_AGG(DISTINCT hotel_name, ', ' ORDER BY hotel_name) AS visited_hotels
    FROM CustomerHotels
    GROUP BY ID_customer, name
)
SELECT 
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM CustomerCategory
ORDER BY 
    CASE preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END;