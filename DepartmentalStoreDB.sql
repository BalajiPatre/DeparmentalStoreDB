
CREATE DATABASE DepartmentalStoreDB;
GO

USE DepartmentalStoreDB;
GO


USE DepartmentalStoreDB;
GO

-- 1. Stores
CREATE TABLE Stores
(
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    StoreCode VARCHAR(20) UNIQUE NOT NULL,
    City VARCHAR(50),
    State VARCHAR(50),
    Address VARCHAR(250),
    Phone VARCHAR(15),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. Departments
CREATE TABLE Departments
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Description VARCHAR(250)
);
GO

-- 3. Categories
CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,

    CONSTRAINT FK_Categories_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
GO

CREATE TABLE Suppliers
(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(150) NOT NULL,
    ContactPerson VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(250),
    City VARCHAR(50),
    State VARCHAR(50),
    GSTNumber VARCHAR(20) UNIQUE,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Products
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    PurchasePrice DECIMAL(10,2) NOT NULL,
    SellingPrice DECIMAL(10,2) NOT NULL,
    Unit VARCHAR(20),
    Barcode VARCHAR(50) UNIQUE,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID),

    CONSTRAINT FK_Products_Suppliers
    FOREIGN KEY (SupplierID)
    REFERENCES Suppliers(SupplierID),

    CONSTRAINT CK_Products_PurchasePrice
    CHECK (PurchasePrice >= 0),

    CONSTRAINT CK_Products_SellingPrice
    CHECK (SellingPrice >= 0)
);
GO

CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Gender VARCHAR(10),
    DateOfBirth DATE,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,

    CONSTRAINT CK_Customers_Gender
    CHECK (Gender IN ('Male', 'Female', 'Other'))
);

CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    JobTitle VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,

    CONSTRAINT FK_Employees_Stores
    FOREIGN KEY (StoreID)
    REFERENCES Stores(StoreID),

    CONSTRAINT CK_Employees_Salary
    CHECK (Salary >= 0)
);

CREATE TABLE Sales
(
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    CustomerID INT NULL,
    EmployeeID INT NOT NULL,
    InvoiceNumber VARCHAR(50) UNIQUE NOT NULL,
    SaleDate DATETIME DEFAULT GETDATE(),
    SubTotal DECIMAL(12,2) NOT NULL,
    DiscountAmount DECIMAL(12,2) DEFAULT 0,
    TaxAmount DECIMAL(12,2) DEFAULT 0,
    GrandTotal DECIMAL(12,2) NOT NULL,
    SaleStatus VARCHAR(20) DEFAULT 'Completed',

    CONSTRAINT FK_Sales_Stores
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),

    CONSTRAINT FK_Sales_Customers
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),

    CONSTRAINT FK_Sales_Employees
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),

    CONSTRAINT CK_Sales_SubTotal
    CHECK (SubTotal >= 0),

    CONSTRAINT CK_Sales_Discount
    CHECK (DiscountAmount >= 0),

    CONSTRAINT CK_Sales_Tax
    CHECK (TaxAmount >= 0),

    CONSTRAINT CK_Sales_GrandTotal
    CHECK (GrandTotal >= 0),

    CONSTRAINT CK_Sales_Status
    CHECK (SaleStatus IN ('Completed', 'Pending', 'Cancelled'))
);

CREATE TABLE SaleDetails
(
    SaleDetailID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    TaxAmount DECIMAL(10,2) DEFAULT 0,
    LineTotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_SaleDetails_Sales
    FOREIGN KEY (SaleID)
    REFERENCES Sales(SaleID),

    CONSTRAINT FK_SaleDetails_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT CK_SaleDetails_Quantity
    CHECK (Quantity > 0),

    CONSTRAINT CK_SaleDetails_UnitPrice
    CHECK (UnitPrice >= 0),

    CONSTRAINT CK_SaleDetails_Discount
    CHECK (DiscountAmount >= 0),

    CONSTRAINT CK_SaleDetails_Tax
    CHECK (TaxAmount >= 0),

    CONSTRAINT CK_SaleDetails_LineTotal
    CHECK (LineTotal >= 0)
);

