USE HRMS;

/*DROP TABLE IF EXISTS Promotion;
DROP TABLE IF EXISTS Orders_Placed;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Employee_Charges;
DROP TABLE IF EXISTS Charge_Sheet;
DROP TABLE IF EXISTS Leave_Record;
DROP TABLE IF EXISTS Contract_Based;
DROP TABLE IF EXISTS Contracts;
DROP TABLE IF EXISTS Resignation;
DROP TABLE IF EXISTS Dependents;
DROP TABLE IF EXISTS Pay_Scale;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Employee_Loan;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Salary;
DROP TABLE IF EXISTS Employee_Account;
DROP TABLE IF EXISTS Retirement;
DROP TABLE IF EXISTS Employee_Post;
DROP TABLE IF EXISTS Regularisation;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS ULB;
DROP TABLE IF EXISTS Employee_Phone;
DROP TABLE IF EXISTS Employee_Login;
DROP TABLE IF EXISTS Employee;*/

CREATE TABLE IF NOT EXISTS Employee (
	EID INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR (30) NOT NULL,
	Address VARCHAR (50) NOT NULL,
	Age INT NOT NULL CHECK (Age < 60 AND Age > 0),
	Gender CHAR(1) NOT NULL,
	Aadhar CHAR(12),
	PRIMARY KEY(EID)
);

