CREATE TABLE customer(
	id INT PRIMARY KEY IDENTITY(1,1),
	id_card VARCHAR(20) NOT NULL UNIQUE CHECK(id_card not like '%[^0-9]%'),
	name NVARCHAR(100) NOT NULL,
	address NVARCHAR(255) NOT NULL 
);

CREATE TABLE subscription(
	id INT PRIMARY KEY IDENTITY(1,1),
	number VARCHAR(100) NOT NULL UNIQUE CHECK(number not like '%[^0-9]%'),
	type NVARCHAR(100) NOT NULL CHECK(type = N'Trả trước' or Type = N'Trả sau'),
	sub_date DATE,
	customer_id INT FOREIGN KEY REFERENCES customer(id)
);

DROP TABLE subscription;
DROP TABLE customer;

-- 3. Viết các câu lệnh để thêm dữ liệu vào bảng
INSERT INTO customer(id_card, name, address)  
VALUES
('123456789', N'Nguyễn Nguyệt Nga', N'Hà Nội'),
('234256475', N'Nguyễn Văn An', N'Nam Định');

INSERT INTO subscription(number, type, sub_date, customer_id) 
VALUES
('0123456789', N'Trả trước', '2002-12-12', 1),
('0123456255', N'Trả sau', '2009-12-12', 1),
('0123456634', N'Trả trước', '2009-12-12', 2),
('0123456952', N'Trả sau', '2005-07-15', 2);

-- 4. Viết các câu lệnh truy vấn
-- a) Hiển thị toàn bộ thông tin của khách hàng
SELECT * FROM customer;

-- b) Hiển thị toàn bộ thông tin của các số thuê bao 
SELECT * FROM subscription;

-- 5. Viết câu lệnh truy vấn
-- a) Hiển thị toàn bộ thông tin của thuê bao số 0123456789
SELECT * 
FROM subscription
WHERE number = '0123456789';

-- b) Hiển thị thông tin khách hàng có số CMND 123456789
SELECT * 
FROM customer
WHERE id_card = '123456789';

-- c) Hiển thị các số thuê bao của khách hàng có số CMND 123456789
SELECT * 
FROM subscription
WHERE customer_id IN (
	SELECT id
	FROM customer
	WHERE id_card = '123456789'
);

-- d) Liệt kê các thuê bao đăng ký vào ngày 12/12/09
SELECT * 
FROM subscription 
WHERE sub_date = '2009-12-12';

-- e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
SELECT *
FROM subscription
WHERE customer_id IN (
	SELECT id
	FROM customer
	WHERE address LIKE N'%Hà Nội'
);

-- 6. Viết các câu lệnh truy vấn
-- a) Tổng số khách hàng của công ty
SELECT COUNT(*) AS NumberOfCustomer
FROM customer;

-- b) Tổng số thuê bao của công ty
SELECT COUNT(*) AS NumberOfSubscription
FROM subscription;

-- c) Tổng số thuê bao đăng ký ngày 12/12/09
SELECT COUNT(*) AS NumberOfSubscription
FROM subscription
WHERE sub_date = '2009-12-12';

-- d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao
SELECT * 
FROM subscription s
LEFT JOIN customer c
ON s.customer_id = c.id;

-- 7. Thay đổi những trường sau trên CSDL
-- a) Thay đổi trường ngày đăng ký là not null
ALTER TABLE subscription
ALTER COLUMN sub_date DATE NOT NULL; 

-- b) Thay đổi trường ngày đăng ký là <= ngày hiện tại
ALTER TABLE subscription
ADD CONSTRAINT CK_sub_date
CHECK (sub_date <= GETDATE());

-- c) Thay đổi số điện thoại phải bắt đầu 09
UPDATE subscription
SET number = '09' + number;

ALTER TABLE subscription
ADD CONSTRAINT CK_number
CHECK (number LIKE '09%');

-- d) Viết câu lệnh thêm trường số điểm thưởng cho mỗi số thuê bao
ALTER TABLE subscription
ADD reward_points INT;

-- 8. Thực hiện các yêu cầu sau
-- a) Đặt chỉ mục cho cột Tên khách hàng
CREATE INDEX IDX_customer_name
ON customer(name);

-- b) Viết các view:
CREATE VIEW View_KhachHan AS
SELECT id, name, address
FROM customer;

CREATE VIEW View_KhachHang_ThueBao AS
SELECT c.id, c.name, s.number
FROM customer c
JOIN subscription s
ON c.id = s.customer_id;

-- c) Viết các store procedure
CREATE PROCEDURE SP_TimKH_ThueBao @number VARCHAR(100)
AS
SELECT *
FROM customer
WHERE id IN (
	SELECT customer_id
	FROM subscription
	WHERE number = @number
);

EXEC SP_TimKH_ThueBao @number = '090123456789';

CREATE PROCEDURE SP_TimTB_KhachHang @name NVARCHAR(100)
AS
SELECT * 
FROM subscription
WHERE customer_id IN (
	SELECT id
	FROM customer
	WHERE name = @name
);

EXEC SP_TimTB_KhachHang @name = N'Nguyễn Nguyệt Nga';

CREATE PROCEDURE SP_ThemTB @number VARCHAR(100), @type NVARCHAR(100), @sub_date DATE, @customer_id INT
AS
INSERT INTO subscription(number, type, sub_date, customer_id)
VALUES (@number, @type, @sub_date, @customer_id);

EXEC SP_ThemTB @number = '0985473402', @type = N'Trả trước', @sub_date = '2010-03-12', @customer_id = 1;

CREATE PROCEDURE SP_HuyTB_MaKH @customer_id INT
AS
DELETE FROM subscription
WHERE customer_id = @customer_id;

EXEC SP_HuyTB_MaKH @customer_id = 2;

