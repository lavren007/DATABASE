-- Задача 2: клиенты, сделавшие >2 бронирований в разных отелях и потратившие >500
WITH CustomerSpending AS (
    SELECT 
        Customer.ID_customer,
        Customer.name,
        COUNT(Booking.ID_booking) AS total_bookings,
        COUNT(DISTINCT Hotel.ID_hotel) AS unique_hotels,
        SUM(Room.price) AS total_spent
    FROM Customer
    JOIN Booking ON Customer.ID_customer = Booking.ID_customer
    JOIN Room ON Booking.ID_room = Room.ID_room
    JOIN Hotel ON Room.ID_hotel = Hotel.ID_hotel
    GROUP BY Customer.ID_customer, Customer.name
    HAVING COUNT(DISTINCT Hotel.ID_hotel) > 1
       AND COUNT(Booking.ID_booking) > 2
       AND SUM(Room.price) > 500
)
SELECT 
    ID_customer,
    name,
    total_bookings,
    total_spent,
    unique_hotels
FROM CustomerSpending
ORDER BY total_spent ASC;