CREATE TABLE Purchases
(
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    SupplierID INT NOT NULL,
    EmployeeID INT NOT NULL,
    PurchaseNumber VARCHAR(50) UNIQUE NOT NULL,
    PurchaseDate DATETIME DEFAULT GETDATE(),
    SubTotal DECIMAL(12,2) NOT NULL,
    TaxAmount DECIMAL(12,2) DEFAULT 0,
    DiscountAmount DECIMAL(12,2) DEFAULT 0,
    GrandTotal DECIMAL(12,2) NOT NULL,
    PurchaseStatus VARCHAR(20) DEFAULT 'Received',

    CONSTRAINT FK_Purchases_Stores
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),

    CONSTRAINT FK_Purchases_Suppliers
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),

    CONSTRAINT FK_Purchases_Employees
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),

    CONSTRAINT CK_Purchases_SubTotal
    CHECK (SubTotal >= 0),

    CONSTRAINT CK_Purchases_Tax
    CHECK (TaxAmount >= 0),

    CONSTRAINT CK_Purchases_Discount
    CHECK (DiscountAmount >= 0),

    CONSTRAINT CK_Purchases_GrandTotal
    CHECK (GrandTotal >= 0),

    CONSTRAINT CK_Purchases_Status
    CHECK (PurchaseStatus IN ('Pending', 'Received', 'Cancelled'))
);

CREATE TABLE PurchaseDetails
(
    PurchaseDetailID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    TaxAmount DECIMAL(10,2) DEFAULT 0,
    LineTotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_PurchaseDetails_Purchases
    FOREIGN KEY (PurchaseID)
    REFERENCES Purchases(PurchaseID),

    CONSTRAINT FK_PurchaseDetails_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT CK_PurchaseDetails_Quantity
    CHECK (Quantity > 0),

    CONSTRAINT CK_PurchaseDetails_UnitCost
    CHECK (UnitCost >= 0),

    CONSTRAINT CK_PurchaseDetails_Discount
    CHECK (DiscountAmount >= 0),

    CONSTRAINT CK_PurchaseDetails_Tax
    CHECK (TaxAmount >= 0),

    CONSTRAINT CK_PurchaseDetails_LineTotal
    CHECK (LineTotal >= 0)
);

CREATE TABLE Payments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod VARCHAR(30) NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    TransactionReference VARCHAR(100),
    PaymentStatus VARCHAR(20) DEFAULT 'Completed',

    CONSTRAINT FK_Payments_Sales
    FOREIGN KEY (SaleID)
    REFERENCES Sales(SaleID),

    CONSTRAINT CK_Payments_Method
    CHECK (PaymentMethod IN
    ('Cash', 'Credit Card', 'Debit Card',
     'UPI', 'Net Banking', 'Gift Card')),

    CONSTRAINT CK_Payments_Amount
    CHECK (Amount > 0),

    CONSTRAINT CK_Payments_Status
    CHECK (PaymentStatus IN
    ('Pending', 'Completed', 'Failed', 'Refunded'))
);

CREATE TABLE Inventory
(
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantityInStock INT DEFAULT 0,
    ReorderLevel INT DEFAULT 10,
    LastUpdated DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Inventory_Stores
    FOREIGN KEY (StoreID)
    REFERENCES Stores(StoreID),

    CONSTRAINT FK_Inventory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT UQ_Inventory_Store_Product
    UNIQUE (StoreID, ProductID),

    CONSTRAINT CK_Inventory_Quantity
    CHECK (QuantityInStock >= 0),

    CONSTRAINT CK_Inventory_Reorder
    CHECK (ReorderLevel >= 0)
);

CREATE TABLE StockTransactions
(
    StockTransactionID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    TransactionType VARCHAR(30) NOT NULL,
    Quantity INT NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    ReferenceNumber VARCHAR(50),
    Remarks VARCHAR(250),

    CONSTRAINT FK_StockTransactions_Stores
    FOREIGN KEY (StoreID)
    REFERENCES Stores(StoreID),

    CONSTRAINT FK_StockTransactions_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT CK_StockTransactions_Type
    CHECK (TransactionType IN
    ('Purchase', 'Sale', 'Return',
     'Damage', 'Adjustment')),

    CONSTRAINT CK_StockTransactions_Quantity
    CHECK (Quantity > 0)
);

CREATE TABLE Returns
(
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Quantity INT NOT NULL,
    ReturnDate DATETIME DEFAULT GETDATE(),
    ReturnReason VARCHAR(250),
    RefundAmount DECIMAL(12,2) DEFAULT 0,
    ReturnStatus VARCHAR(20) DEFAULT 'Pending',

    CONSTRAINT FK_Returns_Sales
    FOREIGN KEY (SaleID)
    REFERENCES Sales(SaleID),

    CONSTRAINT FK_Returns_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT FK_Returns_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID),

    CONSTRAINT CK_Returns_Quantity
    CHECK (Quantity > 0),

    CONSTRAINT CK_Returns_RefundAmount
    CHECK (RefundAmount >= 0),

    CONSTRAINT CK_Returns_Status
    CHECK (ReturnStatus IN
    ('Pending', 'Approved', 'Rejected', 'Completed'))
);

