CREATE DATABASE Restaurant_Project
USE Restaurant_Project

GO 

--  ****** Create Tables *******

CREATE TABLE dbo.Role ( 
  RoleID INT NOT NULL IDENTITY(1,1), 
  RoleTitle VARCHAR(20) NOT NULL, 
  RoleDescription VARCHAR(250) NOT NULL, 
  PRIMARY KEY (RoleID)
); 

CREATE TABLE dbo.Customers (
  CustomerID INT NOT NULL IDENTITY(1,1), 
  CustomerDiscount INT NOT NULL,
  CustomerFName VARCHAR(25) NOT NULL,
  CustomerLName VARCHAR(25) NOT NULL,
  CustomerContact BIGINT NOT NULL, 
  PRIMARY KEY (CustomerID)
); 

CREATE TABLE dbo.CustomerLocation ( 
  CustomerLocationID INT NOT NULL IDENTITY(1,1),
  CustomerID INT NOT NULL, 
  StreetAddress VARCHAR(250) NOT NULL, 
  City VARCHAR(20) NOT NULL, 
  State VARCHAR(20) NOT NULL, 
  ZipCode INT NOT NULL, 
  PRIMARY KEY (CustomerLocationID), 
  CONSTRAINT FK_CustomerLocation_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 

CREATE TABLE dbo.CardDetails ( 
  CardID INT NOT NULL IDENTITY(1,1), 
  CustomerID INT NOT NULL, 
  CustomerFName VARCHAR(25) NOT NULL, 
  CustomerLName VARCHAR(25) NOT NULL, 
  ExpiryDate DATE NOT NULL, 
  VerificationCode INT NOT NULL, 
  PRIMARY KEY (CardID), 
  CONSTRAINT FK_CardDetails_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 

); 

CREATE TABLE dbo.Restaurant ( 
  RestaurantID INT NOT NULL IDENTITY(1,1), 
  Name VARCHAR(50) NOT NULL, 
  Street VARCHAR(250) NOT NULL, 
  City VARCHAR(20) NOT NULL, 
  State VARCHAR(20) NOT NULL, 
  ZipCode INT NOT NULL, 
  RestaurantType VARCHAR(20) NOT NULL, 
  Restaurant_Rating INT NOT NULL, 
  PRIMARY KEY (RestaurantID) 
); 

CREATE TABLE dbo.ResturantEmployee ( 
  EmployeeID INT NOT NULL IDENTITY(1,1), 
  RestaurantID INT NOT NULL, 
  RoleID INT NOT NULL, 
  FirstName VARCHAR(20) NOT NULL, 
  LastName VARCHAR(20) NOT NULL, 
  Gender VARCHAR(10) NOT NULL, 
  PhoneNo BIGINT NOT NULL, 
  DOB DATE NOT NULL, 
  Salary INT NOT NULL, 
  Email VARCHAR(50) NOT NULL, 
  UserName VARCHAR(20) NOT NULL,
  EncryptedPassword VARBINARY(100) NOT NULL,
  PRIMARY KEY (EmployeeID), 
  CONSTRAINT FK_RestaurantEmployee_RestaurantID FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID), 
  CONSTRAINT FK_RestaurantEmployee_RoleID FOREIGN KEY (RoleID) REFERENCES Role(RoleID) 
);

CREATE TABLE dbo.DiningTable(
  DiningTableID INT NOT NULL IDENTITY(1,1),
  Size INT NOT NULL, 
  isReserved VARCHAR(10) NOT NULL, 
  PRIMARY KEY (DiningTableID)
); 

CREATE TABLE dbo.Reservation ( 
  ReservationID INT NOT NULL IDENTITY(1,1), 
  CustomerID INT NOT NULL, 
  DiningTableID INT NOT NULL, 
  CustomerName VARCHAR(25) NOT NULL, 
  ReservationTime TIME NOT NULL, 
  ReservationDate DATE NOT NULL, 
  NumberOfSeats INT NOT NULL, 
  PRIMARY KEY (ReservationID), 
  CONSTRAINT FK_Reservation_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), 
  CONSTRAINT FK_Reservation_DiningTableID FOREIGN KEY (DiningTableID) REFERENCES DiningTable(DiningTableID)
); 

CREATE TABLE dbo.DeliveryPersonal (
  DeliveryPersonalID INT NOT NULL IDENTITY(1,1), 
  RestuarantID INT NOT NULL, 
  Availability bit, 
  FirstName VARCHAR(25) NOT NULL, 
  LastName VARCHAR(25) NOT NULL, 
  PRIMARY KEY (DeliveryPersonalID), 
  CONSTRAINT FK_DeliveryPersonal_RestuarantID FOREIGN KEY (RestuarantID) REFERENCES Restaurant(RestaurantID)
); 

CREATE TABLE dbo.Menu ( 
  MenuID INT NOT NULL IDENTITY(1,1), 
  ResturantID INT NOT NULL, 
  PRIMARY KEY (MenuID), 
  CONSTRAINT FK_Menu_ResturantID FOREIGN KEY (ResturantID) REFERENCES Restaurant(RestaurantID) 
); 

CREATE TABLE dbo.MenuGroup (
  MenuGroupID INT NOT NULL IDENTITY(1,1), 
  MenuID INT NOT NULL, 
  Name VARCHAR(50) NOT NULL, 
  PRIMARY KEY (MenuGroupID), 
  CONSTRAINT FK_MenuGroup_MenuID FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) 
); 

CREATE TABLE dbo.MenuItem ( 
  MenuItemID INT NOT NULL IDENTITY(1,1), 
  MenuGroupID INT NOT NULL, 
  Name VARCHAR(50) NOT NULL, 
  Description VARCHAR(250) NOT NULL, 
  Price FLOAT NOT NULL, 
  ItemImage IMAGE NOT NULL, 
  PRIMARY KEY (MenuItemID), 
  CONSTRAINT FK_MenuItem_MenuGroupID FOREIGN KEY (MenuGroupID) REFERENCES MenuGroup(MenuGroupID)
); 

