--Creating Database
CREATE DATABASE FoodExpressDB;

USE FoodExpressDB;

--Customer Table
CREATE TABLE Customer(
	CustomerID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Phone NVARCHAR(20),
	Address NVARCHAR(200)
);

--Restaurant Table
CREATE TABLE Restaurant(
	RestaurantID INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(100),
	Cuisine NVARCHAR(50),
	City NVARCHAR(50),
	CapacityPerHour INT
);

--MenuItem Table
CREATE TABLE MenuItem(
	ItemID INT IDENTITY(1,1) PRIMARY KEY,
	RestaurantId INT,
	ItemName NVARCHAR(100),
	Price DECIMAL(10,2),

	CONSTRAINT CK_MenuItem_Price
	CHECK(Price>=0),

	CONSTRAINT FK_MenuItem_Restaurant
	FOREIGN KEY(RestaurantID)
	REFERENCES Restaurant(RestaurantID)
);

--Rider Table
CREATE TABLE Rider(
	RiderID INT IDENTITY(1,1) PRIMARY KEY,
	Firstname NVARCHAR(50),
	Lastname NVARCHAR(50),
	VehicleType NVARCHAR(20),
	Status NVARCHAR(20) DEFAULT 'Offline'
);

--Order Table
CREATE TABLE [Order](
	OrderID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT,
	RestaurantID INT,
	RiderID INT,
	OrderDate DATETIME2 DEFAULT SYSDATETIME(),
	Status NVARCHAR(20) DEFAULT 'Placed',
	TotalAmount DECIMAL(10,2),

	CONSTRAINT FK_Order_Customer
	FOREIGN KEY(CustomerID)
	REFERENCES Customer(CustomerID),

	CONSTRAINT FK_Order_Restaurant
	FOREIGN KEY(RestaurantID)
	REFERENCES Restaurant(RestaurantID),


	CONSTRAINT FK_Order_Rider
	FOREIGN KEY(RiderID)
	REFERENCES Rider(RiderID)

);

--OrderItem Table
CREATE TABLE OrderItem(
	OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT,
	ItemId INT,
	Quantity INT,

	CONSTRAINT CK_OrderItem_Quantity
	CHECK(Quantity>0),

	CONSTRAINT FK_OrderItem_Order
	FOREIGN KEY(OrderID)
	REFERENCES [Order](OrderID),

	CONSTRAINT FK_OrderItem_Item
	FOREIGN KEY(ItemID)
	REFERENCES MenuItem(ItemID)
);


--Inserting Values into Tables
INSERT INTO Customer
(FirstName, LastName, Phone, Address)
VALUES
('Rahul', 'Kumar', '9876543210', 'Chennai'),
('Priya', 'Sharma', '9876543211', 'Coimbatore'),
('Arun', 'Raj', '9876543212', 'Madurai'),
('Divya', 'Devi', '9876543213', 'Salem'),
('Karthik', 'Rajan', '9876543214', 'Trichy'),
('Sneha', 'Ravi', '9876543215', 'Chennai'),
('Vijay', 'Kumar', '9876543216', 'Erode'),
('Anitha', 'Suresh', '9876543217', 'Chennai'),
('Surya', 'Prakash', '9876543218', 'Vellore'),
('Meena', 'Lakshmi', '9876543219', 'Coimbatore');

INSERT INTO Restaurant
(Name, Cuisine, City, CapacityPerHour)
VALUES
('Annapoorna', 'South Indian', 'Coimbatore', 50),
('Pizza Palace', 'Italian', 'Chennai', 40),
('Spice Garden', 'North Indian', 'Chennai', 35),
('Dragon House', 'Chinese', 'Madurai', 30),
('Burger Hub', 'Fast Food', 'Coimbatore', 45),
('Dosa Corner', 'South Indian', 'Salem', 50),
('Royal Biryani', 'Biryani', 'Chennai', 60),
('Pasta Point', 'Italian', 'Trichy', 25),
('Tandoori Treat', 'North Indian', 'Erode', 35),
('Food Junction', 'Multi Cuisine', 'Vellore', 40);

INSERT INTO Rider
(FirstName, LastName, VehicleType, Status)
VALUES
('Arjun', 'Kumar', 'Bike', 'Available'),
('Bala', 'Raj', 'Scooter', 'Available'),
('Charan', 'Das', 'Bike', 'Offline'),
('Deepak', 'Ravi', 'Bike', 'Available'),
('Ezhil', 'Kumar', 'Cycle', 'Available'),
('Farhan', 'Ali', 'Scooter', 'Offline'),
('Gokul', 'Raj', 'Bike', 'Available'),
('Hari', 'Prasad', 'Scooter', 'Available'),
('Imran', 'Khan', 'Bike', 'Offline'),
('Jeeva', 'Raman', 'Bike', 'Available');

INSERT INTO MenuItem
(RestaurantID, ItemName, Price)
VALUES
(1, 'Masala Dosa', 80.00),
(1, 'Idli', 40.00),
(2, 'Margherita Pizza', 250.00),
(2, 'Cheese Pizza', 300.00),
(3, 'Paneer Butter Masala', 220.00),
(3, 'Butter Naan', 50.00),
(4, 'Veg Fried Rice', 150.00),
(4, 'Chicken Noodles', 200.00),
(5, 'Veg Burger', 100.00),
(5, 'Chicken Burger', 150.00),
(6, 'Ghee Roast Dosa', 120.00),
(6, 'Pongal', 70.00),
(7, 'Chicken Biryani', 250.00),
(7, 'Mutton Biryani', 320.00),
(8, 'White Sauce Pasta', 180.00),
(8, 'Red Sauce Pasta', 160.00),
(9, 'Tandoori Chicken', 280.00),
(9, 'Paneer Tikka', 200.00),
(10, 'Veg Meals', 120.00),
(10, 'Chicken Meals', 180.00);

WITH OrderNumbers AS
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
)
INSERT INTO [Order]
(CustomerID, RestaurantID, RiderID, TotalAmount)
SELECT
    ((Num - 1) % 10) + 1,
    ((Num - 1) % 10) + 1,
    ((Num - 1) % 10) + 1,
    (
        SELECT SUM(Price)
        FROM MenuItem
        WHERE RestaurantID = ((Num - 1) % 10) + 1
    )
FROM OrderNumbers;

INSERT INTO OrderItem
(OrderID, ItemID, Quantity)
SELECT
    o.OrderID,
    m.ItemID,
    CASE
        WHEN m.ItemID % 2 = 0 THEN 2
        ELSE 1
    END
FROM [Order] o
INNER JOIN MenuItem m
    ON o.RestaurantID = m.RestaurantID;