CREATE TABLE Discounts
(
    DiscountID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NULL,
    DiscountName VARCHAR(100) NOT NULL,
    DiscountType VARCHAR(20) NOT NULL,
    DiscountValue DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Discounts_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),

    CONSTRAINT CK_Discounts_Type
    CHECK (DiscountType IN ('Percentage', 'Fixed')),

    CONSTRAINT CK_Discounts_Value
    CHECK (DiscountValue > 0),

    CONSTRAINT CK_Discounts_Dates
    CHECK (EndDate >= StartDate),

    CONSTRAINT CK_Discounts_Percentage
    CHECK (DiscountType <> 'Percentage'
           OR DiscountValue <= 100)
);




INSERT INTO Stores
(StoreName, StoreCode, City, State, Address, Phone)
VALUES
('Pune Central Store', 'PUN001', 'Pune', 'Maharashtra', 'FC Road, Pune', '9876543210'),
('Mumbai Central Store', 'MUM001', 'Mumbai', 'Maharashtra', 'Andheri, Mumbai', '9876543211'),
('Nashik Central Store', 'NAS001', 'Nashik', 'Maharashtra', 'College Road, Nashik', '9876543212'),
('Nagpur Central Store', 'NAG001', 'Nagpur', 'Maharashtra', 'Dharampeth, Nagpur', '9876543213'),
('Thane Central Store', 'THA001', 'Thane', 'Maharashtra', 'Ghodbunder Road, Thane', '9876543214'),
('Kolhapur Central Store', 'KOL001', 'Kolhapur', 'Maharashtra', 'Rajarampuri, Kolhapur', '9876543215'),
('Aurangabad Central Store', 'AUR001', 'Chhatrapati Sambhajinagar', 'Maharashtra', 'CIDCO, Aurangabad', '9876543216'),
('Bangalore Central Store', 'BLR001', 'Bangalore', 'Karnataka', 'Whitefield, Bangalore', '9876543217'),
('Hyderabad Central Store', 'HYD001', 'Hyderabad', 'Telangana', 'Madhapur, Hyderabad', '9876543218'),
('Delhi Central Store', 'DEL001', 'New Delhi', 'Delhi', 'Karol Bagh, Delhi', '9876543219');
GO

-- Verify inserted records
SELECT * FROM Stores;

-- Verify total records
SELECT COUNT(*) AS TotalStores FROM Stores;
GO

INSERT INTO Departments
(DepartmentName, Description)
VALUES
('Grocery', 'Daily grocery and food essentials'),
('Dairy', 'Milk, cheese, butter and dairy products'),
('Beverages', 'Juices, soft drinks, tea and coffee'),
('Personal Care', 'Personal hygiene and beauty products'),
('Household', 'Cleaning and household essentials'),
('Electronics', 'Electronic products and accessories'),
('Clothing', 'Men, women and kids clothing'),
('Bakery', 'Bread, cakes and bakery products'),
('Frozen Foods', 'Frozen vegetables and ready-to-eat foods'),
('Stationery', 'Books, pens and office supplies');
GO

-- Display all departments
SELECT * FROM Departments;

-- Count total departments
SELECT COUNT(*) AS TotalDepartments
FROM Departments;
GO

SELECT
    DepartmentID,
    DepartmentName
FROM Departments
ORDER BY DepartmentID;
GO


INSERT INTO Categories
(CategoryName, DepartmentID)
VALUES
-- Grocery
('Rice and Grains', 1),
('Pulses and Lentils', 1),

-- Dairy
('Milk and Cream', 2),
('Cheese and Butter', 2),

-- Beverages
('Soft Drinks', 3),
('Tea and Coffee', 3),

-- Personal Care
('Skin Care', 4),
('Hair Care', 4),

-- Household
('Cleaning Products', 5),
('Kitchen Essentials', 5),

-- Electronics
('Mobile Accessories', 6),
('Home Appliances', 6),

-- Clothing
('Mens Wear', 7),
('Womens Wear', 7),

-- Bakery
('Bread and Buns', 8),
('Cakes and Pastries', 8),

