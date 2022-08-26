CREATE TABLE NhaCungCap(
	MaNhaCC VARCHAR(10) PRIMARY KEY,
	TenNhaCC NVARCHAR(100) NOT NULL UNIQUE,
	DiaChi NVARCHAR(100),
	SoDT VARCHAR(20) NOT NULL UNIQUE,
	MaSoThue VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE LoaiDichVu(
	MaLoaiDV VARCHAR(10) PRIMARY KEY,
	TenLoaiDV NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE MucPhi(
	MaMP VARCHAR(10) PRIMARY KEY,
	DonGia DECIMAL(16,0) NOT NULL CHECK(DonGia >= 0) DEFAULT 0,
	MoTa NVARCHAR(100)
);

CREATE TABLE DongXe(
	DongXe VARCHAR(100) PRIMARY KEY,
	HangXe VARCHAR(100) NOT NULL,
	SoChoNgoi INT NOT NULL CHECK(SoChoNgoi > 0)
);

CREATE TABLE DangKyCungCap(
	MaDKCC VARCHAR(10) PRIMARY KEY,
	MaNhaCC VARCHAR(10) FOREIGN KEY REFERENCES NhaCungCap(MaNhaCC),
	MaLoaiDV VARCHAR(10) FOREIGN KEY REFERENCES LoaiDichVu(MaLoaiDV),
	DongXe VARCHAR(100) FOREIGN KEY REFERENCES DongXe(DongXe),
	MaMP VARCHAR(10) FOREIGN KEY REFERENCES MucPhi(MaMP),
	NgayBatDauCungCap DATE NOT NULL DEFAULT GETDATE(),
	NgayKetThucCungCap DATE NOT NULL DEFAULT GETDATE(),
	SoLuongXeDangKy INT NOT NULL CHECK(SoLuongXeDangKy > 0),
	CONSTRAINT end_date_later_than_start_date_CK
    CHECK (NgayBatDauCungCap <= NgayKetThucCungCap)  
);

INSERT INTO NhaCungCap
VALUES
('NCC001',N'Cty TNHH Toàn Pháp','Hai Chau','05113999888', '568941'),
('NCC002',N'Cty Cổ phần Đông Du','Lien Chieu','05113999889', '456789'),
('NCC003',N'Ông Nguyễn Văn A','Hoa Thuan','05113999890', '321456'),
('NCC004',N'Cty Cổ phần Toàn Cầu Xanh','Hai Chau','05113658945', '513364'),
('NCC005',N'Cty TNHH AMA','Thanh Khe','05113875466', '546546'),
('NCC006',N'Bà Trần Thị Bích Vân','Lien Chieu','05113587469', '524545'),
('NCC007',N'Cty TNHH Phan Thành','Thanh Khe','05113987456', '113021'),
('NCC008',N'Ông Phan Đình Nam','Hoa Thuan','05113532456', '121230'),
('NCC009',N'Tập đoàn Đông Á','Lien Chieu','05113987121', '533654'),
('NCC010',N'Cty Cổ phần Rạng Đông','Lien Chieu','05113569654', '187864');

INSERT INTO LoaiDichVu
VALUES
('DV01',N'Dịch vụ xe taxi'),
('DV02',N'Dịch vụ xe buýt công cộng theo tuyến cố định'),
('DV03',N'Dịch vụ xe cho thuê theo hợp đồng');

INSERT INTO MucPhi
VALUES
('MP01',10000,N'Áp dụng từ 1/2015'),
('MP02',15000,N'Áp dụng từ 2/2015'),
('MP03',20000,N'Áp dụng từ 1/2010'),
('MP04',25000,N'Áp dụng từ 2/2011');

INSERT INTO DongXe
VALUES
('Hiace','Toyota',16),
('Vios','Toyota', 5),
('Escape','Ford', 5),
('Cerato','KIA', 7),
('Forte','KIA', 5),
('Starex','Huyndai', 7),
('Grand-i10','Huyndai', 7);

INSERT INTO DangKyCungCap
VALUES
('DK001','NCC001', 'DV01', 'Hiace', 'MP01', '2015-11-20', '2016-11-20', 4),
('DK002','NCC002', 'DV02', 'Vios', 'MP02', '2015-11-20', '2017-11-20', 3),
('DK003','NCC003', 'DV03', 'Escape', 'MP03', '2017-11-20', '2018-11-20', 5),
('DK004','NCC005', 'DV01', 'Cerato', 'MP04', '2015-11-20', '2019-11-20', 7),
('DK005','NCC002', 'DV02', 'Forte', 'MP03', '2019-11-20', '2020-11-20', 1),
('DK006','NCC004', 'DV03', 'Starex', 'MP04', '2016-11-10', '2021-11-20', 2),
('DK007','NCC005', 'DV01', 'Cerato', 'MP03', '2015-11-30', '2016-01-25', 8),
('DK008','NCC006', 'DV01', 'Vios', 'MP02', '2016-02-28', '2016-08-15', 9),
('DK009','NCC005', 'DV03', 'Grand-i10', 'MP02', '2016-04-27', '2017-04-17', 10),
('DK010','NCC006', 'DV01', 'Forte', 'MP02', '2015-11-21', '2016-02-22', 4),
('DK011','NCC007', 'DV01', 'Forte', 'MP01', '2016-12-25', '2017-02-20', 5),
('DK012','NCC007', 'DV03', 'Cerato', 'MP01', '2016-04-14', '2017-12-22', 6),
('DK013','NCC003', 'DV02', 'Cerato', 'MP01', '2015-12-21', '2016-12-21', 8),
('DK014','NCC008', 'DV02', 'Cerato', 'MP01', '2016-05-20', '2016-12-20', 1),
('DK015','NCC003', 'DV01', 'Hiace', 'MP02', '2016-04-24', '2019-11-20', 6),
('DK016','NCC001', 'DV03', 'Grand-i10', 'MP02', '2016-06-22', '2016-12-21', 8),
('DK017','NCC002', 'DV03', 'Cerato', 'MP03', '2016-09-30', '2019-09-30', 4),
('DK018','NCC008', 'DV03', 'Escape', 'MP04', '2017-12-13', '2018-09-30', 2),
('DK019','NCC003', 'DV03', 'Escape', 'MP03', '2016-01-24', '2016-12-30', 8),
('DK020','NCC002', 'DV03', 'Cerato', 'MP04', '2016-05-03', '2017-10-21', 7),
('DK021','NCC006', 'DV01', 'Forte', 'MP02', '2015-01-30', '2016-12-30', 9),
('DK022','NCC002', 'DV02', 'Cerato', 'MP04', '2016-07-25', '2017-12-30', 6),
('DK023','NCC002', 'DV01', 'Forte', 'MP03', '2017-11-30', '2019-05-20', 5),
('DK024','NCC003', 'DV03', 'Forte', 'MP04', '2017-12-23', '2019-11-30', 8),
('DK025','NCC003', 'DV03', 'Forte', 'MP02', '2016-06-24', '2017-10-25', 1);


SELECT * FROM NhaCungCap;
SELECT * FROM LoaiDichVu;
SELECT * FROM MucPhi;
SELECT * FROM DongXe;
SELECT * FROM DangKyCungCap;

DROP TABLE DangKyCungCap;
DROP TABLE NhaCungCap;
DROP TABLE LoaiDichVu;
DROP TABLE MucPhi;
DROP TABLE DongXe;

-- 3. Liệt kê những dòng xe trên 5 chỗ ngồi
SELECT DongXe 
FROM DongXe
WHERE SoChoNgoi > 5;

-- 4. Liệt kê các nhà cung cấp đã từng đăng ký cung cấp 
-- các dòng xe thuộc hãng TOYOTA với mức phí đơn giá 15.000 VND/km
-- hoặc những dòng xe thuộc hãng KIA với mức phí đơn giá 20.000 VND/km
SELECT * 
FROM NhaCungCap
WHERE NhaCungCap.MaNhaCC IN (
	SELECT DangKyCungCap.MaNhaCC
	FROM DangKyCungCap
	WHERE 
	DangKyCungCap.DongXe IN (
		SELECT DongXe.DongXe
		FROM DongXe
		WHERE DongXe.HangXe = 'Toyota'
	) 
	AND DangKyCungCap.MaMP = (
		SELECT MucPhi.MaMP
		FROM MucPhi
		WHERE MucPhi.DonGia = 15000
	)
	OR
	DangKyCungCap.DongXe IN (
		SELECT DongXe.DongXe
		FROM DongXe
		WHERE DongXe.HangXe = 'KIA'
	) 
	AND DangKyCungCap.MaMP = (
		SELECT MucPhi.MaMP
		FROM MucPhi
		WHERE MucPhi.DonGia = 20000
	)	
);

-- 5. Liệt kê toàn bộ nhà cung cấp sắp xếp tăng dần theo tên và giảm dần theo mã số thuế
SELECT * 
FROM NhaCungCap
ORDER BY TenNhaCC ASC, MaSoThue DESC;

-- 6. Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với yêu cầu
-- chỉ đếm những nhà cung cấp thực hiện cung cấp có ngày bắt đầu cung cấp là "20/11/2015" 
SELECT MaNhaCC, COUNT(MaDKCC) AS SoLanDK
FROM DangKyCungCap
WHERE NgayBatDauCungCap = '2015-11-20'
GROUP BY MaNhaCC;

-- 7. Liệt kê toàn bộ các hãng xe với yêu cầu mỗi hãng xe chỉ được liệt kê một lần
SELECT DISTINCT HangXe
FROM DongXe;

-- 8. Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia, HangXe,
-- NgayBatDauCC, NgayKetThucCC của tất cả các lần đăng ký cung cấp phương tiện với yêu cầu 
-- những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương tiện thì cũng liệt kê
SELECT D.MaDKCC, D.MaNhaCC, N.TenNhaCC, N.DiaChi, N.MaSoThue, L.TenLoaiDV, M.DonGia, X.HangXe, D.NgayBatDauCungCap, D.NgayKetThucCungCap
FROM NhaCungCap N
LEFT JOIN DangKyCungCap D
ON N.MaNhaCC = D.MaNhaCC
LEFT JOIN LoaiDichVu L
ON D.MaLoaiDV = L.MaLoaiDV
LEFT JOIN MucPhi M
ON D.MaMP = M.MaMP
LEFT JOIN DongXe X
ON D.DongXe = X.DongXe;

-- 9. Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện thuộc 
-- dòng xe "Hiace" hoặc "Cerato"
SELECT * 
FROM NhaCungCap
WHERE MaNhaCC IN (
	SELECT MaNhaCC
	FROM DangKyCungCap
	WHERE DongXe IN ('Hiace', 'Cerato')
);

-- 10. Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp lần nào
SELECT * 
FROM NhaCungCap
WHERE MaNhaCC NOT IN (
	SELECT MaNhaCC
	FROM DangKyCungCap
);