CREATE TABLE dbo.Orders ( 
  OrderID INT NOT NULL IDENTITY(1,1), 
  CustomerID INT, 
  RestuarantID INT, 
  DiningTableID INT, 
  OrderDateTime DATETIME NOT NULL, 
  OrderStatus VARCHAR(20) NOT NULL, 
  Price FLOAT NOT NULL, 
  OrderType VARCHAR(20) NOT NULL, 
  DiscountAmt FLOAT,
  PRIMARY KEY (OrderID), 
  CONSTRAINT FK_Orders_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), 
  CONSTRAINT FK_Orders_RestuarantID FOREIGN KEY (RestuarantID) REFERENCES Restaurant(RestaurantID), 
  CONSTRAINT FK_Orders_DiningTableID FOREIGN KEY (DiningTableID) REFERENCES DiningTable(DiningTableID)
);

CREATE TABLE dbo.OrderItem ( 
  OrderItemID INT NOT NULL IDENTITY(1,1), 
  OrderID INT NOT NULL, 
  MenuItemID  INT NOT NULL, 
  Quantity INT NOT NULL, 
  Price FLOAT,
  PRIMARY KEY (OrderItemID), 
  CONSTRAINT FK_OrderItem_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), 
  CONSTRAINT FK_OrderItem_MenuItemID FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID) 
);

CREATE TABLE dbo.DeliveryDetails ( 
  DeliveryID INT NOT NULL IDENTITY(1,1), 
  DeliveryPersonnelID INT NOT NULL, 
  OrderID INT NOT NULL, 
  CustomerLocationID INT NOT NULL, 
  DeliveryFee FLOAT NOT NULL, 
  LocationPincode INT NOT NULL, 
  start_time DATETIME NOT NULL, 
  end_time DATETIME, 
  estimated_time DATETIME NOT NULL, 
  PRIMARY KEY (DeliveryID), 
  CONSTRAINT FK_DeliveryDetails_DeliveryPersonnelID FOREIGN KEY (DeliveryPersonnelID) REFERENCES DeliveryPersonal(DeliveryPersonalID), 
  CONSTRAINT FK_DeliveryDetails_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), 
  CONSTRAINT FK_DeliveryDetails_CustomerLocationID FOREIGN KEY (CustomerLocationID) REFERENCES CustomerLocation(CustomerLocationID) 
);



CREATE TABLE dbo.Feedback ( 
  FeedbackID INT NOT NULL IDENTITY(1,1), 
  RestaurantID INT NOT NULL, 
  CustomerID INT NOT NULL, 
  TimelyDelivery INT NOT NULL, 
  Quality INT NOT NULL, 
  Quantity INT NOT NULL, 
  CustomerSatisfaction INT NOT NULL, 
  PRIMARY KEY (FeedbackID),
  CONSTRAINT FK_Feedback_FeedbackID FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID), 
  CONSTRAINT FK_Feedback_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 

CREATE TABLE dbo.Bill (
  BillID INT NOT NULL IDENTITY(1,1), 
  OrderID INT NOT NULL, 
  CustomerID INT  NOT NULL, 
  CardID INT  NOT NULL, 
  PaymentType VARCHAR(20), 
  BillTime TIME NOT NULL, 
  BillDate DATE NOT NULL, 
  TotalBillAmount FLOAT NOT NULL, 
  PRIMARY KEY (BillID), 
  CONSTRAINT FK_Bill_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),  
  CONSTRAINT FK_BillCustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), 
  CONSTRAINT FK_Bill_CardID FOREIGN KEY (CardID) REFERENCES CardDetails(CardID) 
);

-- Column Data Encryption

-- 1. Create DMK(Master Key)
Create MASTER KEY
Encryption By PASSWORD = 'DbP@sswOrd';

-- 2. Create certificate to protect symmetric key

CREATE CERTIFICATE RestaurantMgmtCertificate
WITH SUBJECT = 'Restaurant Management Certificate',
EXPIRY_DATE = '2026-10-31';

-- 3. Create symmetric key to encrypt data
CREATE SYMMETRIC KEY RestaurantMgmtSymmetricKey
WITH ALGORITHM = AES_128
Encryption By Certificate RestaurantMgmtCertificate;


-- 4. Opeen Symmetric Key
OPEN SYMMETRIC KEY RestaurantMgmtSymmetricKey
DECRYPTION BY CERTIFICATE RestaurantMgmtCertificate;



-- Table Level Check Constraints

-- 1) Bill Table

ALTER TABLE dbo.Bill
ADD CONSTRAINT payment_type 
CHECK(PaymentType in ('Cash','Card'));

-- 2) DeliveryDetails  Table

ALTER TABLE dbo.DeliveryDetails
ADD CONSTRAINT check_start_and_end_time
CHECK(end_time >= start_time);

-- 3) DiningTable  Table

ALTER TABLE dbo.DiningTable  
ADD CONSTRAINT check_Table_Size
CHECK(size BETWEEN 0 AND 15);

-- 4) Feedback Table
ALTER TABLE dbo.Feedback  
ADD CONSTRAINT check_Delivery_Rating
CHECK(TimelyDelivery BETWEEN 0 AND 5);

ALTER TABLE dbo.Feedback  
ADD CONSTRAINT check_Quality_Rating
CHECK(Quality BETWEEN 0 AND 5);

ALTER TABLE dbo.Feedback  
ADD CONSTRAINT check_Quantity_Rating
CHECK(Quantity BETWEEN 0 AND 5);

ALTER TABLE dbo.Feedback  
ADD CONSTRAINT check_CustomerSatisfaction_Rating
CHECK(CustomerSatisfaction BETWEEN 0 AND 5);

-- 5) MenuItem Table

ALTER TABLE dbo.MenuItem  
ADD CONSTRAINT check_MenuItem_Price
CHECK(Price BETWEEN 1.00 AND 60.00);

