CREATE TABLE Department(
	DepartId INT PRIMARY KEY IDENTITY(1,1),
	DepartName VARCHAR(50) NOT NULL,
	Description VARCHAR(100) NOT NULL
);

CREATE TABLE Employee(
	EmpCode CHAR(6) PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Birthday SMALLDATETIME NOT NULL,
	Gender BIT DEFAULT 1,
	Address VARCHAR(100),
	DepartID INT FOREIGN KEY REFERENCES Department(DepartId),
	Salary MONEY
);

-- DROP TABLE Employee;
-- DROP TABLE Department;

-- 1. Insert into above tables at least 3 records per table 
INSERT INTO Department(DepartName, Description)
VALUES 
('Marketing', 'Concerned with finding out the needs and wants of potential customers.'),
('Human resources', 'Manages the people who work for the organisation.'),
('Finance', 'Responsible for managing the money coming into and going out of the business.');

INSERT INTO Employee
VALUES
('EMP001', 'David', 'Wallace', '1967-11-17', 1, 'New Yorks', 1, 250000),
('EMP002', 'Jan', 'Levinson', '1961-05-11', 0, 'New Yorks', 1, 110000),
('EMP003', 'Michael', 'Scott', '1964-03-15', 1, 'New Yorks', 2, 75000),
('EMP004', 'Angela', 'Martin', '1971-06-25', 0, 'New Yorks', 2, 63000),
('EMP005', 'Stanley', 'Hudson', '1958-02-19', 1, 'New Yorks', 3, 69000);

 
-- 2. Increase the salary for all employees by 10%
UPDATE Employee
SET Salary = Salary * 1.1;

-- 3. Using ALTER TABLE statement to add constraint on Employee table to ensure that salary always greater than 0
ALTER TABLE Employee
ADD CONSTRAINT emp_salary_greater_0
CHECK (Salary > 0);

-- 4. Create a trigger named tg_chkBirthday to ensure Employee’s age is greater than 22, use the birthday value to check the age
CREATE TRIGGER tg_chkBirthday 
ON Employee 
AFTER INSERT 
AS
BEGIN
	IF (SELECT DATEDIFF(hour,Birthday,GETDATE())/8766 FROM inserted) <= 22
	BEGIN 
		PRINT 'Age is not greater than 22';
		ROLLBACK TRAN;
	END
END;

-- 5. Create an unique, none-clustered index named IX_DepartmentName on DepartName column on Department table
CREATE UNIQUE INDEX IX_DeparmentName
ON Department (DepartName);

-- 6. Create a view to display employee’s code, full name and department name of all employees
CREATE VIEW View_Employee AS
SELECT E.EmpCode, E.FirstName + ' ' + E.LastName AS FullName, D.DepartName
FROM Employee E
LEFT JOIN Department D
ON E.DepartID = D.DepartId;

-- 7. Create a stored procedure named sp_getAllEmp that accepts Department ID as given input parameter and displays all employees in that Department
CREATE PROCEDURE sp_getAllEmp @DepartID INT
AS
SELECT *
FROM Employee
WHERE DepartID = @DepartID;

-- 8. Create a stored procedure named sp_delDept that accepts employee Id as given input parameter to delete an employee
CREATE PROCEDURE sp_delDept @EmpCode CHAR(6)
AS
DELETE FROM Employee
WHERE EmpCode = @EmpCode;
