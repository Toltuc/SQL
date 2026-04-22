--SQLQuery2-CREATE TABLE.sql
USE P_421_DDL;

--CREATE TABLE Directions
--(
--	direction_id	TINYINT			PRIMARY KEY,
--	direction_name	NVARCHAR(150)	NOT NULL
--);
--CREATE TABLE Groups
--(
--	group_id	INT			PRIMARY KEY,
--	group_name	NVARCHAR(16)NOT NULL,
--	direction	TINYINT		NOT NULL
--	CONSTRAINT	FK_Groups_Directions	FOREIGN KEY	REFERENCES	Directions(direction_id)
--);

CREATE TABLE Students
(
	student_id		INT			PRIMARY KEY,
	last_name		NVARCHAR(50)NOT NULL,
	first_name		NVARCHAR(50)NOT NULL,
	middle_name		NVARCHAR(50)	NULL,
	birth_date		DATE		NOT NULL,
	email			NVARCHAR(50),
	phone			NVARCHAR(50),
	photo			VARBINARY(MAX),
	[group]			INT
	CONSTRAINT	FK_Groups_Direction	FOREIGN KEY REFERENCES Groups(group_id)
);