-- 6) OrderItem Table

ALTER TABLE OrderItem 
ADD CONSTRAINT check_OrderItem_Price
CHECK(Price BETWEEN 0.00 AND 60.00);

ALTER TABLE OrderItem 
ADD CONSTRAINT check_OrderItem_Quantity
CHECK(Quantity BETWEEN 1 AND 30);

-- 7) Orders  Table

ALTER TABLE dbo.Orders 
ADD CONSTRAINT Chk_Order_type 
CHECK(OrderType in ('Dining','Pickup', 'Delivery'));

ALTER TABLE dbo.Orders 
ADD CONSTRAINT chk_Order_Status 
CHECK(OrderStatus in ('Delivered','Completed', 'Preparing', 'Ready for Delivery','Pending'));


-- 8) Restaurant  Table

ALTER TABLE dbo.Restaurant  
ADD CONSTRAINT check_Restaurant_Rating
CHECK(Restaurant_Rating BETWEEN 0 AND 5);

-- 9) ResturantEmployee  Table

ALTER TABLE dbo.ResturantEmployee
ADD CONSTRAINT check_Date_Of_Birth
CHECK(DOB < CAST( GETDATE() AS Date ));

-- Functions 

/*
Checks if delivery personnel is available before Inserting Order details in Delivery Detials table
*/
CREATE FUNCTION [dbo].[Constraint_Check_Available_DeliveryPersonnel]
(@OrderID INT, @DeliveryPersonnelID int)
Returns Bit
AS
BEGIN
DECLARE @OrderType varchar(50);
DECLARE @Availability Bit;
DECLARE @check int;
 
SET @OrderType = (Select OrderType from Orders where OrderID=@OrderID)

SET @Availability = (Select Availability From DeliveryPersonal where DeliveryPersonalID=@DeliveryPersonnelID)

     IF(@OrderType = 'Delivery' AND  @Availability=1)
	 BEGIN
	    SET @check=1;
	 END
	else
	 BEGIN
	    SET @check=0;
     END
Return @check;
END;

/*
Checks if order is completed or delivered 
*/
CREATE FUNCTION [dbo].[Constraint_Check_Order_Completed]
(@OrderID INT)
Returns Bit
AS
BEGIN
DECLARE @OrderStatus varchar(50);
DECLARE @check int;
 
SET @OrderStatus = (Select OrderStatus from Orders where OrderID=@OrderID)

     IF(@OrderStatus = 'Completed' OR @OrderStatus='Delivered')
	 BEGIN
	    SET @check=1;
	 END
	else
	 BEGIN
	    SET @check=0;
     END
Return @check;
END;

/*
Get deliveryPersonnelID of the first available delivery personnel
*/
CREATE FUNCTION [dbo].[fn_get_available_delivery_person]()
RETURNS INT
AS
BEGIN
	DECLARE @avalilable_delivery_person INT;
	SET @avalilable_delivery_person = (	SELECT TOP 1 DeliveryPersonalID 
										FROM dbo.[DeliveryPersonal]
										WHERE dbo.[DeliveryPersonal].Availability = 1
									  );
		
	RETURN @avalilable_delivery_person;
END;

/*
Calculate discount based on the discountedAmt column in Orders
*/
CREATE FUNCTION [dbo].[fn_apply_discount]
( @discount INT, @price FLOAT )
RETURNS FLOAT
AS 
BEGIN
	DECLARE @discountedAmt FLOAT;
	SET @discountedAmt = (@price*CAST(@discount AS FLOAT)/100);
	
	RETURN @discountedAmt;
END;

/*
Calculates the delivery fee based on the total amount of the order
*/
CREATE FUNCTION [dbo].[fn_getdelivery_fee]
( @OrderID INT)
RETURNS FLOAT
AS 
BEGIN
	DECLARE @order_Amt float;
	SET @order_Amt = (SELECT Price FROM dbo.[Orders] WHERE OrderID = @OrderID);

	DECLARE @delivery_fee int;

	IF @order_Amt < 30
		SET @delivery_fee = 8.00
	ELSE
		SET @delivery_fee = 0.00
	
	RETURN @delivery_fee;
END;

-- Function to get available table

CREATE FUNCTION [dbo].[fn_get_available_dining_table]()
RETURNS INT
AS
BEGIN
	DECLARE @avalilable_dining_table INT;
	SET @avalilable_dining_table = (SELECT TOP 1 DiningTableID 
										   FROM dbo.DiningTable
										   WHERE isReserved = 0);
		
	RETURN @avalilable_dining_table;
END;

--- Procedures
/*
Store procedure to insert delivery details based on OrderID
*/
CREATE PROCEDURE [dbo].[sp_initiate_delivery]
@order_id INT
AS
	BEGIN

	DECLARE @order_type VARCHAR(250);
	SET @order_type = (SELECT OrderType FROM dbo.[Orders] WHERE OrderID = @order_id);

	DECLARE @order_Amt float;
	SET @order_Amt = (SELECT Price FROM dbo.[Orders] WHERE OrderID = @order_id);

	DECLARE @custID INT;
	SET @custID = (SELECT CustomerID from Orders where OrderID = @order_id);

	DECLARE @loc INT;
	DECLARE @pin INT;
	SELECT @loc = CustomerLocationID, @pin = ZipCode From CustomerLocation where CustomerID = @custID;

	IF @order_type = 'Delivery'
		BEGIN

		INSERT INTO dbo.[DeliveryDetails] (DeliveryPersonnelID, OrderID, DeliveryFee, start_time,estimated_time, CustomerLocationID, LocationPincode)
		VALUES(dbo.fn_get_available_delivery_person(), @order_id, dbo.fn_getdelivery_fee(@order_id),GETDATE(),DATEADD(mi,60,GetDate()), @loc, @pin);

		END;
	END;


