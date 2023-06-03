-- Membuat Database DWH_Project
CREATE DATABASE DWH_Project

-- Membuat tabel DimCustomer
CREATE TABLE DimCustomer(
    CustomerID int NOT NULL,
	CustomerName varchar(50) NOT NULL,
    Age int NOT NULL,
	Gender varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	NoHP varchar(50) NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID)
)

-- Membuat tabel DimProduct
CREATE TABLE DimProduct(
    ProductID int NOT NULL,
    ProductName varchar(255) NOT NULL,
    ProductCategory varchar(255) NOT NULL,
    ProductUnitPrice int NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY (ProductID)
)

-- Membuat tabel DimStatusOrder
CREATE TABLE DimStatusOrder(
    StatusID int NOT NULL,
	StatusOrder varchar(50) NOT NULL,
    StatusOrderDesc varchar(50) NOT NULL,
    CONSTRAINT PK_StatusOrder PRIMARY KEY (StatusID)
)

-- Membuat tabel FactSalesOrder
CREATE TABLE FactSalesOrder(
    OrderID int NOT NULL,
	CustomerID int NOT NULL,
    ProductID int NOT NULL,
    Quantity int NOT NULL,
	Amount int NOT NULL,
	StatusID int NOT NULL,
	OrderDate date NOT NULL
    CONSTRAINT PK_SalesOrder PRIMARY KEY (OrderID),
	CONSTRAINT FK_Customer FOREIGN KEY (CustomerID)
	REFERENCES DimCustomer (CustomerID),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID)
	REFERENCES DimProduct (ProductID),
	CONSTRAINT FK_StatusOrder FOREIGN KEY (StatusID)
	REFERENCES DimStatusOrder (StatusID)
)

-- Membuat Store Procedure
CREATE PROCEDURE summary_order_status
    @StatusID int
AS
BEGIN
    SELECT 
		a.OrderID, 
		b.CustomerName, 
		c.ProductName, 
		a.Quantity, 
		d.StatusOrder
    FROM FactSalesOrder a
    INNER JOIN DimCustomer b ON a.CustomerID = b.CustomerID
    INNER JOIN DimProduct c ON a.ProductID = c.ProductID
    INNER JOIN DimStatusOrder d ON a.StatusID = d.StatusID
    WHERE d.StatusID = @StatusID
END

-- Awaiting Shipment/Menunggu Pembayaran
EXEC summary_order_status @StatusID = 1

-- Awaiting Shipment/Menunggu Pembayaran
EXEC summary_order_status @StatusID = 2

-- Shipped/Sedang Dikirim
EXEC summary_order_status @StatusID = 3

-- Completed/Pesanan Sampai Tujuan
EXEC summary_order_status @StatusID = 4

-- Cancelled/Pesanan dibatalkan oleh customer
EXEC summary_order_status @StatusID = 5