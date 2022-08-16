CREATE TABLE Customers(
	Id VARCHAR(20) PRIMARY KEY CHECK(Id not like '%[^0-9]%'),
	Name NVARCHAR(100) NOT NULL,
	Address NVARCHAR(255) NOT NULL 
);
SELECT * FROM Customers;

CREATE TABLE Subscriptions(
	Number VARCHAR(100) PRIMARY KEY CHECK(Number not like '%[^0-9]%'),
	Type NVARCHAR(100) NOT NULL CHECK(Type = 'Trả trước' or Type = 'Trả sau'),
	SubDate DATE,
	CustomerId VARCHAR(20) FOREIGN KEY REFERENCES Customers(Id)
);
SELECT * FROM Subscriptions;

DROP TABLE Customers;
DROP TABLE Subscriptions;

INSERT INTO Customers VALUES('123456789','Nguyễn Nguyệt Nga', 'Hà Nội');
INSERT INTO Subscriptions VALUES('123456780','Trả trước','2022-12-02','123456789');