/*
Store procedure to generate customer bill on order completion
*/
CREATE PROCEDURE [dbo].[sp_Generate_Customer_Bill]
@order_id INT,
@payment_Type varchar(30),
@CardId int = 0

AS
	BEGIN

	DECLARE @customerId VARCHAR(250);
	DECLARE @order_Amt float;
	DECLARE @order_type VARCHAR(50);
	DECLARE @order_Status VARCHAR(30);
	DECLARE @BillId Int;
	SELECT @customerId=CustomerID, @order_Amt=Price, @order_type = OrderType FROM dbo.[Orders] WHERE OrderID = @order_id AND OrderStatus IN ('Completed');


	
			Select @BillId = BillID from Bill where OrderID = @order_id

			IF(@BillId >=1)
			BEGIN
				INSERT INTO Bill (OrderID,CustomerID,CardID,PaymentType,BillTime,BillDate,TotalBillAmount)
				VALUES (@order_id, @customerId,@CardId,@payment_Type, CONVERT(TIME, GETDATE()), GETDATE(), @order_Amt)
			END

			SELECT c.CustomerFName + c.CustomerLName As 'CustomerName',b.PaymentType,o.DiscountAmt,o.Price As 'TotalOrderAmount',
				   b.BillDate
			FROM Customers c INNER JOIN Orders o
			ON c.CustomerID=o.CustomerID
			INNER JOIN Bill b ON o.OrderID = b.OrderID
		
	END;


-- Triggers

/*
Trigger to calculate the total order price on Update of Orders table
*/
CREATE TRIGGER [dbo].[tr_calculate_total_order_price]
ON [dbo].[Orders]
AFTER UPDATE
AS
	BEGIN
		DECLARE @orderId INT;
		DECLARE @orderPrice FLOAT;
--		DECLARE @orderStatus VARCHAR(50);
		SET @orderId = (SELECT OrderId FROM Inserted WHERE OrderStatus IN ('Completed'));

		--IF @orderStatus = 'Completed'
		--BEGIN

		IF @orderId > 0
		BEGIN
			
			SET @orderId = (SELECT @orderId from Inserted);
			SET @orderPrice = (
									SELECT SUM(Price) 
									FROM dbo.OrderItem
									WHERE orderID = @orderId
							   );
			PRINT 'OrderPrice = '+CAST(@orderPrice AS nvarchar(50));

			DECLARE @discount_Amt Int = 0;
			
			SET @discount_Amt = (
								SELECT CustomerDiscount 
								FROM dbo.[customers] c 
								JOIN dbo.[Orders] o on c.CustomerID = o.CustomerID
								WHERE OrderID = @orderId
								);
			PRINT 'OrderPrice = '+CAST(@orderPrice AS nvarchar(50));
			IF @discount_Amt > 0
				BEGIN
				DECLARE @discounted_Order_Price FLOAT;
				SET @discounted_Order_Price = dbo.[fn_apply_discount](@orderPrice, @discount_Amt);
				
				UPDATE dbo.[Orders] SET Price = @orderPrice - @discounted_Order_Price, DiscountAmt = @discounted_Order_Price
				WHERE OrderID = @orderId
				END
			ELSE
				BEGIN
				UPDATE dbo.[Orders] SET Price = @orderPrice, DiscountAmt = 0
				WHERE OrderID = @orderId
				END

			DECLARE @diningTableID VARCHAR(250);
			SET @diningTableID = (SELECT DiningTableID FROM Inserted);

			IF @diningTableID IS NOT NULL
			UPDATE dbo.DiningTable SET isReserved = 0
			WHERE DiningTableID = @diningTableID

			DECLARE @orderType VARCHAR(250);
			SET @orderType = (SELECT OrderType FROM Inserted);

			IF @orderType = 'Delivery'
				BEGIN
				EXEC sp_initiate_delivery @orderId;
				END;
			END;
 	END;

-- Trigger to update price based on quantity and menuItem price
CREATE TRIGGER [dbo].[tr_calculate_orderItem_price]
ON [dbo].[OrderItem]
AFTER INSERT, UPDATE
AS
	BEGIN
		DECLARE @menuItemID INT;
		SET @menuItemID = (SELECT MenuItemID FROM Inserted);	
		DECLARE @menuItemPrice FLOAT;
		SET @menuItemPrice = (SELECT Price FROM MenuItem where MenuItemID = @menuItemID);	

		DECLARE @quantity INT;
		SET @quantity = (SELECT Quantity FROM Inserted);	

		Update OrderItem SET Price = @menuItemPrice*@quantity where OrderItemID = (SELECT OrderItemID from inserted);
	END


-- Trigger to Update Dining table on Reservation
CREATE TRIGGER [dbo].[tr_update_dining_table]
ON [dbo].Reservation
AFTER INSERT
AS
	BEGIN
		DECLARE @diningTableID INT;
		SET @diningTableID = (SELECT DiningTableID FROM Inserted);

		Update DiningTable SET isReserved = 1 where DiningTableID = @diningTableID;
	END


-- Trigger to update Delivery Personnel after order table is updated
CREATE TRIGGER [dbo].[tr_update_delivery_personnel]
ON [dbo].DeliveryDetails
AFTER UPDATE
AS
	BEGIN

		DECLARE @orderId INT;
		SET @orderId = (SELECT OrderID FROM Inserted);

		DECLARE @deliveryPersonalId INT;
		SET @deliveryPersonalId = (SELECT DeliveryPersonnelID FROM Inserted);

		DECLARE @orderStatus INT;
		SET @orderStatus = (SELECT OrderStatus FROM Orders where OrderID = @orderId);

		IF @orderStatus = 'Delivered'
		Update DeliveryPersonal SET Availability = 1 where DeliveryPersonalID = @deliveryPersonalId;
	END

