CREATE TABLE Brands(
	Id INT PRIMARY KEY,
	Name VARCHAR(100) NOT NULL UNIQUE,
	Address VARCHAR(100) NOT NULL,
	Tel VARCHAR (20) NOT NULL UNIQUE
);

CREATE TABLE Products(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	Description NVARCHAR(255) NOT NULL,
	Unit NVARCHAR(100) NOT NULL DEFAULT N'Chiếc',
	Price DECIMAL(12,4) NOT NULL DEFAULT 0 CHECK(Price >= 0),
	Quantity INT NOT NULL DEFAULT 0 CHECK(Quantity >= 0),
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) 
);

-- 3. Viết các câu lệnh để thêm dữ liệu vào các bảng 
INSERT INTO Brands
VALUES
(123, 'Asus', 'USA', '983232'),
(124, 'Dell', 'USA', '423562');

INSERT INTO Products(Name, Description, Price, Quantity, BrandId)
VALUES
(N'Máy Tính T450', N'Máy nhập cũ', 1000, 10, 123),
(N'Điện Thoại Nokia5670', N'Điện thoại đang hot', 200, 200, 123),
(N'Máy In Samsung 450', N'Máy in đang loại bình', 100, 10, 123),
(N'Máy Tính XPS 13', N'Máy refurbished', 1500, 30, 124),
(N'Điện Thoại N97', N'Máy xách tay', 500, 25, 124),
(N'Máy In 2300', N'Máy mới', 650, 5, 124);

-- 4. Viết các câu lệnh truy vấn
-- a) Hiển thị tất cả các hãng sản xuất
SELECT * 
FROM Brands;

-- b) Hiển thị tất cả các sản phẩm
SELECT * 
FROM Products;

-- 5. Viết các câu lệnh truy vấn
-- a) Liệt kê danh sách hãng theo thứ tự ngược với alphabet của tên 
SELECT *
FROM Brands
ORDER BY Name DESC;

-- b) Liệt kê danh sách sản phẩm của cửa hàng theo thứ tự giá giảm dần
SELECT * 
FROM Products
ORDER BY Price DESC;

-- c) Hiển thị thông tin của hãng Asus
SELECT *
FROM Brands
WHERE Name LIKE 'Asus';

-- d) Liệt kê danh sách sản phẩm còn ít hơn 11 chiếc trong kho
SELECT *
FROM Products
WHERE Quantity < 11;

-- e) Liệt kê danh sách sản phẩm của hãng Asus
SELECT *
FROM Products
WHERE BrandId = (
	SELECT Id
	FROM Brands
	WHERE Name LIKE 'Asus'
);

-- 6. Viết các câu lệnh truy vấn 
-- a) Số hãng sản phẩm mà cửa hàng có
SELECT COUNT(DISTINCT BrandId)
FROM Products
WHERE Quantity > 0;

-- b) Số mặt hàng mà cửa hàng bán
SELECT COUNT(*)
FROM Products;

-- c) Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng
SELECT COUNT(*) Number, Brands.Name
FROM Products
JOIN Brands
ON Products.BrandId = Brands.Id
GROUP BY Brands.Name;

-- d) Tổng số đầu sản phẩm của toàn cửa hàng
SELECT COUNT(*)
FROM Products;