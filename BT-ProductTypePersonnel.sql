CREATE TABLE ResPersonnels(
	Id INT PRIMARY KEY,
	Name NVARCHAR(255) NOT NULL 
);

CREATE TABLE Types(
	Id VARCHAR(100) PRIMARY KEY,
	Name NVARCHAR(255) NOT NULL  
);

CREATE TABLE Products(
	Id VARCHAR(100) PRIMARY KEY,
	ProducedDate DATE NOT NULL DEFAULT GETDATE(),
	TypeId VARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Types(Id),
	PersonnelId INT NOT NULL FOREIGN KEY REFERENCES ResPersonnels(Id)
);

DROP TABLE Products;
DROP TABLE ResPersonnels;
DROP TABLE Types;

-- 3. Viết các câu lệnh để thêm dữ liệu vào bảng
INSERT INTO ResPersonnels
VALUES 
(987688, N'Nguyễn Văn An'),
(987689, N'Trần Đức Bình'),
(987690, N'Phạm Thị Thanh');

INSERT INTO Types
VALUES
('Z37E', N'Máy tính sách tay Z37'),
('N97A', N'Điện thoại di động N97'),
('X15P', N'Máy tính để bàn XP15');

INSERT INTO Products
VALUES
('Z37 111111', '2009-12-12', 'Z37E', 987688),
('Z37 222222', '2010-12-14', 'Z37E', 987688),
('Z37 333333', '2008-11-22', 'Z37E', 987689),
('N97 111111', '2010-04-09', 'N97A', 987689),
('N97 222222', '2013-05-12', 'N97A', 987690),
('N97 333333', '2012-06-17', 'N97A', 987690),
('X15 111111', '2011-10-21', 'X15P', 987688),
('X15 222222', '2010-05-02', 'X15P', 987688),
('X15 333333', '2009-12-02', 'X15P', 987689);

-- 4. Viết câu lệnh truy vấn 
-- a) Liệt kê danh sách loại sản phẩm
SELECT * 
FROM Types;

-- b) Liệt kê danh sách sản phẩm của công ty
SELECT *
FROM Products;

-- c) Liệt kê danh sách người chịu trách nhiệm
SELECT *
FROM ResPersonnels;


-- 5. Viết các câu lệnh truy vấn
-- a) Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
SELECT * 
FROM Types
ORDER BY Name ASC;

-- b) Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên
SELECT *
FROM ResPersonnels
ORDER BY Name ASC;

-- c) Liệt kê các sản phẩm của loại sản phẩm có mã số là Z37E
SELECT * 
FROM Products
WHERE TypeId LIKE 'Z37E';

-- d) Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự tăng dần của mã
SELECT *
FROM Products
WHERE PersonnelId = (
	SELECT Id
	FROM ResPersonnels
	WHERE Name LIKE N'Nguyễn Văn An'
)
ORDER BY Id DESC;


-- 6. Viết các câu lệnh truy vấn
-- a) Số sản phẩm của từng loại sản phẩm
SELECT COUNT(*) AS Quantity, TypeId
FROM Products
GROUP BY TypeId;

-- b) Số loại sản phẩm trung bình theo loại sản phẩm
SELECT COUNT(*)/COUNT(DISTINCT TypeId)
FROM Products;

-- c) Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm
SELECT *
FROM Products 
INNER JOIN Types
ON Products.TypeId = Types.Id;

-- d) Hiển thị toàn bộ thông tin về người chịu trách nhiệm, loại sản phẩm và sản phẩm
SELECT *
FROM Products 
INNER JOIN Types
ON Products.TypeId = Types.Id
INNER JOIN ResPersonnels
ON Products.PersonnelId = ResPersonnels.Id;


-- 7. Thau đổi những trường sau từ cơ sở dữ liệu
-- a) Thay đổi trường ngày sản xuất trước hoặc bằng ngày hiện tại 
ALTER TABLE Products
ADD CONSTRAINT check_produced_date
CHECK(ProducedDate <= GETDATE());