-- Views 
/*
Views to generate weekly report on total sales for each restaurant
*/
CREATE VIEW [WEEKLY TOTAL SALES PER RESTAURANT] AS 
	SELECT r.Name [Restaurant_Name], COUNT(o.OrderID) [No_of_Orders],SUM(o.Price) [Daily_Sales]
	from dbo.Orders o
	INNER JOIN dbo.Restaurant r on o.RestuarantID = r.RestaurantID
	WHERE o.OrderDateTime>=DATEADD(DAY,-7,GETDATE())
	GROUP BY r.Name	
	
/*
Views to generate report for checking monthly spending for each customer
*/
CREATE VIEW [MONTHLY SPENDING PER CUSTOMER] AS 
	SELECT c.CustomerFName [Customer_Name], COUNT(o.OrderID) [No_of_Orders],SUM(o.Price) [Monthly_Spending]
	from dbo.Orders o
	INNER JOIN dbo.Customers c on o.CustomerID = c.CustomerID
	WHERE o.OrderDateTime>=DATEADD(DAY,-30,GETDATE())
	GROUP BY c.CustomerFName

-- Table-level CHECK Constraints based on a function

ALTER TABLE DeliveryDetails with NOCHECK ADD CONSTRAINT 
Check_DeliveryPersonnel_Available_insertion CHECK (dbo.Constraint_Check_Available_DeliveryPersonnel(OrderID,DeliveryPersonnelID)=1);


ALTER TABLE Bill with NOCHECK ADD CONSTRAINT 
Check_Order_Completed CHECK (dbo.Constraint_Check_Order_Completed(OrderID)=1);


--  ******* INSERT *******

INSERT into dbo.Role (RoleTitle,RoleDescription) VALUES 
    ('Restaurant Manager', 'Manages the Restaurant'), 
	('Delivery Personnel', 'Pick up food from a restaurant and deliver to the customer'), 
	('Waiter', 'Greet guests and take orders from customers'), 
	('Chef', 'Plan menus & ensuring that the food meets high-quality standards');

INSERT into dbo.Customers(CustomerDiscount, CustomerFName, CustomerLName, CustomerContact) VALUES
    (20,'John','John','9876543210'),
    (12,'Sandra','Sara','9870654320'),
    (10,'Shikha','Singh','9870654320'),
    (5,'Vikas','Dabhi','9870654320'),
    (8,'Mital','Dudhat','9870654320'),
    (10,'Dhruv','Merchant','9870654320'),
    (4,'Akshay','Yadav','9870654320'),
    (15,'Tara','Singh','9870654320'),
    (8,'Melissa','Acre','9870654320'),
    (12,'Laura','Addice','9870654320');

INSERT dbo.CustomerLocation (CustomerID, StreetAddress, City, State, ZipCode) VALUES
    (1, '12 Babock St', 'Boston', 'massachusetts', 20331),
    (2, '53 Line St', 'Cambridge', 'massachusetts', 20332),
    (3, '67 Hill St', 'Boston', 'massachusetts', 20343),
    (4, '992 Roman St', 'Lowell', 'massachusetts', 22311),
    (5, '293 Beacon St', 'Boston', 'massachusetts', 24322),
    (6, '76 Washington St', 'Boston', 'massachusetts', 24234),
    (7, '433 Hemenway St', 'Everett', 'massachusetts', 20343),
    (8, '96 Roxbury St', 'Boston', 'massachusetts', 20322),
    (9, '334 Jamaica Plains', 'Lowell', 'Arizona', 30293),
    (10, '305 Boylston St', 'Phoenix', 'Arizona', 30256);
    
INSERT into dbo.CardDetails (CustomerID, CustomerFName, CustomerLName, ExpiryDate, VerificationCode) VALUES 
	(1, 'John', 'John', '2027-08-12', 3456),
	(2, 'Sandra', 'Sara', '2028-01-11', 4444),
	(3, 'Shikha', 'Singh', '2026-07-18', 1234),
	(4, 'Vikas', 'Dabhi', '2027-09-09', 8756),
	(5, 'Mital', 'Dudhat', '2025-12-12', 5555),
	(6, 'Dhruv', 'Merchant', '2024-05-23', 6667),
	(7, 'Akshay', 'Yadav', '2030-03-05', 6688),
	(8, 'Tara', 'Singh', '2026-02-01', 9876),
	(9, 'Melissa', 'Acre', '2027-01-15', 3573),
	(10, 'Laura', 'Addice', '2028-07-02', 9090);

INSERT dbo.Restaurant(Name, Street, City, State, ZipCode, RestaurantType, Restaurant_Rating) VALUES
    ('Maharaja', '141 Columbus St', 'Boston', 'Massachusetts', 02215, 'Indian', 4), 
	('Peppinons', '141 Jersey St', 'Boston', 'Massachusetts', 02115, 'Indian', 5), 
	('Naivedhya', '65 Boylston St', 'Cambridge', 'Massachusetts', 03415, 'Indian', 4), 
	('Qdoba', '265 Huntington Ave', 'Lowell', 'Massachusetts', 05675, 'Mexican', 4), 
	('Chipotle', '310 Charge St', 'Everett', 'Massachusetts', 02115, 'Mexican', 5),
    ('Blaze', '23 Park St', 'Boston', 'Massachusetts', 02210, 'American', 5), 
	('MCD', '45 Hemenway St', 'NYC', 'New York', 01211, 'American', 5), 
	('Punjab Masala', '1171 Boylston St', 'Boston', 'Arizona', 05643, 'Indian', 4), 
	('China Main', '86 Birgham St', 'Allston', 'Arizona', 05675, 'Thai', 4), 
	('Agent Jack', '764 Everett St', 'Phoenix', 'Arizona', 05622, 'Thai', 3);

