USE littlelemondb;

-- ---------------------------------------------------
-- Task 1: GetMaxQuantity
-- ---------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) FROM Orders;
END $$

DELIMITER ;

-- Call it:
CALL GetMaxQuantity();


-- ---------------------------------------------------
-- Task 2: GetOrderDetail (prepared statement)
-- ---------------------------------------------------
PREPARE GetOrderDetail FROM
'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;


-- ---------------------------------------------------
-- Task 3: CancelOrder
-- Deletes the dependent OrderDeliveryStatus row first,
-- then the Orders row, so it works regardless of FK links.
-- ---------------------------------------------------
DELIMITER $$

CREATE PROCEDURE CancelOrder(IN id INT)
BEGIN
    DELETE FROM OrderDeliveryStatus WHERE OrderID = id;
    DELETE FROM Orders WHERE OrderID = id;
END $$

DELIMITER ;

-- Call it:
CALL CancelOrder(2);