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
	Price DECIMAL(12,4) NOT NULL DEFAULT 0 CHECK(Price >= 0), -- Giá USD
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
SELECT COUNT(*) AS Number, Brands.Name
FROM Products
LEFT JOIN Brands
ON Products.BrandId = Brands.Id
GROUP BY Brands.Name;

-- d) Tổng số đầu sản phẩm của toàn cửa hàng
SELECT COUNT(*)
FROM Products;

-- 7. Thay đổi những thay đổi sau trên cơ sở dữ liệu
-- a) Thay đổi trường giá tiền của từng mặt hàng là dương (>0)
ALTER TABLE Products
ADD CONSTRAINT CK_price_positive
CHECK (Price > 0);

-- b) Thay đổi số điện thoại phải bắt đầu bằng 0
UPDATE Brands
SET Tel = '0983232'
WHERE Id = 123;

UPDATE Brands
SET Tel = '0423562'
WHERE Id = 124;

ALTER TABLE Brands
ADD CONSTRAINT CK_phone_start_with_0
CHECK (Tel LIKE '0%');

-- c) Viết các câu lệnh để xác định khóa ngoại và khóa chính của các bảng
SELECT
    tc.table_schema, 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY' AND tc.table_name='Brands';

SELECT
    tc.table_schema, 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY' AND tc.table_name='Products';

SELECT
    tc.table_schema, 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='Products';

-- 8. Thực hiện các yêu cầu sau
-- a) Thiết lập chỉ mục cho các cột: Tên hàng và mô tả hàng 
CREATE INDEX IDX_product_name
ON Products(Name);

CREATE INDEX IDX_product_des
ON Products(Description);

-- b) Viết các view
CREATE VIEW View_SanPham AS
SELECT Id, Name, Price
FROM Products;

CREATE VIEW View_SanPham_Hang AS
SELECT P.Id, P.Name, B.Name AS Brand
FROM Products P
LEFT JOIN Brands B
ON P.BrandId = B.Id;

-- c) Viết các store procedure
CREATE PROCEDURE SP_SanPham_TenHang 
AS
SELECT P.Id, P.Name, P.Description, P.Price, P.Quantity, B.Name AS Brand
FROM Products P
LEFT JOIN Brands B
ON P.BrandId = B.Id;

EXEC SP_SanPham_TenHang;
CREATE PROCEDURE SP_SanPham_Gia @Price DECIMAL(12,4)
AS
SELECT * 
FROM Products
WHERE Price >= @Price; 

EXEC SP_SanPham_Gia @Price = 650;

CREATE PROCEDURE SP_SanPham_HetHang 
AS
SELECT * 
FROM Products
WHERE Quantity = 0;

EXEC SP_SanPham_HetHang;

-- d) Viết trigger
CREATE TRIGGER TG_Xoa_Hang
ON Brands
AFTER DELETE 
AS
BEGIN 
	PRINT 'Khong duoc xoa san pham';
	ROLLBACK TRAN;
END;

CREATE TRIGGER TG_Xoa_SanPham
ON Products
AFTER DELETE
AS 
BEGIN 
	IF (SELECT Quantity FROM deleted) > 0
	BEGIN 
		PRINT 'San pham con hang';
		ROLLBACK TRAN;
	END
END;