-- Frozen Foods
('Frozen Vegetables', 9),
('Frozen Snacks', 9),

-- Stationery
('Writing Supplies', 10),
('Notebooks and Paper', 10);
GO

-- Display categories with department names
SELECT
    C.CategoryID,
    C.CategoryName,
    D.DepartmentName
FROM Categories C
INNER JOIN Departments D
    ON C.DepartmentID = D.DepartmentID
ORDER BY C.CategoryID;
GO

-- Count categories
SELECT COUNT(*) AS TotalCategories
FROM Categories;
GO

INSERT INTO Suppliers
(SupplierName, ContactPerson, Email, Phone, Address, City, State, GSTNumber)
VALUES
('Fresh Farm Foods', 'Amit Shah', 'amit@freshfarm.com', '9811000001', 'Market Yard', 'Pune', 'Maharashtra', '27ABCDE1234F1Z1'),
('Shree Grocery Traders', 'Rajesh Patil', 'rajesh@shreegrocery.com', '9811000002', 'APMC Market', 'Mumbai', 'Maharashtra', '27ABCDE1235F1Z2'),
('Golden Rice Suppliers', 'Vijay Kumar', 'vijay@goldenrice.com', '9811000003', 'Main Road', 'Nashik', 'Maharashtra', '27ABCDE1236F1Z3'),
('Pure Dairy Products', 'Suresh More', 'suresh@puredairy.com', '9811000004', 'Industrial Area', 'Pune', 'Maharashtra', '27ABCDE1237F1Z4'),
('Amul Distribution Partner', 'Kiran Joshi', 'kiran@amuldist.com', '9811000005', 'Station Road', 'Mumbai', 'Maharashtra', '27ABCDE1238F1Z5'),
('Cool Drinks Wholesale', 'Manoj Reddy', 'manoj@cooldrinks.com', '9811000006', 'Central Market', 'Hyderabad', 'Telangana', '36ABCDE1239F1Z6'),
('Beverage World', 'Anil Sharma', 'anil@bevworld.com', '9811000007', 'MG Road', 'Bangalore', 'Karnataka', '29ABCDE1240F1Z7'),
('Beauty Care Distributors', 'Pooja Singh', 'pooja@beautycare.com', '9811000008', 'Link Road', 'Mumbai', 'Maharashtra', '27ABCDE1241F1Z8'),
('Cosmetic Hub', 'Neha Jain', 'neha@cosmetichub.com', '9811000009', 'FC Road', 'Pune', 'Maharashtra', '27ABCDE1242F1Z9'),
('Home Cleaning Supplies', 'Rohit Verma', 'rohit@homeclean.com', '9811000010', 'Industrial Estate', 'Nagpur', 'Maharashtra', '27ABCDE1243F1Z0'),
('Kitchen World', 'Deepak Rao', 'deepak@kitchenworld.com', '9811000011', 'Market Street', 'Thane', 'Maharashtra', '27ABCDE1244F1Z1'),
('Tech Electronics', 'Arun Mehta', 'arun@techelectronics.com', '9811000012', 'Electronics Market', 'Delhi', 'Delhi', '07ABCDE1245F1Z2'),
('Digital Accessories', 'Rahul Gupta', 'rahul@digitalacc.com', '9811000013', 'Commercial Street', 'Bangalore', 'Karnataka', '29ABCDE1246F1Z3'),
('Fashion Garments', 'Priya Desai', 'priya@fashiongarments.com', '9811000014', 'Textile Market', 'Mumbai', 'Maharashtra', '27ABCDE1247F1Z4'),
('Style Clothing House', 'Sneha Kulkarni', 'sneha@styleclothing.com', '9811000015', 'Camp Area', 'Pune', 'Maharashtra', '27ABCDE1248F1Z5'),
('Daily Bakery Suppliers', 'Nitin Pawar', 'nitin@dailybakery.com', '9811000016', 'Bakery Street', 'Pune', 'Maharashtra', '27ABCDE1249F1Z6'),
('Sweet Treat Foods', 'Ramesh Iyer', 'ramesh@sweettreat.com', '9811000017', 'Market Road', 'Chennai', 'Tamil Nadu', '33ABCDE1250F1Z7'),
('Frozen Food Traders', 'Sanjay Rao', 'sanjay@frozenfoods.com', '9811000018', 'Cold Storage Area', 'Mumbai', 'Maharashtra', '27ABCDE1251F1Z8'),
('Office Stationery Hub', 'Meera Shah', 'meera@officehub.com', '9811000019', 'Stationery Market', 'Delhi', 'Delhi', '07ABCDE1252F1Z9'),
('National Paper Suppliers', 'Ajay Kumar', 'ajay@nationalpaper.com', '9811000020', 'Industrial Area', 'Nagpur', 'Maharashtra', '27ABCDE1253F1Z0');
GO

