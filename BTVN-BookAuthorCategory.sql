CREATE TABLE categories(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE authors(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(100) NOT NULL
);

CREATE TABLE publishers(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(100) NOT NULL UNIQUE,
	address NVARCHAR(255)
);

CREATE TABLE books(
	id VARCHAR(100) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	summmary NTEXT,
	year_publication DATE NOT NULL DEFAULT GETDATE(),
	edition INT NOT NULL DEFAULT 1 CHECK(edition >= 1),
	price DECIMAL(16,0) NOT NULL DEFAULT 0 CHECK(price >=0),
	quantity INT NOT NULL DEFAULT 0 CHECK(quantity >= 0),
	category_id INT NOT NULL FOREIGN KEY REFERENCES categories(id),
	author_id INT NOT NULL FOREIGN KEY REFERENCES authors(id),
	publisher_id INT NOT NULL FOREIGN KEY REFERENCES publishers(id),
);

DROP TABLE books;
DROP TABLE publishers;
DROP TABLE authors;
DROP TABLE categories;

-- 2. Chèn dữ liệu vào bảng
INSERT INTO categories
VALUES 
(N'Khoa học xã hội'),
(N'Toán học'),
(N'Tin học'),
(N'Văn học'),
(N'Khác');

INSERT INTO authors
VALUES
('Eran Katz'),
('Daniel Boorstin'),
('Ian Stewart'),
('Lev Nikolayevich Tolstoy'),
(N'Nguyễn Văn An');

INSERT INTO publishers
VALUES 
(N'NXB Tri Thức', N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội'),
(N'NXB Kim Đồng', N'22 Quang Trung, Hai Bà Trưng, Hà Nội'),
(N'NXB Trẻ', N'161B Lý Chính Thắng, Phường 7, Quận 3, Thành phố Hồ Chí Minh'),
(N'NXB Giáo Dục', N'81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội');

INSERT INTO books
VALUES 
('B001', N'Trí tuệ Do Thái', N'Bạn có muốn biết: Người Do Thái sáng tạo ra cái gì và nguồn gốc trí tuệ của họ xuất phát từ đâu không? Cuốn sách này sẽ dần hé lộ những bí ẩn về sự thông thái của người Do Thái, của một dân tộc thông tuệ với những phương pháp và kỹ thuật phát triển tầng lớp trí thức đã được giữ kín hàng nghìn năm như một bí ẩn mật mang tính văn hóa.', '2010', 1, 79000, 100, 1, 1, 1),
('B002', N'Những nhà khám phá', N'Là cuốn mở đầu cho tác phẩm bộ ba lịch sử thế giới bao gồm cả "The Creators (Những nhà sáng tạo)" và "The Seekers (Những người tìm kiếm)", nhưng Những nhà khám phá được coi như một kiệt tác độc lập. Một tác phẩm nổi bật, vượt trội, khai mở cho người tò mò muốn biết thế giới đã được khám phá như thế nào, một trong những bách khoa thư lịch sử xuất sắc nhất khó lòng tìm được ở bất cứ nơi đâu khác.', '2009', 1, 120000, 50, 1, 2, 2),
('B003', N'17 phương trình thay đổi thế giới', N'Cuốn sách cho chúng ta biết thế giới ngày nay, phát triển được cũng phần nào nhờ vào 17 phương trình đã có mặt từ nhiều thế kỷ trước. Sẽ không có thành công nếu không có thất bại, 17 phương trình, 17 câu chuyện về quá trình hình thành và phát triển của thế giới công nghệ, máy móc, thông tin liên lạc, cũng là 17 câu chuyện về những con người với những thăng trầm trong cuộc sống.
', '2015', 1, 190000, 70, 2, 3, 3),
('B004', N'Chiến tranh và hòa bình', N'đại tiểu thuyết của đại văn hào Lev Tolstoy – sớm vượt ra khỏi biên giới lãnh thổ để được thế giới thừa nhận là thiên tiểu thuyết vĩ đại nhất mọi thời đại bởi những vấn đề lớn lao của cả nhân loại hiện lên sinh động và xúc động qua từng từ, từng câu bởi ngòi bút nghệ thuật trác việt của tác giả.', '2003', 1, 295000, 25, 4, 4, 4);
 
 -- 3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
 SELECT * 
 FROM books
 WHERE year_publication BETWEEN '2008-01-01' AND GETDATE();

 -- 4. Liệt kê 10 cuốn sách có giá bán cao nhất
 SELECT TOP 10 *
 FROM books
 ORDER BY price DESC;

 -- 5. Tìm những cuốn sách tiêu đề có chứa từ "tin học"
 SELECT *
 FROM books 
 WHERE name LIKE N'%tin học%';

 -- 6. Liệt kê các cuốn sách có tên bắt đầu với chữ T theo thứ tự giá giảm dần
 SELECT *
 FROM books
 WHERE name LIKE 'T%'
 ORDER BY price DESC;

 -- 7. Liệt kê các cuốn sách của nhà xuất bản tri thức
 SELECT * 
 FROM books
 WHERE publisher_id IN (
	SELECT id
	FROM publishers
	WHERE name LIKE N'NXB Tri Thức'
 );

 -- 8. Lấy thông tin chi tiết về nhà xuất bản cuốn "Trí tuệ Do Thái"
 SELECT *
 FROM publishers
 WHERE id IN (
	SELECT publisher_id
	FROM books
	WHERE name LIKE N'Trí tuệ Do Thái' 
);

-- 9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
SELECT b.id, b.name, b.year_publication, p.name AS publisher_name, c.name AS categoriy_name
FROM books AS b
JOIN publishers AS p
ON b.publisher_id = p.id
JOIN categories AS c
ON b.category_id = c.id;

-- 10. Tìm cuốn sách có giá bán đắt nhất
SELECT TOP 1 *
FROM books
ORDER BY price DESC;

-- 11. Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP 1 *
FROM books
ORDER BY quantity DESC;

-- 12.Tìm các cuốn sách của tác giả "Eran Katz"
SELECT *
FROM books
WHERE author_id IN (
	SELECT id
	FROM authors
	WHERE name LIKE 'Eran Katz'
);

-- 13. Giảm giá 10% các cuốn sách xuất bản từ năm 2008 về trước
UPDATE books
SET price = price * (1 - 0.1)
WHERE year_publication < '2008-01-01';

-- 14. Thống kê số đầu sách của mỗi nhà xuất bản
SELECT COUNT(*) AS number_of_books, publisher_id
FROM books
GROUP BY publisher_id;

-- 15. Thống kê đầu sách của mỗi loại sách
SELECT COUNT(*) AS number_of_books, category_id
FROM books
GROUP BY category_id;

-- 16. Đặt Index cho trường tên sách
CREATE INDEX IDX_book_name
ON books (name);

-- 17. Viết View lấy thông tin sau: Mã sách, Tên sách, Tác giả, Nhà XB, Giá bán
CREATE VIEW view_sach_tacgia AS
SELECT b.id, b.name, a.name AS author_name, p.name AS publisher_name, b.price
FROM books AS b
JOIN publishers AS p
ON b.publisher_id = p.id
JOIN authors AS a
ON b.author_id = a.id;

-- 18. Viết store proccedure
-- thêm một cuốn sách mới
CREATE PROCEDURE SP_Them_Sach 
@id VARCHAR(100), @name NVARCHAR(100), @summmary NTEXT, @year_publication DATE, @edition INT, @price DECIMAL(16,0), @quantity INT, @category_id INT, @author_id INT, @publisher_id INT 
AS
INSERT INTO books
VALUES (@id, @name, @summmary, @year_publication, @edition, @price, @quantity, @category_id, @author_id, @publisher_id);

EXEC SP_Them_Sach @id = 'B005', @name = N'Tin học đại cương', @summmary = NULL, @year_publication = '2011', @edition = 1, @price = 30000, @quantity = 0, @category_id = 3, @author_id = 5, @publisher_id = 4;

-- Tìm các cuốn sách theo từ khóa
CREATE PROCEDURE SP_Tim_Sach @name NVARCHAR(100) 
AS
SELECT * 
FROM books
WHERE name LIKE '%' + @name + '%';

EXEC SP_Tim_Sach @name = N'tin học';

-- liệt kê sách theo mã chuyên mục
CREATE PROCEDURE SP_Sach_ChuyenMuc @category_id INT
AS
SELECT *
FROM books
WHERE category_id = @category_id;

EXEC SP_Sach_ChuyenMuc @category_id = 1;

-- 19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho
CREATE TRIGGER can_not_delete_book
ON books
AFTER DELETE 
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted WHERE quantity > 0)
	BEGIN
		PRINT 'Sach van con trong kho';
		ROLLBACK TRANSACTION;
	END
END;

DROP TRIGGER can_not_delete_book

INSERT INTO books
VALUES 
('B006', N'ABC', NULL, '2010', 1, 79000, 0, 1, 1, 1)
DELETE FROM books
WHERE id = 'B006'

-- 20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên mục này
CREATE TRIGGER can_not_delete_category
ON categories
AFTER DELETE
AS
BEGIN
	IF 
		(SELECT SUM(quantity)
		FROM books
		WHERE category_id IN (
			SELECT id 
			FROM deleted
	)) > (0)
	BEGIN
		PRINT 'Van con sach trong danh muc';
		ROLLBACK TRANSACTION;
	END
END;
DROP TRIGGER can_not_delete_category;