INSERT dbo.ResturantEmployee(RestaurantID, RoleID, FirstName, LastName, Gender, PhoneNo, DOB, Salary, Email, UserName, EncryptedPassword) VALUES
    (1,1, 'Robert', 'Hayden', 'Male', 1234567898, '1972-09-12', 100000, 'robert.hayden@gmail.com', 'robert_h',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'robert@123'))),
    (2,1, 'Harry', 'Smith', 'Male', 3454567898, '1982-09-12', 101000, 'harry.smith1@gmail.com', 'harry_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'harry@123'))),
    (3,1, 'Amanda', 'Cloe', 'Female', 3454567868, '1987-03-05', 110000, 'a.cloe@gmail.com', 'amanda_c',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'amanda@123'))),
    (4,1, 'Brook', 'Dsouza', 'Male', 5656567898, '1990-10-19', 120000, 'brook.dsouza@gmail.com', 'brook_d',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'brook@123'))),
    (1,2, 'Adam', 'Smith', 'Male', 3454567828, '1981-09-12', 40000, 'adam.smith1@gmail.com', 'adam_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'adam@123'))),
    (1,2, 'Joe', 'Root', 'Male', 3451111898, '1992-09-12', 41000, 'joe.root@gmail.com', 'joe_r',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'joe@123'))),
    (2,2, 'Melly', 'Rose', 'Female', 3455555898, '1993-09-12', 42000, 'melly.rose@gmail.com', 'melly_r',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'melly@123'))),
    (2,2, 'Marnus', 'Clarke', 'Male', 3459897898, '1992-05-12', 41000, 'marnus.clarke@gmail.com', 'marnus_c',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'marnus@123'))),
    (3,2, 'Olie', 'Pope', 'Male', 0987654321, '1988-06-22', 40000, 'olie.pope@gmail.com', 'olie_p',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'olie@123'))),
    (3,2, 'Stuart', 'Broad', 'Male', 8888887898, '1993-01-12', 39000, 'stuart.broad@gmail.com', 'stuart_b',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'stuart@123'))),
    (4,2, 'Jimmy', 'Smith', 'Male', 3333567898, '1988-10-07', 40000, 'jimmy.smith11@gmail.com', 'jimmy_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'jimmy@123'))),
    (4,2, 'Brett', 'Lee', 'Male', 1111111111, '1989-12-12', 41000, 'brett.lee1@gmail.com', 'brett_l',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'brett@123'))),
    (1,3, 'Brad', 'Hogg', 'Male', 7777767898, '1992-05-22', 43000, 'brad.hogg@gmail.com', 'brad_h',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'brad@123'))),
    (1,3, 'Andrew', 'Symonds', 'Male', 2345678987, '1989-01-04', 45000, 'andrew.symonds@gmail.com', 'andrew_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'andrew@123'))),
    (2,3, 'Michael', 'Weber', 'Male', 2222227898, '1995-04-30', 42000, 'michael.weber@gmail.com', 'michael_w',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'michael@123'))),
    (3,3, 'Elly', 'Laura', 'Female', 4567456745, '1990-04-12', 50000, 'elly.laura@gmail.com', 'elly_l',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'elly@123'))),
    (4,3, 'Mike', 'Dsouza', 'Male', 1112223898, '1985-10-01', 43000, 'mike.dsouza@gmail.com', 'mike_d',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'mike@123'))),
    (1,4, 'Hardy', 'Sandhu', 'Male', 4576876543, '1980-05-19', 60000, 'hardy.sandhu@gmail.com', 'hardy_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'hardy@123'))),
    (2,4, 'Swini', 'Dsouza', 'Female', 5555567898, '1994-03-12', 62000, 'swini.dsouza@gmail.com', 'swini_d',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'swini@123'))),
    (3,4, 'Basu', 'Lewis', 'Male', 1432789650, '1988-03-02', 59000, 'basu.lewis@gmail.com', 'basu_l',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'basu@123'))),
    (4,4, 'Joey', 'Suit', 'Male', 9999999988, '1995-10-01', 60000, 'joey.suit@gmail.com', 'joey_s',EncryptByKey(Key_GUID(N'RestaurantMgmtSymmetricKey'), CONVERT(VARBINARY, 'joey@123')));

INSERT into dbo.DiningTable (Size, isReserved) VALUES
	(3, '0'),
	(5, '0'),
	(7, '0'),
	(2, '0'),
	(2, '0'),
	(8, '0'),
	(10, '0'),
	(2, '0'),
	(4, '0'),
	(6, '0');

INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (3, 7, 'ShikhaSingh','13:30', '2022-12-12', 10);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (4, 1, 'VikasDabhi','20:30', '2022-12-15', 3);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (1, 3, 'JohnJohn','20:00', '2022-12-16', 7);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (2, 5, 'SandraSara','12:30', '2022-12-20', 2);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (5, 9, 'MitalDudhat','19:30', '2022-12-31', 4);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (6, 2, 'DhruvMerchant','19:30', '2023-01-01', 5);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (9, 4, 'MelissaAcre','21:30', '2022-12-23', 2);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (8, 6, 'TaraSingh','14:00', '2022-12-25', 8);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (10, 8, 'LauraAddice','20:30', '2023-01-02', 2);
INSERT into dbo.Reservation (CustomerID, DiningTableID, CustomerName, ReservationTime, ReservationDate, NumberOfSeats) VALUES (7, 10, 'AkshayYadav','19:30', '2023-01-03', 6);

	SELECT * from Reservation;
	SELECT * FROM DiningTable;

INSERT dbo.DeliveryPersonal (RestuarantID, Availability, FirstName, LastName ) VALUES
    (1, 1, 'Harry', 'Smith'),
    (1, 1, 'Joe', 'Root'),
    (2, 1, 'Melly', 'Rose'),
    (2, 1, 'Marnus', 'Clarke'),
    (3, 1, 'Olie', 'Pope'),
    (3, 1, 'Stuart', 'Broad'),
    (4, 1, 'Jimmy', 'Smith'),
    (4, 1, 'Brett', 'Lee');

INSERT dbo.Menu(ResturantID) VALUES
	(1), (2), (3), (4), (5);

INSERT dbo.MenuGroup(MenuID, Name) VALUES
	(5, 'Breakfast'), 
	(5, 'Pizzas'), 
	(3, 'Rice'),
	(4, 'Burgers'), 
	(4, 'Daal');

