CREATE TABLE persons(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(100) NOT NULL,
	address NVARCHAR(255) NOT NULL,
	birth_date DATE 
);

CREATE TABLE phone_numbers(
	id INT PRIMARY KEY IDENTITY(1,1),
	number VARCHAR(20) NOT NULL UNIQUE CHECK(number NOT LIKE '%[^0-9]%'),
	person_id INT NOT NULL FOREIGN KEY REFERENCES persons(id) ON DELETE CASCADE
);

-- DROP TABLE phone_numbers
-- DROP TABLE persons

-- 3. Viết các câu lệnh để thêm dữ liệu vào bảng
INSERT INTO persons
VALUES 
(N'Nguyễn Văn An', N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội','1987-11-18'),
(N'Trần Đức Bình', N'222 Phương Mai, Đống Đa, Hà Nội','1980-03-12'),
(N'Lý Minh Toàn', N'333 Mai Dịch, Cầu Giấy, Hà Nội','2009-12-12'),
(N'Lý Minh Toàn', N'333 Mai Dịch, Cầu Giấy, Hà Nội',NULL);

INSERT INTO phone_numbers
VALUES
('98765431', 1),
('09873452', 1),
('09832323', 1),
('09434343', 1),
('98555321', 2),
('09876652', 2),
('123456789', 3);

-- 4. Viết các câu lệnh truy vấn để
-- a) Liệt kê danh sách những người có trong danh bạ
SELECT * FROM persons;

--b) Liệt kê danh sách số điện thoại có trong danh bạ
SELECT * FROM phone_numbers;

-- 5. Viết các câu lệnh truy vấn để
-- a) Liệt kê danh sách người trong danh bạ theo thứ tự alphabet
SELECT * 
FROM persons
ORDER BY name;

-- b) Liệt kê các số điện thoại của người có tên là Nguyễn Văn An
SELECT * 
FROM phone_numbers
WHERE person_id IN (
	SELECT id
	FROM persons
	WHERE name LIKE N'Nguyễn Văn An'
);

-- c) Liệt kê những người có ngày sinh 12/12/09
SELECT * 
FROM persons
WHERE birth_date = '2009-12-12';

-- 6. Viết các câu lệnh truy vấn để 
-- a) Tìm số lượng số điện thoại của mỗi người trong danh bạ
SELECT COUNT(*) AS number, person_id
FROM phone_numbers  
GROUP BY person_id;

-- b) Tìm tổng số người trong danh bạ sinh vào tháng 12
-- Cách 1:
SELECT COUNT(*) AS number
FROM persons
WHERE birth_date LIKE '____-12-__';
-- Cách 2: 
SELECT COUNT(*) AS number
FROM persons
WHERE MONTH(birth_date) = '12';

-- c) Hiển thị toàn bộ thông tin về người của từng số điện thoại
SELECT * 
FROM phone_numbers AS pn
JOIN persons AS pe
ON pn.person_id = pe.id;

-- d) Hiển thị toàn bộ thông tin về người của số điện thoại 123456789
SELECT * 
FROM phone_numbers AS pn
JOIN persons AS pe
ON pn.person_id = pe.id
WHERE pn.number = '123456789';

-- 7. Thay đổi những trường sau từ cơ sở dữ liệu
-- a) Thay đổi trường ngày sinh trước ngày hiện tại
ALTER TABLE persons
ADD CONSTRAINT CK_birthdate_before_today
CHECK (birth_date < GETDATE());

-- b) Xác định các trường khóa chính, khóa ngoại của các bảng
SELECT * 
FROM information_schema.key_column_usage;  

-- c) Thêm trường "ngày bắt đầu liên lạc"
ALTER TABLE phone_numbers
ADD start_contact_date DATE;

-- 8. Thực hiện các yêu cầu sau
-- a) Tạo các Index
-- a1) IX_HoTen: chỉ mục cho cột họ tên
CREATE INDEX IX_HoTen
ON persons (name);

-- a2) IX_SoDienThoai: chỉ mục cho cột số điện thoại 
CREATE INDEX IX_SoDienThoai
ON phone_numbers (number);

-- b) Tạo các view
-- b1) View_SoDienThoai: hiển thị thông tin gồm họ tên, số điện thoại
CREATE VIEW View_SoDienThoai AS
SELECT pe.name, pn.number 
FROM persons AS pe
JOIN phone_numbers AS pn
ON pe.id = pn.person_id;

-- b2) View_SinhNhat: Hiển thị những người có ngày sinh nhật trong tháng hiện tại 
-- (họ tên, ngày sinh, số điện thoại)
CREATE VIEW View_SinhNhat AS
SELECT * 
FROM persons
WHERE MONTH(birth_date) = MONTH(GETDATE());

-- c) Tạo các Store Procedure:
-- c1) SP_Them_DanhBa: Thêm một người mới vào danh bạ 
CREATE PROCEDURE SP_Them_DanhBa @name NVARCHAR(100), @address NVARCHAR(255), @birth_date DATE 
AS
INSERT INTO persons 
VALUES (@name, @address, @birth_date);

EXEC SP_Them_DanhBa @name = N'Hoàng Hạo Hiên', @address = N'123, Quận 1, TP. Hồ Chí Minh', @birth_date = '1990-08-11';

-- c2) SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)
CREATE PROCEDURE SP_Tim_DanhBa @name NVARCHAR(100) 
AS
SELECT pe.id, pe.name, pe.address, pe.birth_date, pn.number 
FROM persons AS pe
JOIN phone_numbers AS pn
ON pn.person_id = pe.id
WHERE pe.name LIKE '%' + @name + '%';

EXEC SP_Tim_DanhBa @name = N'Bình';