-- Display all suppliers
SELECT * FROM Suppliers;

-- Count suppliers
SELECT COUNT(*) AS TotalSuppliers
FROM Suppliers;
GO



USE DepartmentalStoreDB;
GO

;WITH ProductData AS
(
    SELECT
        C.CategoryID,
        C.CategoryName,
        C.DepartmentID,
        V.VariantName,
        V.Unit,
        V.BasePurchase,
        V.BaseSelling,
        ROW_NUMBER() OVER
        (ORDER BY C.CategoryID, V.VariantNo) AS RowNum
    FROM Categories C
    CROSS JOIN
    (
        VALUES
        (1, 'Standard', 'Pack', 50.00, 65.00),
        (2, 'Premium', 'Pack', 100.00, 130.00),
        (3, 'Family', 'Pack', 150.00, 190.00),
        (4, 'Economy', 'Pack', 75.00, 95.00),
        (5, 'Value', 'Pack', 200.00, 250.00)
    ) V(VariantNo, VariantName, Unit, BasePurchase, BaseSelling)
)
INSERT INTO Products
(
    ProductName,
    SKU,
    CategoryID,
    SupplierID,
    PurchasePrice,
    SellingPrice,
    Unit,
    Barcode
)
SELECT
    CategoryName + ' - ' + VariantName,
    'SKU' + RIGHT('0000' + CAST(RowNum AS VARCHAR(4)), 4),
    CategoryID,
    CategoryID,
    BasePurchase + (CategoryID * 5),
    BaseSelling + (CategoryID * 5),
    Unit,
    '890100' + RIGHT('0000' + CAST(RowNum AS VARCHAR(4)), 4)
FROM ProductData;
GO

-- Display all products
SELECT
    P.ProductID,
    P.ProductName,
    P.SKU,
    C.CategoryName,
    S.SupplierName,
    P.PurchasePrice,
    P.SellingPrice,
    P.Unit
FROM Products P
INNER JOIN Categories C
    ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
ORDER BY P.ProductID;
GO

-- Verify total products
SELECT COUNT(*) AS TotalProducts
FROM Products;
GO

---------------------------------------------------------------------------------


USE DepartmentalStoreDB;
GO

;WITH CustomerData AS
(
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RN,
        V.FirstName,
        V.LastName,
        V.Gender
    FROM
    (
        VALUES
        ('Amit','Sharma','Male'),
        ('Rahul','Patil','Male'),
        ('Priya','Desai','Female'),
        ('Sneha','Kulkarni','Female'),
        ('Karan','Joshi','Male'),
        ('Neha','Pawar','Female'),
        ('Rohit','Verma','Male'),
        ('Pooja','Singh','Female'),
        ('Vijay','Kumar','Male'),
        ('Anjali','Shah','Female'),
        ('Suresh','More','Male'),
        ('Meera','Iyer','Female'),
        ('Arjun','Rao','Male'),
        ('Kavita','Gupta','Female'),
        ('Nitin','Jadhav','Male'),
        ('Swati','Patil','Female'),
        ('Manoj','Reddy','Male'),
        ('Riya','Mehta','Female'),
        ('Deepak','Shinde','Male'),
        ('Aarti','Deshmukh','Female'),
        ('Sanjay','Yadav','Male'),
        ('Komal','Jain','Female'),
        ('Ajay','Kadam','Male'),
        ('Divya','Nair','Female'),
        ('Varun','Malhotra','Male'),
        ('Shweta','Joshi','Female'),
        ('Akash','Chavan','Male'),
        ('Madhuri','Rane','Female'),
        ('Kunal','Bhosale','Male'),
        ('Nisha','Kale','Female'),
        ('Prakash','Mishra','Male'),
        ('Simran','Kaur','Female'),
        ('Ramesh','Naik','Male'),
        ('Isha','Agarwal','Female'),
        ('Abhishek','Thakur','Male'),
        ('Payal','Saxena','Female'),
        ('Harish','Pillai','Male'),
        ('Tanvi','Gokhale','Female'),
        ('Mohit','Sinha','Male'),
        ('Snehal','Mane','Female'),
        ('Gaurav','Chopra','Male'),
        ('Rekha','Joshi','Female'),
        ('Vishal','Patel','Male'),
        ('Ritu','Sharma','Female'),
        ('Siddharth','Desai','Male'),
        ('Pallavi','More','Female'),
        ('Aniket','Sawant','Male'),
        ('Kirti','Rao','Female'),
        ('Yash','Kulkarni','Male'),
        ('Monika','Verma','Female')
    ) V(FirstName, LastName, Gender)
)
INSERT INTO Customers
(
    FirstName,
    LastName,
    Email,
    Phone,
    Gender,
    DateOfBirth,
    RegistrationDate
)
SELECT
    FirstName,
    LastName,
    'customer' + CAST(RN AS VARCHAR(3)) + '@example.com',
    '90000' + RIGHT('00000' + CAST(RN AS VARCHAR(5)), 5),
    Gender,
    DATEADD(DAY, -(RN * 100), CAST('2000-01-01' AS DATE)),
    DATEADD(DAY, -RN, GETDATE())
