USE littlelemondb;

-- ---------------------------------------------------
-- Task 1: Insert the four booking records
-- ---------------------------------------------------
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID, StaffID) VALUES
(1, '2022-10-10', 5, 1, 2),
(2, '2022-11-12', 3, 3, 2),
(3, '2022-10-11', 2, 2, 2),
(4, '2022-10-13', 2, 1, 2);

-- Check it:
SELECT * FROM Bookings;


-- ---------------------------------------------------
-- Task 2: CheckBooking.
-- ---------------------------------------------------
DELIMITER $$

CREATE PROCEDURE CheckBooking(IN in_date DATE, IN in_table INT)
BEGIN
    DECLARE booking_count INT;

    SELECT COUNT(*) INTO booking_count
    FROM Bookings
    WHERE BookingDate = in_date AND TableNumber = in_table;

    IF booking_count > 0 THEN
        SELECT CONCAT('Table ', in_table, ' is already booked on ', in_date) AS BookingStatus;
    ELSE
        SELECT CONCAT('Table ', in_table, ' is available on ', in_date) AS BookingStatus;
    END IF;
END $$

DELIMITER ;

-- Example calls:
CALL CheckBooking('2022-10-10', 5);   -- already booked (from Task 1 data)
CALL CheckBooking('2022-10-10', 9);   -- available


-- ---------------------------------------------------
-- Task 3: AddValidBooking
-- ---------------------------------------------------
DELIMITER $$

CREATE PROCEDURE AddValidBooking(IN in_date DATE, IN in_table INT)
BEGIN
    DECLARE booking_count INT;

    START TRANSACTION;

    INSERT INTO Bookings (BookingDate, TableNumber, CustomerID, StaffID)
    VALUES (in_date, in_table, 1, 2);

    SELECT COUNT(*) INTO booking_count
    FROM Bookings
    WHERE BookingDate = in_date AND TableNumber = in_table;

    IF booking_count > 1 THEN
        ROLLBACK;
        SELECT 'Booking Declined - table already booked' AS Result;
    ELSE
        COMMIT;
        SELECT 'Booking Confirmed' AS Result;
    END IF;
END $$

DELIMITER ;

-- Example calls:
CALL AddValidBooking('2022-10-10', 5);   -- should ROLLBACK (table 5 already booked on that date)
CALL AddValidBooking('2022-12-01', 5);   -- should COMMIT (new date, no conflict)