CREATE TABLE IF NOT EXISTS Employee_Login(
	EID INT NOT NULL,
	User INT NOT NULL,
	PRIMARY KEY(EID, User),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(User) REFERENCES auth_user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Employee_Phone (
	EID INT NOT NULL,
	Phone CHAR(10) NOT NULL,
	PRIMARY KEY(EID, Phone),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ULB (
	UID INT NOT NULL AUTO_INCREMENT,
	ULB_Name VARCHAR(40),
	ULB_Type VARCHAR(11),
	PRIMARY KEY(UID)
);

CREATE TABLE IF NOT EXISTS Post (
	PID INT NOT NULL,
	UID INT NOT NULL,
	Post_Name VARCHAR(30),
	Class CHAR(7),
	Number INT NOT NULL,
	PRIMARY KEY(PID, UID),
	FOREIGN KEY(UID) REFERENCES ULB(UID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Regularisation (
	EID INT NOT NULL,
	Date DATE NOT NULL,
	PID INT,
	UID INT,
	PRIMARY KEY(EID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(PID, UID) REFERENCES Post(PID, UID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Employee_Post (
	EID INT NOT NULL,
	PID INT NOT NULL,
	UID INT NOT NULL,
	PRIMARY KEY(EID, PID, UID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(PID, UID) REFERENCES Post(PID, UID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Retirement(
	EID INT NOT NULL,
	Date DATE,
	Pension INT,
	PRIMARY KEY(EID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Employee_Account(
	EID INT NOT NULL,
	Account_No VARCHAR(11) NOT NULL,
	IFSC CHAR(11) NOT NULL,
	PRIMARY KEY(Account_No, IFSC),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Salary(
	SID INT NOT NULL AUTO_INCREMENT,
	Basic_Pay INT NOT NULL,
	Grade_Pay INT NOT NULL,
	PRIMARY KEY(SID)
);

CREATE TABLE IF NOT EXISTS Loan(
	LID INT NOT NULL AUTO_INCREMENT,
	Amount INT NOT NULL,
	Date DATE NOT NULL,
	Duration INT NOT NULL,
	Type VARCHAR(10),
	Paid INT DEFAULT 0,
	Status CHAR(1) DEFAULT 'N',
	Months INT DEFAULT 0,
	PRIMARY KEY(LID)
);

/* INSERT INTO Loan VALUES(0, 0, '0001-01-01', 1, 'Misc', 'Y');*/

CREATE TABLE IF NOT EXISTS Employee_Loan(
	EID INT NOT NULL,
	LID INT NOT NULL,
	PRIMARY KEY(EID, LID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(LID) REFERENCES Loan(LID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Payment(
	Account_No VARCHAR(11) NOT NULL,
    IFSC CHAR(11) NOT NULL,
	SID INT NOT NULL,
	Date DATE NOT NULL,
	Deductions INT DEFAULT 0,
	PRIMARY KEY(Account_No, IFSC, Date),
	FOREIGN KEY(Account_No, IFSC) REFERENCES Employee_Account(Account_No, IFSC) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(SID) REFERENCES Salary(SID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS Payment_Loan(
	Account_No VARCHAR(11) NOT NULL,
	IFSC CHAR(11) NOT NULL,
	Date DATE NOT NULL,
	LID INT NOT NULL,
	PRIMARY KEY(Account_No, IFSC, Date, LID),
	FOREIGN KEY(Account_No, IFSC, Date) REFERENCES Payment(Account_No, IFSC, Date) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(LID) REFERENCES Loan(LID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Pay_Scale(
	EID INT NOT NULL,
	SID INT NOT NULL,
	PRIMARY KEY(EID, SID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(SID) REFERENCES Salary(SID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Dependents(
	Aadhar CHAR(12) NOT NULL,
	EID INT NOT NULL,
	Name VARCHAR(30) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Age INT NOT NULL CHECK (Age > 0 AND Age < 100),
	Gender CHAR(1) NOT NULL,
	Relation VARCHAR(10) NOT NULL,
	PRIMARY KEY(Aadhar),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Resignation(
	EID INT NOT NULL,
	Date DATE NOT NULL,
	Reason VARCHAR(100) DEFAULT 'NIL',
	w_e_f DATE,
	PRIMARY KEY(EID, Date),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Contracts(
	CID INT NOT NULL AUTO_INCREMENT,
	Contract VARCHAR(100) NOT NULL,
	Salary INT NOT NULL,
	Date_Started DATE,
	End_Date DATE,
	PRIMARY KEY(CID)
);

CREATE TABLE IF NOT EXISTS Contract_Based(
	EID INT NOT NULL,
	CID INT NOT NULL,
	PRIMARY KEY(EID, CID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(CID) REFERENCES Contracts(CID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Leave_Record(
	EID INT NOT NULL,
	Date DATE NOT NULL,
	Type VARCHAR(10),
	Approved CHAR(1) DEFAULT 'N',
	PRIMARY KEY(EID, Date),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Charge_Sheet(
	IID INT NOT NULL AUTO_INCREMENT,
	Decision VARCHAR(100),
	Appeal VARCHAR(100),
	Charges VARCHAR(100),
	PRIMARY KEY(IID)
);

CREATE TABLE IF NOT EXISTS Employee_Charges(
	EID INT NOT NULL,
	IID INT NOT NULL,
	PRIMARY KEY(EID, IID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(IID) REFERENCES Charge_Sheet(IID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Orders(
	OID INT NOT NULL AUTO_INCREMENT,
	Quantity INT NOT NULL CHECK (Quantity > 0),
	Item VARCHAR(20),
	Date DATE,
	Approved CHAR(1) DEFAULT 'N',
	PRIMARY KEY(OID)
);

CREATE TABLE IF NOT EXISTS Orders_Placed(
	EID INT NOT NULL,
	OID INT NOT NULL,
	PRIMARY KEY(EID, OID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(OID) REFERENCES Orders(OID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Promotion(
	EID INT NOT NULL,
	Lower_PID INT NOT NULL,
	Lower_UID INT NOT NULL,
	Higher_PID INT NOT NULL,
	Higher_UID INT NOT NULL,
	Relieving_Date DATE,
	Joining_Date DATE,
	PRIMARY KEY(EID, Lower_PID, Lower_UID, Higher_PID, Higher_UID),
	FOREIGN KEY(EID) REFERENCES Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Lower_PID, Lower_UID) REFERENCES Post(PID, UID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(Higher_PID, Higher_UID) REFERENCES Post(PID, UID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Demotion(
	IID INT NOT NULL,
	Higher_PID INT NOT NULL,
	Higher_UID INT NOT NULL,
	Lower_PID INT NOT NULL,
	Lower_UID INT NOT NULL,
	Relieving_Date DATE,
	Joining_Date DATE,
	PRIMARY KEY(IID, Higher_PID, Higher_UID, Lower_PID, Lower_UID),
	FOREIGN KEY(IID) REFERENCES Charge_Sheet(IID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(Lower_PID, Lower_UID) REFERENCES Post(PID, UID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(Higher_PID, Higher_UID) REFERENCES Post(PID, UID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Initial_Pay_Scale(
	PID INT NOT NULL,
	UID INT NOT NULL,
	SID INT NOT NULL,
	PRIMARY KEY(PID, UID, SID),
	FOREIGN KEY(PID, UID) REFERENCES Post(PID, UID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(SID) REFERENCES Salary(SID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Rates(
	Date DATE NOT NULL,
	DA_Rate INT NOT NULL,
	A_HRA INT NOT NULL,
	B_HRA INT NOT NULL,
	C_HRA INT NOT NULL,
	MA INT NOT NULL,
	Income_Tax VARCHAR(100) NOT NULL,
	Interest_Rate INT NOT NULL,
	Provident_Fund INT NOT NULL,
	GIS INT NOT NULL,
	PRIMARY KEY(Date)
);

CREATE TABLE IF NOT EXISTS Contract_Payment(
	Account_No VARCHAR(11) NOT NULL,
	IFSC CHAR(11) NOT NULL,
	Date DATE NOT NULL,
	CID INT NOT NULL,
	Deductions INT DEFAULT 0,
	PRIMARY KEY(Account_No, IFSC, Date),
	FOREIGN KEY(Account_No, IFSC) REFERENCES Employee_Account(Account_No, IFSC) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(CID) REFERENCES Contracts(CID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

/*INSERT INTO ULB VALUES (1, 'Municipal Corporation, Gurgaon', 'Corporation'),
					   (2, 'Municipal Council, Rohtak', 'Council'),
					   (3, 'Municipal Committee, Sampla', 'Committee');

INSERT INTO POST VALUES (1, 1, 'Executive Officer', 'Class A', 1),
						(2, 1, 'Municipal Engineer', 'Class B', 1),
						(3, 1, 'Secretary', 'Class C', 1),
						(4, 1, 'Junior Engineer', 'Class C', 1),
						(5, 1, 'Sanitary Inspector', 'Class C', 1),
						(6, 1, 'Accountant', 'Class D', 1),
						(7, 1, 'Superintendent', 'Class D', 3),
						(8, 1, 'Assistant', 'Class D', 4),
						(9, 1, 'Clerk', 'Class E', 6),
						(10, 1, 'Peon', 'Class F', 10),
						(1, 2, 'Executive Officer', 'Class A', 1),
						(2, 2, 'Municipal Engineer', 'Class B', 1),
						(3, 2, 'Secretary', 'Class C', 1),
						(4, 2, 'Junior Engineer', 'Class C', 1),
						(5, 2, 'Sanitary Inspector', 'Class C', 1),
						(6, 2, 'Accountant', 'Class D', 1),
						(7, 2, 'Superintendent', 'Class D', 3),
						(8, 2, 'Assistant', 'Class D', 4),
						(9, 2, 'Clerk', 'Class E', 6),
						(10, 2, 'Peon', 'Class F', 10),
						(1, 3, 'Executive Officer', 'Class A', 1),
						(2, 3, 'Municipal Engineer', 'Class B', 1),
						(3, 3, 'Secretary', 'Class C', 1),
						(4, 3, 'Junior Engineer', 'Class C', 1),
						(5, 3, 'Sanitary Inspector', 'Class C', 1),
						(6, 3, 'Accountant', 'Class D', 1),
						(7, 3, 'Superintendent', 'Class D', 3),
						(8, 3, 'Assistant', 'Class D', 4),
						(9, 3, 'Clerk', 'Class E', 6),
						(10, 3, 'Peon', 'Class F', 10);

INSERT INTO Salary(Basic_Pay, Grade_Pay) VALUES (39100, 5400),
												(15600, 5400),
												(34800, 5400),
												(9300, 5400),
												(34800, 4600),
												(9300, 4600),
												(34800, 4200),
												(9300, 4200),
												(20200, 1800),
												(5200, 1800),
												(7440, 1300),
												(4440, 1300);

INSERT INTO Initial_Pay_Scale VALUES (1, 1, 1),
									 (1, 2, 2),
									 (1, 3, 2),
									 (2, 1, 3),
									 (2, 2, 4),
									 (2, 3, 4),
									 (3, 1, 5),
									 (3, 2, 6),
									 (3, 3, 6),
									 (4, 1, 5),
									 (4, 2, 6),
									 (4, 3, 6),
									 (5, 1, 5),
									 (5, 2, 6),
									 (5, 3, 6),
									 (6, 1, 7),
									 (6, 2, 8),
									 (6, 3, 8),
									 (7, 1, 7),
									 (7, 2, 8),
									 (7, 3, 8),
									 (8, 1, 7),
									 (8, 2, 8),
									 (8, 3, 8),
									 (9, 1, 9),
									 (9, 2, 10),
									 (9, 3, 10),
									 (10, 1, 11),
									 (10, 2, 12),
									 (10, 3, 12);


INSERT INTO Rates VALUES ('2017-10-14', 5, 30, 20, 10, 500, '0:0+0:250000;250000:0+5:500000;500000:25000+20:1000000;1000000:125000+30:-1', 9, 10, 10);

INSERT INTO Payment VALUES ('23892810482', 'SBI00000832', 8, 1, '2017-10-14');

*/