FROM CustomerData;
GO

-- Display customers
SELECT * FROM Customers;

-- Verify total customers
SELECT COUNT(*) AS TotalCustomers
FROM Customers;
GO


-----------------------------------------------------------


USE DepartmentalStoreDB;
GO

INSERT INTO Employees
(
    StoreID,
    FirstName,
    LastName,
    Email,
    Phone,
    JobTitle,
    Salary,
    HireDate
)
VALUES
(1,'Raj','Sharma','raj.emp01@example.com','9100000001','Store Manager',45000,'2022-01-10'),
(1,'Amit','Patil','amit.emp02@example.com','9100000002','Cashier',22000,'2023-03-15'),
(2,'Priya','Desai','priya.emp03@example.com','9100000003','Store Manager',48000,'2021-06-20'),
(2,'Rahul','Verma','rahul.emp04@example.com','9100000004','Sales Executive',25000,'2023-07-12'),
(3,'Sneha','Kulkarni','sneha.emp05@example.com','9100000005','Store Manager',42000,'2022-09-05'),
(3,'Karan','Joshi','karan.emp06@example.com','9100000006','Cashier',23000,'2024-01-18'),
(4,'Neha','Pawar','neha.emp07@example.com','9100000007','Store Manager',44000,'2021-11-11'),
(4,'Rohit','Singh','rohit.emp08@example.com','9100000008','Inventory Executive',28000,'2023-02-14'),
(5,'Pooja','Shah','pooja.emp09@example.com','9100000009','Store Manager',46000,'2022-04-25'),
(5,'Vijay','Kumar','vijay.emp10@example.com','9100000010','Cashier',24000,'2023-08-16'),
(6,'Anjali','More','anjali.emp11@example.com','9100000011','Store Manager',43000,'2022-05-19'),
(6,'Suresh','Rao','suresh.emp12@example.com','9100000012','Sales Executive',26000,'2024-02-10'),
(7,'Meera','Gupta','meera.emp13@example.com','9100000013','Store Manager',47000,'2021-12-01'),
(7,'Arjun','Jadhav','arjun.emp14@example.com','9100000014','Inventory Executive',29000,'2023-09-21'),
(8,'Kavita','Nair','kavita.emp15@example.com','9100000015','Store Manager',50000,'2020-07-15'),
(8,'Manoj','Reddy','manoj.emp16@example.com','9100000016','Cashier',25000,'2024-03-12'),
(9,'Swati','Mehta','swati.emp17@example.com','9100000017','Store Manager',49000,'2021-08-08'),
(9,'Deepak','Shinde','deepak.emp18@example.com','9100000018','Sales Executive',27000,'2023-10-17'),
(10,'Riya','Malhotra','riya.emp19@example.com','9100000019','Store Manager',52000,'2020-05-22'),
(10,'Nitin','Kadam','nitin.emp20@example.com','9100000020','Inventory Executive',30000,'2024-04-01');
GO

-- Display employees with store names
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.Salary,
    S.StoreName
FROM Employees E
INNER JOIN Stores S
    ON E.StoreID = S.StoreID
ORDER BY E.EmployeeID;
GO

-- Count employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees;
GO

----------------------------------------------------------------------


USE DepartmentalStoreDB;
GO

