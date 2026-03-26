-- Задача 1: клиенты с более чем двумя бронированиями в разных отелях
WITH CustomerBookings AS (
    SELECT 
        Customer.ID_customer,
        Customer.name,
        Customer.email,
        Customer.phone,
        COUNT(Booking.ID_booking) AS total_bookings,
        COUNT(DISTINCT Hotel.ID_hotel) AS unique_hotels,
        SUM(Booking.check_out_date - Booking.check_in_date) AS total_days,
        STRING_AGG(DISTINCT Hotel.name, ', ' ORDER BY Hotel.name) AS hotel_list
    FROM Customer
    JOIN Booking ON Customer.ID_customer = Booking.ID_customer
    JOIN Room ON Booking.ID_room = Room.ID_room
    JOIN Hotel ON Room.ID_hotel = Hotel.ID_hotel
    GROUP BY Customer.ID_customer, Customer.name, Customer.email, Customer.phone
    HAVING COUNT(DISTINCT Hotel.ID_hotel) > 1
       AND COUNT(Booking.ID_booking) > 2
)
SELECT 
    name,
    email,
    phone,
    total_bookings,
    hotel_list,
    total_days::DECIMAL / total_bookings AS avg_stay_days
FROM CustomerBookings
ORDER BY total_bookings DESC;