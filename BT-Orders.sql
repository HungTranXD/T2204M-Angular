CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	Tel NVARCHAR(20) NOT NULL UNIQUE,
	Address NVARCHAR(255)
);

CREATE TABLE Products(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	Descrip NVARCHAR(255) NOT NULL,
	Unit NVARCHAR(100) NOT NULL,
	Price DECIMAL(12,4) NOT NULL DEFAULT 0 
	--DECIMAL(12,4) do giá là USD
);

CREATE TABLE Orders(
	Id INT PRIMARY KEY IDENTITY(1,1),
	OrderDate DATE NOT NULL DEFAULT GETDATE(),
	GrandTotal DECIMAL(12,4) NOT NULL DEFAULT 0 CHECK(GrandTotal >= 0),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id)	
);

CREATE TABLE Order_Products(
	Quantity INT NOT NULL CHECK(Quantity >= 0),
	SubTotal DECIMAL(12,4) NOT NULL CHECK(SubTotal >= 0),
	OrderId INT FOREIGN KEY REFERENCES Orders(Id),
	ProductId INT FOREIGN KEY REFERENCES Products(Id)
);

DROP TABLE Customers;
DROP TABLE Products;
DROP TABLE Orders;
DROP TABLE Order_Products;

INSERT INTO Customers
VALUES 
(N'Nguyễn Văn An', '987654321', N'111, Nguyễn Trãi, Thanh Xuân, Hà Nội'),
(N'Trần Đức Bình', '123459876', N'222, Đinh Công Tráng, Ba Đình, Hà Nội'),
(N'Hồ Thị Huế', '325402934', N'333, Phú Thượng, Tây Hồ, Hà Nội');

INSERT INTO Products
VALUES
(N'Máy Tính T450', N'Máy nhập mới', N'Chiếc', 1000),
(N'Điện Thoại Nokia5670', N'Điện thoại đang hot', N'Chiếc', 200),
(N'Máy In Samsung 450', N'Máy in đang ế', N'Chiếc', 100);

INSERT INTO Orders(OrderDate, CustomerId)
VALUES
('2009-11-18', 1), -- Ban đầu chưa có GrandTotal
('2011-02-15', 2), -- và sẽ UPDATE sua khi có bảng
('2014-09-02', 3); -- order_products

INSERT INTO Order_Products
VALUES
(1, 1000, 1, 1),
(2, 400, 1, 2),
(1, 100, 1, 3);

INSERT INTO Order_Products
VALUES
(2, 2000, 2, 1);

INSERT INTO Order_Products
VALUES
(1, 200, 3, 2);

UPDATE Orders
SET GrandTotal = (
	SELECT SUM(SubTotal)
	FROM Order_Products
	WHERE OrderId = 1
)
WHERE Id = 1;

UPDATE Orders
SET GrandTotal = (
	SELECT SUM(SubTotal)
	FROM Order_Products
	WHERE OrderId = 2
)
WHERE Id = 2;

UPDATE Orders
SET GrandTotal = (
	SELECT SUM(SubTotal)
	FROM Order_Products
	WHERE OrderId = 3
)
WHERE Id = 3;


-- 4. Viết các câu lệnh truy vấn:
-- a. Liệt kê danh sách khách hàng đã mua ở cửa hàng
SELECT * 
FROM Customers;

-- b. Liệt kê danh sách các sản phẩm của cửa hàng
SELECT * 
FROM Products;

-- c. Liệt kê danh sách các đơn đặt hàng của cửa hàng
SELECT * 
FROM Orders;


-- 5. Viết các câu lệnh truy vấn:
-- a. Liệt kê danh sách khách hàng theo thứ tự alphabet
SELECT * 
FROM Customers
ORDER BY Name;

-- b. Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần
SELECT * 
FROM Products
ORDER BY Price DESC;

-- c. Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua
SELECT * 
FROM Products
WHERE Id IN (
	SELECT ProductId
	FROM Order_Products
	WHERE OrderId IN (
		SELECT Id
		FROM Orders
		WHERE CustomerId = (
			SELECT Id
			FROM Customers
			WHERE Name LIKE N'Nguyễn Văn An'
		)
	)
);


-- 6. Viết các câu lệnh truy vấn:
-- a. Số khách hàng đã mua ở cửa hàng
SELECT COUNT(*) AS NumberOfCustomer
FROM Customers;

-- b. Số mặt hàng mà cửa hàng bán
SELECT COUNT(*) AS NumberOfProduct
FROM Products;

-- c. Tổng tiền của từng đơn hàng
SELECT SUM(SubTotal) AS GrandTotal, OrderId
FROM Order_Products
GROUP BY OrderId;


-- 7. Thay đổi những thông tin sau
-- a. Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương (>0)
ALTER TABLE Products
ADD CONSTRAINT check_product_price_positive
CHECK(Price > 0);

-- b. Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại
ALTER TABLE Orders
ADD CONSTRAINT check_order_date
CHECK(OrderDate < GETDATE());

-- c. Viết câu lệnh để thêm trường ngày xuất hiện trên thị trường của sản phẩm
ALTER TABLE Products
ADD IntroduceDate DATE;

-- 8. Thực hiện các yêu cầu sau 
-- a) Đặt chỉ mục cho cột Tên hàng và Người đặt hàng 
CREATE INDEX IDX_ProductName
ON Products(Name);

CREATE INDEX IDX_CustomerName
ON Customers(Name);

-- b) Xây dựng các View 
CREATE VIEW View_KhachHang AS
SELECT Name, Tel, Address
FROM Customers;

CREATE VIEW View_SanPham AS
SELECT Name, Price
FROM Products;

CREATE VIEW View_KhachHang_SanPham AS
SELECT C.Name, C.Tel, P.Name AS ProductName, OP.Quantity, O.OrderDate
FROM Customers C
JOIN Orders O
ON C.Id = O.CustomerId
JOIN Order_Products OP
ON O.Id = OP.OrderId
JOIN Products P
ON OP.ProductId = P.Id;

-- c) Viết các Store Procedure
CREATE PROCEDURE SP_TimKH_MaKH @Id INT
AS
SELECT * 
FROM Customers
WHERE Id = @Id;

CREATE PROCEDURE SP_TimKH_MaHD @OrderId INT
AS
SELECT * 
FROM Customers
WHERE Id IN (
	SELECT CustomerId
	FROM Orders
	WHERE Id = @OrderId
);

CREATE PROCEDURE SP_SanPham_MaKH @CustomerId INT
AS
SELECT * 
FROM Products
WHERE Id IN (
	SELECT ProductId
	FROM Order_Products
	WHERE OrderId IN (
		SELECT Id
		FROM Orders
		WHERE CustomerId = @CustomerId
	)
);