;WITH SalesData AS
(
    SELECT
        N,
        ((N - 1) % 10) + 1 AS StoreID,
        ((N - 1) % 50) + 1 AS CustomerID,
        ((N - 1) % 20) + 1 AS EmployeeID
    FROM
    (
        SELECT TOP (100)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects
    ) X
)
INSERT INTO Sales
(
    StoreID,
    CustomerID,
    EmployeeID,
    InvoiceNumber,
    SaleDate,
    SubTotal,
    DiscountAmount,
    TaxAmount,
    GrandTotal,
    SaleStatus
)
SELECT
    StoreID,
    CustomerID,
    EmployeeID,
    'INV' + RIGHT('00000' + CAST(N AS VARCHAR(5)), 5),
    DATEADD(DAY, -(N % 90), GETDATE()),
    1000 + (N * 25),
    50,
    90,
    (1000 + (N * 25)) - 50 + 90,
    'Completed'
FROM SalesData;
GO

-- Display sales with customer and employee names
SELECT
    S.SaleID,
    S.InvoiceNumber,
    C.FirstName + ' ' + C.LastName AS CustomerName,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    ST.StoreName,
    S.GrandTotal,
    S.SaleStatus
FROM Sales S
INNER JOIN Customers C
    ON S.CustomerID = C.CustomerID
INNER JOIN Employees E
    ON S.EmployeeID = E.EmployeeID
INNER JOIN Stores ST
    ON S.StoreID = ST.StoreID
ORDER BY S.SaleID;
GO

-- Count sales
SELECT COUNT(*) AS TotalSales
FROM Sales;
GO
----------------------------------------------------------

USE DepartmentalStoreDB;
GO

;WITH SaleProductData AS
(
    SELECT
        S.SaleID,
        ((S.SaleID - 1) % 100) + 1 AS ProductID
    FROM Sales S

    UNION ALL

    SELECT
        S.SaleID,
        (S.SaleID % 100) + 1 AS ProductID
    FROM Sales S
)
INSERT INTO SaleDetails
(
    SaleID,
    ProductID,
    Quantity,
    UnitPrice,
    DiscountAmount,
    TaxAmount,
    LineTotal
)
SELECT
    SPD.SaleID,
    SPD.ProductID,
    2,
    P.SellingPrice,
    0,
    P.SellingPrice * 2 * 0.05,
    (P.SellingPrice * 2) * 1.05
FROM SaleProductData SPD
INNER JOIN Products P
    ON SPD.ProductID = P.ProductID;
GO

SELECT COUNT(*) AS TotalSaleDetails
FROM SaleDetails;
GO

----------------------------------

USE DepartmentalStoreDB;
GO

;WITH PurchaseData AS
(
    SELECT TOP (30)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects
)
INSERT INTO Purchases
(
    StoreID,
    SupplierID,
    EmployeeID,
    PurchaseNumber,
    PurchaseDate,
    SubTotal,
    TaxAmount,
    DiscountAmount,
    GrandTotal,
    PurchaseStatus
)
SELECT
    ((N - 1) % 10) + 1,
    ((N - 1) % 20) + 1,
    ((N - 1) % 20) + 1,
    'PUR' + RIGHT('00000' + CAST(N AS VARCHAR(5)), 5),
    DATEADD(DAY, -(N % 60), GETDATE()),
    5000 + (N * 100),
    250,
    100,
    (5000 + (N * 100)) + 250 - 100,
    'Received'
FROM PurchaseData;
GO

SELECT COUNT(*) AS TotalPurchases
FROM Purchases;
GO

----------------------------------------

USE DepartmentalStoreDB;
GO

;WITH PurchaseProductData AS
(
    SELECT
        P.PurchaseID,
        ((P.PurchaseID - 1) % 100) + 1 AS ProductID
    FROM Purchases P

    UNION ALL

    SELECT
        P.PurchaseID,
        (P.PurchaseID % 100) + 1 AS ProductID
    FROM Purchases P
)
INSERT INTO PurchaseDetails
(
    PurchaseID,
    ProductID,
    Quantity,
    UnitCost,
    DiscountAmount,
    TaxAmount,
    LineTotal
)
SELECT
    PPD.PurchaseID,
    PPD.ProductID,
    5,
    PR.PurchasePrice,
    0,
    PR.PurchasePrice * 5 * 0.05,
    (PR.PurchasePrice * 5) * 1.05
FROM PurchaseProductData PPD
INNER JOIN Products PR
    ON PPD.ProductID = PR.ProductID;
GO

SELECT COUNT(*) AS TotalPurchaseDetails
FROM PurchaseDetails;
GO

------------------------------------------------------------