-- b) Xác định các trường khóa chính và khóa ngoại của các bảng
SELECT * 
FROM information_schema.key_column_usage;  

-- c) Thêm trường "phiên bản" của sản phẩm
ALTER TABLE Products
ADD Version INT NOT NULL DEFAULT 1 CHECK(Version >= 1);


-- 8. Thực hiện các yêu cầu sau
-- a) Đặt chỉ mục cho cột tên người chịu trách nhiệm
CREATE INDEX idx_name
ON ResPersonnels (Name);

-- b) Viết các View
-- b1) View_SanPham: Hiển thị các thông tin Mã sản phẩm, Ngày sản xuất, Loại sản phẩm
CREATE VIEW View_SanPham AS
SELECT Products.Id, Products.ProducedDate, Types.Name
FROM Products
JOIN Types
ON Products.TypeId = Types.Id;

-- b2) Virew_SanPham_NCTN: Hiển thị Mã sản phẩm, Ngày sản xuất, Người chịu trách nhiệm
CREATE VIEW View_SanPham_NCTN AS
SELECT Products.Id, Products.ProducedDate, ResPersonnels.Name
FROM Products
JOIN ResPersonnels
ON Products.PersonnelId = ResPersonnels.Id;

-- b3) View_Top_SanPham: Hiển thị 5 sản phẩm mới nhất (mã sản phẩm, loại sản phẩm, ngày sản xuất)
CREATE VIEW View_Top_SanPham AS
SELECT TOP 5 Products.Id, Types.Name, Products.ProducedDate
FROM Products
JOIN Types
ON Products.TypeId = Types.Id
ORDER BY Products.ProducedDate DESC;


-- c) Viết các Store Procedure
-- c1) SP_Them_LoaiSP: Thêm một loại sản phẩm
CREATE PROCEDURE SP_Them_LoaiSP (@Id VARCHAR(100), @Name NVARCHAR(255))
AS
BEGIN
	INSERT INTO Types
	VALUES (@Id, @Name)
END;
EXEC SP_Them_LoaiSP @Id = 'M16P', @Name = 'Macbook Pro 16 inch';

-- c2) SP_Them_NCTN: Thêm mới người chịu trách nhiệm
CREATE PROCEDURE SP_Them_NCTN (@Id INT, @Name NVARCHAR(255))
AS
BEGIN
	INSERT INTO ResPersonnels
	VALUES (@Id, @Name)
END;
EXEC SP_Them_NCTN @Id = 987691, @Name = N'Hồ Hoàng Tiến';

-- c3) SP_Them_SanPham: Thêm một sản phẩm mới
CREATE PROCEDURE SP_Them_SanPham (@Id VARCHAR(100), @ProducedDate DATE, @TypeId VARCHAR(100), @PersonnelId INT, @Version INT)
AS
BEGIN
	INSERT INTO Products
	VALUES (@Id, @ProducedDate, @TypeId, @PersonnelId, @Version)
END;
EXEC SP_Them_SanPham @Id = 'M16P 111111', @ProducedDate = '2010-06-19', @TypeId = 'M16P', @PersonnelId = 987689, @Version = 1;

-- c4) SP_Xoa_SanPham: Xóa một sản phẩm theo mã sản phẩm
CREATE PROCEDURE SP_Xoa_SanPham (@Id VARCHAR(100))
AS
BEGIN
	DELETE FROM Products
	WHERE Id LIKE @Id
END;
EXEC SP_Xoa_SanPham @Id = 'M16P 111111';

-- c5) SP_Xoa_SanPham_TheoLoai: Xóa tất cả sản phẩm của một loại nào đó
CREATE PROCEDURE SP_Xoa_SanPham_TheoLoai (@TypeId VARCHAR(100))
AS
BEGIN 
	DELETE FROM Products
	WHERE TypeId LIKE @TypeId
END;
EXEC SP_Xoa_SanPham_TheoLoai @TypeId = 'X15P';