INSERT dbo.MenuItem(MenuGroupID, Name, Description, Price, ItemImage ) VALUES
	(3, 'Biryani', 'Chicken Biryani', 15.99, 'biryani.png' ),
	(3, 'Pulav', 'Vegeraterian Pulav', 10.99, 'pulav.png' ),
	(3, 'Masala Rice', 'Rice filled with indian spices', 12.99, 'masalarice.png' ),
	(4, 'Jalepeno Pizza', 'Jalapeno spread on pizza with veggies', 9.90, 'jalepeno.png' ),
	(4, 'Cheese Pizza', 'Cheese burst pizza with extra cheese', 9.49, 'cheese.png' ),
	(4, 'Onion Pizza', 'Onion cut and spread on pizza base with sauces', 7.49, 'onion.png' ),
	(5, 'Sandwitch', 'Vegeterian Sandwitch filled with sauces', 5.49, 'sandwitch.png' ),
	(5, 'Bacon', 'Salt-cured pork made from various cuts', 8.99, 'bacon.png' ),
	(5, 'Salad', 'Plant Salads', 6.50, 'salad.png' );

/*
INSERT query for DINE-IN orders
*/
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (1,1,1,convert(datetime, '2022-11-10 07:51:04 PM', 121),'Pending',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (2,2,2,convert(datetime, '2022-11-15 11:46:57 AM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (2,1,3,convert(datetime, '2022-11-21 04:33:44 PM', 121),'Pending',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (3,5,4,convert(datetime, '2022-11-24 02:41:44 PM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (7,8,5,convert(datetime, '2022-11-26 06:58:44 PM', 121),'Pending',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (9,3,6,convert(datetime, '2022-11-28 05:15:44 PM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (6,10,7,convert(datetime, '2022-11-29 01:23:44 PM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (8,4,8,convert(datetime, '2022-11-30 07:26:53 PM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (4,6,9,convert(datetime, '2022-11-30 08:11:00 PM', 121),'Preparing',0.00,'Dining',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,DiningTableID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (5,7,10,convert(datetime, '2022-11-30 09:07:14 PM', 121),'Pending',0.00,'Dining',0.00);

/*
INSERT query for DINE-IN order items
*/

INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (1,2,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (1,3,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (2,4,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (3,5,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (4,6,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (4,7,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (4,8,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (5,4,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (6,3,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (6,1,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (6,2,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (5,1,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (6,8,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (7,9,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (8,9,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (9,8,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (10,6,3, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (10,4,2, 0.00);

/*
INSERT query for ONLINE orders
*/
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (1,7,convert(datetime, '2022-11-10 07:51:04 PM', 121),'Preparing',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (8,2,convert(datetime, '2022-11-15 11:46:57 AM', 121),'Preparing',0.00,'Pickup',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (5,9,convert(datetime, '2022-11-21 04:33:44 PM', 121),'Pending',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (10,5,convert(datetime, '2022-11-24 02:41:44 PM', 121),'Ready for Delivery',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (2,8,convert(datetime, '2022-11-26 06:58:44 PM', 121),'Pending',0.00,'Pickup',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (4,4,convert(datetime, '2022-11-28 05:15:44 PM', 121),'Ready for Delivery',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (6,3,convert(datetime, '2022-11-29 01:23:44 PM', 121),'Pending',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (8,1,convert(datetime, '2022-11-30 11:26:53 AM', 121),'Ready for Delivery',0.00,'Pickup',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (4,9,convert(datetime, '2022-11-30 09:01:10 PM', 121),'Preparing',0.00,'Delivery',0.00);
INSERT INTO dbo.Orders (CustomerID,RestuarantID,OrderDateTime,OrderStatus,Price,OrderType,DiscountAmt) VALUES (3,10,convert(datetime, '2022-11-30 09:17:14 PM', 121),'Pending',0.00,'Pickup',0.00);
GO

/*
INSERT query for ONLINE order items
*/
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (11,1,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (17,1,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (17,5,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (12,6,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (13,6,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (14,1,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (14,7,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (15,8,4, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (18,1,4, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (18,8,1, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (16,4,5, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (17,6,3, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (19,1,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (18,3,2, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (20,4,3, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (20,7,3, 0.00);
INSERT INTO dbo.OrderItem (OrderID, MenuItemID, Quantity, Price) VALUES (16,9,1, 0.00);

INSERT INTO dbo.Feedback(RestaurantID, CustomerID, TimelyDelivery, Quality, Quantity, CustomerSatisfaction) VALUES
	(2,1,4,4,5,4),
	(1,2,5,3,4,4),
	(3,3,4,4,3,4),
	(4,4,3,5,5,4),
	(5,5,4,4,4,4),
	(6,6,3,5,5,4),
	(7,7,5,5,5,5),
	(8,8,3,3,3,3),
	(9,9,4,5,5,5),
	(10,10,3,3,4,4);

SELECT * from DeliveryDetails;
SELECT * from Orders;
Update Orders SET OrderStatus = 'Completed' where OrderID = 11 ;
Update Orders SET OrderStatus = 'Pending' where OrderID = 11 ;

SELECT SUM(Price) FROM dbo.OrderItem WHERE orderID = 1;
SELECT * FROM MenuItem;
SELECT * FROM OrderItem;

INSERT dbo.DeliveryDetails(DeliveryPersonnelID, OrderID, CustomerLocationID, DeliveryFee, LocationPincode, start_time, end_time , estimated_time) VALUES
   (1, 1, 1, 3.03, 20331, '2022-11-01 10:38:23', '2022-11-01 10:49:10', '2022-11-01 10:48:00'),
   (1, 2, 2, 2.1, 20332, '2022-10-31 09:20:45', '2022-10-31 09:40:05', '2022-10-31 09:40:00'),
   (2, 3, 3, 2.8, 20331, '2022-10-28 18:02:33', '2022-10-28 18:25:34', '2022-10-28 18:30:00'),
   (3, 4, 4, 3.22, 20343, '2022-11-28 15:20:57', '2022-11-28 15:49:37', '2022-11-28 15:50:00'),
   (4, 5, 5, 4.2, 30256, '2022-11-02 20:00:23', '2022-11-02 20:32:40', '2022-11-02 20:30:00'),
   (5, 6, 6, 2.1, 22311, '2022-11-03 11:38:22', '2022-11-03 11:58:12', '2022-11-03 12:00:00'),
   (6, 7, 7, 2.34, 20343, '2022-10-25 22:19:20', '2022-10-25 22:39:24', '2022-10-25 22:40:00'),
   (6, 8, 8, 3.44, 30293, '2022-11-05 12:45:00', '2022-11-05 13:03:00', '2022-11-05 13:00:00'),
   (7, 9, 9, 3.44, 30293, '2022-11-04 13:54:20', '2022-11-04 14:05:32', '2022-11-04 14:10:00'),
   (8, 10, 10, 2.34, 20343, '2022-11-04 09:00:54', '2022-11-04 09:04:50', '2022-11-04 09:05:00');

INSERT INTO dbo.Bill(OrderID, CustomerID, CardID, PaymentType, BillTime, BillDate, TotalBillAmount) VALUES
	(1, 1, 1, 'Cash', '21:59:59', '2022-11-17', 100.05),
	(2, 2, 2, 'Card', '17:49:09', '2022-11-17', 80.05),
	(3, 3, 3, 'Card', '13:49:19', '2022-11-16', 121.55),
	(4, 4, 4, 'Card', '16:05:19', '2022-11-16', 50.15),
	(5, 5, 5, 'Card', '18:45:39', '2022-11-17', 121.05),
	(6, 6, 6, 'Card', '20:15:19', '2022-11-17', 321.05),
	(7, 7, 7, 'Card', '21:39:49', '2022-11-15', 200.65),
	(8, 8, 8, 'Card', '19:34:23', '2022-11-15', 300.75),
	(9, 9, 9, 'Card', '22:15:39', '2022-11-15', 220.65),
	(10, 10, 10, 'Card', '22:01:19', '2022-11-15', 360.95);


--  ******* INDEX ********
CREATE INDEX role_index ON dbo.[Role](RoleID);
CREATE INDEX cust_index ON dbo.[Customers](CustomerID);
CREATE INDEX rest_index ON dbo.[Restaurant](RestaurantID);
CREATE INDEX order_index ON dbo.[Orders](OrderID);
CREATE INDEX dining_index ON dbo.[DiningTable](DiningTableID);
CREATE INDEX delpers_index ON dbo.[DeliveryPersonal](DeliveryPersonalID);
CREATE INDEX deldetails_index ON dbo.[DeliveryDetails](DeliveryID);
CREATE INDEX custloc_index ON dbo.[CustomerLocation](CustomerLocationID);
CREATE INDEX menugroup_index ON dbo.[MenuGroup](MenuGroupID);
CREATE INDEX menu_index ON dbo.[Menu](MenuID);
CREATE INDEX feedback_index ON dbo.[Feedback](FeedbackID);
CREATE INDEX menuitem_index ON dbo.[MenuItem](MenuItemID);
CREATE INDEX restemp_index ON dbo.[ResturantEmployee](EmployeeID);
CREATE INDEX carddet_index ON dbo.[CardDetails](CardID);
CREATE INDEX reservation_index ON dbo.[Reservation](ReservationID);
CREATE INDEX orderitem_index ON dbo.[OrderItem](OrderItemID);
CREATE INDEX bill_index ON dbo.[Bill](BillID);


/*
This will show Binary values for Encrypted Passwords
*/
SELECT userName, DECRYPTBYKEY(EncryptedPassword) from ResturantEmployee;

/*
This will show actual values for Encrypted Passwords
*/
SELECT username, convert(varchar, DecryptByKey(EncryptedPAssword)) from ResturantEmployee;

SELECT * FROM dbo.[MONTHLY SPENDING PER CUSTOMER] Order by [No_of_Orders] DESC;

SELECT * FROM dbo.[WEEKLY TOTAL SALES PER RESTAURANT] Order by [No_of_Orders] DESC;

EXEC sp_Generate_Customer_Bill 

EXEC sp_initiate_delivery

-- *******  HOUSEKEEPING *******
--   DROP TABLES

Close Symmetric KEY RestaurantMgmtSymmetricKey;

DROP Symmetric KEY RestaurantMgmtSymmetricKey;

DROP CERTIFICATE TestCertificate;

-- 1. Role
DROP TABLE ROLE;

-- 2. Table
DROP TABLE DiningTable;

-- 3. Restaurant
DROP TABLE Restaurant;

-- 4. Customers
DROP TABLE Customers;

-- 5. Menu
DROP Table Menu;

-- 6. MenuGroup
DROP Table MenuGroup;

-- 7. MenuItem
DROP Table MenuItem;

-- 8. RestaurantEmployee
DROP Table ResturantEmployee;

--9. DeliveryPersonal
DROP Table DeliveryPersonal;

--10. Orders
DROP Table Orders;

--11. OrderItem
DROP Table OrderItem;

--12. CardDetails
DROP Table CardDetails;

--13. Bill
DROP Table Bill;

--14. Customer Location
DROP Table CustomerLocation;

--15. Reservation
DROP Table Reservation;

--16. Delivery Details
DROP Table DeliveryDetails;

--17. Feedback
DROP Table Feedback;

--  DROP INDEX

--  DROP DATABASE 
USE master;

DROP DATABASE Restaurant_Project ;

DROP TRIGGER [tr_calculate_total_order_price];
DROP FUNCTION [fn_apply_discount];
DROP PROCEDURE [sp_initiate_delivery];
Drop Procedure [sp_Generate_Customer_Bill];
EXEC [sp_Generate_Customer_Bill] 11, 'CASH',1;