USE DepartmentalStoreDB;
GO

INSERT INTO Payments
(
    SaleID,
    PaymentDate,
    PaymentMethod,
    Amount,
    TransactionReference,
    PaymentStatus
)
SELECT
    SaleID,
    DATEADD(MINUTE, 10, SaleDate),
    CASE
        WHEN SaleID % 5 = 0 THEN 'Cash'
        WHEN SaleID % 5 = 1 THEN 'UPI'
        WHEN SaleID % 5 = 2 THEN 'Credit Card'
        WHEN SaleID % 5 = 3 THEN 'Debit Card'
        ELSE 'Net Banking'
    END,
    GrandTotal,
    'TXN' + RIGHT('00000' + CAST(SaleID AS VARCHAR(5)), 5),
    'Completed'
FROM Sales;
GO

SELECT COUNT(*) AS TotalPayments
FROM Payments;
GO

------------------------------------

USE DepartmentalStoreDB;
GO

;WITH InventoryData AS
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects
)
INSERT INTO Inventory
(
    StoreID,
    ProductID,
    QuantityInStock,
    ReorderLevel,
    LastUpdated
)
SELECT
    ((N - 1) % 10) + 1,
    N,
    50 + (N % 100),
    10,
    GETDATE()
FROM InventoryData;
GO

SELECT COUNT(*) AS TotalInventory
FROM Inventory;
GO
-------------------------------------------
USE DepartmentalStoreDB;
GO

;WITH StockData AS
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects
)
INSERT INTO StockTransactions
(
    StoreID,
    ProductID,
    TransactionType,
    Quantity,
    TransactionDate,
    ReferenceNumber,
    Remarks
)
SELECT
    ((N - 1) % 10) + 1,
    ((N - 1) % 100) + 1,
    CASE
        WHEN N % 5 = 0 THEN 'Purchase'
        WHEN N % 5 = 1 THEN 'Sale'
        WHEN N % 5 = 2 THEN 'Return'
        WHEN N % 5 = 3 THEN 'Damage'
        ELSE 'Adjustment'
    END,
    1 + (N % 20),
    DATEADD(DAY, -(N % 30), GETDATE()),
    'STK' + RIGHT('00000' + CAST(N AS VARCHAR(5)), 5),
    'Stock movement transaction'
FROM StockData;
GO

SELECT COUNT(*) AS TotalStockTransactions
FROM StockTransactions;
GO

-----------------------------------------------
USE DepartmentalStoreDB;
GO

;WITH ReturnData AS
(
    SELECT TOP (10)
        S.SaleID,
        S.CustomerID,
        SD.ProductID,
        ROW_NUMBER() OVER (ORDER BY S.SaleID) AS N
    FROM Sales S
    INNER JOIN SaleDetails SD
        ON S.SaleID = SD.SaleID
    WHERE S.CustomerID IS NOT NULL
    ORDER BY S.SaleID
)
INSERT INTO Returns
(
    SaleID,
    ProductID,
    CustomerID,
    Quantity,
    ReturnDate,
    ReturnReason,
    RefundAmount,
    ReturnStatus
)
SELECT
    SaleID,
    ProductID,
    CustomerID,
    1,
    GETDATE(),
    CASE
        WHEN N % 3 = 0 THEN 'Damaged product'
        WHEN N % 3 = 1 THEN 'Wrong product delivered'
        ELSE 'Customer changed mind'
    END,
    100 + (N * 50),
    'Completed'
FROM ReturnData;
GO

SELECT COUNT(*) AS TotalReturns
FROM Returns;
GO

---------------------------------

USE DepartmentalStoreDB;
GO

;WITH DiscountData AS
(
    SELECT TOP (10)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects
)
INSERT INTO Discounts
(
    ProductID,
    DiscountName,
    DiscountType,
    DiscountValue,
    StartDate,
    EndDate,
    IsActive
)
SELECT
    N,
    CASE
        WHEN N % 2 = 0 THEN 'Festival Fixed Discount'
        ELSE 'Special Percentage Discount'
    END,
    CASE
        WHEN N % 2 = 0 THEN 'Fixed'
        ELSE 'Percentage'
    END,
    CASE
        WHEN N % 2 = 0 THEN 100
        ELSE 10
    END,
    DATEADD(DAY, -5, GETDATE()),
    DATEADD(DAY, 30, GETDATE()),
    1
FROM DiscountData;
GO

SELECT COUNT(*) AS TotalDiscounts
FROM Discounts;
GO






