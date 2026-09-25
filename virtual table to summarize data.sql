USE littlelemondb;
CREATE VIEW OrdersView  AS
SELECT OrderID, Quantity, TotalCost
FROM Orders
WHERE Quantity > 2;

Select * from OrdersView;

SELECT
Customers.CustomerID, Customers.FullName, Orders.OrderID,
 Orders.TotalCost, Menus.MenuName, MenuItems.ItemName, MenuItems.Category
FROM Orders
left join Customers on Orders.CustomerID = Customers.CustomerID
left join Menus     on Orders.MenuID     = Menus.MenuID
left join MenuItems on MenuItems.MenuID = Menus.MenuID
where TotalCost> 150
order by Orders.TotalCost ASC;

SELECT MenuName
FROM Menus
WHERE MenuId = ANY (
    SELECT MenuID
    FROM Orders
    WHERE Quantity > 2
);
